import 'package:auth_repository/auth_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projectapp/bussines/authentication_bloc/authentication_bloc.dart';
import 'package:projectapp/bussines/create_recipe_bloc/create_recipe_bloc.dart';
import 'package:projectapp/bussines/get_recipe_bloc/get_recipe_bloc.dart';
import 'package:projectapp/bussines/my_user_bloc/my_user_bloc.dart';
import 'package:projectapp/bussines/recipe_bloc/recipe_bloc.dart';
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
  late ScrollController _scrollController;
  List<Map<String, String>> _ingredients = [];
  List<String> _steps = [];
  late Recipe recipe;
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    recipe = Recipe.empty;
    recipe.imageUrl = '';
    recipe.myUser = widget.myUser;
    _scrollController = ScrollController();
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
          title: Text('add_recipe'.tr()),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<CreateRecipeBloc, CreateRecipeState>(
              listener: (context, state) {
                if (state is CreateRecipeSuccess) {
                  recipe = Recipe.empty;
                  setState(() {
                    recipe = Recipe.empty;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Przepis został dodany!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.of(context).pop(true);
                } else if (state is CreateRecipeFailure) {
                  recipe = Recipe.empty;
                  setState(() {
                    recipe = Recipe.empty;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Wystąpił błąd przy dodawaniu przepisu.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
            BlocListener<RecipeBloc, RecipeState>(
              listener: (context, state) {
                if (state is UploadPictureSuccess) {
                  setState(() {
                    recipe.imageUrl = state.recipeImage;
                  });
                }
              },
            ),
          ],
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
                      // Użyj obrazu z sieci, jeśli URL istnieje
                      image: (recipe.imageUrl != '' &&
                              recipe.imageUrl.isNotEmpty)
                          ? DecorationImage(
                              image: NetworkImage(recipe.imageUrl!),
                              fit: BoxFit.fill,
                            )
                          : null, // Nie ustawiaj obrazu tła, jeśli URL nie istnieje
                    ),
                    // Wyświetl ikonę aparatu, jeśli URL obrazu nie istnieje
                    child: (recipe.imageUrl == '' || recipe.imageUrl.isEmpty)
                        ? Center(child: Icon(Icons.camera_alt, size: 50))
                        : null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.gallery,
                          maxHeight: 500,
                          maxWidth: 500,
                          imageQuality: 40);
                      if (image != null) {
                        CroppedFile? croppedFile =
                            await ImageCropper().cropImage(
                          sourcePath: image.path,
                          aspectRatio:
                              const CropAspectRatio(ratioX: 1, ratioY: 1),
                          aspectRatioPresets: [CropAspectRatioPreset.square],
                          uiSettings: [
                            AndroidUiSettings(
                                toolbarTitle: 'Cropper',
                                toolbarColor:
                                    Theme.of(context).colorScheme.primary,
                                toolbarWidgetColor: Colors.white,
                                initAspectRatio: CropAspectRatioPreset.original,
                                lockAspectRatio: false),
                            IOSUiSettings(
                              title: 'Cropper',
                            ),
                          ],
                        );
                        if (croppedFile != null) {
                          setState(() {
                            context.read<RecipeBloc>().add(
                                UploadPicture(image.path, recipe.recipeId));
                          });
                        }
                      }
                    },
                    child: Text('add_photo'.tr()),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _titleController,
                    decoration:
                        getTextFieldDecoration(context, 'recipe_title'.tr()),
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
                    decoration: getTextFieldDecoration(
                        context, 'recipe_description'.tr()),
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
                    value:
                        selectedCategory, // Ustaw to na aktualnie wybraną kategorię
                    decoration:
                        getTextFieldDecoration(context, 'category'.tr()),
                    items: _categories.map((String category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCategory = newValue;
                      });
                    },
                  ),

                  //skladniki
                  Divider(
                    color: Theme.of(context).primaryColor,
                    height: 40,
                    thickness: 1, // Grubość linii
                  ),
                  TextFormField(
                    controller: _ingredientNameController,
                    decoration:
                        getTextFieldDecoration(context, 'ingredient'.tr()),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _ingredientAmountController,
                    decoration: getTextFieldDecoration(
                        context, 'ingredient_amount'.tr()),
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
                    child: Text('add_ingredient'.tr()),
                  ),
                  // for (var ingredient in _ingredients)
                  //   ListTile(
                  //     title: Text(
                  //         "${ingredient['name']} - ${ingredient['amount']}"),
                  //     trailing: IconButton(
                  //       icon: Icon(Icons.delete),
                  //       onPressed: () {
                  //         setState(() {
                  //           _ingredients.remove(ingredient);
                  //         });
                  //       },
                  //     ),
                  //   ),
                  for (var igridient in _ingredients)
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: ListTile(
                        dense: true,
                        visualDensity: VisualDensity(vertical: -4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                              color: const Color.fromARGB(255, 178, 178, 178)),
                        ),
                        //  tileColor: Color.fromARGB(255, 229, 229, 229),
                        title: Container(
                          margin: EdgeInsets.zero,
                          //  padding: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                              // Zaokrąglenie rogów
                              ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      right: 8.0), // Dodatkowy odstęp od ikony
                                  child: Text(
                                      "${igridient['name']} - ${igridient['amount']}"),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    _steps.remove(igridient);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  Divider(
                    color: Theme.of(context).primaryColor,
                    height: 40,
                    thickness: 1, // Grubość linii
                  ),
                  TextFormField(
                    controller: _stepController,
                    decoration:
                        getTextFieldDecoration(context, 'recipe_step'.tr()),
                    maxLines: 3,
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
                    child: Text('add_step'.tr()),
                  ),
                  SizedBox(height: 10),
                  for (var step in _steps)
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: ListTile(
                        dense: true,
                        visualDensity: VisualDensity(vertical: -4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                              color: const Color.fromARGB(255, 178, 178, 178)),
                        ),
                        //  tileColor: Color.fromARGB(255, 229, 229, 229),
                        title: Container(
                          margin: EdgeInsets.zero,
                          //  padding: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                              // Zaokrąglenie rogów
                              ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      right: 8.0), // Dodatkowy odstęp od ikony
                                  child: Text(step),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    _steps.remove(step);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
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
                            category: selectedCategory);
                      });

                      context
                          .read<CreateRecipeBloc>()
                          .add(CreateRecipe(recipe));
                    },
                    child: Text('save_recipe'.tr()),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  InputDecoration getTextFieldDecoration(
      BuildContext context, String labelText) {
    return InputDecoration(
      labelText: labelText,
      contentPadding: EdgeInsets.all(10.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
      ),
    );
  }
}
