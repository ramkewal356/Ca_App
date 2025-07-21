import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'custom_dropdown_event.dart';
part 'custom_dropdown_state.dart';

class CustomDropdownBloc
    extends Bloc<CustomDropdownEvent, CustomDropdownState> {
  CustomDropdownBloc() : super(CustomDropdownInitial()) {
    on<DropdownSelectedEvent>((event, emit) {
      emit(CustomDropdownSelected(value: event.value));
    });
    on<DropdownResetEvent>((event, emit) {
      emit(CustomDropdownInitial()); // Reset the dropdown state
    });
  }
}
