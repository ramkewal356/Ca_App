import 'package:bloc/bloc.dart';
import 'package:ca_app/data/local_storage/shared_prefs_class.dart';
import 'package:ca_app/data/models/action_on_task_model.dart';
import 'package:ca_app/data/models/get_document_by_requestid_model.dart';
import 'package:ca_app/data/models/get_request_by_receiverId_model.dart';
import 'package:ca_app/data/models/get_request_model.dart';
import 'package:ca_app/data/repositories/raise_request_repository.dart';
import 'package:ca_app/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'raise_request_event.dart';
part 'raise_request_state.dart';

class RaiseRequestBloc extends Bloc<RaiseRequestEvent, RaiseRequestState> {
  bool isFetching = false;
  bool isLastPage = false;
  int pageNumber = 0;
  int pageSize = 10;
  final _myRepo = RaiseRequestRepository();
  RaiseRequestBloc() : super(RaiseRequestInitial()) {
    on<SendRaiseRequestEvent>(_sendRequestApi);
    on<GetYourRequestEvent>(_getYourRequestApi);
    on<GetRequestDetailsEvent>(_getRequestDetails);
    on<GetRequestOfClientEvent>(_getRequestOfClientApi);
    on<GetRequestOfTeamEvent>(_getRequestOfTeamApi);
    on<GetRequestByReceiverIdEvent>(_getRequestByReceiverIdApi);
  }
  Future<void> _sendRequestApi(
      SendRaiseRequestEvent event, Emitter<RaiseRequestState> emit) async {
    int? userId = await SharedPrefsClass().getUserId();
    debugPrint('userId.,.,.,.,.,.,., $userId');

    Map<String, dynamic> body = {
      "text": event.description,
      "senderId": userId.toString(),
      "receiverId": event.receiverId,
      if (event.files.isNotEmpty) "file": event.files
    };

    try {
      emit(RaiseRequestLoading());
      var resp = await _myRepo.sendRequestApi(body: body);
      Utils.toastSuccessMessage(resp.data?.body ?? '');
      emit(SendRaiseRequestSuccess());
    } catch (e) {
      emit(RaiseRequestError(errorMessage: e.toString()));
    }
  }

  Future<void> _getYourRequestApi(
      GetYourRequestEvent event, Emitter<RaiseRequestState> emit) async {
    if (isFetching) return;
    bool isNewSearch = (event.isSearch || event.isFilter);
    if (isNewSearch && !event.isPagination) {
      pageNumber = 0;
      isLastPage = false;
      emit(RaiseRequestLoading()); // Show loading only for the first page
    }
    if (isLastPage) return;
    isFetching = true;
    int? userId = await SharedPrefsClass().getUserId();
    debugPrint('userId.,.,.,.,.,.,., $userId');
    Map<String, dynamic> query = {
      "senderId": userId,
      "pageNumber": pageNumber,
      "pageSize": pageSize,
      "search": event.searchText,
      "readStatus": event.filterText
    };
    try {
      var resp = await _myRepo.getRequestBySenderIdApi(query: query);
      List<RequestData> newData = resp.data?.content ?? [];
      List<RequestData> allData = (pageNumber == 0)
          ? newData
          : [
              ...(state is GetYourRequestListSuccess
                  ? (state as GetYourRequestListSuccess).requestData
                  : []),
              ...newData
            ];
      isLastPage = newData.length < pageSize;
      emit(GetYourRequestListSuccess(
          requestData: allData, isLastPage: isLastPage));
      pageNumber++;
    } catch (e) {
      emit(RaiseRequestError(errorMessage: e.toString()));
    } finally {
      isFetching = false;
    }
  }

  Future<void> _getRequestOfClientApi(
      GetRequestOfClientEvent event, Emitter<RaiseRequestState> emit) async {
    if (isFetching) return;
    bool isNewSearch = (event.isSearch || event.isFilter);
    if (isNewSearch && !event.isPagination) {
      pageNumber = 0;
      isLastPage = false;
      emit(RaiseRequestLoading()); // Show loading only for the first page
    }
    if (isLastPage) return;
    isFetching = true;
    int? userId = await SharedPrefsClass().getUserId();
    debugPrint('userId.,.,.,.,.,.,., $userId');
    Map<String, dynamic> query = {
      "caId": userId,
      "pageNumber": pageNumber,
      "pageSize": pageSize,
      "search": event.searchText,
      "readStatus": event.filterText
    };
    try {
      var resp = await _myRepo.getRequestOfClientByCaId(query: query);
      List<RequestData> newData = resp.data?.content ?? [];
      List<RequestData> allData = (pageNumber == 0)
          ? newData
          : [
              ...(state is GetYourRequestListSuccess
                  ? (state as GetYourRequestListSuccess).requestData
                  : []),
              ...newData
            ];
      isLastPage = newData.length < pageSize;
      emit(GetYourRequestListSuccess(
          requestData: allData, isLastPage: isLastPage));
      pageNumber++;
    } catch (e) {
      emit(RaiseRequestError(errorMessage: e.toString()));
    } finally {
      isFetching = false;
    }
  }

  Future<void> _getRequestOfTeamApi(
      GetRequestOfTeamEvent event, Emitter<RaiseRequestState> emit) async {
    if (isFetching) return;
    bool isNewSearch = (event.isSearch || event.isFilter);
    if (isNewSearch && !event.isPagination) {
      pageNumber = 0;
      isLastPage = false;
      emit(RaiseRequestLoading()); // Show loading only for the first page
    }
    if (isLastPage) return;
    isFetching = true;
    int? userId = await SharedPrefsClass().getUserId();
    debugPrint('userId.,.,.,.,.,.,., $userId');
    Map<String, dynamic> query = {
      "caId": userId,
      "pageNumber": pageNumber,
      "pageSize": pageSize,
      "search": event.searchText,
      "readStatus": event.filterText
    };
    try {
      var resp = await _myRepo.getRequestOfTeamByCaId(query: query);
      List<RequestData> newData = resp.data?.content ?? [];
      List<RequestData> allData = (pageNumber == 0)
          ? newData
          : [
              ...(state is GetYourRequestListSuccess
                  ? (state as GetYourRequestListSuccess).requestData
                  : []),
              ...newData
            ];
      isLastPage = newData.length < pageSize;
      emit(GetYourRequestListSuccess(
          requestData: allData, isLastPage: isLastPage));
      pageNumber++;
    } catch (e) {
      emit(RaiseRequestError(errorMessage: e.toString()));
    } finally {
      isFetching = false;
    }
  }

  Future<void> _getRequestDetails(
      GetRequestDetailsEvent event, Emitter<RaiseRequestState> emit) async {
    Map<String, dynamic> query = {"requestId": event.requestId};
    try {
      emit(GetRequestDetailsLoading(requsetId: event.requestId));
      var resp = await _myRepo.getViewRequestByRequestIdApi(query: query);
      emit(GetRequestDetailsSuccess(getDocumentByRequestIdData: resp));
    } catch (e) {
      emit(RaiseRequestError(errorMessage: e.toString()));
    }
  }

  Future<void> _getRequestByReceiverIdApi(GetRequestByReceiverIdEvent event,
      Emitter<RaiseRequestState> emit) async {
    if (isFetching) return;
    bool isNewSearch = (event.isSearch || event.isFilter);
    if (isNewSearch && !event.isPagination) {
      pageNumber = 0;
      isLastPage = false;
      emit(RaiseRequestLoading()); // Show loading only for the first page
    }
    if (isLastPage) return;
    isFetching = true;
    int? userId = await SharedPrefsClass().getUserId();
    debugPrint('receiverId.,.,.,.,.,.,., $userId');
    Map<String, dynamic> query = {
      "receiverId": userId,
      "pageNumber": pageNumber,
      "pageSize": pageSize,
      "search": event.searchText,
      "readStatus": event.filterText
    };
    try {
      var resp = await _myRepo.getRequestByReceiverIdApi(query: query);
      List<GetRequestData> newData = resp.data?.content ?? [];
      List<GetRequestData> allData = (pageNumber == 0)
          ? newData
          : [
              ...(state is GetRequestByRecieverIdSuccess
                  ? (state as GetRequestByRecieverIdSuccess).requestData
                  : []),
              ...newData
            ];
      isLastPage = newData.length < pageSize;
      emit(GetRequestByRecieverIdSuccess(
          requestData: allData, isLastPage: isLastPage));
      pageNumber++;
    } catch (e) {
      emit(RaiseRequestError(errorMessage: e.toString()));
    } finally {
      isFetching = false;
    }
  }

 
}
class ChangeStatusBloc extends Bloc<RaiseRequestEvent, RaiseRequestState> {
  final _myRepo = RaiseRequestRepository();

  ChangeStatusBloc() : super(RaiseRequestInitial()) {
    on<UnreadToReadStatusEvent>(_unreadToreadStatusApi);
  }
  Future<void> _unreadToreadStatusApi(
      UnreadToReadStatusEvent event, Emitter<RaiseRequestState> emit) async {
    Map<String, dynamic> query = {"requestId": event.requestId};
    try {
      var resp = await _myRepo.unreadToReadStatusApi(query: query);
      emit(UnReadToReadStatusSuccess(changeStatus: resp));
    } catch (e) {
      emit(RaiseRequestError(errorMessage: e.toString()));
    }
  }
}
