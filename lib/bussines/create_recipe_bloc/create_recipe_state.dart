part of 'create_recipe_bloc.dart';

abstract class CreateRecipeState extends Equatable {
  const CreateRecipeState();

  @override
  List<Object> get props => [];
}

class CreateRecipeInitial extends CreateRecipeState {}

class CreateRecipeLoading extends CreateRecipeState {}

class CreateRecipeSuccess extends CreateRecipeState {
  final Recipe recipe;

  const CreateRecipeSuccess(this.recipe);

  @override
  List<Object> get props => [recipe];
}

class CreateRecipeFailure extends CreateRecipeState {}
