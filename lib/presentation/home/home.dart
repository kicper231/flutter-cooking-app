import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class HomeScreen extends StatelessWidget {
  final List<Recipe> recipes = [
    Recipe(id: '1', title: 'Przepis 1', description: 'Opis przepisu 1'),
    // Dodaj więcej przepisów
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome, you are In !'),
        actions: [
          IconButton(
              onPressed: () {
                context.read<SignInBloc>().add(const SignOutRequired());
              },
              icon: Icon(Icons.login))
        ],
      ),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return ListTile(
            title: Text(recipe.title),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeDetailScreen(recipe: recipe),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  RecipeDetailScreen({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recipe.title)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(recipe.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(recipe.description),
            // Dodaj więcej szczegółów o przepisie
          ],
        ),
      ),
    );
  }
}
