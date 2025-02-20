import 'package:ca_app/blocs/custom_dropdown/custom_dropdown_bloc.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomDropdownButton extends StatelessWidget {
  final List<String> dropdownItems;
  final String? initialValue;
  final String hintText;

  final Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final Color? fillColor;
  const CustomDropdownButton(
      {super.key,
      required this.dropdownItems,
      required this.initialValue,
      required this.hintText,
      this.onChanged,
      this.validator,
      this.fillColor});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomDropdownBloc, CustomDropdownState>(
      listener: (context, state) {},
      builder: (context, state) {
        String? selectedValue = (state is CustomDropdownSelected &&
                dropdownItems.contains(state.value))
            ? state.value
            : initialValue;
        return FormField<String>(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            initialValue:
                dropdownItems.contains(selectedValue) ? selectedValue : null,
            validator: validator,
            builder: (FormFieldState<String> fieldState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButton2(
                    hint: Text(
                      hintText,
                      style: AppTextStyle().hintText,
                    ),
                    value: selectedValue,
                    // disabledHint: Text('data'),
                    underline: SizedBox.shrink(),
                    items: dropdownItems.map((value) {
                      return DropdownMenuItem(value: value, child: Text(value));
                    }).toList(),
                    buttonStyleData: ButtonStyleData(
                      height: 55,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: ColorConstants.darkGray),
                        color: fillColor,
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
                      if (onChanged != null) {
                        onChanged!(value);
                      }
                      fieldState.didChange(value);
                    },
                  ),
                  if (fieldState.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 5, left: 15),
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
