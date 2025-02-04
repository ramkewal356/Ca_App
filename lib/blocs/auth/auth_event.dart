import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

class AuthAppInitEvent extends AuthEvent {}

class AuthForgotEvent extends AuthEvent {
  final String email;

  const AuthForgotEvent({required this.email});
  @override
  List<Object> get props => [email];
}
