part of 'recipe_bloc.dart';

sealed class RecipeState extends Equatable {
  const RecipeState();

  @override
  List<Object> get props => [];
}

final class RecipeInitial extends RecipeState {}

class UploadPictureFailure extends RecipeState {}

class UploadPictureLoading extends RecipeState {}

class UploadPictureSuccess extends RecipeState {
  final String recipeImage;
  const UploadPictureSuccess(this.recipeImage);
  @override
  List<Object> get props => [recipeImage];
}

class DeleteRecipeSuccess extends RecipeState {}

class DeleteRecipeFailure extends RecipeState {}
