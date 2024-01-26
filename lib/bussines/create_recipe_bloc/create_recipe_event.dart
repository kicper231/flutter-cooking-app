part of 'create_recipe_bloc.dart';

abstract class CreateRecipeEvent extends Equatable {
  const CreateRecipeEvent();

  @override
  List<Object> get props => [];
}

class CreateRecipe extends CreateRecipeEvent {
  final Recipe recipe;

  const CreateRecipe(this.recipe);

  @override
  List<Object> get props => [recipe];
}
