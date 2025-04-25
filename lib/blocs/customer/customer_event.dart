part of 'customer_bloc.dart';

sealed class CustomerEvent extends Equatable {
  const CustomerEvent();

  @override
  List<Object> get props => [];
}

class GetCustomerBySubCaIdEvent extends CustomerEvent {
  final String subCaId;
  final String searchText;
  final bool isSearch;
  final bool isPagination;
  const GetCustomerBySubCaIdEvent(
      {required this.subCaId,
      required this.searchText,
      required this.isSearch,
      required this.isPagination});
  @override
  List<Object> get props => [subCaId, searchText, isSearch, isPagination];
}

class GetCustomerByCaIdEvent extends CustomerEvent {
  final String? caId;
  final String searchText;
  final bool isSearch;
  final bool isPagination;
  final String filterText;
  final bool isFilter;
  final int? pageNumber;
  final int? pageSize;
  const GetCustomerByCaIdEvent(
      {this.caId,
      required this.searchText,
      required this.isSearch,
      required this.isPagination,
      required this.filterText,
      required this.isFilter,
      this.pageNumber,
      this.pageSize});
  @override
  List<Object> get props => [
        caId ?? '',
        searchText,
        isSearch,
        isPagination,
        filterText,
        isFilter,
        pageNumber ?? 0,
        pageSize ?? 0
      ];
}

class GetCustomerBySubCaEvent extends CustomerEvent {
  final String searchText;
  final bool isSearch;
  final bool isPagination;
  final int? pageNumber;
  final int? pageSize;
  const GetCustomerBySubCaEvent(
      {required this.searchText,
      required this.isSearch,
      required this.isPagination,
      this.pageNumber,
      this.pageSize});
  @override
  List<Object> get props =>
      [searchText, isSearch, isPagination, pageNumber ?? 0, pageSize ?? 0];
}

class GetCustomerByCaIdForTableEvent extends CustomerEvent {
  final String searchText;
  final bool isSearch;
  final bool isPagination;
  final int pageNumber;
  final int pageSize;
  final String? subCaId;
  const GetCustomerByCaIdForTableEvent(
      {required this.searchText,
      required this.isSearch,
      required this.isPagination,
      required this.pageNumber,
      required this.pageSize,
      this.subCaId});
  @override
  List<Object> get props =>
      [
        searchText,
        isSearch,
        isPagination,
        pageNumber,
        pageNumber,
        subCaId ?? ''
      ];
}

class NextPage extends CustomerEvent {}

class PreviousPage extends CustomerEvent {}

class AssignCustomerEvent extends CustomerEvent {
  final List<int> customerId;
  final int subCaId;

  const AssignCustomerEvent({required this.customerId, required this.subCaId});
  @override
  List<Object> get props => [customerId, subCaId];
}

class GetLogincutomerEvent extends CustomerEvent {
  final String selectedClientName;

  const GetLogincutomerEvent({required this.selectedClientName});
  @override
  List<Object> get props => [selectedClientName];
}

class UpdateClientEvent extends CustomerEvent {
  final String selectedClientName;

  const UpdateClientEvent({required this.selectedClientName});
  @override
  List<Object> get props => [selectedClientName];
}
