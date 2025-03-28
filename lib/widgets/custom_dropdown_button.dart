import 'package:ca_app/blocs/custom_dropdown/custom_dropdown_bloc.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/utils/constanst/validator.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomDropdownButton extends StatefulWidget {
  final List<String> dropdownItems;
  final String? initialValue;
  final String hintText;
  final bool initialStateSelected;
  final Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final Color? fillColor;
  const CustomDropdownButton(
      {super.key,
      required this.dropdownItems,
      required this.initialValue,
      required this.hintText,
      this.initialStateSelected = false,
      this.onChanged,
      this.validator,
      this.fillColor});

  @override
  State<CustomDropdownButton> createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomDropdownBloc, CustomDropdownState>(
      listener: (context, state) {},
      builder: (context, state) {
        List<String> uniqueDropdownItems =
            widget.dropdownItems.toSet().toList();
        String? selectedValue = (widget.initialStateSelected)
            ? ((state is CustomDropdownSelected &&
                uniqueDropdownItems.contains(state.value))
            ? state.value
                : (state is CustomDropdownInitial) // Reset state
                    ? null
                    : (widget.initialValue != null &&
                            uniqueDropdownItems.contains(widget.initialValue))
                        ? widget.initialValue
                        : null)
            : (state is CustomDropdownSelected &&
                    uniqueDropdownItems.contains(state.value))
                ? state.value
                : (widget.initialValue != null &&
                        uniqueDropdownItems.contains(widget.initialValue))
                    ? widget.initialValue
                : null;
        // String? selectedValue = (state is CustomDropdownSelected &&
        //         uniqueDropdownItems.contains(state.value))
        //     ? state.value
        //     : (widget.initialValue != null &&
        //             uniqueDropdownItems.contains(widget.initialValue))
        //         ? widget.initialValue
        //         : null;
        return FormField<String>(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            initialValue: uniqueDropdownItems.contains(selectedValue)
                ? selectedValue
                : null,
            validator: widget.validator,
            builder: (FormFieldState<String> fieldState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButton2(
                    hint: Text(
                      widget.hintText,
                      style: AppTextStyle().hintText,
                    ),
                    value: selectedValue,
                    // disabledHint: Text('data'),
                    underline: SizedBox.shrink(),
                    items: uniqueDropdownItems.map((value) {
                      return DropdownMenuItem(value: value, child: Text(value));
                    }).toList(),
                    buttonStyleData: ButtonStyleData(
                      height: 50,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: ColorConstants.darkGray),
                        color: widget.fillColor,
                      ),
                      elevation: 0,
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(
                        Icons.keyboard_arrow_down_outlined,
                      ),
                      iconSize: 24,
                      iconEnabledColor: Colors.black38,
                      iconDisabledColor: Colors.grey,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 200,
                      // width: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: ColorConstants.white,
                      ),
                      offset: const Offset(0, 0),
                      scrollbarTheme: ScrollbarThemeData(
                        radius: const Radius.circular(20),
                        thickness: WidgetStateProperty.all(6),
                        thumbColor:
                            WidgetStateProperty.all(ColorConstants.buttonColor),
                        thumbVisibility: WidgetStateProperty.all(true),
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 50,
                      overlayColor:
                          WidgetStatePropertyAll(ColorConstants.buttonColor),
                      padding: EdgeInsets.only(left: 14, right: 14),
                    ),
                    onChanged: (value) {
                      if (value != null) {
                        BlocProvider.of<CustomDropdownBloc>(context)
                            .add(DropdownSelectedEvent(value: value));
                      }
                      if (widget.onChanged != null) {
                        widget.onChanged!(value);
                      }
                      fieldState.didChange(value);
                    },
                  ),
                  if (fieldState.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 5, left: 10),
                      child: Text(
                        fieldState.errorText!,
                        style: TextStyle(
                          color: Colors.red[900],
                          fontSize: 13,
                        ),
                      ),
                    ),
                ],
              );
            });
      },
    );
  }
}
