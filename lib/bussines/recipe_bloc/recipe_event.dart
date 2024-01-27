part of 'recipe_bloc.dart';

sealed class RecipeEvent extends Equatable {
  const RecipeEvent();

  @override
  List<Object> get props => [];
}

class UploadPicture extends RecipeEvent {
  final String file;
  final String recipeId;
  const UploadPicture(this.file, this.recipeId);
  @override
  List<Object> get props => [file, recipeId];
}

class DeleteRecipe extends RecipeEvent {
  final String recipeId;

  const DeleteRecipe(this.recipeId);

  @override
  List<Object> get props => [recipeId];
}
