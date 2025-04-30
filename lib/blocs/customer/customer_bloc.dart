import 'package:bloc/bloc.dart';
import 'package:ca_app/data/local_storage/shared_prefs_class.dart';
import 'package:ca_app/data/models/get_customer_by_subca_id_model.dart';
import 'package:ca_app/data/models/get_login_customer_model.dart';
import 'package:ca_app/data/repositories/customer_repository.dart';
import 'package:ca_app/utils/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  List<Content> allCustomers = [];
  int pageNumber = 0;
  int rowsPerPage = 7;
  final int pageSize = 10;
  int pageNumber1 = 0;

  final int pageSize1 = 7;
  bool isFetching = false;
  bool isLastPage = false;
  final _myRepo = CustomerRepository();
  CustomerBloc() : super(CustomerInitial()) {
    on<GetCustomerBySubCaIdEvent>(_getCustomerBySubCaId);
    on<NextPage>(_onNextPage);
    on<PreviousPage>(_onPreviousPage);
    on<GetCustomerByCaIdEvent>(_getCustomerByCaIdApi);
    on<GetCustomerByCaIdForTableEvent>(_getCustomerByCaIdForTableApi);
    on<GetCustomerByCaIdForNewEvent>(_getCustomerByCaIdForNewApi);
    on<GetLogincutomerEvent>(_getLoginCustomerByCaId);
    on<GetCustomerBySubCaEvent>(_getCustomerBySubCaIdApi);
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
      List<Content> newData = resp.data?.content ?? [];

      // 🔹 If search/filter changed, replace old data. Otherwise, append for pagination.
      List<Content> allItems = (pageNumber == 0)
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
          totalCustomer: resp.data?.totalElements ?? 0,
          isLastPage: isLastPage));

      pageNumber++;
    } catch (e) {
      emit(CustomerError(errorMessage: e.toString()));
    } finally {
      isFetching = false;
    }
  }

  Future<void> _getCustomerBySubCaIdApi(
      GetCustomerBySubCaEvent event, Emitter<CustomerState> emit) async {
    if (isFetching) return;
    // bool isNewSearch = (event.isSearch);

    if (event.isSearch && !event.isPagination) {
      pageNumber = 0;
      isLastPage = false;
      emit(CustomerLoading()); // Show loading only for the first page
    }
    if (isLastPage) return;
    isFetching = true;
    int? userId = await SharedPrefsClass().getUserId();
    debugPrint('userId.,.,.,.,.,.,., $userId');
    Map<String, dynamic> query = {
      "subCaId": userId,
      "search": event.searchText,
      "pageNumber": event.pageNumber ?? pageNumber,
      "pageSize": event.pageSize ?? pageSize,
    };
    try {
      var resp = await _myRepo.getCustomerBySubCaId(query: query);
      List<Content> newData = resp.data?.content ?? [];

      // 🔹 If search/filter changed, replace old data. Otherwise, append for pagination.
      List<Content> allItems = (pageNumber == 0)
          ? newData
          : [
              ...?(state is GetCustomerBySubCaSuccess
                  ? (state as GetCustomerBySubCaSuccess).getCustomers
                  : []),
              ...newData
            ];

      isLastPage = newData.length < pageSize;

      emit(GetCustomerBySubCaSuccess(
          getCustomers: allItems,
          totalCustomer: resp.data?.totalElements ?? 0,
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

      allCustomers = resp.data?.content ?? [];
      debugPrint('vxbnvcx bcvxcnnbcbnxcj bjbcb $allCustomers');
      emit(GetCustomerBySubCaIdSuccess(
          customers: allCustomers.take(rowsPerPage).toList(),
          currentPage: pageNumber1,
          rowsPerPage: rowsPerPage,
          totalCustomer: resp.data?.totalElements ?? 0));
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
      "pageNumber": event.pageNumber,
      "pageSize": event.pageSize,
      "filter": true,
      if ((event.subCaId ?? '').isNotEmpty) "subCaId": event.subCaId
    };
    try {
      emit(CustomerLoading());

      var resp = ((event.subCaId ?? '').isNotEmpty)
          ? await _myRepo.getCustomerByCaIdAndSubCaIdApi(query: query)
          : await _myRepo.getCustomerByCaId(query: query);
      allCustomers = resp.data?.content ?? [];
      debugPrint('vxbnvcx bcvxcnnbcbnxcj bjbcb $resp');
      emit(GetCustomerByCaIdForTableSuccess(
          customers: allCustomers,
          currentPage: event.pageNumber,
          rowsPerPage: event.pageSize,
          totalCustomer: resp.data?.totalElements ?? 0));
    } catch (e) {
      emit(CustomerError(errorMessage: e.toString()));
    }
  }

  Future<void> _getCustomerByCaIdForNewApi(
      GetCustomerByCaIdForNewEvent event, Emitter<CustomerState> emit) async {
    int? userId = await SharedPrefsClass().getUserId();
    debugPrint('userId.,.,.,.,.,.,., $userId');
    Map<String, dynamic> query = {
      if (event.role == 'CA') "caId": userId,
      if (event.role == 'SUBCA') "subCaId": userId,
      "search": event.searchText,
      "pageNumber": event.pageNumber,
      "pageSize": event.pageSize,
     
    };
    try {
      emit(CustomerLoading());
      var resp = event.role == 'CA'
          ? await _myRepo.getCustomerByCaIdForNewApi(query: query)
          : await _myRepo.getCustomerBySubCaIdApi(query: query);
      List<Content> allCustomerList = resp.data?.content ?? [];
      debugPrint('get customer by ca id new $resp');
      emit(GetCustomerForRaiseSuccess(
          customers: allCustomerList,
          currentPage: event.pageNumber,
          rowsPerPage: event.pageSize,
          totalCustomer: resp.data?.totalElements ?? 0));
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
      if (newPage * currentState.rowsPerPage < currentState.totalCustomer) {
        add(GetCustomerByCaIdForTableEvent(
            searchText: '',
            isSearch: false,
            isPagination: false,
            pageNumber: newPage,
            pageSize: currentState.rowsPerPage));
      }
    } else if (state is GetCustomerForRaiseSuccess) {
      final currentState = state as GetCustomerForRaiseSuccess;

      int newPage = currentState.currentPage + 1;

      // Check if there are more pages
      if (newPage * currentState.rowsPerPage < currentState.totalCustomer) {
        add(GetCustomerByCaIdForNewEvent(
          searchText: '',
          isSearch: false,
          isPagination: false,
          pageNumber: newPage,
          pageSize: currentState.rowsPerPage,
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
        add(GetCustomerByCaIdForTableEvent(
            searchText: '',
            isSearch: false,
            isPagination: false,
            pageNumber: newPage,
            pageSize: currentState.rowsPerPage));
      }
    } else if (state is GetCustomerForRaiseSuccess) {
      final currentState = state as GetCustomerForRaiseSuccess;
      int newPage = currentState.currentPage - 1;

      if (newPage >= 0) {
        add(GetCustomerByCaIdForNewEvent(
            searchText: '',
            isSearch: false,
            isPagination: false,
            pageNumber: newPage,
            pageSize: currentState.rowsPerPage));
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
    Map<String, dynamic> body = {
      "caId": userId.toString(),
      "customerIds": event.customerId,
      "subCaId": event.subCaId,
    };
    try {
      emit(AssignCustomerLoading());
      await _myRepo.assignCustomer(body: body);
      Utils.toastSuccessMessage('Customer Assigned Successfully');
      emit(AssignCustomerSuccess());
    } catch (e) {
      emit(CustomerError(errorMessage: e.toString()));
    }
  }
}

class GetLoginCustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final _myRepo = CustomerRepository();

  GetLoginCustomerBloc() : super(CustomerInitial()) {
    on<GetLogincutomerEvent>(_getLoginCustomerByCaId);
  }

  Future<void> _getLoginCustomerByCaId(
      GetLogincutomerEvent event, Emitter<CustomerState> emit) async {
    int? userId = await SharedPrefsClass().getUserId();
    debugPrint('userId.,.,.,.,.,.,., $userId');
    Map<String, dynamic> query = {
      "caId": userId,
    };
    try {
      var resp = await _myRepo.getLoginCustomerByCaId(query: query);
      emit(GetLoginCustomerSuccess(
          getLoginCustomers: resp.data ?? [],
          selectedClientName: event.selectedClientName));
    } catch (e) {
      emit(CustomerError(errorMessage: e.toString()));
    }
  }
}
