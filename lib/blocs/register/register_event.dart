part of 'register_bloc.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class Register extends RegisterEvent {
  final RegisterRequestModel? registerRequest;

  const Register({required this.registerRequest});
  @override
  List<Object> get props => [registerRequest ?? {}];
}
