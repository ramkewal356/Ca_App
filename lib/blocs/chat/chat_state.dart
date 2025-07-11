part of 'chat_bloc.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

final class ChatInitial extends ChatState {}

class Chatloading extends ChatState {}

class ChatHistoryloading extends ChatState {}

class ChatSuccess extends ChatState {
  final List<Messages> chatData;

  const ChatSuccess({required this.chatData});
  @override
  List<Object> get props => [chatData];
}

class ChatHistorySuccess extends ChatState {
  final String senderId;
  final List<AllChatData> allChatData;
  final bool isLastPage;

  const ChatHistorySuccess(
      {required this.allChatData,
      required this.senderId,
      required this.isLastPage});
  @override
  List<Object> get props => [allChatData, senderId, isLastPage];
}

class ChatError extends ChatState {}
