import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_dropdown_button.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/custom_multi_select_dropdown.dart';
import 'package:flutter/material.dart';

class CustomerAllocation extends StatefulWidget {
  const CustomerAllocation({super.key});

  @override
  State<CustomerAllocation> createState() => _CustomerAllocationState();
}

class _CustomerAllocationState extends State<CustomerAllocation> {
  List<String> selectedItems = [];

  String? selectedCa;
  final List<String> items = [
    "Sarthak",
    "Binni",
    "John",
    "Alex",
    "Emma",
    'fdgfg',
    'hgfhjhgjhg',
    'hghjgvvbv'
  ];
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
              MultiSelectSearchableDropdown(
                hintText: 'Select client',
                items: items,
                selectedItems: selectedItems,
                onChanged: (newSelection) {
                  setState(() {
                    selectedItems = newSelection;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select at least one item';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              CommonButtonWidget(
                buttonTitle: 'Select Client',
                onTap: () {},
              ),
              SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: DataTable(
                    headingRowHeight: 50,
                    headingRowColor:
                        WidgetStatePropertyAll(ColorConstants.buttonColor),
                    headingTextStyle: AppTextStyle().buttontext,
                    columns: [
                      DataColumn(label: Text('USERID')),
                      DataColumn(label: Text('NAME')),
                      DataColumn(label: Text('MOBILE'))
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(
                          Text('#1234'),
                        ),
                        DataCell(
                          Text('Ramkewal'),
                        ),
                        DataCell(
                          Text('992954721'),
                        )
                      ]),
                      DataRow(cells: [
                        DataCell(
                          Text('#1234'),
                        ),
                        DataCell(
                          Text('Ramkewal'),
                        ),
                        DataCell(
                          Text('992954721'),
                        )
                      ])
                    ]),
              )
            ],
          ),
        ));
  }
}
