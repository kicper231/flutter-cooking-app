part of 'get_recipe_bloc.dart';

abstract class GetRecipeEvent extends Equatable {
  const GetRecipeEvent();

  @override
  List<Object> get props => [];
}

class GetRecipes extends GetRecipeEvent {}
