import 'package:bloc/bloc.dart';
import 'package:ca_app/data/local_storage/shared_prefs_class.dart';
import 'package:ca_app/data/models/get_ca_dashboard_model.dart';
import 'package:ca_app/data/repositories/dashboard_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final _myResp = DashboardRepository();
  DashboardBloc() : super(DashboardInitial()) {
    on<GetCaDashboardEvent>(_getCaDashboardApi);
  }
  Future<void> _getCaDashboardApi(
      GetCaDashboardEvent event, Emitter<DashboardState> emit) async {
    int? userId = await SharedPrefsClass().getUserId();
    debugPrint('userId.,.,.,.,.,.,., $userId');
    Map<String, dynamic> query = {"caId": userId};
    try {
      emit(DashboardLoading());
      var resp = await _myResp.getReminderByCaId(query: query);
      emit(GetCaDashboardSuccess(getCaDashboardData: resp));
    } catch (e) {
      emit(DashboardError(errorMessage: e.toString()));
    }
  }
}
