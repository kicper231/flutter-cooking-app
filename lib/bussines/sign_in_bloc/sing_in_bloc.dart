import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'sing_in_event.dart';
part 'sing_in_state.dart';

class SingInBloc extends Bloc<SingInEvent, SingInState> {
  SingInBloc() : super(SingInInitial()) {
    on<SingInEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
