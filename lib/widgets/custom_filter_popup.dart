import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:flutter/material.dart';

class CustomFilterPopup extends StatefulWidget {
  final String filterTitle;
  final Widget filterIcon;
  final List<String> filterItems;
  final Map<String, bool> selectedFilters;
  final ValueChanged<Map<String, bool>> onFilterChanged;
  const CustomFilterPopup(
      {super.key,
      required this.filterTitle,
      required this.filterIcon,
      required this.filterItems,
      required this.selectedFilters,
      required this.onFilterChanged});

  @override
  State<CustomFilterPopup> createState() => _CustomFilterPopupState();
}

class _CustomFilterPopupState extends State<CustomFilterPopup> {
  late Map<String, bool> selectedFilters;

  @override
  void initState() {
    super.initState();
    selectedFilters = Map.from(widget.selectedFilters);
  }

  void _updateSelection(String filter, bool? value, StateSetter setStatePopup) {
    if (filter == "All") {
      bool newValue = value ?? false;
      selectedFilters.updateAll((key, _) => newValue);
    } else {
      selectedFilters[filter] = value ?? false;
      selectedFilters["All"] = selectedFilters.values.every((v) => v);
    }

    setStatePopup(() {}); // Updates Popup UI
    setState(() {}); // Updates main UI
    widget.onFilterChanged(selectedFilters); // Notify parent
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
              border: Border.all(), borderRadius: BorderRadius.circular(5)),
          child: Row(
            children: [
              Text(
                widget.filterTitle,
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
