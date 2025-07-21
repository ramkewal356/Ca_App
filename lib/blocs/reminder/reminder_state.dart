part of 'reminder_bloc.dart';

sealed class ReminderState extends Equatable {
  const ReminderState();

  @override
  List<Object> get props => [];
}

final class ReminderInitial extends ReminderState {}

class ReminderLoading extends ReminderState {}

class GetReminderSuccess extends ReminderState {
  final List<Content> getRemindersData;
  final bool isLastPage;

  const GetReminderSuccess(
      {required this.getRemindersData, required this.isLastPage});
  @override
  List<Object> get props => [getRemindersData, isLastPage];
}

class CreateReminderSuccess extends ReminderState {
  final bool isSuccess;

  const CreateReminderSuccess({required this.isSuccess});
  @override
  List<Object> get props => [isSuccess];
}

class GetViewReminderSuccess extends ReminderState {
  final GetViewReminderByIdModel getViewReminderByIdData;

  const GetViewReminderSuccess({required this.getViewReminderByIdData});
  @override
  List<Object> get props => [getViewReminderByIdData];
}

class UpdateReminderSuccess extends ReminderState {
  final UpdateReminderModel updateReminder;

  const UpdateReminderSuccess({required this.updateReminder});
  @override
  List<Object> get props => [updateReminder];
}

class ReminderError extends ReminderState {
  final String errorMeassage;

  const ReminderError({required this.errorMeassage});
  @override
  List<Object> get props => [errorMeassage];
}

class ActiveDeactiveReminderSucess extends ReminderState {
  final CommonModel activeDeactiveReminder;

  const ActiveDeactiveReminderSucess({required this.activeDeactiveReminder});
  @override
  List<Object> get props => [activeDeactiveReminder];
}

class ActiveDeactiveReminderError extends ReminderState {}
