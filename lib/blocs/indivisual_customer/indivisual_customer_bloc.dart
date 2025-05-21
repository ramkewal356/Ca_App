import 'package:bloc/bloc.dart';
import 'package:ca_app/data/local_storage/shared_prefs_class.dart';
import 'package:ca_app/data/models/get_requested_service_caid_model.dart';
import 'package:ca_app/data/repositories/indivisual_customer_repository.dart';
import 'package:ca_app/utils/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'indivisual_customer_event.dart';
part 'indivisual_customer_state.dart';

class IndivisualCustomerBloc
    extends Bloc<IndivisualCustomerEvent, IndivisualCustomerState> {
  bool isFetching = false;
  bool isLastPage = false;
  int pageNumber = 0;
  int pageSize = 10;
  final _myRepo = IndivisualCustomerRepository();
  IndivisualCustomerBloc() : super(IndivisualCustomerInitial()) {
    on<GetRequestedServiceByCaIdEvent>(_getRequestedServiceByCaIdApi);
    on<AcceptOrRejectServiceEvent>(_acceptOrRejectServiceApi);
  }
  Future<void> _getRequestedServiceByCaIdApi(
      GetRequestedServiceByCaIdEvent event,
      Emitter<IndivisualCustomerState> emit) async {
    if (isFetching) return;
    // bool isNewSearch = (event.isSearch || event.isFilter);
    if (event.isFilter && !event.isPagination) {
      pageNumber = 0;
      isLastPage = false;
      emit(IndivisualCustomerLoading()); // Show loading only for the first page
    }
    if (isLastPage) return;
    isFetching = true;
    int? userId = await SharedPrefsClass().getUserId();
    debugPrint('userId.,.,.,.,.,.,., $userId');
    Map<String, dynamic> query = {
      "caId": userId,
      "pageNumber": pageNumber,
      "pageSize": pageSize,
      "orderStatus": event.filterText
    };
    try {
      var resp = await _myRepo.getRequestServiceByCaIdApi(query: query);
      List<Content> newData = resp.data?.content ?? [];
      List<Content> allData = (pageNumber == 0)
          ? newData
          : [
              ...(state is GetRequestedServiceByCaIdSuccess
                  ? (state as GetRequestedServiceByCaIdSuccess)
                      .getRequestedServiceList
                  : []),
              ...newData
            ];
      isLastPage = newData.length < pageSize;
      emit(GetRequestedServiceByCaIdSuccess(
          getRequestedServiceList: allData, isLastPage: isLastPage));
      pageNumber++;
    } catch (e) {
      emit(IndivisualCustomerError(errorMessage: e.toString()));
    } finally {
      isFetching = false;
    }
  }

  Future<void> _acceptOrRejectServiceApi(AcceptOrRejectServiceEvent event,
      Emitter<IndivisualCustomerState> emit) async {
    Map<String, dynamic> body = {
      "serviceOrderId": event.serviceOrderId,
      "orderStatus": event.orderStatus,
      if (event.comment.isNotEmpty) "rejectionComment": event.comment
    };
    try {
      emit(IndivisualCustomerLoading());
      var resp = await _myRepo.acceptOrRejectServiceApi(body: body);
      Utils.toastSuccessMessage('${resp.data?.body}');
      emit(AcceptOrRejectServiceSuccess());
    } catch (e) {
      emit(IndivisualCustomerError(errorMessage: e.toString()));
    }
  }
}
