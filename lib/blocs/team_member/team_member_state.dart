part of 'team_member_bloc.dart';

sealed class TeamMemberState extends Equatable {
  const TeamMemberState();

  @override
  List<Object> get props => [];
}

final class TeamMemberInitial extends TeamMemberState {}

final class TeamMemberLoading extends TeamMemberState {}

final class GetTeamMemberSuccess extends TeamMemberState {
  final List<Datum>? getTeamMemberModel;
  final bool isLastPage;
  const GetTeamMemberSuccess(
      {required this.getTeamMemberModel, required this.isLastPage});
  @override
  List<Object> get props => [getTeamMemberModel ?? [], isLastPage];
}

final class TeamMemberError extends TeamMemberState {
  final String errorMessage;

  const TeamMemberError({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
