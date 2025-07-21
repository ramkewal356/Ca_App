part of 'logs_bloc.dart';

sealed class LogsState extends Equatable {
  const LogsState();

  @override
  List<Object> get props => [];
}

final class LogsInitial extends LogsState {}

final class LogsLoading extends LogsState {}

final class LogsSuccess extends LogsState {
  final List<LogsData>? logsModel;
  final bool isLastPage;

  const LogsSuccess({required this.logsModel, required this.isLastPage});
  @override
  List<Object> get props => [logsModel ?? [], isLastPage];
}

final class LogsError extends LogsState {
  final String errorMessage;

  const LogsError({required this.errorMessage});
  @override

  List<Object> get props => [errorMessage];
}
