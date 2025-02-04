import 'package:ca_app/blocs/multi_select_dropdown/multi_select_dropdown_bloc.dart';
import 'package:ca_app/blocs/multi_select_dropdown/multi_select_dropdown_event.dart';
import 'package:ca_app/blocs/multi_select_dropdown/multi_select_dropdown_state.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_simple_multiselect/flutter_simple_multiselect.dart';

class CustomMultiSelectDropdown extends StatefulWidget {
  final List<String> items;
  final String hintText;
  final FocusNode? focusNode;
  final String? Function(dynamic)? validator;
  const CustomMultiSelectDropdown(
      {super.key,
      required this.items,
      required this.hintText,
      this.focusNode,
      this.validator});

  @override
  State<CustomMultiSelectDropdown> createState() =>
      _CustomMultiSelectDropdownState();
}

class _CustomMultiSelectDropdownState extends State<CustomMultiSelectDropdown> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MultiSelectDropdownBloc, MultiSelectDropdownState>(
      listener: (context, state) {},
      builder: (context, state) {
        List<String> selectedItems = [];
        if (state is MultiSelectDropdownLoaded) {
          selectedItems = state.selectedItems;
        }
        return FlutterMultiselect(
          autofocus: false,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          enableBorderColor: ColorConstants.darkGray,
          focusedBorderColor: ColorConstants.darkGray,
          errorBorderColor: ColorConstants.darkGray,
          borderRadius: 5,
          borderSize: 1,
          resetTextOnSubmitted: true,
          debounceDuration: Duration(milliseconds: 200),
          minTextFieldWidth: 300,
          suggestionsBoxMaxHeight: 300,
          suggestionsBoxBackgroundColor: ColorConstants.white,
          length: selectedItems.length,
          focusNode: widget.focusNode,
          inputDecoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: AppTextStyle().hintText,
              errorText: null,
              error: null,
              contentPadding: EdgeInsets.symmetric(horizontal: 10)),
          tagBuilder: (context, index) => Chip(
            backgroundColor: ColorConstants.buttonColor,
            label: Text(
              selectedItems[index],
              style: AppTextStyle().checkboxTitle,
            ),
            deleteIcon: Icon(
              Icons.close,
              color: ColorConstants.white,
            ),
            onDeleted: () {
              context
                  .read<MultiSelectDropdownBloc>()
                  .add(RemoveSelection(index: index));
            },
          ),
          suggestionBuilder: (context, state, data) {
            return BlocBuilder<MultiSelectDropdownBloc,
                MultiSelectDropdownState>(builder: (context, state) {
              bool isSelected = false;
              if (state is MultiSelectDropdownLoaded) {
                isSelected = state.selectedItems.contains(data);
              }
              return CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                value: isSelected,
                title: Text(data),
                onChanged: (value) {
                  context
                      .read<MultiSelectDropdownBloc>()
                      .add(ToggleSelection(data));
                },
              );
            });
          },
          findSuggestions: (String query) async {
            return widget.items
                .where(
                    (item) => item.toLowerCase().contains(query.toLowerCase()))
                .toList();
          },
          validator: null,
        );
      },
    );
  }
}
