import 'package:ca_app/blocs/multi_select_dropdown/multi_select_dropdown_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'multi_select_dropdown_event.dart';

class MultiSelectDropdownBloc
    extends Bloc<MultiSelectDropdownEvent, MultiSelectDropdownState> {
  MultiSelectDropdownBloc()
      : super(MultiSelectDropdownLoaded(selectedItems: [])) {
    on<ToggleSelection>((event, emit) {
      if (state is MultiSelectDropdownLoaded) {
        final currentState = state as MultiSelectDropdownLoaded;
        List<String> updatedSelection = List.from(currentState.selectedItems);

        if (updatedSelection.contains(event.item)) {
          updatedSelection.remove(event.item);
        } else {
          updatedSelection.add(event.item);
        }

        emit(MultiSelectDropdownLoaded(
            selectedItems:
                updatedSelection)); // ✅ Make sure the new state is emitted
      }
    });

    on<RemoveSelection>((event, emit) {
      if (state is MultiSelectDropdownLoaded) {
        final currentState = state as MultiSelectDropdownLoaded;
        final newList = List<String>.from(currentState.selectedItems);
        newList.removeAt(event.index);
        emit(MultiSelectDropdownLoaded(selectedItems: newList));
      }
    });
  }
}
