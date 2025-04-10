part of 'task_bloc.dart';

sealed class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

final class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class GetSelfAssignTaskSuccess extends TaskState {
  final List<AssignTaskData> getSelfAssignTaskList;
  final bool isLastPage;
  const GetSelfAssignTaskSuccess(
      {required this.getSelfAssignTaskList, required this.isLastPage});
  @override
  List<Object> get props => [getSelfAssignTaskList, isLastPage];
}

class GetAssignTaskSuccess extends TaskState {
  final List<AssignTaskData> getAssignTaskList;
  final bool isLastPage;
  const GetAssignTaskSuccess(
      {required this.getAssignTaskList, required this.isLastPage});
  @override
  List<Object> get props => [getAssignTaskList, isLastPage];
}
class GetTaskByAssignIdSuccess extends TaskState {
  final List<AssignTaskData> getTaskList;
  final bool isLastPage;
  const GetTaskByAssignIdSuccess(
      {required this.getTaskList, required this.isLastPage});
  @override
  List<Object> get props => [getTaskList, isLastPage];
}
class TaskError extends TaskState {
  final String errorMessage;

  const TaskError({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

class CreateTaskSuccess extends TaskState {
  final bool taskCreated;

  const CreateTaskSuccess({required this.taskCreated});
  @override
  List<Object> get props => [taskCreated];
}

class GetViewTaskDetailsSuccess extends TaskState {
  final GetViewTaskByTaskIdModel getViewTaskDetails;

  const GetViewTaskDetailsSuccess({required this.getViewTaskDetails});
  @override
  List<Object> get props => [getViewTaskDetails];
}

class ActionOnTaskLoading extends TaskState {
  final String taskId;

  const ActionOnTaskLoading({required this.taskId});
  @override
  List<Object> get props => [taskId];
}

class TaskUploadDocumentSuccess extends TaskState {
  final DocumentUploadModel taskDocumentUploadModel;

  const TaskUploadDocumentSuccess({required this.taskDocumentUploadModel});
  @override
  List<Object> get props => [taskDocumentUploadModel];
}

class ActionOnTaskSuccess extends TaskState {
  final GetActionOnTaskModel actionOnTaskData;

  const ActionOnTaskSuccess({required this.actionOnTaskData});
  @override
  List<Object> get props => [actionOnTaskData];
}
