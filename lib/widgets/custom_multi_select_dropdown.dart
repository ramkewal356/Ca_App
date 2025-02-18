import 'package:ca_app/blocs/multi_select_dropdown/multi_select_dropdown_bloc.dart';
import 'package:ca_app/blocs/multi_select_dropdown/multi_select_dropdown_event.dart';
import 'package:ca_app/blocs/multi_select_dropdown/multi_select_dropdown_state.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/custom_search_field.dart';
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

class MultiSelectSearchableDropdown extends FormField<List<String>> {
  // ignore: use_super_parameters
  MultiSelectSearchableDropdown({
    Key? key,
    required String hintText,
    required List<String> items,
    required List<String> selectedItems,
    required Function(List<String>) onChanged,
    FormFieldValidator<List<String>>? validator,
  }) : super(
          key: key,
          initialValue: selectedItems,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          builder: (FormFieldState<List<String>> state) {
            return CustomDropdownSerchable(
              hintText: hintText,
              items: items,
              selectedItems: selectedItems,
              onChanged: (value) {
                state.didChange(value);
                onChanged(value);
              },
              errorText: state.errorText,
            );
          },
        );
}

class CustomDropdownSerchable extends StatefulWidget {
  final String hintText;
  final List<String> items;
  final List<String> selectedItems;
  final Function(List<String>) onChanged;
  final String? errorText;
  const CustomDropdownSerchable({
    super.key,
    required this.hintText,
    required this.items,
    required this.selectedItems,
    required this.onChanged,
    this.errorText,
  });

  @override
  State<CustomDropdownSerchable> createState() =>
      _CustomDropdownSerchableState();
}

class _CustomDropdownSerchableState extends State<CustomDropdownSerchable> {
  final GlobalKey _buttonKey = GlobalKey();
  final TextEditingController _searchController = TextEditingController();
  OverlayEntry? _overlayEntry;
  List<String> filterList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    filterList = widget.items;
  }

  void _showPopupMenu(BuildContext context) {
    _overlayEntry?.remove(); // Remove old menu before creating a new one

    final RenderBox renderBox =
        _buttonKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final double buttonHeight = renderBox.size.height; // Get dynamic height

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () => _hidePopupMenu(),
              behavior: HitTestBehavior.translucent,
            ),
          ),
          Positioned(
            left: offset.dx,
            top: offset.dy + buttonHeight + 5, // Adjust dynamically
            width: renderBox.size.width,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(8),
              child: StatefulBuilder(
                builder: (context, setStatePopup) {
                  return Container(
                    height: 300,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomSearchField(
                          controller: _searchController,
                          serchHintText: 'search',
                          onChanged: (value) async {
                            setStatePopup(() {
                              filterList = widget.items
                                  .where((item) => item
                                      .toLowerCase()
                                      .contains(value.toLowerCase()))
                                  .toList();
                            });
                          },
                        ),
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: filterList.length,
                            itemBuilder: (context, index) {
                              bool isSelected = widget.selectedItems
                                  .contains(filterList[index]);
                              return CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                activeColor: ColorConstants.buttonColor,
                                title: Text(filterList[index]),
                                value: isSelected,
                                onChanged: (value) {
                                  setState(() {
                                    if (value == true) {
                                      widget.selectedItems
                                          .add(filterList[index]);
                                    } else {
                                      widget.selectedItems
                                          .remove(filterList[index]);
                                    }
                                    _updatePopupMenu(); // Refresh dropdown position
                                    widget.onChanged(widget.selectedItems);
                                  });
                                  setStatePopup(() {});
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hidePopupMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _updatePopupMenu() {
    _hidePopupMenu();
    Future.delayed(Duration(milliseconds: 20), () {
      _showPopupMenu(context);
    });
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          key: _buttonKey,
          onTap: () => _showPopupMenu(context),
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: widget.selectedItems.isNotEmpty ? 5 : 12),
            decoration: BoxDecoration(
                border: Border.all(color: ColorConstants.darkGray),
                borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.selectedItems.isNotEmpty
                        ? Expanded(
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 2,
                              children:
                                  widget.selectedItems.map((selectedItem) {
                                return Chip(
                                  backgroundColor: ColorConstants.buttonColor,
                                  label: Text(
                                    selectedItem,
                                    style: AppTextStyle().checkboxTitle,
                                  ),
                                  deleteIcon: Icon(
                                    Icons.close,
                                    color: ColorConstants.white,
                                  ),
                                  onDeleted: () {
                                    setState(() {
                                      widget.selectedItems.remove(selectedItem);
                                      // _updatePopupMenu();
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          )
                        : Text(
                            widget.hintText,
                            style: AppTextStyle().hintText,
                          ),
                    Icon(
                      Icons.keyboard_arrow_down_outlined,
                      color: ColorConstants.darkGray,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 10),
            child: Text(
              widget.errorText!,
              style: TextStyle(color: Colors.red[900], fontSize: 13),
            ),
          ),
      ],
    );
  }
}
  // List<String> items = [
  //   'vinay',
  //   'mohan',
  //   'aman',
  //   'vishal',
  //   'varun',
  //   'ram',
  //   'ramkewal'
  // ];
  // List<String> selectedItems = [];
  // bool isVisible = false;
  // FocusNode _focusNode = FocusNode();
  // final GlobalKey dropdownKey = GlobalKey();
  // // @override
  // // void initState() {
  // //   super.initState();
  // //   _focusNode.addListener(() {
  // //     print('cmnbcnmbcmnxbcmnbcmn');
  // //     if (!_focusNode.hasFocus) {
  // //       setState(() {
  // //         isVisible = false; // Close dropdown when focus is lost
  // //       });
  // //     }
  // //   });
  // // }

  // // @override
  // // void dispose() {
  // //   _focusNode.dispose();

  // //   super.dispose();
  // // }
  // OverlayEntry? _overlayEntry;
  // GlobalKey _dropdownKey = GlobalKey();

  // @override
  // void dispose() {
  //   _overlayEntry?.remove();
  //   super.dispose();
  // }

  // void _toggleDropdown() {
  //   if (isVisible) {
  //     _hideDropdown();
  //   } else {
  //     _showDropdown();
  //   }
  // }

  // void _showDropdown() {
  //   _overlayEntry = _createOverlayEntry();
  //   Overlay.of(context).insert(_overlayEntry!);
  //   setState(() {
  //     isVisible = true;
  //   });
  // }

  // void _hideDropdown() {
  //   _overlayEntry?.remove();
  //   setState(() {
  //     isVisible = false;
  //   });
  // }

  // void _updateDropdown() {
  //   // if (isVisible) {
  //   //   _overlayEntry?.remove();
  //   //   _overlayEntry = _createOverlayEntry();
  //   //   Overlay.of(context).insert(_overlayEntry!);
  //   // }
  //   _hideDropdown();
  //   Future.delayed(Duration(milliseconds: 20), () {
  //     _showDropdown();
  //   });
  // }

  // OverlayEntry _createOverlayEntry() {
  //   RenderBox renderBox =
  //       _dropdownKey.currentContext!.findRenderObject() as RenderBox;
  //   var offset = renderBox.localToGlobal(Offset.zero);
  //   var dropdownWidth = renderBox.size.width;

  //   /// 🔥 **Dynamic Top Position**
  //   double dropdownTop = offset.dy + renderBox.size.height;

  //   return OverlayEntry(
  //     builder: (context) => Stack(
  //       children: [
  //         // Tap outside to close dropdown
  //         Positioned.fill(
  //           child: GestureDetector(
  //             onTap: _hideDropdown,
  //             behavior: HitTestBehavior.translucent,
  //           ),
  //         ),
  //         Positioned(
  //           left: offset.dx,
  //           top: dropdownTop,
  //           width: dropdownWidth,
  //           child: Material(
  //               elevation: 4,
  //               borderRadius: BorderRadius.circular(8),
  //               child: StatefulBuilder(
  //                 builder: (context, setStateSB) {
  //                   return Container(
  //                     height: 250,
  //                     decoration: BoxDecoration(
  //                       color: Colors.white,
  //                       borderRadius: BorderRadius.circular(8),
  //                       border: Border.all(color: Colors.grey),
  //                     ),
  //                     child: ListView.builder(
  //                       itemCount: items.length,
  //                       itemBuilder: (context, index) {
  //                         bool isSelected =
  //                             selectedItems.contains(items[index]);
  //                         return CheckboxListTile(
  //                           value: isSelected,
  //                           title: Text(items[index]),
  //                           onChanged: (value) {
  //                             setState(() {
  //                               if (value == true) {
  //                                 selectedItems.add(items[index]);
  //                               } else {
  //                                 selectedItems.remove(items[index]);
  //                               }
  //                               _updateDropdown();
  //                             });
  //                             setStateSB(() {});
  //                             // _hideDropdown(); // Close dropdown after selection
  //                           },
  //                         );
  //                       },
  //                     ),
  //                   );
  //                 },
  //               )),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return GestureDetector(
  //     key: _buttonKey,
  //     onTap: () => _showPopupMenu(context),
  //     child: Container(
  //       padding: EdgeInsets.symmetric(
  //           horizontal: 10, vertical: selectedItems.isNotEmpty ? 5 : 15),
  //       decoration: BoxDecoration(
  //           border: Border.all(), borderRadius: BorderRadius.circular(8)),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               selectedItems.isNotEmpty
  //                   ? Expanded(
  //                       child: Wrap(
  //                         spacing: 8,
  //                         runSpacing: 2,
  //                         children: selectedItems.map((selectedItem) {
  //                           return Chip(
  //                             label: Text(selectedItem),
  //                             deleteIcon: Icon(Icons.close),
  //                             onDeleted: () {
  //                               setState(() {
  //                                 selectedItems.remove(selectedItem);
  //                                 // _updatePopupMenu();
  //                               });
  //                             },
  //                           );
  //                         }).toList(),
  //                       ),
  //                     )
  //                   : Text('Select item'),
  //               Icon(Icons.keyboard_arrow_down_outlined)
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // return GestureDetector(
  //   // behavior: HitTestBehavior.translucent,
  //   onTap: () {
  //     _hideDropdown();
  //   },
  //   child: Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       GestureDetector(
  //         key: _dropdownKey,
  //         onTap: _toggleDropdown,
  //         // onTap: () {
  //         //   _focusNode.requestFocus();
  //         //   setState(() {
  //         //     isVisible = !isVisible;
  //         //   });
  //         // },
  //         child: Container(
  //           padding: EdgeInsets.symmetric(
  //               horizontal: 10, vertical: selectedItems.isNotEmpty ? 5 : 15),
  //           decoration: BoxDecoration(
  //               border: Border.all(), borderRadius: BorderRadius.circular(8)),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   selectedItems.isNotEmpty
  //                       ? Expanded(
  //                           child: Wrap(
  //                             spacing: 8,
  //                             runSpacing: 2,
  //                             children: selectedItems.map((selectedItem) {
  //                               return Chip(
  //                                 label: Text(selectedItem),
  //                                 deleteIcon: Icon(Icons.close),
  //                                 onDeleted: () {
  //                                   setState(() {
  //                                     selectedItems.remove(selectedItem);
  //                                     // _updateDropdown();
  //                                   });
  //                                 },
  //                               );
  //                             }).toList(),
  //                           ),
  //                         )
  //                       : Text('Select item'),
  //                   Icon(Icons.keyboard_arrow_down_outlined)
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  // Dropdown list with outside click detection
  // if (isVisible)
  //   Material(
  //     elevation: 4,
  //     borderRadius: BorderRadius.circular(8),
  //     child: Container(
  //       height: 250,
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(8),
  //         border: Border.all(color: Colors.grey),
  //       ),
  //       child: ListView.builder(
  //         itemCount: items.length,
  //         itemBuilder: (context, index) {
  //           bool isSelected = selectedItems.contains(items[index]);
  //           return CheckboxListTile(
  //             value: isSelected,
  //             title: Text(items[index]),
  //             onChanged: (value) {
  //               setState(() {
  //                 if (value == true) {
  //                   if (!selectedItems.contains(items[index])) {
  //                     selectedItems.add(items[index]);
  //                   }
  //                 } else {
  //                   selectedItems.remove(items[index]);
  //                 }
  //               });
  //             },
  //           );
  //         },
  //       ),
  //     ),
  //   ),
  //     ],
  //   ),
  // );
  // }
// }
