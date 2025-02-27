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

class NextPage extends CustomerEvent {}

class PreviousPage extends CustomerEvent {}
