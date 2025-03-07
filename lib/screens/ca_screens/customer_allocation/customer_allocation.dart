import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_dropdown_button.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/custom_multi_select_dropdown.dart';
import 'package:ca_app/widgets/custom_search_field.dart';
import 'package:flutter/material.dart';

class CustomerAllocation extends StatefulWidget {
  const CustomerAllocation({super.key});

  @override
  State<CustomerAllocation> createState() => _CustomerAllocationState();
}

class _CustomerAllocationState extends State<CustomerAllocation> {
  final TextEditingController _searchController = TextEditingController();
  // List<String> selectedItems = [];

  String? selectedCa;
  // final List<String> items = [
  //   "Sarthak",
  //   "Binni",
  //   "John",
  //   "Alex",
  //   "Emma",
  //   'fdgfg',
  //   'hgfhjhgjhg',
  //   'hghjgvvbv'
  // ];

  int? selectedRowIndex; // Store the selected row index

  List<Map<String, String>> tableData = [
    {"USERID": "#1234", "NAME": "Ramkewal", "MOBILE": "992954721"},
    {"USERID": "#1235", "NAME": "Rahul", "MOBILE": "987654321"},
    {"USERID": "#1236", "NAME": "John", "MOBILE": "999999999"},
  ];

  void _onSelectRow(int index) {
    setState(() {
      if (selectedRowIndex == index) {
        selectedRowIndex = null; // Deselect if clicking again
      } else {
        selectedRowIndex = index; // Select new row
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
        appBar: CustomAppbar(
          title: 'Customer Allocation',
          backIconVisible: true,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select Team Member', style: AppTextStyle().labletext),
              SizedBox(height: 5),
              CustomDropdownButton(
                dropdownItems: ['vishal'],
                initialValue: selectedCa,
                hintText: 'Select your ca',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your ca';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Text('Select Client', style: AppTextStyle().labletext),
              SizedBox(height: 5),
              // MultiSelectSearchableDropdown(
              //   hintText: 'Select client',
              //   items: items,
              //   selectedItems: selectedItems,
              //   onChanged: (newSelection) {
              //     setState(() {
              //       selectedItems = newSelection;
              //     });
              //   },
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please select at least one item';
              //     }
              //     return null;
              //   },
              // ),
              // SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: CustomSearchField(
                        controller: _searchController,
                        serchHintText: 'search  id'),
                  ),
                  SizedBox(width: 10),
                  CommonButtonWidget(
                    buttonWidth: 120,
                    buttonTitle: 'Assign',
                    onTap: () {},
                  ),
                ],
              ),
              SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: DataTable(
                  columnSpacing: 0,
                  headingRowHeight: 50,
                  headingRowColor:
                      WidgetStatePropertyAll(ColorConstants.buttonColor),
                  headingTextStyle: AppTextStyle().buttontext,
                  columns: [
                    DataColumn(label: SizedBox.shrink()),
                    DataColumn(
                        label: SizedBox(width: 60, child: Text("USERID"))),
                    DataColumn(label: Text("NAME")),
                    DataColumn(
                        label: SizedBox(width: 120, child: Text("MOBILE"))),
                  ],
                  rows: List<DataRow>.generate(tableData.length, (index) {
                    var data = tableData[index];
                    bool isSelected =
                        selectedRowIndex == index; // Check if selected

                    return DataRow(
                      // selected: isSelected,
                      // onSelectChanged: (selected) => _onSelectRow(index),
                      cells: [
                        DataCell(SizedBox(
                          width: 0,
                          child: Checkbox(
                            value: isSelected,
                            onChanged: (bool? value) {
                              _onSelectRow(index);
                            },
                          ),
                        )),
                        DataCell(SizedBox(
                            width: 60, child: Text(data["USERID"] ?? ''))),
                        DataCell(Text(data["NAME"] ?? '')),
                        DataCell(SizedBox(
                            width: 120, child: Text(data["MOBILE"] ?? ''))),
                      ],
                    );
                  }),
                ),
              ),
              
            ],
          ),
        ));
  }
}
