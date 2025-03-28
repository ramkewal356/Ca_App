part of 'logs_bloc.dart';

sealed class LogsEvent extends Equatable {
  const LogsEvent();

  @override
  List<Object> get props => [];
}

class GetLogsEvent extends LogsEvent {
  final bool byCaId;
  final String uponId;
  final bool isPagination;
  final bool isFilter;
  final bool isSort;
  final String action;
  final String sorthing;
  const GetLogsEvent(
      {this.byCaId = false,
      this.uponId = '',
      required this.isPagination,
      required this.action,
      this.isFilter = false,
      this.isSort = false,
      required this.sorthing});
  @override
  List<Object> get props =>
      [byCaId, uponId, isPagination, action, isFilter, isSort, sorthing];
}
