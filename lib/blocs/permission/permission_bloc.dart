import 'package:bloc/bloc.dart';
import 'package:ca_app/data/local_storage/shared_prefs_class.dart';
import 'package:ca_app/data/models/get_permission_history_model.dart';
import 'package:ca_app/data/repositories/permission_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'permission_event.dart';
part 'permission_state.dart';

class PermissionBloc extends Bloc<PermissionEvent, PermissionState> {
  int pageNumber = 0;
  final int pageSize = 10;
  bool isFetching = false;
  bool isLastPage = false;
  final _myRepo = PermissionRepository();
  PermissionBloc() : super(PermissionInitial()) {
    on<GetPermissionHistoryEvent>(_getPermissionHistoryApi);
  }
  Future<void> _getPermissionHistoryApi(
      GetPermissionHistoryEvent event, Emitter<PermissionState> emit) async {
    if (isFetching) return;

    if (!event.isPagination) {
      pageNumber = 0;
      isLastPage = false;
      emit(PermissionLoading());

      /// Show loading only for the first page
    }

    if (isLastPage) return;
    isFetching = true;
    int? userId = await SharedPrefsClass().getUserId();
    debugPrint('userId.,.,.,.,.,.,., $userId');
    Map<String, dynamic> query = {
      "updatedById": userId.toString(),
      "pageNumber": pageNumber,
      "pageSize": pageSize,
    };
    try {
      var resp = await _myRepo.getPermissionHistoryApi(query: query);
      List<Content> newData = resp.data?.content ?? [];
      List<Content> allData = (pageNumber == 0)
          ? newData
          : [
              ...(state is GetPermissionHistorySuccess
                  ? (state as GetPermissionHistorySuccess)
                      .getPermissionHistoryList
                  : []),
              ...newData
            ];
      isLastPage = newData.length < pageSize;
      emit(GetPermissionHistorySuccess(
          getPermissionHistoryList: allData, isLastPage: isLastPage));
      pageNumber++;
    } catch (e) {
      emit(PermissionError(message: e.toString()));
    } finally {
      isFetching = false;
    }
  }
}
