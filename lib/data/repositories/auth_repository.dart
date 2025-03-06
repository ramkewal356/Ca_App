
import 'package:ca_app/data/models/deactive_user_model.dart';
import 'package:ca_app/data/models/user_model.dart';
import 'package:ca_app/data/models/login_model.dart';
import 'package:ca_app/data/models/otp_send_and_verify_model.dart';
import 'package:ca_app/data/models/response_model/base_response_model.dart';
import 'package:ca_app/data/providers/end_points.dart';
import 'package:ca_app/data/providers/http_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AuthRepository {
  //**** Login API ****//
  Future<LoginModel?> loginApi({required Map<String, dynamic> body}) async {
    var http = HttpService(
        isAuthorizeRequest: false,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.loginUrl,
        body: body,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.POST);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('response ${response?.data}');
      var baseResponse = BaseResponseModel.fromJson(response?.data);
      if (baseResponse.status?.httpCode == '200') {
        return LoginModel.fromJson(response?.data);
      }
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
    return null;
  }
  //**** Add New User API ****//
  Future<UserModel?> addNewUser(
      {required Map<String, dynamic> body}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.addNewUserUrl,
        body: body,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.POST);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('userResponse ${response?.data}');
      return UserModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  //**** Update Profile Image API ****//
  Future<UserModel?> updateProfileImage(
      {required Map<String, dynamic> body}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.updateProfileImageUrl,
        body: body,
        bodyType: HttpBodyType.FormData,
        methodType: HttpMethodType.PUT);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('sendOtpResponse ${response?.data}');
      return UserModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }
  //**** Send Otp API ****//
  Future<OtpSendAndVerifyModel?> sendOtpForReset(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: false,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.sendOtpForResetUrl,
        queryParameters: query,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.PUT);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('sendOtpResponse ${response?.data}');
      return OtpSendAndVerifyModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  //**** Send Otp API ****//
  Future<OtpSendAndVerifyModel?> reSendOtpForUser(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: false,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.resendOtpForUsersUrl,
        queryParameters: query,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.PUT);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('reSendOtpResponse ${response?.data}');
      return OtpSendAndVerifyModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

//**** Verify Otp API ****//
  Future<OtpSendAndVerifyModel?> verifyOtpForReset(
      {required Map<String, dynamic> body}) async {
    var http = HttpService(
        isAuthorizeRequest: false,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.verifyOtpUrl,
        body: body,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.PUT);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('sendOtpResponse ${response?.data}');
      return OtpSendAndVerifyModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

//**** Verify Otp API ****//
  Future<UserModel?> verifyOtpForUser(
      {required Map<String, dynamic> body}) async {
    var http = HttpService(
        isAuthorizeRequest: false,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.verifyOtpForUserUrl,
        body: body,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.PUT);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('sendOtpResponse ${response?.data}');
      return UserModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

//**** Update User API ****//
  Future<UserModel?> updateUser({required Map<String, dynamic> body}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.updateUserUrl,
        body: body,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.PUT);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('sendOtpResponse ${response?.data}');
      return UserModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }


  //**** GetUserById API ****//
  Future<UserModel?> getUserByIdApi(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.getUserByIdUrl,
        queryParameters: query,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.GET);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('getUserResponse ${response?.data}');
      return UserModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }
  //**** Deactive User API ****//
  Future<ActiveDeactiveUserModel?> activeDeactiveUserApi(
      {required Map<String, dynamic> body}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.deactiveUserUrl,
        body: body,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.PUT);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('getDeactiveResponse ${response?.data}');
      return ActiveDeactiveUserModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }
}
