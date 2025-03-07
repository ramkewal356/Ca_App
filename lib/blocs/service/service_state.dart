part of 'service_bloc.dart';

sealed class ServiceState extends Equatable {
  const ServiceState();

  @override
  List<Object> get props => [];
}

final class ServiceInitial extends ServiceState {}

class ServiceLoading extends ServiceState {}

class AddServiceLoading extends ServiceState {}

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

class ServiceError extends ServiceState {
  final String errorMessage;

  const ServiceError({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
