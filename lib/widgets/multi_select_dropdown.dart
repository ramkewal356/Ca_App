import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class MultiSelectDropdown<T extends Object> extends StatelessWidget {
  final List<DropdownItem<T>> items;
  final MultiSelectController<T> controller;
  final String hintText;
  final bool enabled;
  final bool searchEnabled;
  final String? Function(List<DropdownItem<T>>?)? validator;
  final void Function(List<T>)? onSelectionChange;
  const MultiSelectDropdown({
    super.key,
    required this.items,
    required this.controller,
    required this.hintText,
    this.enabled = true,
    this.searchEnabled = true,
    this.validator,
    this.onSelectionChange,
  });

  @override
  Widget build(BuildContext context) {
    return MultiDropdown<T>(
        items: items,
        controller: controller,
        enabled: enabled,
        searchEnabled: searchEnabled,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        chipDecoration: ChipDecoration(
            backgroundColor: ColorConstants.buttonColor,
            wrap: true,
            runSpacing: 4,
            spacing: 10,
            deleteIcon: Icon(
              Icons.close,
              color: ColorConstants.white,
              size: 16,
            ),
            labelStyle: AppTextStyle().enquiryButton),
        fieldDecoration: FieldDecoration(
          hintText: hintText,
          hintStyle: AppTextStyle().hintText,
          showClearIcon: false,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.black87,
            ),
          ),
        ),
        dropdownDecoration: const DropdownDecoration(
            marginTop: 0,
            maxHeight: 300,
            borderRadius: BorderRadius.all(Radius.circular(10))
            // header: Padding(
            //   padding: EdgeInsets.all(8),
            //   child: Text(
            //     'Select countries from the list',
            //     textAlign: TextAlign.start,
            //     style: TextStyle(
            //       fontSize: 16,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
            ),
        dropdownItemDecoration: DropdownItemDecoration(
          selectedIcon: const Icon(Icons.check_box, color: Colors.green),
          disabledIcon: Icon(Icons.lock, color: Colors.grey.shade300),
        ),
        validator: validator,
        onSelectionChange: onSelectionChange);
  }
}
