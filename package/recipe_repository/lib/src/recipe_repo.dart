import 'models/models.dart';

abstract class RecipeRepository {
  Future<Recipe> createRecipe(Recipe recipe);

  Future<List<Recipe>> getRecipes();

  Future<List<Recipe>> getRecipesByUser(String userId);
}
