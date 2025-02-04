part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginApi extends LoginEvent {
  final String userName;
  final String password;

  const LoginApi({required this.userName, required this.password});
  @override
  List<Object> get props => [userName, password];
}
