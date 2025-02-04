import 'package:equatable/equatable.dart';

abstract class MultiSelectDropdownState extends Equatable {
  const MultiSelectDropdownState();
  @override
  List<Object> get props => [];
}

class MultiSelectDropdownInitial extends MultiSelectDropdownState {}

class MultiSelectDropdownLoaded extends MultiSelectDropdownState {
  final List<String> selectedItems;
  const MultiSelectDropdownLoaded({required this.selectedItems});

  @override
  List<Object> get props => [selectedItems];
}
