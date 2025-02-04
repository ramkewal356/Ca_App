import 'package:bloc/bloc.dart';
import 'package:ca_app/data/models/register_request_model.dart';
import 'package:equatable/equatable.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial()) {
    on<Register>(_register);
  }
}

Future<void> _register(Register event, Emitter<RegisterState> emit) async {
  try {
    emit(RegisterLoading());
    await Future.delayed(Duration(seconds: 2));
    emit(RegisterSuccess(registerResponse: true));
  } catch (e) {
    emit(RegisterError(error: e.toString()));
  }
}
