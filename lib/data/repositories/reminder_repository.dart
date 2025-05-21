import 'package:ca_app/data/models/common_model.dart';
import 'package:ca_app/data/models/get_reminders_model.dart';
import 'package:ca_app/data/models/get_view_reminder_model.dart';
import 'package:ca_app/data/models/update_reminder_model.dart';
import 'package:ca_app/data/providers/end_points.dart';
import 'package:ca_app/data/providers/http_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ReminderRepository {
  //**** Get Reminder by CA Id API ****//
  Future<GetRemindersModel> getReminderByCaId(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.getReminderUrl,
        queryParameters: query,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.GET);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('reminder Response ${response?.data}');
      return GetRemindersModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  //**** Create Reminder by CA Id API ****//
  Future<bool> craeteReminderApi({required Map<String, dynamic> body}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.createReminderUrl,
        body: body,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.POST);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('create reminder Response ${response?.data}');
      return true;
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  //**** Get View Reminder by CA Id API ****//
  Future<GetViewReminderByIdModel> getViewReminderById(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.getViewReminderByIdUrl,
        queryParameters: query,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.GET);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('reminder Response ${response?.data}');
      return GetViewReminderByIdModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  //**** Update Reminder by CA Id API ****//
  Future<UpdateReminderModel> updateReminderById(
      {required Map<String, dynamic> body}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.updateReminderByIdUrl,
        body: body,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.PUT);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('reminder Response ${response?.data}');
      return UpdateReminderModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  //**** Active Deactive Reminder by CA Id API ****//
  Future<CommonModel> activeDeactiveReminderById(
      {required Map<String, dynamic> query, required bool isActive}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: isActive
            ? EndPoints.activeReminderUrl
            : EndPoints.deactiveReminderUrl,
        queryParameters: query,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.PUT);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('reminder Response ${response?.data}');
      return CommonModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }
}
