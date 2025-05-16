import 'package:ca_app/data/models/add_service_model.dart';
import 'package:ca_app/data/models/assign_service_to_user_model.dart';
import 'package:ca_app/data/models/create_new_service_model.dart';
import 'package:ca_app/data/models/customer_service_model.dart';
import 'package:ca_app/data/models/get_all_service_request_by_customerid_model.dart';
import 'package:ca_app/data/models/get_calist_by_servicename_model.dart';
import 'package:ca_app/data/models/get_service_and_subservice_list_model.dart';
import 'package:ca_app/data/models/get_services_list_model.dart';
import 'package:ca_app/data/models/get_view_requested_ca_by_service_model.dart';
import 'package:ca_app/data/models/get_view_service_model.dart';
import 'package:ca_app/data/providers/end_points.dart';
import 'package:ca_app/data/providers/http_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ServiceRepository {
  //****  Get Services List API ****//
  Future<GetServicesListModel> getServicesListApi(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.getServicesListUrl,
        queryParameters: query,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.GET);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('ServiceResponse ${response?.data}');
      return GetServicesListModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }
  //****  Get Services List By CAID API ****//
  Future<GetServicesListModel> getServicesListByCaIdApi(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.getServicesListByIdUrl,
        queryParameters: query,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.GET);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('ServiceResponse ${response?.data}');
      return GetServicesListModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  //****  Get Services Dropdown List API ****//
  Future<GetServiceAndSubServiceListModel> getServiceDropdownListApi(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.getServiceDropdownListUrl,
        queryParameters: query,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.GET);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('ServiceListResponse ${response?.data}');
      return GetServiceAndSubServiceListModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  //****  Get Services List API ****//
  Future<GetServiceAndSubServiceListModel> getSubServiceByServicenameApi(
      {required Map<String, dynamic> body}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.getSubServiceByServiceNameListUrl,
        body: body,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.POST);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('SubServiceListResponse ${response?.data}');
      return GetServiceAndSubServiceListModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  //****  Add Services  API ****//
  Future<AddServiceModel> addServiceApi(
      {required Map<String, dynamic> body}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.addServiceUrl,
        body: body,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.POST);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('AddServiceResponse ${response?.data}');
      return AddServiceModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  //****  Create Services  API ****//
  Future<CreateNewServiceModel> createServiceApi(
      {required Map<String, dynamic> body}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.createNewServiceUrl,
        body: body,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.POST);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('CreateServiceResponse ${response?.data}');
      return CreateNewServiceModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  //****  Create Services  API ****//
  Future<bool> removeServiceApi({required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.deleteServiceUrl,
        queryParameters: query,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.PUT);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('CreateServiceResponse ${response?.data}');
      return true;
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  //****  Get View Services  API ****//
  Future<GetViewServiceModel> getViewServiceByCaIdApi(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.getViewServiceUrl,
        queryParameters: query,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.GET);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('CreateServiceResponse ${response?.data}');
      return GetViewServiceModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  //****  Assign Services  API ****//
  Future<AssignServiceToUserModel> assignServiceToClientApi(
      {required Map<String, dynamic> body}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.assignServiceUrl,
        body: body,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.POST);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('assignServiceToUserResponse ${response?.data}');
      return AssignServiceToUserModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

//**** Update Assign Services  API ****//
  Future<bool> updateAssignServiceToClientApi(
      {required Map<String, dynamic> body}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.updateServiceToUserUrl,
        body: body,
        bodyType: HttpBodyType.FormData,
        methodType: HttpMethodType.PUT);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('assignServiceToUserResponse ${response?.data}');
      return true;
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }
  
  //****  Get View Services  API ****//
  Future<GetServicesForIndivisualCustomerModel>
      getServiceForIndivisualCustomerApi(
          {required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.getServicesForIndivisualCustomerUrl,
        queryParameters: query,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.GET);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('GetServiceForIndivisualResponse ${response?.data}');
      return GetServicesForIndivisualCustomerModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  //****  Get View Services  API ****//
  Future<GetCaByServiceNameModel> getCaByServiceNameApi(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.getCaByServiceNameUrl,
        queryParameters: query,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.GET);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('GetCaByServiceResponse ${response?.data}');
      return GetCaByServiceNameModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  //****  Get View Services  API ****//
  Future<AssignServiceToUserModel> sendServiceOrderRequestApi(
      {required Map<String, dynamic> body}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.sendServiceOrderRequestUrl,
        body: body,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.POST);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('CreateServiceOrederRequestResponse ${response?.data}');
      return AssignServiceToUserModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  //****  Get All Services Request by CustomerId  API ****//
  Future<GetAllServiceRequestByCustomerIdModel>
      getServiceRequestByCustomerIdApi(
          {required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.getAllServiceRequestByCustomerIdUrl,
        queryParameters: query,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.GET);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('CreateServiceOrederRequestResponse ${response?.data}');
      return GetAllServiceRequestByCustomerIdModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  //****  Get All Services Request by CustomerId  API ****//
  Future<GetViewRequestedCaByServiceIdModel> getViewRequestCaByServiceApi(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.getViewRequestCaByServiceIdUrl,
        queryParameters: query,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.GET);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('CreateServiceOrederRequestResponse ${response?.data}');
      return GetViewRequestedCaByServiceIdModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }
}
