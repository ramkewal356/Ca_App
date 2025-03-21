part of 'help_and_support_bloc.dart';

sealed class HelpAndSupportEvent extends Equatable {
  const HelpAndSupportEvent();

  @override
  List<Object> get props => [];
}

class AddContactEvent extends HelpAndSupportEvent {
  final String email;
  final String subject;
  final String message;
  final bool isAuthorize;

  const AddContactEvent(
      {required this.email,
      required this.subject,
      required this.message,
      required this.isAuthorize});
  @override
  List<Object> get props => [email, subject, message, isAuthorize];
}

class GetContactByUserIdEvent extends HelpAndSupportEvent {
  final bool isPagination;

  const GetContactByUserIdEvent({required this.isPagination});
  @override
  List<Object> get props => [isPagination];
}

class GetContactByContactIdEvent extends HelpAndSupportEvent {
  final int contactId;

  const GetContactByContactIdEvent({required this.contactId});
  @override
  List<Object> get props => [contactId];
}
