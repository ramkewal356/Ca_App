import 'package:ca_app/blocs/auth/auth_event.dart';
import 'package:ca_app/blocs/auth/auth_state.dart';
import 'package:ca_app/data/local_storage/shared_prefs_class.dart';
import 'package:ca_app/data/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final _myRepo = AuthRepository();
  AuthBloc() : super(AuthInitState()) {
    on<AuthAppInitEvent>(_authUser);
    on<LoginEvent>(_loginApi);
    on<SendOtpEvent>(_sendOtpApi);
    on<VerifyOtpEvent>(_verifyOtpApi);
    on<UpdateUserEvent>(_updateUserApi);
    on<GetUserByIdEvent>(_getUserById);
   
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
        emit(AuthErrorState(erroMessage: 'Failed'));
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
          SharedPrefsClass().saveUser(loginResp?.data?.token ?? '',
              loginResp?.data?.role ?? '', loginResp?.data?.id ?? 0);
          emit(LoginSuccess(loginModel: loginResp));
        }
      }
    } catch (e) {
      emit(AuthErrorState(erroMessage: e.toString()));
    }
  }

  //**** Call Send Otp API ****//
  Future<void> _sendOtpApi(SendOtpEvent event, Emitter<AuthState> emit) async {
    Map<String, dynamic> query = {"email": event.email};
    try {
      emit(AuthLoading());
      var resp = await _myRepo.sendOtpForReset(query: query);
      if (resp?.status?.httpCode == '200') {
        emit(SendOtpSuccess(otpSendModel: resp));
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
      }
    } catch (e) {
      emit(AuthErrorState(erroMessage: e.toString()));
    }
  }

  //**** Call Update User API ****//
  Future<void> _updateUserApi(
      UpdateUserEvent event, Emitter<AuthState> emit) async {
    Map<String, dynamic> body = {
      "userId": event.userId,
      "password": event.password,
      "gender": event.gender,
      "firstName": event.firstName,
      "address": event.address
    };
    try {
      emit(AuthLoading());
      var resp = await _myRepo.updateUser(body: body);
      if (resp?.status?.httpCode == '200') {
        emit(UpdateUserSuccess(updateUser: resp));
      }
    } catch (e) {
      emit(AuthErrorState(erroMessage: e.toString()));
    }
  }

  //**** Call GetUser API ****//
  Future<void> _getUserById(
      GetUserByIdEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());
      int? userId = await SharedPrefsClass().getUserId();
      Map<String, dynamic> query = {"userId": userId};
      var resp = await _myRepo.getUserByIdApi(query: query);
      if (resp?.status?.httpCode == '200') {
        emit(GetUserByIdSuccess(getUserByIdData: resp));
      }
    } catch (e) {
      emit(AuthErrorState(erroMessage: e.toString()));
    }
  }
}
