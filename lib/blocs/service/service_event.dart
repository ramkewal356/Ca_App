part of 'service_bloc.dart';

sealed class ServiceEvent extends Equatable {
  const ServiceEvent();

  @override
  List<Object> get props => [];
}

class GetCaServiceListEvent extends ServiceEvent {
  final bool isPagination;
  final bool isSearch;
  final String searchText;

  const GetCaServiceListEvent(
      {required this.isSearch,
      required this.searchText,
      required this.isPagination});
  @override
  List<Object> get props => [isSearch, searchText, isPagination];
}

class GetServiceListEvent extends ServiceEvent {}

class GetSubServiceListEvent extends ServiceEvent {
  final String serviceName;

  const GetSubServiceListEvent({required this.serviceName});
  @override
  List<Object> get props => [serviceName];
}

class AddServiceEvent extends ServiceEvent {
  final int serviceId;

  const AddServiceEvent({required this.serviceId});
  @override
  List<Object> get props => [serviceId];
}

class CreateServiceEvent extends ServiceEvent {
  final String serviceName;
  final String subService;
  final String serviceDesc;

  const CreateServiceEvent(
      {required this.serviceName,
      required this.subService,
      required this.serviceDesc});
  @override
  List<Object> get props => [serviceName, subService, serviceDesc];
}
