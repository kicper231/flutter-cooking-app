import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:recipe_repository/recipe_repository.dart';

part 'create_recipe_event.dart';
part 'create_recipe_state.dart';

class CreateRecipeBloc extends Bloc<CreateRecipeEvent, CreateRecipeState> {
  final RecipeRepository _recipeRepository;

  CreateRecipeBloc({
    required RecipeRepository recipeRepository,
  })  : _recipeRepository = recipeRepository,
        super(CreateRecipeInitial()) {
    on<CreateRecipe>((event, emit) async {
      emit(CreateRecipeLoading());
      try {
        Recipe recipe = await _recipeRepository.createRecipe(event.recipe);
        emit(CreateRecipeSuccess(recipe));
      } catch (_) {
        emit(CreateRecipeFailure());
      }
    });
  }
}
