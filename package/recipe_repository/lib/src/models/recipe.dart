import 'package:auth_repository/auth_repository.dart';

import '../entities/entities.dart';

class Recipe {
  String recipeId;
  String title; // Dodane pole
  String description;
  String imageUrl; // Dodane pole
  List<Map<String, dynamic>> ingredients; // Dodane pole
  List<String> steps; // Dodane pole
  DateTime createAt;
  MyUser myUser;

  Recipe({
    required this.recipeId,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.ingredients,
    required this.steps,
    required this.createAt,
    required this.myUser,
  });

  static final empty = Recipe(
    recipeId: '',
    title: '',
    description: '',
    imageUrl: '',
    ingredients: [],
    steps: [],
    createAt: DateTime.now(),
    myUser: MyUser.empty,
  );

  Recipe copyWith({
    String? recipeId,
    String? title,
    String? description,
    String? imageUrl,
    List<Map<String, dynamic>>? ingredients,
    List<String>? steps,
    DateTime? createAt,
    MyUser? myUser,
  }) {
    return Recipe(
      recipeId: recipeId ?? this.recipeId,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      createAt: createAt ?? this.createAt,
      myUser: myUser ?? this.myUser,
    );
  }

  RecipeEntity toEntity() {
    return RecipeEntity(
      recipeId: recipeId,
      title: title,
      description: description,
      imageUrl: imageUrl,
      ingredients: ingredients,
      steps: steps,
      createAt: createAt,
      myUser: myUser,
    );
  }

  static Recipe fromEntity(RecipeEntity entity) {
    return Recipe(
      recipeId: entity.recipeId,
      title: entity.title,
      description: entity.description,
      imageUrl: entity.imageUrl,
      ingredients: entity.ingredients,
      steps: entity.steps,
      createAt: entity.createAt,
      myUser: entity.myUser,
    );
  }

  @override
  String toString() {
    return '''Recipe: {
      recipeId: $recipeId,
      title: $title,
      description: $description,
      imageUrl: $imageUrl,
      ingredients: $ingredients,
      steps: $steps,
      createAt: $createAt,
      myUser: $myUser,
    }''';
  }
}
