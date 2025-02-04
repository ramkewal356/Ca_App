import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class MultiSelectDropdownWidget extends StatefulWidget {
  final List<String> items;
  final String? Function(List<DropdownItem<String>>?)? validator;
  final String hintText;
  final Function(List<String>)? onSelectionChange;
  const MultiSelectDropdownWidget({
    super.key,
    required this.items,
    this.validator,
    required this.hintText,
    required this.onSelectionChange,
  });

  @override
  State<MultiSelectDropdownWidget> createState() =>
      _MultiSelectDropdownWidgetState();
}

class _MultiSelectDropdownWidgetState extends State<MultiSelectDropdownWidget> {
  List<String> selectedItems = [];
  TextEditingController searchController = TextEditingController();
  final MultiSelectController<String> controller = MultiSelectController();
  @override
  Widget build(BuildContext context) {
    return MultiDropdown<String>(
      items: widget.items.map((e) => DropdownItem(label: e, value: e)).toList(),
      controller: controller,
      enabled: true,
      searchEnabled: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      chipDecoration: ChipDecoration(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          borderRadius: BorderRadius.circular(5),
          labelStyle: AppTextStyle().checkboxTitle,
          deleteIcon: Icon(
            Icons.close_rounded,
            color: ColorConstants.white,
            size: 16,
          ),
          backgroundColor: ColorConstants.buttonColor),
      fieldDecoration: FieldDecoration(
        hintText: widget.hintText,
        hintStyle: AppTextStyle().hintText,
        showClearIcon: false,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        suffixIcon: Icon(
          Icons.keyboard_arrow_down_outlined,
          color: ColorConstants.darkGray,
        ),
        border: OutlineInputBorder(
            borderSide: BorderSide(
              color: ColorConstants.darkGray,
            ),
            borderRadius: BorderRadius.circular(8.0)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: ColorConstants.darkGray,
            // width: 2.0,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: ColorConstants.darkGray,
            // width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: ColorConstants.darkGray,
            // color: redColor,
            // width: 2.0,
          ),
        ),
      ),
      dropdownDecoration: const DropdownDecoration(
        marginTop: 2,
        maxHeight: 300,
      ),
      dropdownItemDecoration: DropdownItemDecoration(
        backgroundColor: ColorConstants.white,
        selectedBackgroundColor: ColorConstants.white,
        selectedIcon: Icon(Icons.check_box, color: ColorConstants.buttonColor),
        // disabledIcon: Icon(Icons.check_box, color: Colors.red),
      ),
      // selectedItemBuilder: (selectedItemsList) {
      //   return Wrap(
      //     spacing: 4.0,
      //     runSpacing: 4.0,
      //     children: selectedItems.map((selectedItem) {
      //       return Chip(
      //         backgroundColor: Colors.blueAccent,
      //         label: Text(
      //           selectedItem,
      //           style: TextStyle(color: Colors.white),
      //         ),
      //         deleteIcon: Icon(Icons.close, color: Colors.white),
      //         onDeleted: () {
      //           setState(() {
      //             selectedItems.remove(selectedItem);
      //             controller.unselectWhere((e) => e.value == selectedItem);
      //           });
      //         },
      //       );
      //     }).toList(),
      //   );
      // },
      itemBuilder: (item, index, onTap) {
        bool isSelected = selectedItems.contains(item.value);
        return StatefulBuilder(
          builder: (context, setStateSB) {
            return CheckboxListTile(
              dense: true,
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.only(left: 10),
              visualDensity: VisualDensity(horizontal: -4, vertical: -2),
              activeColor: ColorConstants.buttonColor,
              title: Text(
                item.label,
                style: AppTextStyle().listTileText,
              ),
              value: isSelected,
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    if (!selectedItems.contains(item.value)) {
                      selectedItems.add(item.value);
                      controller.selectWhere((e) => e.value == item.value);
                    }
                  } else {
                    selectedItems.remove(item.value);
                    controller.unselectWhere((e) => e.value == item.value);
                  }
                });
                setStateSB(() {}); // Update checkbox state
                // debugPrint('Selected items: $selectedItems');
              },
            );
          },
        );
      },
      validator: widget.validator,
      onSelectionChange: (selectedItemsList) {
        setState(() {
          selectedItems = selectedItemsList;
        });
        if (widget.onSelectionChange != null) {
          widget.onSelectionChange!(selectedItemsList);
        }
        debugPrint("OnSelectionChange: $selectedItems");
      },
    );
  }
}
