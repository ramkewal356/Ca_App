part of 'document_bloc.dart';

sealed class DocumentEvent extends Equatable {
  const DocumentEvent();

  @override
  List<Object> get props => [];
}

class GetRecentDocumentEvent extends DocumentEvent {
  final bool isPagination;

  const GetRecentDocumentEvent({required this.isPagination});
  @override
  List<Object> get props => [isPagination];
}

class GetViewDocumentEvent extends DocumentEvent {
  final String userId;
  final String searchText;
  final bool isPagination;
  final String filterText;
  final bool isFilter;
  final bool isSearch;
  final int? pageNumber;
  final int? pagesize;
  const GetViewDocumentEvent(
      {required this.userId,
      required this.searchText,
      required this.filterText,
      required this.isPagination,
      required this.isFilter,
      required this.isSearch,
      this.pageNumber,
      this.pagesize});
  @override
  List<Object> get props => [
        userId,
        searchText,
        filterText,
        isPagination,
        isFilter,
        isSearch,
        pageNumber ?? 0,
        pagesize ?? 0
      ];
}
