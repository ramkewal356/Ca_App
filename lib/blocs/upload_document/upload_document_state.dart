part of 'upload_document_bloc.dart';

sealed class UploadDocumentState extends Equatable {
  const UploadDocumentState();

  @override
  List<Object> get props => [];
}

class UploadDocumentInitial extends UploadDocumentState {}

class UploadDocumentLoaded extends UploadDocumentState {
  final List<PlatformFile> documents;

  const UploadDocumentLoaded({required this.documents});
  @override
  List<Object> get props => [documents];
}
class SingleDocumentUploaded extends UploadDocumentState {
  final PlatformFile documentfile;

  const SingleDocumentUploaded({required this.documentfile});
  @override
  List<Object> get props => [documentfile];
}

class UploadDocumentError extends UploadDocumentState {
  final String message;

  const UploadDocumentError({required this.message});
  @override
  List<Object> get props => [message];
}
