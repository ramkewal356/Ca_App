
import 'package:ca_app/data/models/user_model.dart';
import 'package:ca_app/data/models/login_model.dart';
import 'package:ca_app/data/models/otp_send_and_verify_model.dart';
import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object> get props => [];
}

//////////////**** Initial State ****////////////////
class AuthInitState extends AuthState {}

///////////////**** Loading State ****///////////////
class AuthLoading extends AuthState {}

///////////////**** Send Otp Loading State ****///////////////
class SendOtpLoading extends AuthState {}

///////////////**** Success State ****///////////////
/// Auth Success State///
class AuthSuccessState extends AuthState {
  final String role;

  const AuthSuccessState({required this.role});
  @override
  List<Object> get props => [role];
}
/// Get User Loading State///
class GetUserLoading extends AuthState {
  
}
/// Login Success State///
class LoginSuccess extends AuthState {
  final LoginModel? loginModel;

  const LoginSuccess({required this.loginModel});

  @override
  List<Object> get props => [loginModel ?? []];
}

/// Add User Success State///
final class AddUserSuccess extends AuthState {
  final UserModel? addUserModel;

  const AddUserSuccess({required this.addUserModel});
  @override
  List<Object> get props => [addUserModel ?? []];
}

/// SendOtp Success State///
class SendOtpSuccess extends AuthState {
  final OtpSendAndVerifyModel? otpSendModel;

  const SendOtpSuccess({required this.otpSendModel});
  @override
  List<Object> get props => [otpSendModel ?? []];
}

/// VerifyOtp Success State///
class VerifyOtpSuccess extends AuthState {
  final OtpSendAndVerifyModel? verifyModel;

  const VerifyOtpSuccess({required this.verifyModel});
  @override
  List<Object> get props => [verifyModel ?? []];
}
/// VerifyOtp Success State///
class VerifyOtpForUserSuccess extends AuthState {
  final UserModel? verifiedUser;

  const VerifyOtpForUserSuccess({required this.verifiedUser});
  @override
  List<Object> get props => [verifiedUser ?? []];
}
/// Update Success State///
class UpdateUserSuccess extends AuthState {
  final UserModel? updateUser;

  const UpdateUserSuccess({required this.updateUser});
  @override
  List<Object> get props => [updateUser ?? []];
}

/// Update Success State///
class UpdateProfileImgSuccess extends AuthState {
  final UserModel? updateUser;

  const UpdateProfileImgSuccess({required this.updateUser});
  @override
  List<Object> get props => [updateUser ?? []];
}
/// GetUserById Success State///
class GetUserByIdSuccess extends AuthState {
  final UserModel? getUserByIdData;
  const GetUserByIdSuccess({required this.getUserByIdData});
  @override
  List<Object> get props => [getUserByIdData ?? []];
}
/// Deactive Loading  State///
class DeactiveLoading extends AuthState {}

/// Deactive user Success State///
class DeactiveUserSucess extends AuthState {}

/////////////////**** End Success State ****////////////////

///////////////**** Fail State ****////////////////
class AuthFail extends AuthState {}
///////////////**** Error State ****////////////////
class AuthErrorState extends AuthState {
  final String erroMessage;

  const AuthErrorState({required this.erroMessage});

  @override
  List<Object> get props => [erroMessage];
}
