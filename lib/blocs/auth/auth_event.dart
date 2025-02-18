import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

class AuthAppInitEvent extends AuthEvent {}

//**** Send Otp Event ****//
class SendOtpEvent extends AuthEvent {
  final String email;

  const SendOtpEvent({required this.email});
  @override
  List<Object> get props => [email];
}
//**** Verify Otp Event ****//
class VerifyOtpEvent extends AuthEvent {
  final String email;
  final String otp;
  const VerifyOtpEvent({required this.email, required this.otp});
  @override
  List<Object> get props => [email, otp];
}

//**** Udate User Event ****//
class UpdateUserEvent extends AuthEvent {
  final String userId;
  final String password;
  final String gender;
  final String firstName;
  final String address;

  const UpdateUserEvent(
      {required this.userId,
      required this.password,
      required this.gender,
      required this.firstName,
      required this.address});
  @override
  List<Object> get props => [userId, password, gender, firstName, address];
}

//**** Login Event ****//
class LoginEvent extends AuthEvent {
  final String userName;
  final String password;

  const LoginEvent({required this.userName, required this.password});
  @override
  List<Object> get props => [userName, password];
}

//**** Register Event ****//
class RegisterEvent extends AuthEvent {}

//**** GetUserById Event ****//
class GetUserByIdEvent extends AuthEvent {}
