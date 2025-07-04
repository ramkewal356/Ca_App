import 'dart:convert';

import 'package:ca_app/data/models/all_chat_history_model.dart';
import 'package:ca_app/data/models/chat_history_model.dart';
import 'package:ca_app/data/providers/end_points.dart';
import 'package:ca_app/data/providers/http_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ChatRepository {
  //**** Get Chat history API ****//
  Future<ChatHistoryModel> getChatHistoryApi(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.chatHistoryUrl,
        queryParameters: query,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.GET);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      // debugPrint('Get Chat history response ${response?.data}');
      // return ChatHistoryModel.fromJson(response?.data);
      if (response?.data is Map<String, dynamic>) {
        return ChatHistoryModel.fromJson(response!.data);
      } else if (response?.data is String) {
        return chatHistoryModelFromJson(response!.data);
      }

      // ✅ fallback if type is unexpected
      throw Exception(
          "Unexpected response type: ${response?.data.runtimeType}");
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  //**** Get Chat history API ****//
  Future<AllChatHistoryModel> getAllChatHistoryApi(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.allChatHistoryUrl,
        queryParameters: query,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.GET);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('Get All Chat history response ${response?.data}');
      final parsedData = response?.data is String
          ? json.decode(response?.data)
          : response?.data;
      return AllChatHistoryModel.fromJson(parsedData);
      // if (response?.data is Map<String, dynamic>) {
      //   return AllChatHistoryModel.fromJson(response!.data);
      // } else if (response?.data is String) {
      //   return allChatHistoryModelFromJson(response!.data);
      // }

      // // ✅ fallback if type is unexpected
      // throw Exception(
      // "Unexpected response type: ${response?.data.runtimeType}");
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }
}
