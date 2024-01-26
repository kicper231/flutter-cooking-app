import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
//import 'package:projectapp/presentation/home/home.dart';
import 'package:recipe_repository/recipe_repository.dart';

part 'get_recipe_event.dart';
part 'get_recipe_state.dart';

class GetRecipeBloc extends Bloc<GetRecipeEvent, GetRecipeState> {
  final RecipeRepository _recipeRepository;

  GetRecipeBloc({
    required RecipeRepository recipeRepository,
  })  : _recipeRepository = recipeRepository,
        super(GetRecipeInitial()) {
    on<GetRecipes>((event, emit) async {
      emit(GetRecipeLoading());
      try {
        List<Recipe> recipes = await _recipeRepository.getRecipes();
        emit(GetRecipeSuccess(recipes));
      } catch (_) {
        emit(GetRecipeFailure());
      }
    });
  }
}
