import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';

part 'upload_document_event.dart';
part 'upload_document_state.dart';

class UploadDocumentBloc
    extends Bloc<UploadDocumentEvent, UploadDocumentState> {
  UploadDocumentBloc() : super(UploadDocumentInitial()) {
    on<InitializePageEvent>(_initializePage);

    on<PickDocumentEvent>(_pickDocument);
    on(_pickSingleImage);
    on<RemoveDocumentEvent>(_removeDocument);
    on<ResetDocumentEvent>(_resetDocument);
  }
  List<PlatformFile> _documents = [];

  Future<void> _initializePage(
      InitializePageEvent event, Emitter<UploadDocumentState> emit) async {
    // Ensure page has an entry in the map
    _documents = _documents;
    emit(UploadDocumentLoaded(documents: List.from(_documents)));
  }

  Future<void> _pickDocument(
      PickDocumentEvent event, Emitter<UploadDocumentState> emit) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
      );

      if (result != null) {
        _documents.addAll(result.files);
        emit(UploadDocumentLoaded(documents: List.from(_documents)));
      }
    } catch (e) {
      emit(UploadDocumentError(message: e.toString()));
    }
  }

  Future<void> _pickSingleImage(
      PickSingleImageEvent event, Emitter<UploadDocumentState> emit) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
      );

      if (result != null) {
        _documents.addAll(result.files);
        emit(UploadDocumentLoaded(documents: List.from(_documents)));
      }
    } catch (e) {
      emit(UploadDocumentError(message: e.toString()));
    }
  }

  Future<void> _removeDocument(
      RemoveDocumentEvent event, Emitter<UploadDocumentState> emit) async {
    _documents.removeAt(event.index);
    emit(UploadDocumentLoaded(documents: List.from(_documents)));
  }

  Future<void> _resetDocument(
      ResetDocumentEvent event, Emitter<UploadDocumentState> emit) async {
    _documents.clear();
    emit(UploadDocumentLoaded(documents: List.from(_documents)));
  }
}

// class UploadDocumentBloc
//     extends Bloc<UploadDocumentEvent, UploadDocumentState> {
//   final Map<String, List<PlatformFile>> _documentsByPage = {};
//   UploadDocumentBloc() : super(UploadDocumentInitial()) {
//     on<InitializePageEvent>(_initializePage);

//     on<PickDocumentEvent>(_pickDocument);
//     on<RemoveDocumentEvent>(_removeDocument);
//   }
//   final List<PlatformFile> _documents = [];

//   Future<void> _initializePage(
//       InitializePageEvent event, Emitter<UploadDocumentState> emit) async {
//     // Ensure page has an entry in the map
//     _documentsByPage[event.pageId] = _documentsByPage[event.pageId] ?? [];
//     emit(UploadDocumentLoaded(
//         documents: List.from(_documentsByPage[event.pageId]!)));
//   }

//   Future<void> _pickDocument(
//       PickDocumentEvent event, Emitter<UploadDocumentState> emit) async {
//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         allowMultiple: true,
//         type: FileType.custom,
//         allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
//       );

//       if (result != null) {
//         _documentsByPage[event.pageId]?.addAll(result.files);
//         emit(UploadDocumentLoaded(
//             documents: List.from(_documentsByPage[event.pageId]!)));
//       }
//     } catch (e) {
//       emit(UploadDocumentError(message: e.toString()));
//     }
//   }

//   Future<void> _removeDocument(
//       RemoveDocumentEvent event, Emitter<UploadDocumentState> emit) async {
//     _documentsByPage[event.pageId]?.removeAt(event.index);
//     emit(UploadDocumentLoaded(
//         documents: List.from(_documentsByPage[event.pageId]!)));
//   }
// }
