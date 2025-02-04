import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object> get props => [];
}

class AuthInitState extends AuthState {}

class AuthSuccessState extends AuthState {}

class AuthFailState extends AuthState {}

class AuthForgotLoadingState extends AuthState {}

class AuthForgotSuccessState extends AuthState {}

class AuthForgotFailState extends AuthState {
  final String message;

  const AuthForgotFailState({required this.message});
  @override
  List<Object> get props => [message];
}

class AuthAppFailureState extends AuthState {
  final String message;

  const AuthAppFailureState({required this.message});

  @override
  List<Object> get props => [message];
}
