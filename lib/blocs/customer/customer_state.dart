part of 'customer_bloc.dart';

sealed class CustomerState extends Equatable {
  const CustomerState();

  @override
  List<Object> get props => [];
}

final class CustomerInitial extends CustomerState {}

class CustomerLoading extends CustomerState {}

class GetCustomerBySubCaIdSuccess extends CustomerState {
  final List<Datum>? getCustomerBySubCaIdModel;

  const GetCustomerBySubCaIdSuccess({required this.getCustomerBySubCaIdModel});
  @override
  List<Object> get props => [getCustomerBySubCaIdModel ?? []];
}

class CustomerError extends CustomerState {
  final String errorMessage;

  const CustomerError({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
