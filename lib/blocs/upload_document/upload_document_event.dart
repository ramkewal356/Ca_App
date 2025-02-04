part of 'upload_document_bloc.dart';

sealed class UploadDocumentEvent extends Equatable {
  const UploadDocumentEvent();

  @override
  List<Object> get props => [];
}

class InitializePageEvent extends UploadDocumentEvent {}

class PickDocumentEvent extends UploadDocumentEvent {}

class RemoveDocumentEvent extends UploadDocumentEvent {
  final int index;

  const RemoveDocumentEvent({
    required this.index,
  });
  @override
  List<Object> get props => [index];
}

class ResetDocumentEvent extends UploadDocumentEvent {}
