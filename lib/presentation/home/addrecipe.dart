import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectapp/bussines/create_recipe_bloc/create_recipe_bloc.dart';
import 'package:recipe_repository/recipe_repository.dart';

class AddRecipe extends StatefulWidget {
  const AddRecipe({super.key});

  @override
  State<AddRecipe> createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _descriptionController = TextEditingController();
  late Recipe recipe;

  @override
  void initState() {
    super.initState();
    recipe = Recipe.empty;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _ingredientsController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final List<String> _categories = [
      'Deser',
      'Śniadanie',
      'Obiad',
      'Kolacja',
      'Przekąska'
    ]; // Dodaj swoje kategorie
    //final createRecipeBloc = context.read<CreateRecipeBloc>();
    //final recipeRepository = context.read<FirebaseRecipeRepository>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dodaj Przepis'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Tytuł przepisu',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Proszę wpisać tytuł przepisu';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField(
                decoration: const InputDecoration(
                  labelText: 'Kategoria przepisu',
                  border: OutlineInputBorder(),
                ),
                items: _categories.map((String category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  // Logika zmiany kategorii
                },
                validator: (value) =>
                    value == null ? 'Proszę wybrać kategorię' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _ingredientsController,
                decoration: const InputDecoration(
                  labelText: 'Składniki',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Proszę wpisać składniki';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Opis przygotowania',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Proszę wpisać opis przygotowania';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Miejsce na Twoją logikę dodawania zdjęć
                },
                child: const Text('Dodaj zdjęcie'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Tutaj tworzysz obiekt Recipe z danymi z formularza
                    setState(() {
                      recipe.title = _titleController.text;
                      // recipe.ingredients = _ingredientsController
                      //     .text; // Może wymagać dodatkowej konwersji
                      recipe.description = _descriptionController.text;
                      // Uaktualnij inne pola recipe, jeśli potrzebujesz
                    });

                    // Użyj Bloc do dodania przepisu
                    context.read<CreateRecipeBloc>().add(CreateRecipe(recipe));
                  }
                },
                child: const Text('Zapisz przepis'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
