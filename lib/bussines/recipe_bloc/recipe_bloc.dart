import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:recipe_repository/recipe_repository.dart';
part 'recipe_event.dart';
part 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipeRepository _recipeRepository;

  RecipeBloc({required RecipeRepository recipeRepository})
      : _recipeRepository = recipeRepository,
        super(RecipeInitial()) {
    on<DeleteRecipe>(_handleDeleteRecipe);
    on<UploadPicture>((event, emit) async {
      emit(UploadPictureLoading());
      try {
        String userImage =
            await _recipeRepository.uploadPicture(event.file, event.recipeId);
        emit(UploadPictureSuccess(userImage));
      } catch (e) {
        emit(UploadPictureFailure());
      }
    });
  }

  Future<void> _handleDeleteRecipe(
      DeleteRecipe event, Emitter<RecipeState> emit) async {
    try {
      await _recipeRepository.deleteRecipe(event.recipeId);
      emit(DeleteRecipeSuccess());
    } catch (e) {
      emit(DeleteRecipeFailure());
    }
  }
}
