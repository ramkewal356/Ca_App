part of 'customer_bloc.dart';

sealed class CustomerState extends Equatable {
  const CustomerState();

  @override
  List<Object> get props => [];
}

final class CustomerInitial extends CustomerState {}

class CustomerLoading extends CustomerState {}

class GetCustomerBySubCaIdSuccess extends CustomerState {
  final List<Datum> customers;
  final int currentPage;
  final int rowsPerPage;
  final int totalCustomer;
  const GetCustomerBySubCaIdSuccess(
      {required this.customers,
      required this.currentPage,
      required this.rowsPerPage,
      required this.totalCustomer});

  // CopyWith method for updating pagination
  GetCustomerBySubCaIdSuccess copyWith(
      {List<Datum>? customers,
      int? currentPage,
      int? rowsPerPage,
      int? totalCustomer}) {
    return GetCustomerBySubCaIdSuccess(
        customers: customers ?? this.customers,
        currentPage: currentPage ?? this.currentPage,
        rowsPerPage: rowsPerPage ?? this.rowsPerPage,
        totalCustomer: totalCustomer ?? this.totalCustomer);
  }

  @override
  List<Object> get props =>
      [customers, currentPage, rowsPerPage, totalCustomer];
}

class GetCustomerByCaIdSuccess extends CustomerState {
  final List<Datum>? getCustomers;
  final int totalCustomer;
  final bool isLastPage;
  const GetCustomerByCaIdSuccess(
      {required this.getCustomers,
      required this.totalCustomer,
      required this.isLastPage});
  GetCustomerByCaIdSuccess copyWith(
      {List<Datum>? getCustomers, int? totalCustomer, bool? isLastPage}) {
    return GetCustomerByCaIdSuccess(
        getCustomers: getCustomers ?? this.getCustomers,
        totalCustomer: totalCustomer ?? this.totalCustomer,
        isLastPage: isLastPage ?? this.isLastPage);
  }

  @override
  List<Object> get props => [getCustomers ?? [], totalCustomer, isLastPage];
}

class CustomerError extends CustomerState {
  final String errorMessage;

  const CustomerError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
