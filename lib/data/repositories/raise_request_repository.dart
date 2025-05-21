import 'package:ca_app/data/models/common_model.dart';
import 'package:ca_app/data/models/get_document_by_requestid_model.dart';
import 'package:ca_app/data/models/get_request_by_receiverId_model.dart';
import 'package:ca_app/data/models/get_request_model.dart';

import 'package:ca_app/data/providers/end_points.dart';
import 'package:ca_app/data/providers/http_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RaiseRequestRepository {
  //**** Send Raise Request API ****//
  Future<CommonModel> sendRequestApi(
      {required Map<String, dynamic> body}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.sendRaiseRequest,
        body: body,
        bodyType: HttpBodyType.FormData,
        methodType: HttpMethodType.POST);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('send raise request Response ${response?.data}');
      return CommonModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  //**** Get Request By Sender Id API ****//
  Future<GetRequestModel> getRequestBySenderIdApi(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.getRequestBySenderId,
        queryParameters: query,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.GET);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('send raise request Response ${response?.data}');
      return GetRequestModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  //**** Get Request By Request Id API ****//
  Future<GetDocumentByRequestIdModel> getViewRequestByRequestIdApi(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.getRequestByRequestId,
        queryParameters: query,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.GET);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('view request Response ${response?.data}');
      return GetDocumentByRequestIdModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  Future<GetRequestModel> getRequestOfClientByCaId(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.getRequestOfClientUrl,
        queryParameters: query,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.GET);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('view request of Client Response ${response?.data}');
      return GetRequestModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  Future<GetRequestModel> getRequestOfTeamByCaId(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.getRequestOfTeamUrl,
        queryParameters: query,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.GET);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('view request of Team Response ${response?.data}');
      return GetRequestModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  Future<CommonModel> unreadToReadStatusApi(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.unreadToReadStatusUrl,
        queryParameters: query,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.PUT);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('view request of Team Response ${response?.data}');
      return CommonModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }
  Future<GetRequestByReceiverIdModel> getRequestByReceiverIdApi(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.getRequestByReceiverId,
        queryParameters: query,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.GET);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('view request of Team Response ${response?.data}');
      return GetRequestByReceiverIdModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }
}
