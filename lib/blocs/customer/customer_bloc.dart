import 'package:bloc/bloc.dart';
import 'package:ca_app/data/local_storage/shared_prefs_class.dart';
import 'package:ca_app/data/models/get_customer_by_subca_id_model.dart';
import 'package:ca_app/data/repositories/customer_repository.dart';
import 'package:ca_app/utils/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  List<CustomerData> allCustomers = [];
  int pageNumber = 0;
  int rowsPerPage = 10;
  final int pageSize = 10;
  int pageNumber1 = 0;

  final int pageSize1 = 10;
  bool isFetching = false;
  bool isLastPage = false;
  final _myRepo = CustomerRepository();
  CustomerBloc() : super(CustomerInitial()) {
    on<GetCustomerBySubCaIdEvent>(_getCustomerBySubCaId);
    on<NextPage>(_onNextPage);
    on<PreviousPage>(_onPreviousPage);
    on<GetCustomerByCaIdEvent>(_getCustomerByCaIdApi);
    on<GetCustomerByCaIdForTableEvent>(_getCustomerByCaIdForTableApi);
    on<GetLogincutomerEvent>(_getLoginCustomerByCaId);
    on<UpdateClientEvent>((event, emit) {
      if (state is GetLoginCustomerSuccess) {
        emit(GetLoginCustomerSuccess(
          getLoginCustomers:
              (state as GetLoginCustomerSuccess).getLoginCustomers,
          selectedClientName: event.selectedClientName,
        ));
      }
    });
  }
  Future<void> _getCustomerByCaIdApi(
      GetCustomerByCaIdEvent event, Emitter<CustomerState> emit) async {
    if (isFetching) return;
    bool isNewSearch = (event.isSearch || event.isFilter);

    if (isNewSearch && !event.isPagination) {
      pageNumber = 0;
      isLastPage = false;
      emit(CustomerLoading()); // Show loading only for the first page
    }
    if (isLastPage) return;
    isFetching = true;
    int? userId = await SharedPrefsClass().getUserId();
    debugPrint('userId.,.,.,.,.,.,., $userId');
    Map<String, dynamic> query = {
      "caId": (event.caId ?? '').isEmpty ? userId : event.caId,
      "search": event.searchText,
      "pageNumber": event.pageNumber ?? pageNumber,
      "pageSize": event.pageSize ?? pageSize,
      "filter": event.filterText
    };
    try {
      var resp = await _myRepo.getCustomerByCaId(query: query);
      List<CustomerData> newData = resp.data ?? [];

      // 🔹 If search/filter changed, replace old data. Otherwise, append for pagination.
      List<CustomerData> allItems = (pageNumber == 0)
          ? newData
          : [
              ...?(state is GetCustomerByCaIdSuccess
                  ? (state as GetCustomerByCaIdSuccess).getCustomers
                  : []),
              ...newData
            ];

      isLastPage = newData.length < pageSize;

      emit(GetCustomerByCaIdSuccess(
          getCustomers: allItems,
          totalCustomer: newData.length,
          isLastPage: isLastPage));

      pageNumber++;
    } catch (e) {
      emit(CustomerError(errorMessage: e.toString()));
    } finally {
      isFetching = false;
    }
  }

  Future<void> _getCustomerBySubCaId(
      GetCustomerBySubCaIdEvent event, Emitter<CustomerState> emit) async {
    Map<String, dynamic> query = {
      "subCaId": event.subCaId,
      "search": event.searchText,
      "pageNumber": pageNumber1,
      "pageSize": pageSize1,
    };
    try {
      var resp = await _myRepo.getCustomerBySubCaId(query: query);

      allCustomers = resp.data ?? [];
      debugPrint('vxbnvcx bcvxcnnbcbnxcj bjbcb $allCustomers');
      emit(GetCustomerBySubCaIdSuccess(
          customers: allCustomers.take(rowsPerPage).toList(),
          currentPage: pageNumber1,
          rowsPerPage: rowsPerPage,
          totalCustomer: allCustomers.length));
    } catch (e) {
      emit(CustomerError(errorMessage: e.toString()));
    }
  }

  Future<void> _getCustomerByCaIdForTableApi(
      GetCustomerByCaIdForTableEvent event, Emitter<CustomerState> emit) async {
    int? userId = await SharedPrefsClass().getUserId();
    debugPrint('userId.,.,.,.,.,.,., $userId');
    Map<String, dynamic> query = {
      "caId": userId,
      "search": event.searchText,
      "pageNumber": pageNumber1,
      "pageSize": pageSize1,
      "filter": true
    };
    try {
      emit(CustomerLoading());
      var resp = await _myRepo.getCustomerByCaId(query: query);
      allCustomers = resp.data ?? [];
      debugPrint('vxbnvcx bcvxcnnbcbnxcj bjbcb $allCustomers');
      emit(GetCustomerByCaIdForTableSuccess(
          customers: allCustomers.take(rowsPerPage).toList(),
          currentPage: pageNumber1,
          rowsPerPage: rowsPerPage,
          totalCustomer: allCustomers.length));
    } catch (e) {
      emit(CustomerError(errorMessage: e.toString()));
    }
  }

  Future<void> _getLoginCustomerByCaId(
      GetLogincutomerEvent event, Emitter<CustomerState> emit) async {
    int? userId = await SharedPrefsClass().getUserId();
    debugPrint('userId.,.,.,.,.,.,., $userId');
    Map<String, dynamic> query = {
      "caId": userId,
    };
    try {
      if (event is GetLogincutomerEvent) {
        var resp = await _myRepo.getLoginCustomerByCaId(query: query);
        emit(GetLoginCustomerSuccess(
            getLoginCustomers: resp.data ?? [],
            selectedClientName: event.selectedClientName));
      } else if (event is UpdateClientEvent) {
        emit(GetLoginCustomerSuccess(
            getLoginCustomers:
                (state as GetLoginCustomerSuccess).getLoginCustomers,
            selectedClientName: event.selectedClientName));
      }
    } catch (e) {
      emit(CustomerError(errorMessage: e.toString()));
    }
  }

  void _onNextPage(NextPage event, Emitter<CustomerState> emit) {
    if (state is GetCustomerBySubCaIdSuccess) {
      final currentState = state as GetCustomerBySubCaIdSuccess;
      int newPage = currentState.currentPage + 1;

      // Check if there are more pages
      if (newPage * currentState.rowsPerPage < allCustomers.length) {
        emit(currentState.copyWith(
          customers: allCustomers
              .skip(newPage * currentState.rowsPerPage)
              .take(currentState.rowsPerPage)
              .toList(),
          currentPage: newPage,
        ));
      }
    } else if (state is GetCustomerByCaIdForTableSuccess) {
      final currentState = state as GetCustomerByCaIdForTableSuccess;
      int newPage = currentState.currentPage + 1;

      // Check if there are more pages
      if (newPage * currentState.rowsPerPage < allCustomers.length) {
        emit(currentState.copyWith(
          customers: allCustomers
              .skip(newPage * currentState.rowsPerPage)
              .take(currentState.rowsPerPage)
              .toList(),
          currentPage: newPage,
        ));
      }
    }
  }

  void _onPreviousPage(PreviousPage event, Emitter<CustomerState> emit) {
    if (state is GetCustomerBySubCaIdSuccess) {
      final currentState = state as GetCustomerBySubCaIdSuccess;
      int newPage = currentState.currentPage - 1;

      if (newPage >= 0) {
        emit(currentState.copyWith(
          customers: allCustomers
              .skip(newPage * currentState.rowsPerPage)
              .take(currentState.rowsPerPage)
              .toList(),
          currentPage: newPage,
        ));
      }
    } else if (state is GetCustomerByCaIdForTableSuccess) {
      final currentState = state as GetCustomerByCaIdForTableSuccess;
      int newPage = currentState.currentPage - 1;

      if (newPage >= 0) {
        emit(currentState.copyWith(
          customers: allCustomers
              .skip(newPage * currentState.rowsPerPage)
              .take(currentState.rowsPerPage)
              .toList(),
          currentPage: newPage,
        ));
      }
    }
  }
}

class AssigneCustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final _myRepo = CustomerRepository();

  AssigneCustomerBloc() : super(CustomerInitial()) {
    on<AssignCustomerEvent>(_assignCustomerApi);
  }
  void _assignCustomerApi(
      AssignCustomerEvent event, Emitter<CustomerState> emit) async {
    int? userId = await SharedPrefsClass().getUserId();
    debugPrint('userId.,.,.,.,.,.,., $userId');
    Map<String, dynamic> query = {
      "caId": userId,
      "customerId": event.customerId,
      "subCAId": event.subCaId,
    };
    try {
      emit(AssignCustomerLoading());
      await _myRepo.assignCustomer(query: query);
      Utils.toastSuccessMessage('Customer Assigned Successfully');
      emit(AssignCustomerSuccess());
    } catch (e) {
      emit(CustomerError(errorMessage: e.toString()));
    }
  }
}
