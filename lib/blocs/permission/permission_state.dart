part of 'permission_bloc.dart';

sealed class PermissionState extends Equatable {
  const PermissionState();

  @override
  List<Object> get props => [];
}

final class PermissionInitial extends PermissionState {}

class PermissionLoading extends PermissionState {}

class GetPermissionHistorySuccess extends PermissionState {
  final List<Content> getPermissionHistoryList;

  final bool isLastPage;

  const GetPermissionHistorySuccess(
      {required this.getPermissionHistoryList, required this.isLastPage});
  @override
  List<Object> get props => [getPermissionHistoryList, isLastPage];
}

class PermissionError extends PermissionState {
  final String message;

  const PermissionError({required this.message});
  @override
  List<Object> get props => [message];
}
