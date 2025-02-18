import 'package:ca_app/screens/ca_screens/task_allocation/common_task_card_screen.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_bottomsheet_modal.dart';
import 'package:ca_app/widgets/custom_dropdown_button.dart';
import 'package:ca_app/widgets/custom_filter_popup.dart';
import 'package:ca_app/widgets/custom_multi_select_dropdown.dart';
import 'package:ca_app/widgets/custom_search_field.dart';

import 'package:ca_app/widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AssignTaskListScreen extends StatefulWidget {
  const AssignTaskListScreen({super.key});

  @override
  State<AssignTaskListScreen> createState() => _AssignTaskListScreenState();
}

class _AssignTaskListScreenState extends State<AssignTaskListScreen> {
  String? selectedCa;
  List<String> selectedClient = [];
  String? selectedPriority;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String countryCode = '91';
  Map<String, bool> selectedFilter = {
    "All": false,
    "Active": false,
    "Inactive": false
  };
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              Expanded(
                child: CustomSearchField(
                    controller: _searchController,
                    serchHintText:
                        'Search..by service name,subservice name,id'),
              ),
              SizedBox(width: 5),
              CustomFilterPopup(
                filterTitle: 'All',
                filterIcon: Icon(Icons.filter_list_rounded),
                filterItems: ['All', 'Active', 'Inactive'],
                selectedFilters: selectedFilter,
                onFilterChanged: (value) {},
              ),
              SizedBox(width: 10),
              CustomBottomsheetModal(
                  buttonHieght: 48,
                  buttonWidth: 130,
                  buttonTitle: 'CREATE TASK',
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Create New Task',
                                style: AppTextStyle().headingtext,
                              ),
                              IconButton(
                                  onPressed: () {
                                    context.pop();
                                  },
                                  icon: Icon(Icons.close)),
                            ],
                          ),
                          Text('Task Assigned Name : (Optional)',
                              style: AppTextStyle().labletext),
                          SizedBox(height: 5),
                          CustomDropdownButton(
                            dropdownItems: [],
                            initialValue: selectedCa,
                            hintText: 'Select Sub Ca',
                            validator: (p0) {
                              if (p0 == null || p0.isEmpty) {
                                return 'Please select sub ca';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          Text('Client Name', style: AppTextStyle().labletext),
                          SizedBox(height: 5),
                          MultiSelectSearchableDropdown(
                            hintText: 'Select Client',
                            items: [],
                            selectedItems: selectedClient,
                            onChanged: (p0) {},
                            validator: (p0) {
                              if (p0 == null || p0.isEmpty) {
                                return 'Please select client';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          Text('Priority', style: AppTextStyle().labletext),
                          SizedBox(height: 5),
                          CustomDropdownButton(
                            dropdownItems: [],
                            initialValue: selectedPriority,
                            hintText: 'Select priority',
                            validator: (p0) {
                              if (p0 == null || p0.isEmpty) {
                                return 'Please select priority';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          Text('Task Name', style: AppTextStyle().labletext),
                          SizedBox(height: 5),
                          TextformfieldWidget(
                            controller: _taskNameController,
                            hintText: 'Task name',
                            validator: (p0) {
                              if (p0 == null || p0.isEmpty) {
                                return 'Please enter task';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          Text('Description', style: AppTextStyle().labletext),
                          SizedBox(height: 5),
                          TextformfieldWidget(
                            controller: _descriptionController,
                            hintText: 'Description',
                            validator: (p0) {
                              if (p0 == null || p0.isEmpty) {
                                return 'Please enter description';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 15),
                          CommonButtonWidget(
                            buttonTitle: 'CREATE TASK',
                            onTap: () {
                              if (_formKey.currentState!.validate()) {}
                            },
                          )
                        ],
                      ),
                    ),
                  ))
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 6,
            itemBuilder: (context, index) {
              return CommonTaskCardScreen(
                taskId: '#1234',
                assignDate: '23/02/2025',
                taskName: 'xcvbnm',
                clientEmail: 'ram@gmail.com',
                priority: 'Heigh',
                assignTo: 'cvcbcvbcvn',
                status: 'Active',
              );
            },
          ),
        )
      ],
    );
  }
}
