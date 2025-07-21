import 'package:bloc/bloc.dart';
import 'package:ca_app/data/local_storage/shared_prefs_class.dart';
import 'package:ca_app/data/models/degination_model.dart';
import 'package:ca_app/data/models/get_active_ca_with_service_model.dart';
import 'package:ca_app/data/models/get_permission_model.dart';
import 'package:ca_app/data/models/get_subca_by_caid_model.dart';
import 'package:ca_app/data/models/get_team_member_model.dart';
import 'package:ca_app/data/repositories/team_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'team_member_event.dart';
part 'team_member_state.dart';

class TeamMemberBloc extends Bloc<TeamMemberEvent, TeamMemberState> {
  int pageNumber = 0;
  final int pageSize = 10;
  bool isFetching = false;
  bool isLastPage = false;
  final _myRepo = TeamRepository();
  TeamMemberBloc() : super(TeamMemberInitial()) {
    on<GetTeamMemberEvent>(_getTeamMemberApi);
    on<GetSubCaByCaIdEvent>(_getSubCaByCaIdApi);
    on<GetVerifiedSubCaByCaIdEvent>(_getVerifiedSubCaByCaIdApi);
    on<UpdateSubCaNameEvent>((event, emit) {
      if (state is GetVerifiedSubCaByCaIdSuccess) {
        emit(GetVerifiedSubCaByCaIdSuccess(
            getTeamMemberModel:
                (state as GetVerifiedSubCaByCaIdSuccess).getTeamMemberModel,
            selectedSubCaName: event.selectedSubCaName));
      }
    });
    on<GetActiveCaWithServiceEvent>(_getActiveCaWithServiceApi);
  }
  Future<void> _getTeamMemberApi(
      GetTeamMemberEvent event, Emitter<TeamMemberState> emit) async {
    if (isFetching) return;

    bool isNewSearch = (event.isSearch || event.isFilter);

    if (isNewSearch && !event.isPagination) {
      pageNumber = 0;
      isLastPage = false;
      emit(TeamMemberLoading()); // Show loading only for the first page
    }

    if (isLastPage) return;
    isFetching = true;
    int? userId = await SharedPrefsClass().getUserId();
    debugPrint('userId.,.,.,.,.,.,., $userId');
    Map<String, dynamic> query = {
      "caId": userId,
      "search": event.searchText,
      "pageNumber": event.pageNumber ?? pageNumber,
      "pageSize": event.pagesize ?? pageSize,
      "filter": event.filterText
    };
    try {
      var resp = await _myRepo.getTeamByCaId(query: query);

      List<TeamContent> newData = resp.data?.content ?? [];

      // 🔹 If search/filter changed, replace old data. Otherwise, append for pagination.
      List<TeamContent> allItems = (pageNumber == 0)
          ? newData
          : [
              ...?(state is GetTeamMemberSuccess
                  ? (state as GetTeamMemberSuccess).getTeamMemberModel
                  : []),
              ...newData
            ];

      isLastPage = newData.length < pageSize;

      emit(GetTeamMemberSuccess(
        getTeamMemberModel: allItems,
        isLastPage: isLastPage,
      ));

      pageNumber++;
    } catch (e) {
      emit(TeamMemberError(errorMessage: e.toString()));
    } finally {
      isFetching = false;
    }
  }

  Future<void> _getSubCaByCaIdApi(
      GetSubCaByCaIdEvent event, Emitter<TeamMemberState> emit) async {
    int? userId = await SharedPrefsClass().getUserId();
    debugPrint('userId.,.,.,.,.,.,., $userId');
    Map<String, dynamic> query = {"caId": userId, "search": event.searhText};
    try {
      var resp = await _myRepo.getSubCaByCaIdApi(query: query);
      emit(GetSubCaListSuccess(getTeamMembers: resp.data ?? []));
    } catch (e) {
      emit(TeamMemberError(errorMessage: e.toString()));
    }
  }

  Future<void> _getVerifiedSubCaByCaIdApi(
      GetVerifiedSubCaByCaIdEvent event, Emitter<TeamMemberState> emit) async {
    int? userId = await SharedPrefsClass().getUserId();
    debugPrint('userId.,.,.,.,.,.,., $userId');
    Map<String, dynamic> query = {
      "caId": userId,
    };
    try {
      var resp = await _myRepo.getVerifiedSubCaByCaId(query: query);
      emit(GetVerifiedSubCaByCaIdSuccess(
          getTeamMemberModel: resp.data ?? [],
          selectedSubCaName: event.selectedSubCaName));
    } catch (e) {
      emit(TeamMemberError(errorMessage: e.toString()));
    }
  }

  Future<void> _getActiveCaWithServiceApi(
      GetActiveCaWithServiceEvent event, Emitter<TeamMemberState> emit) async {
    Map<String, dynamic> query = {"pageNumber": 0, "pageSize": 10};
    try {
      var resp = await _myRepo.getActiveCaWithServiceApi(query: query);
      emit(GetActiveCaWithServiceSuccess(getActiveCaWithServicesModel: resp));
    } catch (e) {
      emit(TeamMemberError(errorMessage: e.toString()));
    }
  }
}

class GetDeginationBloc extends Bloc<TeamMemberEvent, TeamMemberState> {
  final _myRepo = TeamRepository();
  GetDeginationBloc() : super(TeamMemberInitial()) {
    on<GetDeginationEvent>(_getDeginationList);
  }
  Future<void> _getDeginationList(
      GetDeginationEvent event, Emitter<TeamMemberState> emit) async {
    try {
      var resp = await _myRepo.getDeginationList();
      emit(GetDeginationListSuccess(deginationList: resp));
    } catch (e) {
      emit(TeamMemberError(errorMessage: e.toString()));
    }
  }
}

class GetPermissionBloc extends Bloc<TeamMemberEvent, TeamMemberState> {
  final _myRepo = TeamRepository();

  GetPermissionBloc() : super(TeamMemberInitial()) {
    on<GetPermissionEvent>(_getPermissionApi);
  }
  Future<void> _getPermissionApi(
      GetPermissionEvent event, Emitter<TeamMemberState> emit) async {
    Map<String, dynamic> query = {"type": "SUBCA"};
    try {
      emit(TeamMemberLoading());
      var resp = await _myRepo.getPermissionList(query: query);
      emit(GetPermissionListSuccess(getPermissionList: resp.data));
    } catch (e) {
      emit(TeamMemberError(errorMessage: e.toString()));
    }
  }
}
