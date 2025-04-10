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
  final int? pageNumber;
  final int? pageSize;

  const GetCaServiceListEvent(
      {required this.isSearch,
      required this.searchText,
      required this.isPagination,
      this.pageNumber,
      this.pageSize});
  @override
  List<Object> get props =>
      [isSearch, searchText, isPagination, pageNumber ?? 0, pageSize ?? 0];
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

class UpdateAssignServiceEvent extends ServiceEvent {
  final String clientId;
  final String serviceIds;

  const UpdateAssignServiceEvent(
      {required this.clientId, required this.serviceIds});
  @override
  List<Object> get props => [clientId, serviceIds];
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

class DeleteServiceEvent extends ServiceEvent {
  final String serviceId;

  const DeleteServiceEvent({required this.serviceId});
  @override
  List<Object> get props => [serviceId];
}

class GetViewServiceEvent extends ServiceEvent {
  final bool isPagination;
  final bool isSearch;
  final String searchText;
  final bool isFilter;
  final String filterTex;

  const GetViewServiceEvent({
    required this.isPagination,
    required this.isSearch,
    required this.searchText,
    required this.isFilter,
    required this.filterTex,
  });
  @override
  List<Object> get props =>
      [isPagination, isSearch, searchText, isFilter, filterTex];
}

class AssignServiceEvent extends ServiceEvent {
  final List<int> selectedClients;
  final List<int> selectedServices;

  const AssignServiceEvent(
      {required this.selectedClients, required this.selectedServices});
  @override
  List<Object> get props => [selectedClients, selectedServices];
}

class GetServiceByCaIdEvent extends ServiceEvent {
  final int caId;
  final bool isSearch;
  final String searchText;
  final bool isPagination;

  const GetServiceByCaIdEvent(
      {required this.caId,
      required this.isSearch,
      required this.searchText,
      required this.isPagination});
  @override
  List<Object> get props => [caId, isSearch, searchText, isPagination];
}
