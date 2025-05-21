part of 'indivisual_customer_bloc.dart';

sealed class IndivisualCustomerState extends Equatable {
  const IndivisualCustomerState();

  @override
  List<Object> get props => [];
}

final class IndivisualCustomerInitial extends IndivisualCustomerState {}

final class IndivisualCustomerLoading extends IndivisualCustomerState {}

class GetRequestedServiceByCaIdSuccess extends IndivisualCustomerState {
  final List<Content> getRequestedServiceList;
  final bool isLastPage;

  const GetRequestedServiceByCaIdSuccess(
      {required this.getRequestedServiceList, required this.isLastPage});
  @override
  List<Object> get props => [getRequestedServiceList, isLastPage];
}
class AcceptOrRejectServiceSuccess extends IndivisualCustomerState {
  
}
final class IndivisualCustomerError extends IndivisualCustomerState {
  final String errorMessage;

  const IndivisualCustomerError({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
