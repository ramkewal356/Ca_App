part of 'team_member_bloc.dart';

sealed class TeamMemberState extends Equatable {
  const TeamMemberState();

  @override
  List<Object> get props => [];
}

final class TeamMemberInitial extends TeamMemberState {}

final class TeamMemberLoading extends TeamMemberState {}

final class GetTeamMemberSuccess extends TeamMemberState {
  final List<TeamContent>? getTeamMemberModel;
  final bool isLastPage;
  const GetTeamMemberSuccess(
      {required this.getTeamMemberModel, required this.isLastPage});
  @override
  List<Object> get props => [getTeamMemberModel ?? [], isLastPage];
}

final class GetVerifiedSubCaByCaIdSuccess extends TeamMemberState {
  final List<Datum> getTeamMemberModel;
  final String selectedSubCaName;
  const GetVerifiedSubCaByCaIdSuccess(
      {required this.getTeamMemberModel, required this.selectedSubCaName});
  @override
  List<Object> get props => [getTeamMemberModel, selectedSubCaName];
}

class GetSubCaListSuccess extends TeamMemberState {
  final List<Datum> getTeamMembers;

  const GetSubCaListSuccess({required this.getTeamMembers});
  @override
  List<Object> get props => [getTeamMembers];
}

class GetDeginationListSuccess extends TeamMemberState {
  final DeginationModel deginationList;

  const GetDeginationListSuccess({required this.deginationList});
  @override
  List<Object> get props => [deginationList];
}

class GetPermissionListSuccess extends TeamMemberState {
  final List<PermissionData> getPermissionList;

  const GetPermissionListSuccess({required this.getPermissionList});
  @override
  List<Object> get props => [getPermissionList];
}

final class TeamMemberError extends TeamMemberState {
  final String errorMessage;

  const TeamMemberError({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
