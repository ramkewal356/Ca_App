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
  final String urgencyFilterText;
  const GetRequestedServiceByCaIdEvent(
      {required this.isFilter,
      required this.filterText,
      required this.isPagination,
      required this.urgencyFilterText});
  @override
  List<Object> get props =>
      [isFilter, filterText, isPagination, urgencyFilterText];
}

class AcceptOrRejectServiceEvent extends IndivisualCustomerEvent {
  final int serviceOrderId;
  final String orderStatus;
  final String comment;

  const AcceptOrRejectServiceEvent(
      {required this.serviceOrderId,
      required this.orderStatus,
      this.comment = ''});
  @override
  List<Object> get props => [serviceOrderId, orderStatus, comment];
}
