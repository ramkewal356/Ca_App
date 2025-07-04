import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ca_app/data/local_storage/shared_prefs_class.dart';
import 'package:ca_app/data/models/all_chat_history_model.dart';
import 'package:ca_app/data/models/chat_history_model.dart';
import 'package:ca_app/data/repositories/chat_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final _myRepo = ChatRepository();

  ChatBloc() : super(ChatInitial()) {
    on<GetChatHistoryEvent>(_getChatHistory);
  }

  Future<void> _getChatHistory(
      GetChatHistoryEvent event, Emitter<ChatState> emit) async {
    Map<String, dynamic> query = {
      "receiverId": event.receiverId,
      "senderId": event.senderId,
      "search": event.searchText
    };
    try {
      emit(Chatloading());
      var resp = await _myRepo.getChatHistoryApi(query: query);
      emit(ChatSuccess(chatData: resp));
    } catch (e) {
      emit(ChatError());
    }
  }
}

class ChatHistoryBloc extends Bloc<ChatEvent, ChatState> {
  int pageNumber = 0;
  int pageSize = 10;

  final int pageSize1 = 10;
  bool isFetching = false;
  bool isLastPage = false;

  final _myRepo = ChatRepository();
  ChatHistoryBloc() : super(ChatInitial()) {
    on<GetAllChatHistoryEvent>(_getAllchatHistoryApi);
    on<UpdateChatListEvent>((event, emit) async {
      int? userId = await SharedPrefsClass().getUserId();

      emit(ChatHistorySuccess(
        allChatData: event.updatedChatList,
        senderId: userId.toString(),
        isLastPage: true,
      ));
    });
  }

  Future<void> _getAllchatHistoryApi(
      GetAllChatHistoryEvent event, Emitter<ChatState> emit) async {
    if (isFetching) return;
    // bool isNewSearch = (event.isSearch);

    if (event.isSearch && !event.isPagination) {
      pageNumber = 0;
      isLastPage = false;
      emit(ChatHistoryloading()); // Show loading only for the first page
    }
    if (isLastPage) return;
    isFetching = true;
    int? userId = await SharedPrefsClass().getUserId();
    debugPrint('userId.,.,.,.,.,.,., $userId');
    Map<String, dynamic> query = {
      "caId": userId,
      "search": event.searchText,
    };
    try {
      var resp = await _myRepo.getAllChatHistoryApi(query: query);
      List<AllChatData> newData = resp.data ?? [];

      // 🔹 If search/filter changed, replace old data. Otherwise, append for pagination.
      List<AllChatData> allItems = (pageNumber == 0)
          ? newData
          : [
              ...(state is ChatHistorySuccess
                  ? (state as ChatHistorySuccess).allChatData
                  : []),
              ...newData
            ];

      // isLastPage = newData.length < pageSize;

      emit(ChatHistorySuccess(
          allChatData: allItems,
          senderId: userId.toString(),
          isLastPage: isLastPage));

      // pageNumber++;
    } catch (e) {
      emit(ChatError());
    } finally {
      isFetching = false;
    }
  }
}
