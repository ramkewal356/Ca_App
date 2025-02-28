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
  final int? pageNumber;
  final int? pagesize;
  const GetTeamMemberEvent(
      {required this.searchText,
      required this.filterText,
      required this.isPagination,
      required this.isFilter,
      required this.isSearch,
      this.pageNumber,
      this.pagesize});
  @override
  List<Object> get props =>
      [
        searchText,
        filterText,
        isPagination,
        isFilter,
        isSearch,
        pageNumber ?? 0,
        pagesize ?? 0
      ];
}
