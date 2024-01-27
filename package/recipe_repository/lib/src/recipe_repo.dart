import 'models/models.dart';

abstract class RecipeRepository {
  Future<Recipe> createRecipe(Recipe recipe);

  Future<List<Recipe>> getRecipes();

  Future<List<Recipe>> getRecipesByUser(String userId);
  Future<String> uploadPicture(String file, String recipeId);
  Future<void> deleteRecipe(String recipeId);
}
