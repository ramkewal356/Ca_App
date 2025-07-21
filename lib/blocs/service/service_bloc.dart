import 'package:bloc/bloc.dart';
import 'package:ca_app/data/local_storage/shared_prefs_class.dart';
import 'package:ca_app/data/models/add_service_model.dart';
import 'package:ca_app/data/models/common_model.dart';
import 'package:ca_app/data/models/create_new_service_model.dart';
import 'package:ca_app/data/models/customer_service_model.dart';
import 'package:ca_app/data/models/get_all_service_request_by_customerid_model.dart';
import 'package:ca_app/data/models/get_calist_by_servicename_model.dart';
import 'package:ca_app/data/models/get_service_and_subservice_list_model.dart';
import 'package:ca_app/data/models/get_services_list_model.dart';
import 'package:ca_app/data/models/get_view_requested_ca_by_service_model.dart';
import 'package:ca_app/data/models/get_view_service_model.dart';
import 'package:ca_app/data/repositories/service_repository.dart';
import 'package:ca_app/utils/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'service_event.dart';
part 'service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  int pageNumber = 0;
  int pageSize = 10;
  int pageSize1 = 10;

  bool isFetching = false;
  bool isLastPage = false;
  bool isFetchingSubService = false;
  final _myRepo = ServiceRepository();
  ServiceBloc() : super(ServiceInitial()) {
    on<GetCaServiceListEvent>(_getCaServiceListApi);
    on<GetServiceListEvent>(_getServiceListApi);
    on<GetSubServiceListEvent>(_getSubServiceListApi);
    on<AddServiceEvent>(_addServiceApi);
    on<DeleteServiceEvent>(_deleteServiceApi);
    on<CreateServiceEvent>(_createServiceApi);
    on<GetViewServiceEvent>(_getViewService);
    on<GetServiceByCaIdEvent>(_getServiceByCaIdApi);
    // on<GetServiceForCustomerEvent>(_getServiceForCustomereListApi);
    on<GetCaByServiceNameEvent>(_getCaByServiceNameApi);
    on<GetServiceRequestedCaEvent>(_getServiceRequestByCustomerIdApi);
    on<ViewRequestedCaByServiceIdEvent>(_getViewRequestedCaByServiceIdApi);
  }
  Future<void> _getCaServiceListApi(
      GetCaServiceListEvent event, Emitter<ServiceState> emit) async {
    if (isFetching) return;

    if (event.isSearch && !event.isPagination) {
      pageNumber = 0;
      isLastPage = false;
      emit(ServiceLoading()); // Show loading only for the first page
    }

    if (isLastPage) return;
    isFetching = true;
    int? userId = await SharedPrefsClass().getUserId();
    debugPrint('userId.,.,.,.,.,.,., $userId');
    Map<String, dynamic> query = {
      "caId": event.caId ?? userId,
      "search": event.searchText,
      "pageNumber": event.pageNumber ?? pageNumber,
      "pageSize": event.pageSize ?? pageSize,
    };
    try {
      var resp = await _myRepo.getServicesListApi(query: query);
      List<ServicesListData> newData = resp.data?.content ?? [];
      List<ServicesListData> allData = (pageNumber == 0)
          ? newData
          : [
              ...(state is GetCaServiceListSuccess
                  ? (state as GetCaServiceListSuccess).getCaServicesList
                  : []),
              ...newData
            ];
      isLastPage = newData.length < pageSize;
      emit(GetCaServiceListSuccess(
          getCaServicesList: allData, isLastPage: isLastPage));
      pageNumber++;
    } catch (e) {
      emit(ServiceError(errorMessage: e.toString()));
    } finally {
      isFetching = false;
    }
  }

  Future<void> _getServiceListApi(
      GetServiceListEvent event, Emitter<ServiceState> emit) async {
    Map<String, dynamic> query = {
      "search": '',
      "pageNumber": -1,
      "pageSize": -1,
    };
    try {
      var resp = await _myRepo.getServiceDropdownListApi(query: query);

      if (state is GetCaServiceListSuccess) {
        emit((state as GetCaServiceListSuccess)
            .copyWith(getServicesList: resp.data?.content));
      } else {
        emit(GetCaServiceListSuccess(
            getServicesList: resp.data?.content ?? [],
            getCaServicesList: [],
            getSubServiceList: [],
            isLastPage: false));
      }
    } catch (e) {
      emit(ServiceError(errorMessage: e.toString()));
    }
  }

  Future<void> _getSubServiceListApi(
      GetSubServiceListEvent event, Emitter<ServiceState> emit) async {
    if (isFetchingSubService) return; // Prevent duplicate calls
    isFetchingSubService = true;
    Map<String, dynamic> body = {
      "serviceName": event.serviceName,
      "search": '',
      "pageNumber": -1,
      "pageSize": -1,
    };
    try {
      // emit(ServiceLoading());
      var resp = await _myRepo.getSubServiceByServicenameApi(body: body);
      // emit(GetSubServiceListByServiceNameSuccess(
      //     getSubServiceList: resp.data ?? []));

      if (state is GetCaServiceListSuccess) {
        emit((state as GetCaServiceListSuccess).copyWith(
          getSubServiceList: resp.data?.content,
        ));
      } else {
        emit(GetCaServiceListSuccess(
            getServicesList: (state as GetCaServiceListSuccess).getServicesList,
            getCaServicesList: [],
            getSubServiceList: resp.data?.content ?? [],
            isLastPage: false));
      }
    } catch (e) {
      emit(ServiceError(errorMessage: e.toString()));
    } finally {
      isFetchingSubService = false;
    }
  }

  Future<void> _addServiceApi(
      AddServiceEvent event, Emitter<ServiceState> emit) async {
    int? userId = await SharedPrefsClass().getUserId();
    Map<String, dynamic> body = {"caId": userId, "serviceId": event.serviceId};
    try {
      emit(AddServiceLoading());
      var resp = await _myRepo.addServiceApi(body: body);

      emit(AddServiceSuccess(addServiceModel: resp));
      Utils.toastSuccessMessage('Service Added Successfully');
    } catch (e) {
      emit(ServiceError(errorMessage: e.toString()));
    }
  }

  Future<void> _createServiceApi(
      CreateServiceEvent event, Emitter<ServiceState> emit) async {
    int? userId = await SharedPrefsClass().getUserId();
    Map<String, dynamic> body = {
      "serviceName": event.serviceName,
      "subService": event.subService,
      "serviceDesc": event.serviceDesc,
      "caId": userId
    };
    try {
      emit(ServiceLoading());
      var resp = await _myRepo.createServiceApi(body: body);

      emit(CreateServiceSuccess(createNewServiceModel: resp));
      Utils.toastSuccessMessage('Service Added Successfully');
    } catch (e) {
      emit(ServiceError(errorMessage: e.toString()));
    }
  }

  Future<void> _deleteServiceApi(
      DeleteServiceEvent event, Emitter<ServiceState> emit) async {
    Map<String, dynamic> query = {"id": event.serviceId};
    try {
      var resp = await _myRepo.removeServiceApi(query: query);
      if (state is GetCaServiceListSuccess) {
        emit((state as GetCaServiceListSuccess).copyWith(deleteService: resp));
      } else {
        emit(GetCaServiceListSuccess(
            getServicesList: [],
            getCaServicesList:
                (state as GetCaServiceListSuccess).getCaServicesList,
            getSubServiceList: [],
            isLastPage: false));
      }
    } catch (e) {
      emit(DeleteServiceError());
    }
  }

  Future<void> _getViewService(
      GetViewServiceEvent event, Emitter<ServiceState> emit) async {
    if (isFetching) return;
    bool isNewSearch = (event.isSearch || event.isFilter);
    if (isNewSearch && !event.isPagination) {
      pageNumber = 0;
      isLastPage = false;
      emit(ServiceLoading()); // Show loading only for the first page
    }

    if (isLastPage) return;
    isFetching = true;
    int? userId = await SharedPrefsClass().getUserId();
    Map<String, dynamic> query = {
      "caId": userId,
      "pageNumber": pageNumber,
      "pageSize": pageSize,
      "search": event.searchText,
      "filter": event.filterTex
    };
    try {
      var resp = await _myRepo.getViewServiceByCaIdApi(query: query);
      List<ViewServiceData> newData = resp.data?.content ?? [];
      List<ViewServiceData> allData = (pageNumber == 0)
          ? newData
          : [
              ...(state is GetViewServiceSuccess
                  ? (state as GetViewServiceSuccess).getViewServiceList
                  : []),
              ...newData
            ];
      isLastPage = newData.length < pageSize;
      emit(GetViewServiceSuccess(
          getViewServiceList: allData, isLastPage: isLastPage));
      pageNumber++;
    } catch (e) {
      emit(ServiceError(errorMessage: e.toString()));
    } finally {
      isFetching = false;
    }
  }

  Future<void> _getServiceByCaIdApi(
      GetServiceByCaIdEvent event, Emitter<ServiceState> emit) async {
    if (isFetching) return;
    // bool isNewSearch = (event.isSearch || event.isFilter);
    if (event.isSearch && !event.isPagination) {
      pageNumber = 0;
      isLastPage = false;
      emit(ServiceLoading()); // Show loading only for the first page
    }

    if (isLastPage) return;
    isFetching = true;
    // int? userId = await SharedPrefsClass().getUserId();
    Map<String, dynamic> query = {
      "caId": event.caId,
      "pageNumber": pageNumber,
      "pageSize": pageSize,
      "search": event.searchText,
    };
    try {
      var resp = await _myRepo.getServicesListByCaIdApi(query: query);
      List<ServicesListData> newData = resp.data?.content ?? [];
      List<ServicesListData> allData = (pageNumber == 0)
          ? newData
          : [
              ...(state is GetServiceByCaIdSuccess
                  ? (state as GetServiceByCaIdSuccess).serviceList
                  : []),
              ...newData
            ];
      isLastPage = newData.length < pageSize;
      emit(GetServiceByCaIdSuccess(
          serviceList: allData, isLastPage: isLastPage));
      pageNumber++;
    } catch (e) {
      emit(ServiceError(errorMessage: e.toString()));
    } finally {
      isFetching = false;
    }
  }

  // Future<void> _getServiceForCustomereListApi(
  //     GetServiceForCustomerEvent event, Emitter<ServiceState> emit) async {
  //   if (isFetching) return;
  //   bool isSearch = (event.isSearch || event.isFilterByLocation);
  //   if (isSearch && !event.isPagination) {
  //     pageNumber = 0;
  //     isLastPage = false;
  //     emit(GetServiceLoading()); // Show loading only for the first page
  //   }

  //   if (isLastPage) return;
  //   isFetching = true;

  //   Map<String, dynamic> query = {
  //     "search": event.searchText,
  //     "pageNumber": pageNumber,
  //     "pageSize": pageSize,
  //     "address": event.location
  //   };
  //   try {
  //     var resp = await _myRepo.getServiceForIndivisualCustomerApi(query: query);
  //     List<Content> newData = resp.data?.content ?? [];
  //     List<Content> allData = (pageNumber == 0)
  //         ? newData
  //         : [
  //             ...(state is GetServiceForIndivisualCustomerSuccess
  //                 ? (state as GetServiceForIndivisualCustomerSuccess)
  //                     .serviceForCustomerList
  //                 : []),
  //             ...newData
  //           ];
  //     isLastPage = newData.length < pageSize;
  //     emit(GetServiceForIndivisualCustomerSuccess(
  //         serviceForCustomerList: allData, isLastPage: isLastPage));
  //     pageNumber++;
  //   } catch (e) {
  //     emit(ServiceError(errorMessage: e.toString()));
  //   } finally {
  //     isFetching = false;
  //   }
  // }

  Future<void> _getCaByServiceNameApi(
      GetCaByServiceNameEvent event, Emitter<ServiceState> emit) async {
    if (isFetching) return;
    bool isNewSearch = (event.isFilter || event.isSearch);
    if (isNewSearch && !event.isPagination) {
      pageNumber = 0;
      isLastPage = false;
      emit(ServiceLoading()); // Show loading only for the first page
    }

    if (isLastPage) return;
    isFetching = true;

    Map<String, dynamic> query = {
      "serviceId": event.serviceId,
      "pageNumber": pageNumber,
      "pageSize": pageSize,
      "filter": event.filter,
      "search": event.searchText
    };
    try {
      // emit(ServiceLoading());
      var resp = await _myRepo.getCaByServiceNameApi(query: query);
      // emit(GetCaByServiceNameSuccess(getCaByServiceNameModel: resp));
      List<CaList> newData = resp.data?.caList ?? [];
      List<CaList> allData = (pageNumber == 0)
          ? newData
          : [
              ...(state is GetCaByServiceNameSuccess
                  ? (state as GetCaByServiceNameSuccess).caList
                  : []),
              ...newData
            ];
      isLastPage = newData.length < pageSize;
      emit(GetCaByServiceNameSuccess(
        caList: allData,
        isLastPage: isLastPage,
        serviceName: resp.data?.serviceName ?? '',
        subService: resp.data?.subService ?? '',
        serviceDesc: resp.data?.serviceDesc ?? '',
        serviceId: resp.data?.serviceId ?? 0,
      ));
      pageNumber++;
    } catch (e) {
      emit(ServiceError(errorMessage: e.toString()));
    } finally {
      isFetching = false;
    }
  }

  Future<void> _getServiceRequestByCustomerIdApi(
      GetServiceRequestedCaEvent event, Emitter<ServiceState> emit) async {
    if (isFetching) return;
    bool isNewSearch = (event.isSearch || event.isFilter);
    if (isNewSearch && !event.isPagination) {
      pageNumber = 0;
      isLastPage = false;
      emit(ServiceLoading()); // Show loading only for the first page
    }

    if (isLastPage) return;
    isFetching = true;
    int? customerId = await SharedPrefsClass().getUserId();
    Map<String, dynamic> query = {
      "customerId": customerId,
      "pageNumber": pageNumber,
      "pageSize": pageSize,
      "orderStatus": event.filterTex,
      "search": event.searchText,
      "urgencyLevel": event.urgencyFilterText
    };
    try {
      var resp = await _myRepo.getServiceRequestByCustomerIdApi(query: query);

      List<RequestCaContent> newData = resp.data?.content ?? [];
      List<RequestCaContent> allData = (pageNumber == 0)
          ? newData
          : [
              ...(state is GetAllServiceRequestedCaSuccess
                  ? (state as GetAllServiceRequestedCaSuccess).requestedCaList
                  : []),
              ...newData
            ];
      isLastPage = newData.length < pageSize;
      emit(GetAllServiceRequestedCaSuccess(
        requestedCaList: allData,
        isLastPage: isLastPage,
      ));
      pageNumber++;
    } catch (e) {
      emit(ServiceError(errorMessage: e.toString()));
    } finally {
      isFetching = false;
    }
  }

  Future<void> _getViewRequestedCaByServiceIdApi(
      ViewRequestedCaByServiceIdEvent event, Emitter<ServiceState> emit) async {
    Map<String, dynamic> query = {"serviceOrderId": event.serviceId};
    try {
      emit(ServiceLoading());
      var resp = await _myRepo.getViewRequestCaByServiceApi(query: query);

      emit(ViewRequestedCaByServiceIdSuccess(
          getViewRequestedCaByServiceIdModel: resp));
    } catch (e) {
      emit(ServiceError(errorMessage: e.toString()));
    }
  }
}

class AssignServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  int pageNumber = 0;
  int pageSize = 10;
  int pageSize1 = 10;

  bool isFetching = false;
  bool isLastPage = false;
  final _myRepo = ServiceRepository();
  AssignServiceBloc() : super(ServiceInitial()) {
    on<AssignServiceEvent>(_assignServiceToClient);
    on<UpdateAssignServiceEvent>(_updateAssignServiceToClient);
    on<SendSercieRequestOrderEvent>(_sendServiceRequestOrderApi);
    on<GetServiceForCustomerEvent>(_getServiceForCustomereListApi);
  }
  Future<void> _assignServiceToClient(
      AssignServiceEvent event, Emitter<ServiceState> emit) async {
    Map<String, dynamic> body = {
      "userIds": event.selectedClients,
      "serviceIds": event.selectedServices
    };
    try {
      emit(AddServiceLoading());
      var resp = await _myRepo.assignServiceToClientApi(body: body);
      Utils.toastSuccessMessage('${resp.data?.body}');
      emit(AssignServiceToUserSuccess(assignServiceToClient: resp));
    } catch (e) {
      emit(ServiceError(errorMessage: e.toString()));
    }
  }

  Future<void> _updateAssignServiceToClient(
      UpdateAssignServiceEvent event, Emitter<ServiceState> emit) async {
    Map<String, dynamic> body = {
      "userId": event.clientId,
      "serviceIds": event.serviceIds
    };
    try {
      emit(AddServiceLoading());
      var resp = await _myRepo.updateAssignServiceToClientApi(body: body);
      Utils.toastSuccessMessage('Updated successfully');
      emit(UpdateAssigneService(updatedAssignService: resp));
    } catch (e) {
      emit(ServiceError(errorMessage: e.toString()));
    }
  }

  Future<void> _sendServiceRequestOrderApi(
      SendSercieRequestOrderEvent event, Emitter<ServiceState> emit) async {
    int? customerId = await SharedPrefsClass().getUserId();
    Map<String, dynamic> body = {
      "serviceId": event.serviceId,
      "customerId": customerId,
      "caId": event.caId,
      "message": event.message,
      "subject": event.subject,
      "urgencyLevel": event.urgencyLevel
    };
    try {
      emit(SendServiceRequestLoading(caId: event.caId));
      var resp = await _myRepo.sendServiceOrderRequestApi(body: body);
      Utils.toastSuccessMessage('${resp.data?.body}');
      emit(SendSericeRequestOrderSuccess());
    } catch (e) {
      emit(ServiceError(errorMessage: e.toString()));
    }
  }

  Future<void> _getServiceForCustomereListApi(
      GetServiceForCustomerEvent event, Emitter<ServiceState> emit) async {
    if (isFetching) return;
    bool isSearch = (event.isSearch || event.isFilterByLocation);
    if (isSearch && !event.isPagination) {
      pageNumber = 0;
      isLastPage = false;
      emit(GetServiceLoading()); // Show loading only for the first page
    }

    if (isLastPage) return;
    isFetching = true;

    Map<String, dynamic> query = {
      "search": event.searchText,
      "pageNumber": pageNumber,
      "pageSize": pageSize,
      "address": event.location
    };
    try {
      var resp = await _myRepo.getServiceForIndivisualCustomerApi(query: query);
      List<Content> newData = resp.data?.content ?? [];
      List<Content> allData = (pageNumber == 0)
          ? newData
          : [
              ...(state is GetServiceForIndivisualCustomerSuccess
                  ? (state as GetServiceForIndivisualCustomerSuccess)
                      .serviceForCustomerList
                  : []),
              ...newData
            ];
      isLastPage = newData.length < pageSize;
      emit(GetServiceForIndivisualCustomerSuccess(
          serviceForCustomerList: allData, isLastPage: isLastPage));
      pageNumber++;
    } catch (e) {
      emit(ServiceError(errorMessage: e.toString()));
    } finally {
      isFetching = false;
    }
  }
}
