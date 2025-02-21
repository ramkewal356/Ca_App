
import 'package:ca_app/data/models/get_user_by_id_model.dart';
import 'package:ca_app/data/models/login_model.dart';
import 'package:ca_app/data/models/otp_send_and_verify_model.dart';
import 'package:ca_app/data/models/update_user_model.dart';
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

///////////////**** Success State ****///////////////
/// Auth Success State///
class AuthSuccessState extends AuthState {
  final String role;

  const AuthSuccessState({required this.role});
  @override
  List<Object> get props => [role];
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
  final GetUserByIdModel? addUserModel;

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

/// Update Success State///
class UpdateUserSuccess extends AuthState {
  final UpdateUserModel? updateUser;

  const UpdateUserSuccess({required this.updateUser});
  @override
  List<Object> get props => [updateUser ?? []];
}

/// GetUserById Success State///
class GetUserByIdSuccess extends AuthState {
  final GetUserByIdModel? getUserByIdData;
  const GetUserByIdSuccess({required this.getUserByIdData});
  @override
  List<Object> get props => [getUserByIdData ?? []];
}
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
