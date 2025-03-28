part of 'custom_dropdown_bloc.dart';

sealed class CustomDropdownEvent extends Equatable {
  const CustomDropdownEvent();

  @override
  List<Object> get props => [];
}

class DropdownSelectedEvent extends CustomDropdownEvent {
  final String value;

  const DropdownSelectedEvent({required this.value});
  @override
  List<Object> get props => [value];
}
class DropdownResetEvent extends CustomDropdownEvent {}
