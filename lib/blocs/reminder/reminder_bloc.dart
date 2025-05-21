import 'package:bloc/bloc.dart';
import 'package:ca_app/data/local_storage/shared_prefs_class.dart';
import 'package:ca_app/data/models/common_model.dart';
import 'package:ca_app/data/models/get_reminders_model.dart';
import 'package:ca_app/data/models/get_view_reminder_model.dart';
import 'package:ca_app/data/models/update_reminder_model.dart';
import 'package:ca_app/data/repositories/reminder_repository.dart';
import 'package:ca_app/utils/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'reminder_event.dart';
part 'reminder_state.dart';

class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  int pageNumber = 0;
  int pageSize = 10;
  bool isFetching = false;
  bool isLastPage = false;
  final _myRepo = ReminderRepository();
  ReminderBloc() : super(ReminderInitial()) {
    on<GetReminderEvent>(_getReminderByCaIdApi);
    on<GetViewReminderEvent>(_getViewReminderApi);
    on<ActiveDeactiveReminderEvent>(_activeDeactiveReminderApi);
  }
  Future<void> _getReminderByCaIdApi(
      GetReminderEvent event, Emitter<ReminderState> emit) async {
    if (isFetching) return;
    if (event.isFilter && !event.isPagination) {
      pageNumber = 0;
      isLastPage = false;
      emit(ReminderLoading());
    }
    if (isLastPage) return;
    isFetching = true;
    int? userId = await SharedPrefsClass().getUserId();
    debugPrint('userId.,.,.,.,.,.,., $userId');
    Map<String, dynamic> query = {
      "pageNumber": pageNumber,
      "pageSize": pageSize,
      "status": event.status,
      "occurrence": event.occurence,
      "caId": userId
    };
    try {
      var resp = await _myRepo.getReminderByCaId(query: query);
      List<Content> newData = resp.data?.content ?? [];
      List<Content> allData = (pageNumber == 0)
          ? newData
          : [
              ...(state is GetReminderSuccess
                  ? (state as GetReminderSuccess).getRemindersData
                  : []),
              ...newData
            ];
      isLastPage = newData.length < pageSize;
      emit(GetReminderSuccess(
          getRemindersData: allData, isLastPage: isLastPage));
      pageNumber++;
    } catch (e) {
      emit(ReminderError(errorMeassage: e.toString()));
    } finally {
      isFetching = false;
    }
  }

  Future<void> _getViewReminderApi(
      GetViewReminderEvent event, Emitter<ReminderState> emit) async {
    Map<String, dynamic> query = {"id": event.reminderId};
    try {
      emit(ReminderLoading());
      var resp = await _myRepo.getViewReminderById(query: query);
      emit(GetViewReminderSuccess(getViewReminderByIdData: resp));
    } catch (e) {
      emit(ReminderError(errorMeassage: e.toString()));
    }
  }

  Future<void> _activeDeactiveReminderApi(
      ActiveDeactiveReminderEvent event, Emitter<ReminderState> emit) async {
    Map<String, dynamic> query = {"id": event.reminderId};
    try {
      // emit(ReminderLoading());
      var resp = await _myRepo.activeDeactiveReminderById(
          query: query, isActive: event.isActivate);
      Utils.toastSuccessMessage(resp.data?.body ?? '');
      emit(ActiveDeactiveReminderSucess(activeDeactiveReminder: resp));
    } catch (e) {
      emit(ActiveDeactiveReminderError());
    }
  }
}

class CreateReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  final _myRepo = ReminderRepository();

  CreateReminderBloc() : super(ReminderInitial()) {
    on<CreateReminderEvent>(_createReminderApi);
    on<UpdateReminderEvent>(_updateReminderApi);
  }
  Future<void> _createReminderApi(
      CreateReminderEvent event, Emitter<ReminderState> emit) async {
    int? userId = await SharedPrefsClass().getUserId();
    debugPrint('userId.,.,.,.,.,.,., $userId');
    Map<String, dynamic> body = {
      "title": event.title,
      "description": event.description,
      "occurrence": event.occurence,
      "createdBy": userId,
      "userIds": event.userIds
    };
    try {
      emit(ReminderLoading());
      var resp = await _myRepo.craeteReminderApi(body: body);
      Utils.toastSuccessMessage('Reminder Created Successfully');
      emit(CreateReminderSuccess(isSuccess: resp));
    } catch (error) {
      emit(ReminderError(errorMeassage: error.toString()));
    }
  }

  Future<void> _updateReminderApi(
      UpdateReminderEvent event, Emitter<ReminderState> emit) async {
    int? userId = await SharedPrefsClass().getUserId();
    debugPrint('userId.,.,.,.,.,.,., $userId');
    Map<String, dynamic> body = {
      "id": event.reminderId,
      "title": event.title,
      "description": event.description,
      "occurrence": event.occurence,
      "createdBy": userId,
      "userIds": event.userIds
    };
    try {
      emit(ReminderLoading());
      var resp = await _myRepo.updateReminderById(body: body);
      Utils.toastSuccessMessage(resp.status?.message ?? '');
      emit(UpdateReminderSuccess(updateReminder: resp));
    } catch (error) {
      emit(ReminderError(errorMeassage: error.toString()));
    }
  }
}
