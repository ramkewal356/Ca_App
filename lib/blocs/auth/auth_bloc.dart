import 'package:ca_app/blocs/auth/auth_event.dart';
import 'package:ca_app/blocs/auth/auth_state.dart';
import 'package:ca_app/data/local_storage/shared_prefs_class.dart';
import 'package:ca_app/data/models/user_model.dart';
import 'package:ca_app/data/repositories/auth_repository.dart';
import 'package:ca_app/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final _myRepo = AuthRepository();
  AuthBloc() : super(AuthInitState()) {
    on<AuthAppInitEvent>(_authUser);
    on<LoginEvent>(_loginApi);
    on<AddUserEvent>(_addUserApi);

    on<SendOtpEvent>(_sendOtpApi);
    on<ReSendOtpEvent>(_reSendOtpForUserApi);

    on<VerifyOtpEvent>(_verifyOtpApi);
    on<VerifyOtpForUserEvent>(_verifyOtpForUserApi);

    on<UpdateUserEvent>(_updateUserApi);
    on<UpdateProfileImageEvent>(_uploadProfileImageApi);

    on<GetUserByIdEvent>(_getUserById);
    on<DeactiveUserEvent>(_activeDeactiveUser);
  }
  //**** Call AuthUser API ****//
  Future<void> _authUser(
      AuthAppInitEvent event, Emitter<AuthState> emit) async {
    try {
      await Future.delayed(Duration(seconds: 2)); // a simulated delay
      String? token = await SharedPrefsClass().getToken();
      String? role = await SharedPrefsClass().getRole();

      debugPrint('token:---$token');
      if (token != null) {
        emit(AuthSuccessState(role: role ?? ''));
      } else {
        emit(AuthFail());
      }
    } catch (e) {
      emit(AuthErrorState(erroMessage: e.toString()));
    }
  }

  //**** Call login API ****//
  Future<void> _loginApi(LoginEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());
      Map<String, dynamic> body = {
        "email": event.userName,
        "password": event.password
      };
      var loginResp = await _myRepo.loginApi(body: body);
      if (loginResp?.status?.httpCode == '200') {
        if (loginResp?.data?.token != null || loginResp?.data?.role != null) {
          await SharedPrefsClass().saveUser(loginResp?.data?.token ?? '',
              loginResp?.data?.role ?? '', loginResp?.data?.id ?? 0);
          emit(LoginSuccess(loginModel: loginResp));
        }
      }
    } catch (e) {
      emit(AuthErrorState(erroMessage: e.toString()));
    }
  }

  //**** Call Add User API ****//
  Future<void> _addUserApi(AddUserEvent event, Emitter<AuthState> emit) async {
    try {
      int? userId = await SharedPrefsClass().getUserId();
      debugPrint('userId.,.,.,.,.,.,., $userId');

      Map<String, dynamic> body = {
        "caId": userId,
        "addedBy": userId,
        "firstName": event.firstName,
        "lastName": event.lastName,
        "mobile": event.mobile,
        "email": event.email,
        "role": event.role,
        "countryCode": event.countryCode,
        if ((event.addharNumber ?? '').isNotEmpty)
          "aadhaarCardNumber": event.addharNumber,
        if ((event.degination ?? '').isNotEmpty) "designation": event.degination
      };
      emit(AuthLoading());
      var userResp = await _myRepo.addNewUser(body: body);
      if (userResp?.status?.httpCode == '200') {
        emit(AddUserSuccess(addUserModel: userResp));
      }
    } catch (e) {
      emit(AuthErrorState(erroMessage: e.toString()));
    }
  }

  //**** Call Send Otp API ****//
  Future<void> _sendOtpApi(SendOtpEvent event, Emitter<AuthState> emit) async {
    Map<String, dynamic> query = {"email": event.email};
    try {
      emit(SendOtpLoading());
      var resp = await _myRepo.sendOtpForReset(query: query);
      if (resp?.status?.httpCode == '200') {
        emit(SendOtpSuccess(otpSendModel: resp));
        Utils.toastSuccessMessage('Otp Send Successfully');
      }
    } catch (e) {
      emit(AuthErrorState(erroMessage: e.toString()));
    }
  }

  //**** Call ReSend Otp API ****//
  Future<void> _reSendOtpForUserApi(
      ReSendOtpEvent event, Emitter<AuthState> emit) async {
    Map<String, dynamic> query = {"email": event.email};
    try {
      emit(SendOtpLoading());
      var resp = await _myRepo.reSendOtpForUser(query: query);
      if (resp?.status?.httpCode == '200') {
        emit(SendOtpSuccess(otpSendModel: resp));
        Utils.toastSuccessMessage('Otp Send Successfully');
      }
    } catch (e) {
      emit(AuthErrorState(erroMessage: e.toString()));
    }
  }

  //**** Call Verify Otp API ****//
  Future<void> _verifyOtpApi(
      VerifyOtpEvent event, Emitter<AuthState> emit) async {
    Map<String, dynamic> body = {"email": event.email, "otp": event.otp};
    try {
      emit(AuthLoading());
      var resp = await _myRepo.verifyOtpForReset(body: body);
      if (resp?.status?.httpCode == '200') {
        emit(VerifyOtpSuccess(verifyModel: resp));
        Utils.toastSuccessMessage('Otp Verified Successfully');
      }
    } catch (e) {
      emit(AuthErrorState(erroMessage: e.toString()));
    }
  }

  //**** Call Verify Otp for user API ****//
  Future<void> _verifyOtpForUserApi(
      VerifyOtpForUserEvent event, Emitter<AuthState> emit) async {
    Map<String, dynamic> body = {"email": event.email, "otp": event.otp};
    try {
      emit(AuthLoading());
      var resp = await _myRepo.verifyOtpForUser(body: body);
      if (resp?.status?.httpCode == '200') {
        emit(VerifyOtpForUserSuccess(verifiedUser: resp));
        Utils.toastSuccessMessage('Otp Verified Successfully');
      }
    } catch (e) {
      emit(AuthErrorState(erroMessage: e.toString()));
    }
  }

  //**** Call Update User API ****//
  Future<void> _updateUserApi(
      UpdateUserEvent event, Emitter<AuthState> emit) async {
    int? userId = await SharedPrefsClass().getUserId();
    debugPrint('userId.,.,.,.,.,.,., $userId');
    Map<String, dynamic> body = {
      "firstname": event.firstName,
      "lastname": event.lastName,
      "email": event.email,
      "gender": event.gender,
      "mobile": event.mobile,
      "panCardNumber": event.panCard,
      "aadhaarCardNumber": event.addharCard,
      "address": event.address,
      "userId": event.userId.isEmpty ? userId : event.userId,
      "password": event.password
    };
    try {
      emit(AuthLoading());
      var resp = await _myRepo.updateUser(body: body);
      if (resp?.status?.httpCode == '200') {
        emit(UpdateUserSuccess(updateUser: resp));
        Utils.toastSuccessMessage('Profile Updated Successfully');
      }
    } catch (e) {
      emit(AuthErrorState(erroMessage: e.toString()));
    }
  }

//**** Call Upload profile image API ****//
  Future<void> _uploadProfileImageApi(
      UpdateProfileImageEvent event, Emitter<AuthState> emit) async {
    MultipartFile? companyImage;
    MultipartFile? selectedImage;
    if (event.companyLogo != null ||
        (event.companyLogo?.path ?? '').isNotEmpty) {
      companyImage =
          await MultipartFile.fromFile(event.companyLogo?.path ?? '');
    } else if (event.imageUrl != null ||
        (event.imageUrl?.path ?? '').isNotEmpty) {
      selectedImage = await MultipartFile.fromFile(event.imageUrl?.path ?? '');
    }
    debugPrint('bnxcnxcnmxbcmnbxcmncbm${selectedImage?.filename}');
    debugPrint('bnxcnxcnmxbcmnbxcmncbm ${companyImage?.filename}');

    int? userId = await SharedPrefsClass().getUserId();
    debugPrint('userId.,.,.,.,.,.,., $userId');
    Map<String, dynamic> body = {
      "userId": userId,
      "image": selectedImage,
      "companyLogo": companyImage
    };
    try {
      emit(AuthLoading());
      var resp = await _myRepo.updateProfileImage(body: body);
      if (resp?.status?.httpCode == '200') {
        emit(UpdateUserSuccess(updateUser: resp));
        Utils.toastSuccessMessage('Profile Image Updated Successfully');
      }
    } catch (e) {
      emit(AuthErrorState(erroMessage: e.toString()));
    }
  }

  //**** Call GetUser API ****//
  Future<UserModel?> _getUserById(
      GetUserByIdEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());
      int? userId = await SharedPrefsClass().getUserId();
      if (userId == null) {
        await Future.delayed(Duration(seconds: 2));
      }
      Map<String, dynamic> query = {
        "userId": (event.userId ?? '').isEmpty ? userId : event.userId
      };
      var resp = await _myRepo.getUserByIdApi(query: query);
      if (resp?.status?.httpCode == '200') {
        emit(GetUserByIdSuccess(getUserByIdData: resp));
      }
      return resp;
    } catch (e) {
      emit(AuthErrorState(erroMessage: e.toString()));
    }
    return null;
  }

  Future<void> _activeDeactiveUser(
      DeactiveUserEvent event, Emitter<AuthState> emit) async {
    try {
      emit(DeactiveLoading());
      int? userId = await SharedPrefsClass().getUserId();
      Map<String, dynamic> body = {
        "actionPerformerId": userId,
        "actionUponId": event.actionUponId,
        "reason": event.reason,
        "action": event.action
      };
      var resp = await _myRepo.activeDeactiveUserApi(body: body);
      if (resp?.status?.httpCode == '200') {
        emit(DeactiveUserSucess());
      }
    } catch (e) {
      emit(AuthErrorState(erroMessage: e.toString()));
    }
  }
}
