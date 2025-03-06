import 'package:bloc/bloc.dart';
import 'package:ca_app/data/local_storage/shared_prefs_class.dart';
import 'package:ca_app/data/models/logs_model.dart';
import 'package:ca_app/data/repositories/logs_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'logs_event.dart';
part 'logs_state.dart';

class LogsBloc extends Bloc<LogsEvent, LogsState> {
  int pageNumber = 0;
  final int pageSize = 6;
  bool isFetching = false;
  bool isLastPage = false;
  final _myRepo = LogsRepository();
  LogsBloc() : super(LogsInitial()) {
    on<GetLogsEvent>(_getLogsApi);
  }
  Future<void> _getLogsApi(GetLogsEvent event, Emitter<LogsState> emit) async {
    if (isFetching) return;

    if (!event.isPagination) {
      pageNumber = 0;
      isLastPage = false;
      emit(LogsLoading());

      /// Show loading only for the first page
    }

    if (isLastPage) return;
    isFetching = true;
    int? userId = await SharedPrefsClass().getUserId();
    debugPrint('userId.,.,.,.,.,.,., $userId');
    Map<String, dynamic> query = {
      "caId": userId,
      "pageNumber": pageNumber,
      "pageSize": pageSize,
    };
    Map<String, dynamic> query1 = {
      "actionUponId": event.uponId,
      "pageNumber": pageNumber,
      "pageSize": pageSize,
    };
    try {
      var resp = await _myRepo.getActiveDeactiveLogsApi(
          query: event.byCaId ? query : query1, byCaId: event.byCaId);
      List<LogsData> newData = resp.data ?? [];
      List<LogsData> allData = (pageNumber == 0)
          ? newData
          : [
              ...?(state is LogsSuccess
                  ? (state as LogsSuccess).logsModel
                  : []),
              ...newData
            ];
      isLastPage = newData.length < pageSize;
      emit(LogsSuccess(logsModel: allData, isLastPage: isLastPage));
      pageNumber++;
    } catch (e) {
      emit(LogsError(errorMessage: e.toString()));
    } finally {
      isFetching = false;
    }
  }
}
