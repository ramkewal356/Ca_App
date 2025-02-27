import 'package:bloc/bloc.dart';
import 'package:ca_app/data/local_storage/shared_prefs_class.dart';
import 'package:ca_app/data/models/recent_document_model.dart';
import 'package:ca_app/data/repositories/document_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'document_event.dart';
part 'document_state.dart';

class DocumentBloc extends Bloc<DocumentEvent, DocumentState> {
  int pageNumber = 0;
  final int pageSize = 4;
  bool isFetching = false;
  // bool isLastPage = false;
  final _myRepo = DocumentRepository();
  DocumentBloc() : super(DocumentInitial()) {
    on<GetRecentDocumentEvent>(_getRecentDocumentApi);
  }
  Future<void> _getRecentDocumentApi(
      GetRecentDocumentEvent event, Emitter<DocumentState> emit) async {
    if (isFetching) return;

    int? userId = await SharedPrefsClass().getUserId();
    debugPrint('userId.,.,.,.,.,.,., $userId');
    Map<String, dynamic> query = {
      "caId": userId,
      "pageNumber": pageNumber,
      "pageSize": pageSize,
    };
    try {
      isFetching = true;
      if (!event.isPagination) {
        pageNumber = 0;
        emit(DocumentLoading()); // Show loading only for the first page
      }
      List<Content>? allData = [];
      if (state is RecentDocumentSuccess && !event.isPagination) {
        allData = (state as RecentDocumentSuccess).recentDocumnets;
      }

      var resp = await _myRepo.getRecentDocumentByCustomerIdApi(query: query);
      List<Content> newData = resp.data?.content ?? [];

      if (newData.isNotEmpty) {
        allData?.addAll(newData);
        pageNumber++;
      }

      bool isLastPage = newData.length < pageSize;
      emit(RecentDocumentSuccess(
          recentDocumnets: allData, isLastPage: isLastPage));
    } catch (e) {
      emit(DocumentError(errorMessage: e.toString()));
    } finally {
      isFetching = false;
    }
  }
}
