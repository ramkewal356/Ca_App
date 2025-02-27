part of 'document_bloc.dart';

sealed class DocumentState extends Equatable {
  const DocumentState();

  @override
  List<Object> get props => [];
}

final class DocumentInitial extends DocumentState {}

final class DocumentLoading extends DocumentState {}

class RecentDocumentSuccess extends DocumentState {
  final List<Content>? recentDocumnets;
  final bool isLastPage;
  const RecentDocumentSuccess(
      {required this.recentDocumnets, required this.isLastPage});
  @override
  List<Object> get props => [recentDocumnets ?? [], isLastPage];
}

final class DocumentError extends DocumentState {
  final String errorMessage;

  const DocumentError({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
