part of 'raise_request_bloc.dart';

sealed class RaiseRequestEvent extends Equatable {
  const RaiseRequestEvent();

  @override
  List<Object> get props => [];
}

class SendRaiseRequestEvent extends RaiseRequestEvent {
  final String description;

  final String receiverId;
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
  final bool isFilter;
  final String filterText;
  const GetYourRequestEvent(
      {required this.isPagination,
      required this.isSearch,
      required this.searchText,
      required this.isFilter,
      required this.filterText});
  @override
  List<Object> get props =>
      [isPagination, isSearch, searchText, filterText, isFilter];
}

class GetRequestOfClientEvent extends RaiseRequestEvent {
  final bool isPagination;
  final bool isSearch;
  final String searchText;
final bool isFilter;
  final String filterText;
  const GetRequestOfClientEvent(
      {required this.isPagination,
      required this.isSearch,
      required this.searchText,
      required this.isFilter,
      required this.filterText});
  @override
  List<Object> get props =>
      [isPagination, isSearch, searchText, isFilter, filterText];
}

class GetRequestOfTeamEvent extends RaiseRequestEvent {
  final bool isPagination;
  final bool isSearch;
  final String searchText;
final bool isFilter;
  final String filterText;
  const GetRequestOfTeamEvent(
      {required this.isPagination,
      required this.isSearch,
      required this.searchText,
      required this.isFilter,
      required this.filterText});
  @override
  List<Object> get props =>
      [isPagination, isSearch, searchText, isFilter, filterText];
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
final bool isFilter;
  final String filterText;
  const GetRequestByReceiverIdEvent(
      {required this.isPagination,
      required this.isSearch,
      required this.searchText,
      required this.isFilter,
      required this.filterText});
  @override
  List<Object> get props =>
      [isPagination, isSearch, searchText, isFilter, filterText];
}

class UnreadToReadStatusEvent extends RaiseRequestEvent {
  final int requestId;

  const UnreadToReadStatusEvent({required this.requestId});
  @override
  List<Object> get props => [requestId];
}
