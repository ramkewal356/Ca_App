part of 'custom_dropdown_bloc.dart';

abstract class CustomDropdownState extends Equatable {
  const CustomDropdownState();

  @override
  List<Object> get props => [];
}

final class CustomDropdownInitial extends CustomDropdownState {}

class CustomDropdownSelected extends CustomDropdownState {
  final String value;

  const CustomDropdownSelected({required this.value});
  @override
  List<Object> get props => [value];
}
