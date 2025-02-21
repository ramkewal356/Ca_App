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
