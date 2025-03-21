import 'package:ca_app/data/models/add_contact_model.dart';
import 'package:ca_app/data/models/get_contact_by_contactid_model.dart';
import 'package:ca_app/data/models/get_contact_by_userid_model.dart';
import 'package:ca_app/data/providers/end_points.dart';
import 'package:ca_app/data/providers/http_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HelpAndSupportRepository {
  //**** Add Contact API ****//
  Future<AddContactModel> addContactApi(
      {required Map<String, dynamic> body, required bool isAuthorized}) async {
    var http = HttpService(
        isAuthorizeRequest: isAuthorized,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.addContactUrl,
        body: body,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.POST);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('add contact ${response?.data}');
      return AddContactModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  //**** Get Contact by User Id API ****//
  Future<GetContactByUserIdModel> getContactByUserId(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.getContactByUserIdUrl,
        queryParameters: query,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.GET);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('getCustomer by CaID Response ${response?.data}');
      return GetContactByUserIdModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  //**** Get Contact by contact Id API ****//
  Future<GetContactByContactIdModel> getContactByContactIdApi(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.getContactByContactIdUrl,
        queryParameters: query,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.GET);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('getCustomer by CaID Response ${response?.data}');
      return GetContactByContactIdModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }
}
