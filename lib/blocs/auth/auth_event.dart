import 'dart:io';

import 'package:dio/dio.dart';
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
//**** Send Otp Event ****//
class ReSendOtpEvent extends AuthEvent {
  final String email;

  const ReSendOtpEvent({required this.email});
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
//**** Verify Otp For User Event ****//
class VerifyOtpForUserEvent extends AuthEvent {
  final String email;
  final String otp;
  const VerifyOtpForUserEvent({required this.email, required this.otp});
  @override
  List<Object> get props => [email, otp];
}

//**** Udate Profile Event ****//
class UpdateProfileImageEvent extends AuthEvent {
  final MultipartFile imageUrl;

  const UpdateProfileImageEvent({required this.imageUrl});
  @override
  List<Object> get props => [imageUrl];
}

//**** Udate User Event ****//
class UpdateUserEvent extends AuthEvent {
  final String userId;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? password;
  final String? mobile;
  final String? gender;
  final String? panCard;
  final String? addharCard;
  final String? address;

  const UpdateUserEvent(
      {required this.userId,
      this.password,
      this.gender,
      this.firstName,
      this.lastName,
      this.email,
      this.mobile,
      this.panCard,
      this.addharCard,
      this.address});
  @override
  List<Object> get props => [
        userId,
        password ?? '',
        gender ?? '',
        firstName ?? '',
        lastName ?? '',
        email ?? '',
        mobile ?? '',
        panCard ?? '',
        addharCard ?? '',
        address ?? ''
      ];
}

//**** Login Event ****//
class LoginEvent extends AuthEvent {
  final String userName;
  final String password;

  const LoginEvent({required this.userName, required this.password});
  @override
  List<Object> get props => [userName, password];
}

//**** Add New User Event ****//
class AddUserEvent extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String countryCode;
  final String mobile;
  final String role;

  const AddUserEvent(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.countryCode,
      required this.mobile,
      required this.role});

  @override
  List<Object> get props =>
      [firstName, lastName, email, countryCode, mobile, role];
}

//**** GetUserById Event ****//
class GetUserByIdEvent extends AuthEvent {
  final String? userId;
  
  const GetUserByIdEvent({this.userId});
  @override
  List<Object> get props => [userId ?? ''];
}
