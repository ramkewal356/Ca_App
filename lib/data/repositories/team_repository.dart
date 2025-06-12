import 'dart:convert';

import 'package:ca_app/data/models/degination_model.dart';
import 'package:ca_app/data/models/get_active_ca_with_service_model.dart';
import 'package:ca_app/data/models/get_permission_model.dart';
import 'package:ca_app/data/models/get_subca_by_caid_model.dart';
import 'package:ca_app/data/models/get_team_member_model.dart';
import 'package:ca_app/data/providers/end_points.dart';
import 'package:ca_app/data/providers/http_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class TeamRepository {
  //**** Get Team by CA Id API ****//
  Future<GetTeamMemberModel> getTeamByCaId(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.getSubCaByCaId,
        queryParameters: query,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.GET);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('teamResponse ${response?.data}');
      return GetTeamMemberModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }
  //**** Get Team by CA Id API ****//
  Future<GetSubCaByCaIdModel> getSubCaByCaIdApi(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.getSubCaByCaIdUrl,
        queryParameters: query,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.GET);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('teamResponse ${response?.data}');
      return GetSubCaByCaIdModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }
  //**** Get Verified subCa by CA Id API ****//
  Future<GetSubCaByCaIdModel> getVerifiedSubCaByCaId(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.getVerifiedSubCaByCaId,
        queryParameters: query,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.GET);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('teamResponse ${response?.data}');
      return GetSubCaByCaIdModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }
  //**** Get Degination API ****//
  Future<DeginationModel> getDeginationList() async {
    var http = HttpService(
        isAuthorizeRequest: false,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.getDegination,
       
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.GET);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('teamResponse ${response?.data}');
      return DeginationModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  //**** Get Permission API ****//
  Future<GetPermissionModel> getPermissionList(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.getPermission,
        queryParameters: query,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.GET);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('teamResponse ${response?.data}');
      return GetPermissionModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }
  
  //**** Get Permission API ****//
  Future<GetActiveCaWithServicesModel> getActiveCaWithServiceApi(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: false,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.getActiveCauWithService,
        queryParameters: query,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.GET);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('teamResponse ${response?.data}');
      final jsonData = json.decode(response?.data);
      return GetActiveCaWithServicesModel.fromJson(jsonData);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }
}
