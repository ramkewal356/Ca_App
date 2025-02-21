part of 'team_member_bloc.dart';

sealed class TeamMemberEvent extends Equatable {
  const TeamMemberEvent();

  @override
  List<Object> get props => [];
}

class GetTeamMemberEvent extends TeamMemberEvent {
  final String searchText;
  final bool isPagination;
  final String filterText;
  final bool isFilter;
  final bool isSearch;
  const GetTeamMemberEvent(
      {required this.searchText,
      required this.filterText,
      required this.isPagination,
      required this.isFilter,
      required this.isSearch});
  @override
  List<Object> get props =>
      [searchText, filterText, isPagination, isFilter, isSearch];
}
