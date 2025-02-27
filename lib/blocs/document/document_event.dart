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
