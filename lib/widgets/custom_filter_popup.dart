import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:flutter/material.dart';

class CustomFilterPopup extends StatefulWidget {
  // final String filterTitle;
  final Widget filterIcon;
  final List<String> filterItems;
  final Map<String, bool> selectedFilters;
  final ValueChanged<String> onFilterChanged;
  const CustomFilterPopup(
      {super.key,
      // required this.filterTitle,
      required this.filterIcon,
      required this.filterItems,
      required this.selectedFilters,
      required this.onFilterChanged});

  @override
  State<CustomFilterPopup> createState() => _CustomFilterPopupState();
}

class _CustomFilterPopupState extends State<CustomFilterPopup> {
  late Map<String, bool> selectedFilters;
  String _filterTitle = 'All';
  @override
  void initState() {
    super.initState();
    selectedFilters = Map.from(widget.selectedFilters);
  }

  void _updateSelection(String filter, bool? value, StateSetter setStatePopup) {
    if (filter == "All") {
      bool newValue = value ?? false;
      selectedFilters.updateAll((key, _) => newValue);
    } else if (filter == "Active") {
      selectedFilters["Active"] = value ?? false;
      selectedFilters["Inactive"] =
          false; // Unselect Inactive if Active is selected
    } else if (filter == "Inactive") {
      selectedFilters["Inactive"] = value ?? false;
      selectedFilters["Active"] =
          false; // Unselect Active if Inactive is selected
    }

    // If both "Active" and "Inactive" are selected, check "All"
    selectedFilters["All"] = selectedFilters["Active"] == true &&
        selectedFilters["Inactive"] == true;

    // If "All" is unchecked, uncheck Active & Inactive
    if (!selectedFilters["All"]!) {
      selectedFilters["All"] = false;
    }

    setStatePopup(() {}); // Updates Popup UI
    setState(() {}); // Updates main UI

    // Send the correct filter value to API
    _applyFilters();
    _updateFilterTitle();
  }

  void _updateFilterTitle() {
    if (selectedFilters["All"] == true) {
      _filterTitle = "All";
    } else if (selectedFilters["Active"] == true) {
      _filterTitle = "Active";
    } else if (selectedFilters["Inactive"] == true) {
      _filterTitle = "Inactive";
    } else {
      _filterTitle = "All"; // Default title
    }
  }

  void _applyFilters() {
    if (selectedFilters["All"] == true) {
      widget.onFilterChanged(""); // Pass empty string when all selected
    } else if (selectedFilters["Active"] == true) {
      widget.onFilterChanged("true"); // Active
    } else if (selectedFilters["Inactive"] == true) {
      widget.onFilterChanged("false"); // Inactive
    } else {
      widget.onFilterChanged(""); // Default empty if nothing selected
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
        position: PopupMenuPosition.under,
        color: ColorConstants.white,
        padding: EdgeInsets.symmetric(horizontal: 10),
        constraints: BoxConstraints(minWidth: 150, maxWidth: 150),
        offset: Offset(0, 0),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          decoration: BoxDecoration(
              border: Border.all(color: ColorConstants.darkGray),
              borderRadius: BorderRadius.circular(5)),
          child: Row(
            children: [
              Text(
                _filterTitle,
                style: AppTextStyle().cardValueText,
              ),
              SizedBox(width: 5),
              widget.filterIcon
            ],
          ),
        ),
        onSelected: (value) {},
        itemBuilder: (BuildContext context) {
          return <PopupMenuEntry<String>>[
            PopupMenuItem(
              padding: EdgeInsets.zero,
              enabled: false,
              child: StatefulBuilder(
                builder: (context, setStatePopup) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: widget.filterItems.map((filter) {
                      return _buildCheckListTile(
                        context,
                        filter,
                        selectedFilters[filter] ?? false,
                        (value) =>
                            _updateSelection(filter, value, setStatePopup),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ];
        });
  }

  Widget _buildCheckListTile(BuildContext context, String title, bool? value,
      void Function(bool?)? onChanged) {
    return CheckboxListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        activeColor: ColorConstants.buttonColor,
        controlAffinity: ListTileControlAffinity.leading,
        value: value,
        title: Text(
          title,
          style: AppTextStyle().lableText,
        ),
        onChanged: onChanged);
  }
}
