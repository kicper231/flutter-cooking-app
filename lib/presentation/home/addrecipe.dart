import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectapp/bussines/authentication_bloc/authentication_bloc.dart';
import 'package:projectapp/bussines/create_recipe_bloc/create_recipe_bloc.dart';
import 'package:projectapp/bussines/my_user_bloc/my_user_bloc.dart';
import 'package:recipe_repository/recipe_repository.dart';

class AddRecipe extends StatefulWidget {
  final MyUser myUser;

  const AddRecipe(this.myUser, {Key? key}) : super(key: key);

  @override
  State<AddRecipe> createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _ingredientNameController = TextEditingController();
  final _ingredientAmountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _stepController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, String>> _ingredients = [];
  List<String> _steps = [];
  late Recipe recipe;

  @override
  void initState() {
    super.initState();
    recipe = Recipe.empty;
    recipe.myUser = widget.myUser;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _scrollController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    // final myUserBloc = context.read<MyUserBloc>();

    // final myUser = myUserBloc.state.user;
    final authBloc = context.read<AuthenticationBloc>();
    final myUser = authBloc.state.user;
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
        body: BlocListener<CreateRecipeBloc, CreateRecipeState>(
          listener: (context, state) {
            if (state is CreateRecipeSuccess) {
              // Wyświetl powiadomienie
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Przepis został dodany!'),
                  backgroundColor: Colors.green,
                ),
              );
              // Przekieruj do głównej strony (np. poprzedniej strony)
              Navigator.pop(context);
            } else if (state is CreateRecipeFailure) {
              // Wyświetl powiadomienie o błędzie
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Wystąpił błąd przy dodawaniu przepisu.'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                controller: _scrollController,
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: AssetImage("assets/food.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Icon(Icons.camera_alt, size: 50),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Miejsce na Twoją logikę dodawania zdjęć
                    },
                    child: const Text('Dodaj zdjęcie'),
                  ),
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
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Opis',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Proszę wpisać opis przepisu';
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
                    onChanged: (String? newValue) {},
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _ingredientNameController,
                    decoration: const InputDecoration(
                      labelText: 'Nazwa składnika',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _ingredientAmountController,
                    decoration: const InputDecoration(
                      labelText: 'Ilość',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _ingredients.add({
                          "name": _ingredientNameController.text,
                          "amount": _ingredientAmountController.text
                        });
                        _ingredientNameController.clear();
                        _ingredientAmountController.clear();
                      });
                    },
                    child: const Text('Dodaj Składnik'),
                  ),
                  for (var ingredient in _ingredients)
                    ListTile(
                      title: Text(
                          "${ingredient['name']} - ${ingredient['amount']}"),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            _ingredients.remove(ingredient);
                          });
                        },
                      ),
                    ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _stepController,
                    decoration: const InputDecoration(
                      labelText: 'Krok przygotowania',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (_stepController.text.isNotEmpty) {
                        setState(() {
                          _steps.add(_stepController.text);
                          _stepController.clear();
                        });
                      }
                    },
                    child: const Text('Dodaj Krok'),
                  ),
                  for (var step in _steps)
                    ListTile(
                      title: Text(step),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            _steps.remove(step);
                          });
                        },
                      ),
                    ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Tutaj tworzysz obiekt Recipe z danymi z formularza
                      setState(() {
                        recipe = recipe.copyWith(
                          title: _titleController.text,
                          description: _descriptionController.text,
                          ingredients: _ingredients,
                          steps: _steps,
                        );
                      });

                      // Użyj Bloc do dodania przepisu
                      context
                          .read<CreateRecipeBloc>()
                          .add(CreateRecipe(recipe));
                    },
                    child: const Text('Zapisz przepis'),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
