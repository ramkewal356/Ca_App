part of 'reminder_bloc.dart';

sealed class ReminderEvent extends Equatable {
  const ReminderEvent();

  @override
  List<Object> get props => [];
}

class GetReminderEvent extends ReminderEvent {
  final String status;
  final String occurence;
  final bool isFilter;
  final bool isPagination;

  const GetReminderEvent(
      {required this.status,
      required this.occurence,
      required this.isFilter,
      required this.isPagination});
  @override
  List<Object> get props => [status, occurence, isFilter, isPagination];
}

class CreateReminderEvent extends ReminderEvent {
  final String title;
  final String description;
  final String occurence;
  final List<int> userIds;

  const CreateReminderEvent(
      {required this.title,
      required this.description,
      required this.occurence,
      required this.userIds});
  @override
  List<Object> get props => [title, description, occurence, userIds];
}

class GetViewReminderEvent extends ReminderEvent {
  final int reminderId;

  const GetViewReminderEvent({required this.reminderId});
  @override
  List<Object> get props => [reminderId];
}

class UpdateReminderEvent extends ReminderEvent {
  final String reminderId;
  final String title;
  final String description;
  final String occurence;
  final List<int> userIds;

  const UpdateReminderEvent(
      {required this.reminderId,
      required this.title,
      required this.description,
      required this.occurence,
      required this.userIds});
  @override
  List<Object> get props =>
      [reminderId, title, description, occurence, userIds];
}

class ActiveDeactiveReminderEvent extends ReminderEvent {
  final int reminderId;
  final bool isActivate;

  const ActiveDeactiveReminderEvent(
      {required this.reminderId, required this.isActivate});
  @override
  List<Object> get props => [reminderId, isActivate];
}
