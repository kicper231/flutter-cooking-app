part of 'get_recipe_bloc.dart';

abstract class GetRecipeState extends Equatable {
  const GetRecipeState();

  @override
  List<Object> get props => [];
}

class GetRecipeInitial extends GetRecipeState {}

class GetRecipeLoading extends GetRecipeState {}

class GetRecipeSuccess extends GetRecipeState {
  final List<Recipe> recipes;

  const GetRecipeSuccess(this.recipes);

  @override
  List<Object> get props => [recipes];
}

class GetRecipeFailure extends GetRecipeState {}
