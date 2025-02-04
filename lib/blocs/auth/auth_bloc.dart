import 'package:ca_app/blocs/auth/auth_event.dart';
import 'package:ca_app/blocs/auth/auth_state.dart';
import 'package:ca_app/data/local_storage/shared_prefs_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitState()) {
    on<AuthAppInitEvent>(_authUser);
    on<AuthForgotEvent>(_forgotPasswordApi);
  }

  Future<void> _authUser(
      AuthAppInitEvent event, Emitter<AuthState> emit) async {
    try {
      await Future.delayed(Duration(seconds: 2)); // a simulated delay
      String? token = await SharedPrefsClass().getToken();
      debugPrint('token:---$token');
      if (token != null) {
        emit(AuthSuccessState());
      } else {
        emit(AuthFailState());
      }
    } catch (e) {
      emit(AuthAppFailureState(message: e.toString()));
    }
  }

  Future<void> _forgotPasswordApi(
      AuthForgotEvent event, Emitter<AuthState> emit) async {
    emit(AuthForgotLoadingState());
    await Future.delayed(Duration(seconds: 3));
    emit(AuthForgotSuccessState());
  }
}
