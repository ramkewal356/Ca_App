import 'package:bloc/bloc.dart';
import 'package:ca_app/data/local_storage/shared_prefs_class.dart';
import 'package:ca_app/data/models/get_view_document_by_userid_model.dart';
import 'package:ca_app/data/models/recent_document_model.dart';
import 'package:ca_app/data/repositories/document_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'document_event.dart';
part 'document_state.dart';

class DocumentBloc extends Bloc<DocumentEvent, DocumentState> {
  int pageNumber = 0;
  final int pageSize = 6;
  bool isFetching = false;
  bool isLastPage = false;
  int pageNumber1 = 0;
  final int pageSize1 = 6;
  bool isFetching1 = false;
  bool isLastPage1 = false;
  final _myRepo = DocumentRepository();
  DocumentBloc() : super(DocumentInitial()) {
    on<GetRecentDocumentEvent>(_getRecentDocumentApi);
    on<GetViewDocumentEvent>(_getViewDocumentApi);
    on<DownloadDocumentEvent>(_downloadDocument);
    on<DownloadDocumentFileEvent>(_downloadDocumentFile);
  }
  Future<void> _getRecentDocumentApi(
      GetRecentDocumentEvent event, Emitter<DocumentState> emit) async {
    if (isFetching) return;

    if (!event.isPagination) {
      pageNumber = 0;
      isLastPage = false;
      emit(DocumentLoading());

      /// Show loading only for the first page
    }

    if (isLastPage) return;
    isFetching = true;
    int? userId = await SharedPrefsClass().getUserId();
    debugPrint('userId.,.,.,.,.,.,., $userId');
    Map<String, dynamic> query = {
      "caId": userId,
      "pageNumber": pageNumber,
      "pageSize": pageSize,
    };
    try {
      var resp = await _myRepo.getRecentDocumentByCustomerIdApi(query: query);
      List<Content> newData = resp.data?.content ?? [];

      // 🔹 If search/filter changed, replace old data. Otherwise, append for pagination.
      List<Content> allItems = (pageNumber == 0)
          ? newData
          : [
              ...?(state is RecentDocumentSuccess
                  ? (state as RecentDocumentSuccess).recentDocumnets
                  : []),
              ...newData
            ];

      isLastPage = newData.length < pageSize;

      emit(RecentDocumentSuccess(
          recentDocumnets: allItems, isLastPage: isLastPage));

      pageNumber++;
    } catch (e) {
      emit(DocumentError(errorMessage: e.toString()));
    } finally {
      isFetching = false;
    }
  }

  Future<void> _getViewDocumentApi(
      GetViewDocumentEvent event, Emitter<DocumentState> emit) async {
    if (isFetching1) return;
    bool isNewSearch = (event.isSearch || event.isFilter);
    if (isNewSearch && !event.isPagination) {
      pageNumber1 = 0;
      isLastPage1 = false;
      emit(DocumentLoading());

      /// Show loading only for the first page
    }

    if (isLastPage1) return;
    isFetching1 = true;

    Map<String, dynamic> query = {
      "userId": event.userId,
      "search": event.searchText,
      "pageNumber": event.pageNumber ?? pageNumber1,
      "pageSize": event.pagesize ?? pageSize1,
      "filter": event.filterText
    };

    try {
      var resp = await _myRepo.getViewDocumentByUserIdApi(query: query);

      List<ViewDocument> newData = resp.data ?? [];

      // 🔹 If search/filter changed, replace old data. Otherwise, append for pagination.
      List<ViewDocument> allItems = (pageNumber1 == 0)
          ? newData
          : [
              ...?(state is ViewDocumentSuccess
                  ? (state as ViewDocumentSuccess).viewDocumnets
                  : []),
              ...newData
            ];

      isLastPage1 = newData.length < pageSize1;

      emit(ViewDocumentSuccess(
          viewDocumnets: allItems,
          isLastPage: isLastPage1,
          totalDocument: allItems.length));

      pageNumber1++;
    } catch (e) {
      emit(DocumentError(errorMessage: e.toString()));
    } finally {
      isFetching1 = false;
    }
  }

  Future<void> _downloadDocument(
      DownloadDocumentEvent event, Emitter<DocumentState> emit) async {
    try {
      emit(DocumentDownloading());
      await _myRepo.downloadFile(docUrl: event.docUrl, docName: event.docName);

      emit(DownloadDocumentSuccess());
      await Future.delayed(Duration(milliseconds: 500));
      emit(DocumentInitial());
    } catch (e) {
      emit(DocumentError(errorMessage: e.toString()));
    }
  }

  Future<void> _downloadDocumentFile(
      DownloadDocumentFileEvent event, Emitter<DocumentState> emit) async {
    try {
      emit(DocumentDownloading());
      await _myRepo.downloadDocumentFile(
          docUrl: event.docUrl, docName: event.docName);

      emit(DownloadDocumentFileSuccess());

      // emit(DocumentInitial());
    } catch (e) {
      // emit(DocumentInitial());
      emit(DocumentError(errorMessage: e.toString()));
    }
  }
}
