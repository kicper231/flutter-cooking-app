part of 'update_user_data_bloc_bloc.dart';

sealed class UpdateUserDataEvent extends Equatable {
  const UpdateUserDataEvent();

  @override
  List<Object> get props => [];
}

class UploadPicture extends UpdateUserDataEvent {
  final String file;
  final String userId;
  const UploadPicture(this.file, this.userId);
  @override
  List<Object> get props => [file, userId];
}
