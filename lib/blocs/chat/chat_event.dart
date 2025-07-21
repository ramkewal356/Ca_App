part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class GetChatHistoryEvent extends ChatEvent {
  final String senderId;
  final String receiverId;
  final bool isSearch;
  final String searchText;
  const GetChatHistoryEvent(
      {required this.senderId,
      required this.receiverId,
      required this.isSearch,
      required this.searchText});
  @override
  List<Object> get props => [senderId, receiverId, isSearch, searchText];
}

class GetAllChatHistoryEvent extends ChatEvent {
  final bool isSearch;
  final String searchText;
  final bool isPagination;

  const GetAllChatHistoryEvent(
      {required this.isSearch,
      required this.searchText,
      required this.isPagination});
  @override
  List<Object> get props => [isSearch, searchText, isPagination];
}

class UpdateChatListEvent extends ChatEvent {
  final List<AllChatData> updatedChatList;
  const UpdateChatListEvent(this.updatedChatList);
  @override
  List<Object> get props => [updatedChatList];
}

class UpdateChatHistoryEvent extends ChatEvent {
  final List<Messages> updatedMessage;

  const UpdateChatHistoryEvent({required this.updatedMessage});
  @override
  List<Object> get props => [updatedMessage];
}
