import 'package:ca_app/data/models/logs_model.dart';
import 'package:ca_app/data/providers/end_points.dart';
import 'package:ca_app/data/providers/http_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class LogsRepository {
  //****  Get Logs By CaId API ****//
  Future<LogsModel> getActiveDeactiveLogsApi(
      {required Map<String, dynamic> query, required bool byCaId}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: byCaId
            ? EndPoints.getActiveDeactiveLogByCaIdUrl
            : EndPoints.getActiveDeactiveLogByUponIdUrl,
        queryParameters: query,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.GET);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('teamResponse ${response?.data}');
      return LogsModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  // //****  Get Logs By CaId API ****//
  // Future<LogsModel> getActiveDeactiveLogsByUponId(
  //     {required Map<String, dynamic> query}) async {
  //   var http = HttpService(
  //       isAuthorizeRequest: true,
  //       baseURL: EndPoints.baseUrl,
  //       endURL: EndPoints.getActiveDeactiveLogByCaIdUrl,
  //       queryParameters: query,
  //       bodyType: HttpBodyType.JSON,
  //       methodType: HttpMethodType.GET);
  //   try {
  //     Response<dynamic>? response = await http.request<dynamic>();
  //     debugPrint('teamResponse ${response?.data}');
  //     return LogsModel.fromJson(response?.data);
  //   } catch (e) {
  //     debugPrint('error $e');
  //     http.handleErrorResponse(error: e);
  //     rethrow;
  //   }
  // }
}
