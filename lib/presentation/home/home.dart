import 'package:auth_repository/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:projectapp/bussines/authentication_bloc/authentication_bloc.dart';
import 'package:projectapp/bussines/create_recipe_bloc/create_recipe_bloc.dart';
import 'package:projectapp/bussines/my_user_bloc/my_user_bloc.dart';
import 'package:projectapp/bussines/sign_in_bloc/sign_in_bloc.dart';
import 'package:projectapp/presentation/home/addrecipe.dart';
import 'package:projectapp/presentation/home/drawer.dart';
import 'package:recipe_repository/recipe_repository.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Welcome, you are In !'),
//         actions: [
//           IconButton(
//               onPressed: () {
//                 context.read<SignInBloc>().add(const SignOutRequired());
//               },
//               icon: Icon(Icons.login))
//         ],
//       ),
//     );
//   }
// }

List<Recipe> recipes = [
  Recipe(
      id: "1",
      title: "szarlotka po bretonskusdadasasda",
      description: "Opis przepisu 1"),
  Recipe(id: "2", title: "Przepis 1", description: "Opis przepisu 1"),
  Recipe(id: "3", title: "Przepis 1", description: "Opis przepisu 1"),
];

class Recipe {
  final String id;
  final String title;
  final String description;

  Recipe({required this.id, required this.title, required this.description});
}

class RecipesPage extends StatefulWidget {
  @override
  _RecipesPageState createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  List<Recipe> filteredRecipes = [];
  bool isSearching = false;
  final TextEditingController _searchQueryController = TextEditingController();
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    filteredRecipes = recipes;
    _focusNode = FocusNode();
    _searchQueryController.addListener(() {
      setState(() {
        if (_searchQueryController.text.isEmpty) {
          isSearching = false;
          filteredRecipes = recipes;
        } else {
          isSearching = true;
          filteredRecipes = recipes
              .where((recipe) => recipe.title
                  .toLowerCase()
                  .contains(_searchQueryController.text.toLowerCase()))
              .toList();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight + 10),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500), // Czas trwania animacji
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

              backgroundColor:
                  Colors.transparent, // Ustawienie tła AppBar na przezroczyste
              elevation: 0, // Usunięcie cienia AppBar
              title: isSearching
                  ? TextField(
                      // autofocus: true,
                      focusNode: _focusNode, // Użycie FocusNode
                      controller: _searchQueryController,
                      style: TextStyle(),
                      decoration: InputDecoration(
                        hintText: "Szukaj przepisów...",
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
        body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 3,
            mainAxisSpacing: 3,
            childAspectRatio: 9 / 11,
          ),
          itemCount: filteredRecipes.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                context.push('/recipe/${filteredRecipes[index].id}');
              },
              child: Card(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 10),
                    Hero(
                      tag: 'recipe${filteredRecipes[index].id}',
                      child: Image.asset("assets/food.png"),
                    ),
                    SizedBox(height: 10), // Odstęp między zdjęciem a tekstem
                    Container(
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Text(
                        filteredRecipes[index].description,
                        maxLines: 1, // Zwiększenie liczby linii
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 7, top: 0, bottom: 10, right: 7),
                      child: Text(
                        filteredRecipes[index].title,
                        textAlign: TextAlign.center,
                        maxLines: 2, // Zwiększenie liczby linii dla tytułu
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        floatingActionButton: BlocBuilder<MyUserBloc, MyUserState>(
          builder: (context, state) {
            if (state.status == MyUserStatus.success) {
              return FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) =>
                          BlocProvider<CreateRecipeBloc>(
                        create: (context) => CreateRecipeBloc(
                            recipeRepository: FirebaseRecipeRepository()),
                        child: AddRecipe(state.user!),
                      ),
                    ),
                  );
                },
                child: const Icon(CupertinoIcons.add),
              );
            } else {
              return const FloatingActionButton(
                onPressed: null,
                child: Icon(CupertinoIcons.clear),
              );
            }
          },
        ),
        drawer: Mydrawer());
  }

  Future createReciped({required String title}) async {
    final mama =
        FirebaseFirestore.instance.collection('recipes').doc('twojastara');
    final json = {'description': 'opis', 'id': 2, 'title': title};
    await mama.set(json);
  }

  @override
  void dispose() {
    _searchQueryController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}


// class RecipesPage extends StatefulWidget {
//   @override
//   _RecipesPageState createState() => _RecipesPageState();
// }

// class _RecipesPageState extends State<RecipesPage> {
//   List<Recipe> recipes = [
//     Recipe(id: "1", title: "twojastrara")
//   ]; // Your initial list of recipes
//   List<Recipe> filteredRecipes = [];

//   @override
//   void initState() {
//     super.initState();
//     filteredRecipes = recipes; // Initially, all recipes are shown
//   }

//   void _filterRecipes(String query) {
//     if (query.isEmpty) {
//       setState(() {
//         filteredRecipes = recipes;
//       });
//     } else {
//       setState(() {
//         filteredRecipes = recipes
//             .where((recipe) =>
//                 recipe.title.toLowerCase().contains(query.toLowerCase()))
//             .toList();
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Welcome, you are In !'),
//         actions: [
//           IconButton(
//             onPressed: () {
//               // Your sign out logic
//             },
//             icon: const Icon(CupertinoIcons.back),
//           ),
//           IconButton(
//             icon: Icon(Icons.search),
//             onPressed: () {
//               // Implement your search logic here
//               showSearch(
//                 context: context,
//                 delegate: RecipeSearchDelegate(recipes, _filterRecipes),
//               );
//             },
//           )
//         ],
//       ),
//       body: GridView.builder(
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//         ),
//         itemCount: filteredRecipes.length,
//         itemBuilder: (context, index) {
//           return GestureDetector(
//             onTap: () {
//               // Your item tap logic
//             },
//             child: Card(
//               color: Colors.white,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Hero(
//                     tag: 'recipe${filteredRecipes[index].id}',
//                     child: CircleAvatar(
//                       child: Text(filteredRecipes[index]
//                           .title[0]), // First letter of title
//                       radius: 40.0,
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(filteredRecipes[index].title),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(CupertinoIcons.add),
//         onPressed: () {
//           // Your FAB logic
//         },
//       ),
//       drawer: Drawer(child: Text('ok')),
//     );
//   }
// }

// class RecipeSearchDelegate extends SearchDelegate {
//   final List<Recipe> recipes;
//   final Function(String) onQueryUpdate;

//   RecipeSearchDelegate(this.recipes, this.onQueryUpdate);

//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: Icon(Icons.clear),
//         onPressed: () {
//           query = '';
//           onQueryUpdate(query);
//         },
//       )
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: Icon(Icons.arrow_back),
//       onPressed: () {
//         close(context, null);
//       },
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     return Container(); // You can implement result view if needed
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     onQueryUpdate(query);
//     return Container(); // Suggestions are handled in the main view
//   }
// }

// class Recipe {
//   String title;
//   String id;

//   Recipe({required this.title, required this.id});
// }
