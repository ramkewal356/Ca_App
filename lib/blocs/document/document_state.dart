part of 'document_bloc.dart';

sealed class DocumentState extends Equatable {
  const DocumentState();

  @override
  List<Object> get props => [];
}

final class DocumentInitial extends DocumentState {}

final class DocumentDownloading extends DocumentState {
  final String docName;

  const DocumentDownloading({required this.docName});
  @override
  List<Object> get props => [docName];
}

final class DocumentLoading extends DocumentState {}

class RecentDocumentSuccess extends DocumentState {
  final List<DocContent>? recentDocumnets;
  final bool isLastPage;
  const RecentDocumentSuccess(
      {required this.recentDocumnets, required this.isLastPage});
  @override
  List<Object> get props => [recentDocumnets ?? [], isLastPage];
}

class ViewDocumentSuccess extends DocumentState {
  final List<ViewDocument>? viewDocumnets;
  final bool isLastPage;
  final int totalDocument;
  const ViewDocumentSuccess(
      {required this.viewDocumnets,
      required this.isLastPage,
      required this.totalDocument});
  @override
  List<Object> get props => [viewDocumnets ?? [], isLastPage, totalDocument];
}

class DownloadDocumentSuccess extends DocumentState {}

class DownloadDocumentFileSuccess extends DocumentState {
  final String docName;

  const DownloadDocumentFileSuccess({required this.docName});
  @override
  List<Object> get props => [docName];
}

final class DocumentError extends DocumentState {
  final String errorMessage;

  const DocumentError({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
