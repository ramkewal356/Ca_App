part of 'raise_request_bloc.dart';

sealed class RaiseRequestState extends Equatable {
  const RaiseRequestState();

  @override
  List<Object> get props => [];
}

final class RaiseRequestInitial extends RaiseRequestState {}

class RaiseRequestLoading extends RaiseRequestState {}

class GetRequestDetailsLoading extends RaiseRequestState {
  final int requsetId;

  const GetRequestDetailsLoading({required this.requsetId});
  @override
  List<Object> get props => [requsetId];
}

class SendRaiseRequestSuccess extends RaiseRequestState {}

class GetYourRequestListSuccess extends RaiseRequestState {
  final List<RequestData> requestData;
  final bool isLastPage;

  const GetYourRequestListSuccess(
      {required this.requestData, required this.isLastPage});
  @override
  List<Object> get props => [requestData, isLastPage];
}

class GetRequestByRecieverIdSuccess extends RaiseRequestState {
  final List<GetRequestData> requestData;
  final bool isLastPage;

  const GetRequestByRecieverIdSuccess(
      {required this.requestData, required this.isLastPage});
  @override
  List<Object> get props => [requestData, isLastPage];
}

// class GetRequestOfTeamSuccess extends RaiseRequestState {
//   final List<RequestData> requestData;
//   final bool isLastPage;

//   const GetRequestOfTeamSuccess(
//       {required this.requestData, required this.isLastPage});
//   @override
//   List<Object> get props => [requestData, isLastPage];
// }

class GetRequestDetailsSuccess extends RaiseRequestState {
  final GetDocumentByRequestIdModel getDocumentByRequestIdData;

  const GetRequestDetailsSuccess({required this.getDocumentByRequestIdData});
  @override
  List<Object> get props => [getDocumentByRequestIdData];
}

class UnReadToReadStatusSuccess extends RaiseRequestState {
  final CommonModel changeStatus;

  const UnReadToReadStatusSuccess({required this.changeStatus});
  @override
  List<Object> get props => [changeStatus];
}



class RaiseRequestError extends RaiseRequestState {
  final String errorMessage;

  const RaiseRequestError({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
