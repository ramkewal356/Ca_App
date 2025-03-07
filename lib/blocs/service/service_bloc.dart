import 'package:bloc/bloc.dart';
import 'package:ca_app/data/local_storage/shared_prefs_class.dart';
import 'package:ca_app/data/models/add_service_model.dart';
import 'package:ca_app/data/models/create_new_service_model.dart';
import 'package:ca_app/data/models/get_service_and_subservice_list_model.dart';
import 'package:ca_app/data/models/get_services_list_model.dart';
import 'package:ca_app/data/models/get_view_service_model.dart';
import 'package:ca_app/data/repositories/service_repository.dart';
import 'package:ca_app/utils/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'service_event.dart';
part 'service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  int pageNumber = 0;
  final int pageSize = 4;
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
      "caId": userId,
      "search": event.searchText,
      "pageNumber": event.pageNumber ?? pageNumber,
      "pageSize": event.pageSize ?? pageSize,
    };
    try {
      var resp = await _myRepo.getServicesListApi(query: query);
      List<ServicesListData> newData = resp.data ?? [];
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
      // emit(ServiceLoading());
      var resp = await _myRepo.getServiceDropdownListApi(query: query);
      // emit(GetServiceDropDownListSuccess(getServiceList: resp.data ?? []));

      if (state is GetCaServiceListSuccess) {
        emit((state as GetCaServiceListSuccess)
            .copyWith(getServicesList: resp.data));
      } else {
        emit(GetCaServiceListSuccess(
            getServicesList: resp.data ?? [],
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
          getSubServiceList: resp.data,
        ));
      } else {
        emit(GetCaServiceListSuccess(
            getServicesList: (state as GetCaServiceListSuccess).getServicesList,
            getCaServicesList: [],
            getSubServiceList: resp.data ?? [],
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

    if (event.isSearch && !event.isPagination) {
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
      "filter": ''
    };
    try {
      var resp = await _myRepo.getViewServiceByCaIdApi(query: query);
      List<ViewServiceData> newData = resp.data ?? [];
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
}

// class AddServiceBloc extends Bloc<ServiceEvent, ServiceState> {
//   final _myRepo = ServiceRepository();
//   AddServiceBloc() : super(ServiceInitial()) {
//     on<AddServiceEvent>(_addServiceApi);
//   }
//   Future<void> _addServiceApi(
//       AddServiceEvent event, Emitter<ServiceState> emit) async {
//     int? userId = await SharedPrefsClass().getUserId();
//     Map<String, dynamic> body = {"caId": userId, "serviceId": event.serviceId};
//     try {
//       emit(AddServiceLoading());
//       var resp = await _myRepo.addServiceApi(body: body);

//       emit(AddServiceSuccess(addServiceModel: resp));
//       Utils.toastSuccessMessage('Service Added Successfully');
//     } catch (e) {
//       emit(ServiceError(errorMessage: e.toString()));
//     }
//   }
// }
