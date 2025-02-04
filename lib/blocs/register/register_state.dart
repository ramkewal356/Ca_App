part of 'register_bloc.dart';

sealed class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

final class RegisterInitial extends RegisterState {}

final class RegisterLoading extends RegisterState {}

final class RegisterSuccess extends RegisterState {
  // final RegisterResponseModel? registerResponse;
  final bool registerResponse;

  const RegisterSuccess({required this.registerResponse});
  @override
  List<Object> get props => [registerResponse];
}

final class RegisterError extends RegisterState {
  final String error;

  const RegisterError({required this.error});
  @override
  List<Object> get props => [error];
}
