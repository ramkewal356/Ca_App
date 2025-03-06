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
  const GetLogsEvent(
      {this.byCaId = false, this.uponId = '', required this.isPagination});
  @override
  List<Object> get props => [byCaId, uponId];
}
