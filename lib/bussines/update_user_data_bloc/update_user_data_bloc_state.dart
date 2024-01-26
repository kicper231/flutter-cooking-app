part of 'update_user_data_bloc_bloc.dart';

sealed class UpdateUserDataState extends Equatable {
  const UpdateUserDataState();

  @override
  List<Object> get props => [];
}

final class UpdateUserDataBlocInitial extends UpdateUserDataState {}

class UpdateUserInfoInitial extends UpdateUserDataState {}

class UploadPictureFailure extends UpdateUserDataState {}

class UploadPictureLoading extends UpdateUserDataState {}

class UploadPictureSuccess extends UpdateUserDataState {
  final String userImage;
  const UploadPictureSuccess(this.userImage);
  @override
  List<Object> get props => [userImage];
}
