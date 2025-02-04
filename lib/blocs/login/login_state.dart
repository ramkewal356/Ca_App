part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

final class LoginInitial extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {
  final LoginModel? loginModel;

  const LoginSuccessState({required this.loginModel});

  @override
  List<Object> get props => [loginModel ?? []];
}

class LoginErrorState extends LoginState {
  final String errorMessage;

  const LoginErrorState({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
