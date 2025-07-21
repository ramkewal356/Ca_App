part of 'permission_bloc.dart';

sealed class PermissionEvent extends Equatable {
  const PermissionEvent();

  @override
  List<Object> get props => [];
}

class GetPermissionHistoryEvent extends PermissionEvent {
  final bool isPagination;

  const GetPermissionHistoryEvent({required this.isPagination});
  @override
  List<Object> get props => [isPagination];
}
