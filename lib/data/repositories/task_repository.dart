import 'package:ca_app/data/models/common_model.dart';
import 'package:ca_app/data/models/get_assign_task_model.dart';
import 'package:ca_app/data/models/get_view_task_by_taskid_model.dart';
import 'package:ca_app/data/providers/end_points.dart';
import 'package:ca_app/data/providers/http_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class TaskRepository {
  //**** Get Self Assign Task API ****//
  Future<GetAssignTaskListModel> getSelfAssignTaskApi(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.getSelfTaskUrl,
        queryParameters: query,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.GET);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('teamResponse ${response?.data}');
      return GetAssignTaskListModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  //**** Get  Assign Task API ****//
  Future<GetAssignTaskListModel> getAssignTaskApi(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.getAssignTaskUrl,
        queryParameters: query,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.GET);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('teamResponse ${response?.data}');
      return GetAssignTaskListModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  //**** Create New Task API ****//
  Future<bool> createNewTaskApi({required Map<String, dynamic> body}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.createNewTaskUrl,
        body: body,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.POST);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('create task ${response?.data}');
      return true;
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  //**** Get View Task API ****//
  Future<GetViewTaskByTaskIdModel> getViewTaskDetailsApi(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.getViewTaskUrl,
        queryParameters: query,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.GET);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('get view task ${response?.data}');
      return GetViewTaskByTaskIdModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  //**** COMPLETE ,REJECT,ACCEPT Task API ****//
  Future<CommonModel> actionOnTaskApi(
      {required Map<String, dynamic> body}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.actionOnTaskUrl,
        body: body,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.PUT);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('create task ${response?.data}');
      return CommonModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  //**** TaskUpload Document API ****//
  Future<CommonModel> taskDocumentUploadApi(
      {required Map<String, dynamic> body}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.taskDocumentUploadUrl,
        body: body,
        bodyType: HttpBodyType.FormData,
        methodType: HttpMethodType.PUT);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('create task ${response?.data}');
      return CommonModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  //**** Get Task By assigned Id API ****//
  Future<GetAssignTaskListModel> getTaskByAssignedIdApi(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.gettaskbyAssignedIdUrl,
        queryParameters: query,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.GET);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('teamResponse ${response?.data}');
      return GetAssignTaskListModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }
}
