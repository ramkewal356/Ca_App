import 'package:ca_app/data/models/login_model.dart';
import 'package:ca_app/data/providers/end_points.dart';
import 'package:ca_app/data/providers/http_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AuthRepository {
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
      return LoginModel.fromJson(response?.data);
    } catch (e) {
      if (e is DioError && e.response != null) {
        // Handle API errors with custom error messages
        String errorMessage =
            e.response?.data['error'] ?? 'An unknown error occurred';

        throw errorMessage;
      } else {
        // Handle unexpected errors
        throw Exception('An unexpected error occurred');
      }

      // http.handleErrorResponse(error: e);
      // rethrow;
    }
  }
}
