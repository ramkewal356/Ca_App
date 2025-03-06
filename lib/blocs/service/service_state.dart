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

class GetCaServiceListSuccess extends ServiceState {
  final List<ServicesListData> getCaServicesList;
  final List<ServiceAndSubServiceListData> getServicesList;
  final List<ServiceAndSubServiceListData> getSubServiceList;

  final bool isLastPage;

  const GetCaServiceListSuccess(
      {required this.getCaServicesList,
      required this.isLastPage,
      this.getServicesList = const [],
      this.getSubServiceList = const []});
  @override
  List<Object> get props =>
      [getCaServicesList, isLastPage, getServicesList, getSubServiceList];
  GetCaServiceListSuccess copyWith(
      {List<ServicesListData>? getCaServicesList,
      bool? isLastPage,
      List<ServiceAndSubServiceListData>? getServicesList,
      List<ServiceAndSubServiceListData>? getSubServiceList}) {
    return GetCaServiceListSuccess(
        getCaServicesList: getCaServicesList ?? this.getCaServicesList,
        isLastPage: isLastPage ?? this.isLastPage,
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

class ServiceError extends ServiceState {
  final String errorMessage;

  const ServiceError({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
