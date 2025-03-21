part of 'help_and_support_bloc.dart';

sealed class HelpAndSupportState extends Equatable {
  const HelpAndSupportState();

  @override
  List<Object> get props => [];
}

final class HelpAndSupportInitial extends HelpAndSupportState {}

class HelpAndSupportLoading extends HelpAndSupportState {}

class AddContactSuccess extends HelpAndSupportState {
  final AddContactModel addContactModel;

  const AddContactSuccess({required this.addContactModel});
  @override
  List<Object> get props => [addContactModel];
}

class GetContactByUserIdSuccess extends HelpAndSupportState {
  final List<ContactData> getContactByUserIdList;

  final bool isLastPage;

  const GetContactByUserIdSuccess(
      {required this.getContactByUserIdList, required this.isLastPage});
  @override
  List<Object> get props => [getContactByUserIdList, isLastPage];
}

class GetContactByContactIdLoading extends HelpAndSupportState {
  final int contactid;

  const GetContactByContactIdLoading({required this.contactid});
  @override
  List<Object> get props => [contactid];
}

class GetContactByContactIdSuccess extends HelpAndSupportState {
  final GetContactByContactIdModel getContactByContactIdModel;
  final int contactId;

  const GetContactByContactIdSuccess(
      {required this.getContactByContactIdModel, required this.contactId});
  @override
  List<Object> get props => [getContactByContactIdModel, contactId];
}

class HelpAndSupportError extends HelpAndSupportState {
  final String error;

  const HelpAndSupportError({required this.error});
  @override
  List<Object> get props => [error];
}
