part of 'task_bloc.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class GetSelfAssignTaskEvent extends TaskEvent {
  final bool isSearch;
  final String searchText;
  final bool isPagination;

  const GetSelfAssignTaskEvent(
      {required this.isSearch,
      required this.searchText,
      required this.isPagination});
  @override
  List<Object> get props => [isSearch, searchText, isPagination];
}

class GetAssignTaskEvent extends TaskEvent {
  final bool isSearch;
  final String searchText;
  final bool isPagination;
  final bool isFilter;
  final String filterText;
  const GetAssignTaskEvent(
      {required this.isSearch,
      required this.searchText,
      required this.isPagination,
      required this.isFilter,
      required this.filterText});
  @override
  List<Object> get props =>
      [isSearch, searchText, isPagination, isFilter, filterText];
}
class GetTaskByAssignIdEvent extends TaskEvent {
  final bool isSearch;
  final String searchText;
  final bool isPagination;
  final bool isFilter;
  final String filterText;
  const GetTaskByAssignIdEvent(
      {required this.isSearch,
      required this.searchText,
      required this.isPagination,
      required this.isFilter,
      required this.filterText});
  @override
  List<Object> get props =>
      [isSearch, searchText, isPagination, isFilter, filterText];
}
class CreateTaskEvent extends TaskEvent {
  final int assignedId;
  final int customerId;
  final String priority;
  final String taskName;
  final String description;

  const CreateTaskEvent(
      {required this.assignedId,
      required this.customerId,
      required this.priority,
      required this.taskName,
      required this.description});
  @override
  List<Object> get props =>
      [assignedId, customerId, priority, taskName, description];
}

class GetViewTaskDetailsEvent extends TaskEvent {
  final String taskId;

  const GetViewTaskDetailsEvent({required this.taskId});
  @override
  List<Object> get props => [taskId];
}

class ActionOnTaskEvent extends TaskEvent {
  final String taskId;
  final String taskResponse;

  const ActionOnTaskEvent({required this.taskId, required this.taskResponse});
  @override
  List<Object> get props => [taskId, taskResponse];
}

class TaskUploadDocumentEvent extends TaskEvent {
  final int taskId;
  final List<MultipartFile> documentList;
  final bool emailStatus;

  const TaskUploadDocumentEvent(
      {required this.taskId,
      required this.documentList,
      required this.emailStatus});
  @override
  List<Object> get props => [taskId, documentList, emailStatus];
}
