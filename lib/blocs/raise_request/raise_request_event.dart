part of 'raise_request_bloc.dart';

sealed class RaiseRequestEvent extends Equatable {
  const RaiseRequestEvent();

  @override
  List<Object> get props => [];
}

class SendRaiseRequestEvent extends RaiseRequestEvent {
  final String description;

  final List<int> receiverId;
  final List<MultipartFile> files;

  const SendRaiseRequestEvent(
      {required this.description,
      required this.receiverId,
      required this.files});
  @override
  List<Object> get props => [description, receiverId, files];
}

class GetYourRequestEvent extends RaiseRequestEvent {
  final bool isPagination;
  final bool isSearch;
  final String searchText;

  const GetYourRequestEvent(
      {required this.isPagination,
      required this.isSearch,
      required this.searchText});
  @override
  List<Object> get props => [isPagination, isSearch, searchText];
}

class GetRequestOfClientEvent extends RaiseRequestEvent {
  final bool isPagination;
  final bool isSearch;
  final String searchText;

  const GetRequestOfClientEvent(
      {required this.isPagination,
      required this.isSearch,
      required this.searchText});
  @override
  List<Object> get props => [isPagination, isSearch, searchText];
}

class GetRequestOfTeamEvent extends RaiseRequestEvent {
  final bool isPagination;
  final bool isSearch;
  final String searchText;

  const GetRequestOfTeamEvent(
      {required this.isPagination,
      required this.isSearch,
      required this.searchText});
  @override
  List<Object> get props => [isPagination, isSearch, searchText];
}

class GetRequestDetailsEvent extends RaiseRequestEvent {
  final int requestId;

  const GetRequestDetailsEvent({required this.requestId});
  @override
  List<Object> get props => [requestId];
}
class GetRequestByReceiverIdEvent extends RaiseRequestEvent {
  final bool isPagination;
  final bool isSearch;
  final String searchText;

  const GetRequestByReceiverIdEvent(
      {required this.isPagination,
      required this.isSearch,
      required this.searchText});
  @override
  List<Object> get props => [isPagination, isSearch, searchText];
}
