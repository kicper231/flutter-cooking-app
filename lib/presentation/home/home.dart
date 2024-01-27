import 'package:auth_repository/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:projectapp/bussines/authentication_bloc/authentication_bloc.dart';
import 'package:projectapp/bussines/create_recipe_bloc/create_recipe_bloc.dart';
import 'package:projectapp/bussines/get_recipe_bloc/get_recipe_bloc.dart';
import 'package:projectapp/bussines/my_user_bloc/my_user_bloc.dart';
import 'package:projectapp/bussines/recipe_bloc/recipe_bloc.dart';
import 'package:projectapp/bussines/sign_in_bloc/sign_in_bloc.dart';
import 'package:projectapp/presentation/home/addrecipe.dart';
import 'package:projectapp/presentation/home/drawer.dart';
import 'package:projectapp/presentation/recipedails/recipedatails.dart';
import 'package:recipe_repository/recipe_repository.dart';

// List<Recipe> recipes = [
//   Recipe(
//       id: "1",
//       title: "szarlotka po bretonskusdadasasda",
//       description: "Opis przepisu 1"),
//   Recipe(id: "2", title: "Przepis 1", description: "Opis przepisu 1"),
//   Recipe(id: "3", title: "Przepis 1", description: "Opis przepisu 1"),
// ];

// class Recipe {
//   final String id;
//   final String title;
//   final String description;

//   Recipe({required this.id, required this.title, required this.description});
// }

class RecipesPage extends StatefulWidget {
  static final GlobalKey<_RecipesPageState> globalKey =
      GlobalKey<_RecipesPageState>();

  RecipesPage() : super(key: globalKey);
  @override
  _RecipesPageState createState() => _RecipesPageState();
  static void refreshRecipes() {
    globalKey.currentState?.refreshRecipes();
  }
}

class _RecipesPageState extends State<RecipesPage> {
  final TextEditingController _searchQueryController = TextEditingController();
  late FocusNode _focusNode;
  bool isSearching = false;
  List<Recipe> filteredRecipes = [];

  void refreshRecipes() {
    final userId = context.read<AuthenticationBloc>().state.user?.uid;
    if (userId != null) {
      context.read<GetRecipeBloc>().add(GetRecipes(userId));
    }
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _searchQueryController.addListener(_onSearchChanged);
    final userId = context.read<AuthenticationBloc>().state.user?.uid;

    context.read<GetRecipeBloc>().add(GetRecipes(userId!));
  }

  void _onSearchChanged() {
    setState(() {
      if (_searchQueryController.text.isEmpty) {
        if (context.read<GetRecipeBloc>().state is GetRecipeSuccess) {
          filteredRecipes =
              (context.read<GetRecipeBloc>().state as GetRecipeSuccess).recipes;
        }
      } else {
        isSearching = true;
        // Filtrowanie przepisów
        filteredRecipes =
            (context.read<GetRecipeBloc>().state as GetRecipeSuccess)
                .recipes
                .where((recipe) => recipe.title
                    .toLowerCase()
                    .contains(_searchQueryController.text.toLowerCase()))
                .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 10),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          color: isSearching
              ? Color.fromRGBO(210, 107, 228, 1)
              : Theme.of(context).primaryColor,
          child: AppBar(
            leadingWidth: 56,
            titleSpacing: 0.0,
            flexibleSpace: isSearching
                ? null
                : Image(
                    image: AssetImage('assets/flower.png'),
                    fit: BoxFit.cover,
                  ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: isSearching
                ? TextField(
                    focusNode: _focusNode,
                    controller: _searchQueryController,
                    style: TextStyle(),
                    decoration: InputDecoration(
                      hintText: 'search_recipes'.tr(),
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                  )
                : Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Babcine',
                      style: TextStyle(
                        fontFamily: 'Wendy',
                        fontSize: 30,
                      ),
                    ),
                  ),
            actions: <Widget>[
              isSearching
                  ? IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                        setState(() {
                          isSearching = false;
                          _focusNode.unfocus();
                        });
                      },
                    )
                  : IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        setState(() {
                          isSearching = true;
                          _focusNode.requestFocus();
                        });
                      },
                    ),
            ],
          ),
        ),
      ),
      body: BlocListener<GetRecipeBloc, GetRecipeState>(
        listener: (context, state) {
          if (state is GetRecipeSuccess) {
            setState(() {
              filteredRecipes = state.recipes;
            });
          }
        },
        child: BlocBuilder<GetRecipeBloc, GetRecipeState>(
          builder: (context, state) {
            if (state is GetRecipeLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is GetRecipeSuccess) {
              return _buildRecipeGrid(state.recipes);
            } else {
              return Center(child: Text('Błąd ładowania przepisów'));
            }
          },
        ),
      ),
      floatingActionButton: BlocBuilder<MyUserBloc, MyUserState>(
        builder: (context, state) {
          if (state.status == MyUserStatus.success) {
            return FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<bool>(
                    builder: (BuildContext context) => BlocProvider(
                      create: (context) => RecipeBloc(
                          recipeRepository: context.read<RecipeRepository>()),
                      child: BlocProvider<CreateRecipeBloc>(
                        create: (context) => CreateRecipeBloc(
                            recipeRepository: context.read<RecipeRepository>()),
                        child: AddRecipe(state.user!),
                      ),
                    ),
                  ),
                ).then((isUpdated) {
                  if (isUpdated != null && isUpdated == true) {
                    BlocProvider.of<GetRecipeBloc>(context)
                        .add(GetRecipes(state.user!.userId));
                  }
                });
              },
              child: const Icon(CupertinoIcons.add,
                  color: Color.fromARGB(192, 33, 33, 33)),
            );
          } else {
            return const FloatingActionButton(
              onPressed: null,
              child: Icon(CupertinoIcons.clear),
            );
          }
        },
      ),
      drawer: Mydrawer(),
    );
  }

  Widget _buildRecipeGrid(List<Recipe> recipes) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 3,
        mainAxisSpacing: 3,
        childAspectRatio: 9 / 10,
      ),
      itemCount: filteredRecipes.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute<bool>(
                  builder: (context) => BlocProvider(
                        create: (context) => RecipeBloc(
                            recipeRepository: context.read<RecipeRepository>()),
                        child: RecipeDetailPage(
                            recipe: filteredRecipes[index], index: index),
                      )),
            ).then((isUpdated) {
              if (isUpdated != null && isUpdated == true) {
                String? userId =
                    context.read<AuthenticationBloc>().state.user?.uid;
                if (userId != null) {
                  BlocProvider.of<GetRecipeBloc>(context)
                      .add(GetRecipes(userId));
                }
              }
            });
          },
          child: Card(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Hero(
                  tag: '$index',
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10)),
                      child: recipes[index].imageUrl == ''
                          ? Image.asset("assets/food.png", fit: BoxFit.cover)
                          : Image.network(recipes[index].imageUrl,
                              fit: BoxFit.fill),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Text(
                          filteredRecipes[index].category,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        filteredRecipes[index].title,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 22,
                          color: Theme.of(context).textTheme.bodyText1!.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchQueryController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
