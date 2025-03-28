part of 'dashboard_bloc.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

final class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class GetCaDashboardSuccess extends DashboardState {
  final GetCaDashboardDataModel getCaDashboardData;

  const GetCaDashboardSuccess({required this.getCaDashboardData});
  @override
  List<Object> get props => [getCaDashboardData];
}

class DashboardError extends DashboardState {
  final String errorMessage;

  const DashboardError({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
