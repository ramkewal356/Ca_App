part of 'service_bloc.dart';

sealed class ServiceState extends Equatable {
  const ServiceState();

  @override
  List<Object> get props => [];
}

final class ServiceInitial extends ServiceState {}

class ServiceLoading extends ServiceState {}

class AddServiceLoading extends ServiceState {}

class SendServiceRequestLoading extends ServiceState {
  final int caId;

  const SendServiceRequestLoading({required this.caId});
  @override
  List<Object> get props => [caId];
}

class GetServiceLoading extends ServiceState {}

class DeleteServiceLoading extends ServiceState {}

class GetCaServiceListSuccess extends ServiceState {
  final List<ServicesListData> getCaServicesList;
  final List<ServiceAndSubServiceListData> getServicesList;
  final List<ServiceAndSubServiceListData> getSubServiceList;
  final bool deleteService;
  final bool isLastPage;

  const GetCaServiceListSuccess(
      {required this.getCaServicesList,
      required this.isLastPage,
      this.getServicesList = const [],
      this.getSubServiceList = const [],
      this.deleteService = false});
  @override
  List<Object> get props => [
        getCaServicesList,
        isLastPage,
        getServicesList,
        getSubServiceList,
        deleteService
      ];
  GetCaServiceListSuccess copyWith(
      {List<ServicesListData>? getCaServicesList,
      bool? isLastPage,
      bool? deleteService,
      List<ServiceAndSubServiceListData>? getServicesList,
      List<ServiceAndSubServiceListData>? getSubServiceList}) {
    return GetCaServiceListSuccess(
        getCaServicesList: getCaServicesList ?? this.getCaServicesList,
        isLastPage: isLastPage ?? this.isLastPage,
        deleteService: deleteService ?? this.deleteService,
        getServicesList: getServicesList ?? this.getServicesList,
        getSubServiceList: getSubServiceList ?? this.getSubServiceList);
  }
}

class AddServiceSuccess extends ServiceState {
  final AddServiceModel addServiceModel;

  const AddServiceSuccess({required this.addServiceModel});
  @override
  List<Object> get props => [addServiceModel];
}

class CreateServiceSuccess extends ServiceState {
  final CreateNewServiceModel createNewServiceModel;

  const CreateServiceSuccess({required this.createNewServiceModel});
  @override
  List<Object> get props => [createNewServiceModel];
}

class DeleteServiceError extends ServiceState {}

class GetViewServiceSuccess extends ServiceState {
  final List<ViewServiceData> getViewServiceList;
  final bool isLastPage;

  const GetViewServiceSuccess(
      {required this.getViewServiceList, required this.isLastPage});
  @override
  List<Object> get props => [getViewServiceList, isLastPage];
}

class AssignServiceToUserSuccess extends ServiceState {
  final CommonModel assignServiceToClient;

  const AssignServiceToUserSuccess({required this.assignServiceToClient});
  @override
  List<Object> get props => [assignServiceToClient];
}

class UpdateAssigneService extends ServiceState {
  final bool updatedAssignService;

  const UpdateAssigneService({required this.updatedAssignService});
  @override
  List<Object> get props => [updatedAssignService];
}

class GetServiceByCaIdSuccess extends ServiceState {
  final List<ServicesListData> serviceList;
  final bool isLastPage;

  const GetServiceByCaIdSuccess(
      {required this.serviceList, required this.isLastPage});
  @override
  List<Object> get props => [serviceList, isLastPage];
}

class GetServiceForIndivisualCustomerSuccess extends ServiceState {
  final List<Content> serviceForCustomerList;
  final bool isLastPage;

  const GetServiceForIndivisualCustomerSuccess(
      {required this.serviceForCustomerList, required this.isLastPage});
  @override
  List<Object> get props => [serviceForCustomerList, isLastPage];
}

class GetCaByServiceNameSuccess extends ServiceState {
  final List<CaList> caList;
  final bool isLastPage;
  final String serviceName;
  final String subService;
  final String serviceDesc;
  final int serviceId;
  const GetCaByServiceNameSuccess(
      {required this.caList,
      required this.serviceName,
      required this.subService,
      required this.serviceDesc,
      required this.serviceId,
      required this.isLastPage});
  @override
  List<Object> get props =>
      [caList, serviceName, subService, serviceDesc, serviceId, isLastPage];
}

class SendSericeRequestOrderSuccess extends ServiceState {}

class GetAllServiceRequestedCaSuccess extends ServiceState {
  final List<RequestCaContent> requestedCaList;
  final bool isLastPage;

  const GetAllServiceRequestedCaSuccess(
      {required this.requestedCaList, required this.isLastPage});
  @override
  List<Object> get props => [requestedCaList, isLastPage];
}

class ViewRequestedCaByServiceIdSuccess extends ServiceState {
  final GetViewRequestedCaByServiceIdModel getViewRequestedCaByServiceIdModel;

  const ViewRequestedCaByServiceIdSuccess(
      {required this.getViewRequestedCaByServiceIdModel});
  @override
  List<Object> get props => [getViewRequestedCaByServiceIdModel];
}

class ServiceError extends ServiceState {
  final String errorMessage;

  const ServiceError({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
