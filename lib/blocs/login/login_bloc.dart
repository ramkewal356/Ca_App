import 'package:bloc/bloc.dart';
import 'package:ca_app/data/models/login_model.dart';
import 'package:ca_app/data/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final _myRepo = AuthRepository();

  LoginBloc() : super(LoginInitial()) {
    on<LoginApi>(_loginApi);
  }
  Future<void> _loginApi(LoginApi event, Emitter<LoginState> emit) async {
    try {
      emit(LoginLoadingState());
      Map<String, dynamic> body = {
        "email": event.userName,
        "password": event.password
      };
      var loginModel = await _myRepo.loginApi(body: body);
      emit(LoginSuccessState(loginModel: loginModel));
    } catch (e) {
      emit(LoginErrorState(errorMessage: e.toString()));
    }
  }
}
