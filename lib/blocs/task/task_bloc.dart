import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:ca_app/data/local_storage/shared_prefs_class.dart';
import 'package:ca_app/data/models/action_on_task_model.dart';
import 'package:ca_app/data/models/get_self_assign_task_model.dart';
import 'package:ca_app/data/models/get_view_task_by_taskid_model.dart';
import 'package:ca_app/data/models/task_upload_document_model.dart';
import 'package:ca_app/data/repositories/task_repository.dart';
import 'package:ca_app/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  int pageNumber = 0;
  final int pageSize = 10;
  bool isFetching = false;
  bool isLastPage = false;
  final _myRepo = TaskRepository();
  TaskBloc() : super(TaskInitial()) {
    on<GetSelfAssignTaskEvent>(_getSelfAssignTaskListApi);
    on<GetAssignTaskEvent>(_getAssignTaskListApi);
    on<GetViewTaskDetailsEvent>(_getViewTaskDetailsApi);
    on<TaskUploadDocumentEvent>(_taskDocumentUploadApi);
  }
  Future<void> _getSelfAssignTaskListApi(
      GetSelfAssignTaskEvent event, Emitter<TaskState> emit) async {
    if (isFetching) return;

    if (event.isSearch && !event.isPagination) {
      pageNumber = 0;
      isLastPage = false;
      emit(TaskLoading()); // Show loading only for the first page
    }
    if (isLastPage) return;
    isFetching = true;
    int? userId = await SharedPrefsClass().getUserId();
    debugPrint('created by Id.,.,.,.,.,.,., $userId');
    Map<String, dynamic> query = {
      "createdById": userId,
      "search": event.searchText,
      "pageNumber": pageNumber,
      "pageSize": pageSize,
      "filter": ''
    };
    try {
      var resp = await _myRepo.getSelfAssignTaskApi(query: query);
      List<AssignTaskData> newData = resp.data ?? [];
      List<AssignTaskData> allData = (pageNumber == 0)
          ? newData
          : [
              ...(state is GetSelfAssignTaskSuccess
                  ? (state as GetSelfAssignTaskSuccess).getSelfAssignTaskList
                  : []),
              ...newData
            ];
      isLastPage = newData.length < pageSize;
      emit(GetSelfAssignTaskSuccess(
          getSelfAssignTaskList: allData, isLastPage: isLastPage));
      pageNumber++;
    } catch (e) {
      emit(TaskError(errorMessage: e.toString()));
    } finally {
      isFetching = false;
    }
  }

  Future<void> _getAssignTaskListApi(
      GetAssignTaskEvent event, Emitter<TaskState> emit) async {
    if (isFetching) return;
    bool isNewSearch = (event.isSearch || event.isFilter);
    if (isNewSearch && !event.isPagination) {
      pageNumber = 0;
      isLastPage = false;
      emit(TaskLoading()); // Show loading only for the first page
    }
    if (isLastPage) return;
    isFetching = true;
    int? userId = await SharedPrefsClass().getUserId();
    debugPrint('created by Id.,.,.,.,.,.,., $userId');
    Map<String, dynamic> query = {
      "createdById": userId,
      "search": event.searchText,
      "pageNumber": pageNumber,
      "pageSize": pageSize,
      "filter": event.filterText
    };
    try {
      var resp = await _myRepo.getAssignTaskApi(query: query);
      List<AssignTaskData> newData = resp.data ?? [];
      List<AssignTaskData> allData = (pageNumber == 0)
          ? newData
          : [
              ...(state is GetAssignTaskSuccess
                  ? (state as GetAssignTaskSuccess).getAssignTaskList
                  : []),
              ...newData
            ];
      isLastPage = newData.length < pageSize;
      emit(GetAssignTaskSuccess(
          getAssignTaskList: allData, isLastPage: isLastPage));
      pageNumber++;
    } catch (e) {
      emit(TaskError(errorMessage: e.toString()));
    } finally {
      isFetching = false;
    }
  }

  Future<void> _getViewTaskDetailsApi(
      GetViewTaskDetailsEvent event, Emitter<TaskState> emit) async {
    Map<String, dynamic> query = {"taskId": event.taskId};
    try {
      emit(TaskLoading());
      var resp = await _myRepo.getViewTaskDetailsApi(query: query);
      emit(GetViewTaskDetailsSuccess(getViewTaskDetails: resp));
    } catch (e) {
      emit(TaskError(errorMessage: e.toString()));
    }
  }

  Future<void> _taskDocumentUploadApi(
      TaskUploadDocumentEvent event, Emitter<TaskState> emit) async {
    Map<String, dynamic> body = {
      "taskId": event.taskId,
      "file": event.documentList,
      "emailStatus": event.emailStatus
    };
    try {
      emit(TaskLoading());
      var resp = await _myRepo.taskDocumentUploadApi(body: body);
      Utils.toastSuccessMessage(resp.data?.body ?? '');
      emit(TaskUploadDocumentSuccess(taskDocumentUploadModel: resp));
    } catch (e) {
      emit(TaskError(errorMessage: e.toString()));
    }
  }
}

class CreateNewTaskBloc extends Bloc<TaskEvent, TaskState> {
  final _myRepo = TaskRepository();
  CreateNewTaskBloc() : super(TaskInitial()) {
    on<CreateTaskEvent>(_createNewTask);
  }
  Future<void> _createNewTask(
      CreateTaskEvent event, Emitter<TaskState> emit) async {
    int? userId = await SharedPrefsClass().getUserId();
    debugPrint('created by Id.,.,.,.,.,.,., $userId');
    Map<String, dynamic> body = {
      "createdById": userId,
      "name": event.taskName,
      "priority": event.priority,
      "description": event.description,
      "assignedId": event.assignedId,
      "customerId": event.customerId,
      "assigneeId": userId
    };
    try {
      emit(TaskLoading());
      var resp = await _myRepo.createNewTaskApi(body: body);
      Utils.toastSuccessMessage('New Task Created Successfully');
      emit(CreateTaskSuccess(taskCreated: resp));
    } catch (e) {
      emit(TaskError(errorMessage: e.toString()));
    }
  }
}

class ActionOnTaskBloc extends Bloc<TaskEvent, TaskState> {
  final _myRepo = TaskRepository();
  ActionOnTaskBloc() : super(TaskInitial()) {
    on<ActionOnTaskEvent>(_actionOnTaskApi);
  }
  Future<void> _actionOnTaskApi(
      ActionOnTaskEvent event, Emitter<TaskState> emit) async {
    Map<String, dynamic> body = {
      "id": event.taskId,
      "taskResponse": event.taskResponse
    };
    try {
      emit(ActionOnTaskLoading(taskId: event.taskId));
      var resp = await _myRepo.actionOnTaskApi(body: body);
      Utils.toastSuccessMessage('Task Completed Succussfully');
      emit(ActionOnTaskSuccess(actionOnTaskData: resp));
    } catch (e) {
      emit(TaskError(errorMessage: e.toString()));
    }
  }
}
