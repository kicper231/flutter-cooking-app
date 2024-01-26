import 'package:auth_repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'update_user_data_bloc_event.dart';
part 'update_user_data_bloc_state.dart';

class UpdateUserDataBloc
    extends Bloc<UpdateUserDataEvent, UpdateUserDataState> {
  final UserRepository _userRepository;

  UpdateUserDataBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(UpdateUserDataBlocInitial()) {
    on<UploadPicture>((event, emit) async {
      emit(UploadPictureLoading());
      try {
        String userImage =
            await _userRepository.uploadPicture(event.file, event.userId);
        emit(UploadPictureSuccess(userImage));
      } catch (e) {
        emit(UploadPictureFailure());
      }
    });
  }
}
