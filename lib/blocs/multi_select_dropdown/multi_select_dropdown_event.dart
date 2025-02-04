import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// EVENTS
abstract class MultiSelectDropdownEvent extends Equatable {
  const MultiSelectDropdownEvent();
  @override
  List<Object> get props => [];
}

// Toggle Selection Event
class ToggleSelection extends MultiSelectDropdownEvent {
  final String item;
  const ToggleSelection(this.item);

  @override
  List<Object> get props => [item];
}

// Confirm Selection Event
class RemoveSelection extends MultiSelectDropdownEvent {
  final int index;

  const RemoveSelection({required this.index});
  @override
  //
  List<Object> get props => [index];
}
