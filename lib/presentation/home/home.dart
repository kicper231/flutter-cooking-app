import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:projectapp/bussines/sign_in_bloc/sign_in_bloc.dart';

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
  List<Recipe> recipes = [
    Recipe(id: "1", title: "Przepis 1", description: "Opis przepisu 1"),
    // Dodaj więcej przepisów
  ];
  List<Recipe> filteredRecipes = [];
  bool isSearching = false;
  final TextEditingController _searchQueryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredRecipes = recipes;
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
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500), // Czas trwania animacji
          color: isSearching
              ? Color.fromRGBO(206, 147, 216, 1)
              : Theme.of(context).primaryColor,
          child: AppBar(
            backgroundColor:
                Colors.transparent, // Ustawienie tła AppBar na przezroczyste
            elevation: 0, // Usunięcie cienia AppBar
            title: isSearching
                ? TextField(
                    controller: _searchQueryController,
                    style: TextStyle(),
                    decoration: InputDecoration(
                      hintText: "Szukaj przepisów...",
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                  )
                : Center(
                    child: Text(
                      'Babcine',
                      style: TextStyle(
                        fontFamily: 'Wendy',
                        fontSize: 26,
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
                        });
                      },
                    )
                  : IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        setState(() {
                          isSearching = true;
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
        ),
        itemCount: filteredRecipes.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      RecipeDetailScreen(recipeId: filteredRecipes[index].id),
                ),
              );
            },
            child: Card(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'recipe${filteredRecipes[index].id}',
                    child: CircleAvatar(
                      child: Text(filteredRecipes[index].title[0]),
                      radius: 40.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(filteredRecipes[index].title),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(CupertinoIcons.add),
        onPressed: () {
          // Logika przycisku FAB
        },
      ),
      drawer: SafeArea(
        child: Container(
          child: ListTileTheme(
            textColor: Colors.white,
            iconColor: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 128.0,
                  height: 128.0,
                  margin: const EdgeInsets.only(
                    top: 24.0,
                    bottom: 64.0,
                  ),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/images/flutter_logo.png',
                  ),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(Icons.account_circle_rounded),
                  title: Text('Profile'),
                ),
                ListTile(
                  onTap: () {
                    context.read<SignInBloc>().add(const SignOutRequired());
                  },
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                ),
                Spacer(),
                DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 16.0,
                    ),
                    child: Text('Terms of Service | Privacy Policy'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchQueryController.dispose();
    super.dispose();
  }
}

class RecipeDetailScreen extends StatelessWidget {
  final String recipeId;

  // Przykładowa metoda do pobierania przepisu - na razie zwraca statyczne dane
  Recipe getRecipeById(String id) {
    // Tymczasowe przepisy - powinny być zastąpione danymi z bazy danych
    List<Recipe> recipes = [
      Recipe(id: '1', title: 'Przepis 1', description: 'Opis przepisu 1'),
      // Dodaj więcej przepisów
    ];
    return recipes.firstWhere((recipe) => recipe.id == id,
        orElse: () =>
            Recipe(id: '0', title: 'Nie znaleziono', description: ''));
  }

  RecipeDetailScreen({Key? key, required this.recipeId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recipe = getRecipeById(recipeId);

    return Scaffold(
      appBar: AppBar(title: Text(recipe.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'recipe$recipeId',
              child: CircleAvatar(
                child: Text(recipe.title[0]), // pierwsza litera tytułu
                radius: 50.0,
              ),
            ),
            SizedBox(height: 20),
            Text(recipe.description),
            // Dodaj więcej szczegółów o przepisie
          ],
        ),
      ),
    );
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
