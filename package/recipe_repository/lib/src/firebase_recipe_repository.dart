import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../recipe_repository.dart';

class FirebaseRecipeRepository implements RecipeRepository {
  final RecipeCollection = FirebaseFirestore.instance.collection('Recipes');

  @override
  Future<Recipe> createRecipe(Recipe Recipe) async {
    try {
      Recipe.recipeId = const Uuid().v1();
      Recipe.createAt = DateTime.now();

      await RecipeCollection.doc(Recipe.recipeId)
          .set(Recipe.toEntity().toDocument());

      return Recipe;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Recipe>> getRecipes() async {
    try {
      return await RecipeCollection.get().then((value) => value.docs
          .map((e) => Recipe.fromEntity(RecipeEntity.fromDocument(e.data())))
          .toList());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Recipe>> getRecipesByUser(String userId) async {
    try {
      return await RecipeCollection.where('myUser.userId', isEqualTo: userId)
          .get()
          .then((value) => value.docs
              .map(
                  (e) => Recipe.fromEntity(RecipeEntity.fromDocument(e.data())))
              .toList());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
