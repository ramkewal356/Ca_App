import 'package:ca_app/data/models/get_all_title_model.dart';
import 'package:ca_app/data/models/get_ca_degree_list.dart';
import 'package:ca_app/data/models/get_occupation_list_model.dart';
import 'package:ca_app/data/providers/end_points.dart';
import 'package:ca_app/data/providers/http_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ProfileRepository {
  //**** GetAll Title  API ****//
  Future<GetAllTitleModel> getAllTitleApi() async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.getAllTitleUrl,
        // queryParameters: query,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.GET);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('getAlltitle  ${response?.data}');
      return GetAllTitleModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  //**** Get Ca Degree  API ****//
  Future<GetCaDegreeListModel> getCADegreeListpi() async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.getCaDegreeListUrl,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.GET);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('getCa Degree ${response?.data}');
      return GetCaDegreeListModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  //**** Get user occupation  API ****//
  Future<GetOccupationLIstModel> getOccupationListpi() async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.getOccupationListUrl,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.GET);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('get Occupation ${response?.data}');
      return GetOccupationLIstModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }
}
