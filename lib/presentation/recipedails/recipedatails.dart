// import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectapp/bussines/recipe_bloc/recipe_bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:projectapp/bussines/sign_in_bloc/sign_in_bloc.dart';
// import 'package:projectapp/presentation/home/drawer.dart';
import 'package:projectapp/presentation/home/home.dart';
import 'package:projectapp/presentation/recipedails/fullscreen.dart';
import 'package:recipe_repository/recipe_repository.dart';

// class RecipeDetailScreen extends StatelessWidget {
//   final Recipe recipe;

// //   RecipeDetailScreen(this.recipe, {Key? key}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text(recipe.title)),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Hero(
// //               tag: 'recipe${recipe.recipeId}',
// //               child: CircleAvatar(
// //                 child: Text(recipe.title[0]), // pierwsza litera tytułu
// //                 radius: 50.0,
// //               ),
// //             ),
// //             SizedBox(height: 20),
// //             Text(recipe.description),
// //             // Dodaj więcej szczegółów o przepisie
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

class RecipeDetailPage extends StatefulWidget {
  final Recipe recipe;
  final int index;
  RecipeDetailPage({required this.recipe, required this.index});

  @override
  _RecipeDetailPageState createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  late var recipe;
  late var index;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController = ScrollController(keepScrollOffset: true);
    recipe = widget.recipe;
    index = widget.index;
    // recipe = recipes.firstWhere((element) => element.id == widget.recipeId);
    // Jeżeli lista jest pusta lub nie znajdzie elementu, 'orElse' zwróci null
  }

  Color appBarColor = Colors.transparent;

  changeAppBarColor(ScrollController scrollController) {
    if (scrollController.position.hasPixels) {
      if (scrollController.position.pixels > 2.0) {
        setState(() {});
      }
      if (scrollController.position.pixels <= 2.0) {
        setState(() {
          appBarColor = Colors.transparent;
        });
      }
    } else {
      setState(() {
        appBarColor = Colors.transparent;
      });
    }
  }

  // fab to write review
  showFAB(TabController tabController) {
    int reviewTabIndex = 2;
    if (tabController.index == reviewTabIndex) {
      return true;
    }
    return false;
  }

  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return BlocListener<RecipeBloc, RecipeState>(
      listener: (context, state) {
        if (state is DeleteRecipeSuccess) {
          Navigator.of(context).pop(true); // Powrót do poprzedniego ekranu
        } else if (state is DeleteRecipeFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to delete the recipe')));
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            child: AppBar(
              actions: [
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.white),
                  onPressed: () {
                    // Otwarcie okna dialogowego
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          title: Text('Potwierdź'),
                          content:
                              Text('Czy na pewno chcesz usunąć ten przepis?'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Anuluj'),
                              onPressed: () {
                                // Zamknięcie okna dialogowego bez wykonania akcji
                                Navigator.of(dialogContext).pop();
                              },
                            ),
                            TextButton(
                              child: Text('Usuń'),
                              onPressed: () {
                                // Wywołanie zdarzenia usuwania przepisu
                                context
                                    .read<RecipeBloc>()
                                    .add(DeleteRecipe(recipe.recipeId));
                                // Zamknięcie okna dialogowego
                                Navigator.of(dialogContext).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ),
        body: ListView(
          controller: _scrollController,
          key: PageStorageKey<String>('uniqueListViewKey'),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: BouncingScrollPhysics(),
          children: [
            /// image
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => FullScreenImage(
                        image:
                            Image.network(recipe.imageUrl, fit: BoxFit.fill))));
              },
              child: Hero(
                tag: '$index', // Unikalny identyfikator dla Hero
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10)),
                    child: recipe.imageUrl == ''
                        ? Image.asset("assets/food.png", fit: BoxFit.cover)
                        : Image.network(recipe.imageUrl, fit: BoxFit.fill),
                  ),
                ),
              ),
            ),
            // Section 2 - Recipe Info
            Container(
              width: MediaQuery.of(context).size.width,
              padding:
                  EdgeInsets.only(top: 20, bottom: 30, left: 16, right: 16),
              color: Color.fromRGBO(255, 255, 255, 1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recipe Calories and Time
                  Row(),
                  // Recipe Title
                  Container(
                    margin: EdgeInsets.only(bottom: 12, top: 16),
                    child: Text(
                      '${recipe.title}',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'inter'),
                    ),
                  ),
                  // Recipe Description
                  Text(
                    '${recipe.description}',
                    style: TextStyle(
                        color:
                            const Color.fromARGB(255, 0, 0, 0).withOpacity(0.9),
                        fontSize: 16,
                        height: 150 / 100),
                  ),
                ],
              ),
            ),
            // Tabbar ( Ingridients, Tutorial, Reviews )
            Container(
              color: Theme.of(context).primaryColor,
              height: 60,
              width: MediaQuery.of(context).size.width,
              child: TabBar(
                controller: _tabController,
                onTap: (index) {
                  setState(() {
                    _tabController.index = index;
                  });
                },
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black.withOpacity(0.6),
                labelStyle:
                    TextStyle(fontFamily: 'inter', fontWeight: FontWeight.w500),
                indicatorColor: Colors.black,
                tabs: [
                  Tab(
                    text: 'Ingridients',
                  ),
                  Tab(
                    text: 'Tutorial',
                  ),
                ],
              ),
            ),
            // IndexedStack based on TabBar index
            IndexedStack(
              index: _tabController.index,
              children: [
                // Składniki
                ListView.separated(
                  key: PageStorageKey<String>('uniqueListViewK22ey'),
                  itemCount: recipe.ingredients.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    var ingredient = recipe.ingredients[index];
                    String name = ingredient['name'];
                    String amount = ingredient['amount'];

                    return ListTile(
                      title: Text('Składnik: $name'),
                      subtitle: Text('Ilość: $amount'),
                    );
                  },
                  separatorBuilder: (context, index) => Divider(
                    color: Theme.of(context).primaryColor,
                    thickness: 1,
                  ),
                ),

                // Tutorials
                ListView.separated(
                  key: PageStorageKey<String>('uniqueListViewK11ey'),
                  itemCount: recipe.steps.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('Krok ${index + 1}'),
                      subtitle: Text('${recipe.steps[index]}'),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: Theme.of(context).primaryColor,
                      thickness: 1, // Ustaw grubość separatora
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
