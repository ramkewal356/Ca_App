part of 'indivisual_customer_bloc.dart';

sealed class IndivisualCustomerEvent extends Equatable {
  const IndivisualCustomerEvent();

  @override
  List<Object> get props => [];
}

class GetRequestedServiceByCaIdEvent extends IndivisualCustomerEvent {
  final bool isFilter;
  final String filterText;
  final bool isPagination;

  const GetRequestedServiceByCaIdEvent(
      {required this.isFilter,
      required this.filterText,
      required this.isPagination});
  @override
  List<Object> get props => [isFilter, filterText, isPagination];
}
