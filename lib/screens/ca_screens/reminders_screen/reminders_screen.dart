import 'package:ca_app/blocs/custom_dropdown/custom_dropdown_bloc.dart';
import 'package:ca_app/blocs/customer/customer_bloc.dart';
import 'package:ca_app/blocs/reminder/reminder_bloc.dart';
import 'package:ca_app/data/models/get_login_customer_model.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_bottomsheet_modal.dart';
import 'package:ca_app/widgets/custom_card.dart';
import 'package:ca_app/widgets/custom_dropdown_button.dart';
import 'package:ca_app/widgets/custom_filter_popup.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/custom_list_tile_card.dart';
import 'package:ca_app/widgets/custom_multi_select_dropdown.dart';
import 'package:ca_app/widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  String countryCode = '91';
  String selectedFilter = '';
  String searchQuery = '';
  String? selectedOccurence;
  Map<String, bool> selectedFilters = {
    "All": false,
    "Active": false,
    "Inactive": false
  };
  List<String> selectedItems = [];
  List<int> selectedUserIds = [];
  @override
  void initState() {
    super.initState();
    _fetchReminder(isFilter: true);
    _scrollController.addListener(_onScroll);
  }

  void _fetchReminder({bool isFilter = false, bool isPagination = false}) {
    context.read<ReminderBloc>().add(GetReminderEvent(
        status: selectedFilter,
        occurence: selectedOccurence ?? '',
        isFilter: isFilter,
        isPagination: isPagination));
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _fetchReminder(isPagination: true);
    }
  }

  void _onFilterChanged(String value) {
    setState(() {
      selectedFilter = value;
    });
    _fetchReminder(isFilter: true);
  }

  void _onFilterChanged1(String value) {
    setState(() {
      selectedOccurence = value;
    });
    _fetchReminder(isFilter: true);
  }

  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
      appBar: CustomAppbar(
        title: 'Reminders',
        backIconVisible: true,
      ),
      onRefresh: () async {
        _fetchReminder(isFilter: true);
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            // _searchFocusNode.unfocus();
          },
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomFilterPopup(
                          // filterTitle: 'All',
                          filterIcon: Icon(Icons.filter_list_rounded),
                          filterItems: ["All", "Active", "Inactive"],
                          selectedFilters: selectedFilters,
                          onFilterChanged: _onFilterChanged,
                        ),
                        SizedBox(width: 10),
                        FilterPopup(onFilterChanged: _onFilterChanged1)
                      ],
                    ),
                  ),
                  BlocConsumer<ReminderBloc, ReminderState>(
                    builder: (context, state) {
                      if (state is ReminderLoading) {
                        return Expanded(
                            child: Center(
                                child: CircularProgressIndicator(
                          color: ColorConstants.buttonColor,
                        )));
                      } else if (state is ReminderError) {
                        return Center(
                          child: Text(
                            'No data found !',
                            style: AppTextStyle().redText,
                          ),
                        );
                      } else if (state is GetReminderSuccess) {
                        return Expanded(
                          child: state.getRemindersData.isEmpty
                              ? Center(
                                  child: Text(
                                    'No Data Found!',
                                    style: AppTextStyle().redText,
                                  ),
                                )
                              : ListView.builder(
                                  controller: _scrollController,
                                  itemCount: (state.getRemindersData.length) +
                                      (state.isLastPage ? 0 : 1),
                                  itemBuilder: (context, index) {
                                    if (index ==
                                        state.getRemindersData.length) {
                                      return Center(
                                          child: CircularProgressIndicator(
                                        color: ColorConstants.buttonColor,
                                      ));
                                    }
                                    var data = state.getRemindersData[index];
                                    return GestureDetector(
                                      onTap: () {
                                        context.push(
                                            '/ca_dashboard/view_reminder',
                                            extra: {
                                              'reminderId': data.id
                                            }).then((onValue) {
                                          _fetchReminder(isFilter: true);
                                        });
                                      },
                                      child: CustomCard(
                                          child: CustomListTileCard(
                                        id: '${data.id}',
                                        title: '${data.title}',
                                        subtitle1: '${data.description}',
                                        subtitle2: '',
                                        status: data.status ?? false,
                                        imgUrl: '',
                                        letter: '',
                                      )),
                                    );
                                  },
                                ),
                        );
                      }
                      return Container();
                    },
                    listener: (context, state) {},
                  )
                ],
              ),
              Positioned(
                  right: 0,
                  bottom: 0,
                  child: CustomBottomsheetModal(
                      buttonHieght: 48,
                      buttonWidth: 110,
                      buttonTitle: 'Reminder',
                      isFlotingButton: true,
                      buttonIcon: true,
                      onTap: () {
                        context
                            .read<CustomerBloc>()
                            .add(GetLogincutomerEvent(selectedClientName: ''));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Add New Reminder',
                                    style: AppTextStyle().cardLableText,
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        context.pop();
                                      },
                                      icon: Icon(Icons.close)),
                                ],
                              ),
                              Text('Select Client',
                                  style: AppTextStyle().labletext),
                              SizedBox(height: 5),
                              BlocBuilder<CustomerBloc, CustomerState>(
                                builder: (context, state) {
                                  List<LoginCustomerData> customers = [];
                                  if (state is GetLoginCustomerSuccess) {
                                    customers = state.getLoginCustomers;
                                    debugPrint(
                                        'object ${customers.map((toElement) => '${toElement.firstName} ${toElement.lastName}').toList()}');
                                  }
                                  return MultiSelectSearchableDropdown(
                                    hintText: 'Select client',
                                    openInModal: true,
                                    items: customers
                                        .map((toElement) =>
                                            '${toElement.firstName} ${toElement.lastName}')
                                        .toList(),
                                    selectedItems: selectedItems,
                                    onChanged: (newSelection) {
                                      selectedUserIds = customers
                                          .where((customer) =>
                                              newSelection.contains(
                                                  '${customer.firstName} ${customer.lastName}'))
                                          .map((customer) =>
                                              customer.userId ?? 0)
                                          .toList();
                                      setState(() {
                                        selectedItems = newSelection;
                                        debugPrint(
                                            'selectedItems $selectedUserIds');
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select client';
                                      }
                                      return null;
                                    },
                                  );
                                },
                              ),
                              SizedBox(height: 10),
                              Text('Occurence',
                                  style: AppTextStyle().labletext),
                              SizedBox(height: 5),
                              CustomDropdownButton(
                                dropdownItems: ['WEEKLY', 'MONTHLY', 'YEARLY'],
                                initialValue: selectedOccurence,
                                initialStateSelected: true,
                                hintText: 'Select occurence',
                                onChanged: (p0) {
                                  setState(() {
                                    selectedOccurence = p0;
                                    debugPrint(
                                        'selected occurence $selectedOccurence');
                                  });
                                },
                                validator: (p0) {
                                  if (p0 == null || p0.isEmpty) {
                                    return 'Please select occurence';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 10),
                              Text('Title', style: AppTextStyle().labletext),
                              SizedBox(height: 5),
                              TextformfieldWidget(
                                controller: _titleController,
                                hintText: 'Enter title',
                                validator: (p0) {
                                  if (p0 == null || p0.isEmpty) {
                                    return 'Please enter title';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 10),
                              Text('Description',
                                  style: AppTextStyle().labletext),
                              SizedBox(height: 5),
                              TextformfieldWidget(
                                controller: _descriptionController,
                                hintText: 'Enter description',
                                validator: (p0) {
                                  if (p0 == null || p0.isEmpty) {
                                    return 'Please enter description';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 15),
                              BlocConsumer<CreateReminderBloc, ReminderState>(
                                listener: (context, state) {
                                  if (state is CreateReminderSuccess) {
                                    context.pop();
                                    _titleController.clear();
                                    _descriptionController.clear();
                                    selectedOccurence = null;
                                    selectedItems.clear();
                                    context
                                        .read<CustomDropdownBloc>()
                                        .add(DropdownResetEvent());
                                    _fetchReminder(isFilter: true);
                                  }
                                },
                                builder: (context, state) {
                                  return CommonButtonWidget(
                                    buttonTitle: 'ADD REMINDER',
                                    loader: state is ReminderLoading,
                                    onTap: () {
                                      debugPrint(
                                          'SELECTED...$selectedOccurence');
                                      if (_formKey.currentState!.validate()) {
                                        context.read<CreateReminderBloc>().add(
                                            CreateReminderEvent(
                                                title: _titleController.text,
                                                description:
                                                    _descriptionController.text,
                                                occurence:
                                                    selectedOccurence ?? '',
                                                userIds: selectedUserIds));
                                      }
                                    },
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      )))
            ],
          ),
        ),
      ),
    );
  }
}

class FilterPopup extends StatefulWidget {
  final ValueChanged<String> onFilterChanged;

  const FilterPopup({super.key, required this.onFilterChanged});

  @override
  State<FilterPopup> createState() => _FilterPopupState();
}

class _FilterPopupState extends State<FilterPopup> {
  Map<String, bool> filters = {
    "All": true, // Default selection
    "Weekly": false,
    "Monthly": false,
    "Yearly": false,
  };

  String _filterTitle = "All"; // Default title

  void _updateSelection(String filter, bool? value, StateSetter setStatePopup) {
    // Reset all filters to false first
    filters.updateAll((key, _) => false);

    // Set only the selected filter to true
    filters[filter] = value ?? false;

    // Update filter title
    setStatePopup(() {});
    setState(() {
      _filterTitle = filter;
    });

    // Apply filters & send correct numeric value
    _applyFilters();
  }

  void _applyFilters() {
    String filterValue;

    if (filters["All"] == true) {
      filterValue = '';
    } else if (filters["Weekly"] == true) {
      filterValue = 'WEEKLY';
    } else if (filters["Monthaly"] == true) {
      filterValue = 'MONTHLY';
    } else if (filters["Yearly"] == true) {
      filterValue = 'YEARLY';
    } else {
      filterValue = ''; // Default if no filter is selected
    }

    // Callback to parent widget
    widget.onFilterChanged(filterValue);
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      position: PopupMenuPosition.under,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10),
      constraints: BoxConstraints(minWidth: 150, maxWidth: 150),
      offset: Offset(0, 0),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Text(
              _filterTitle == 'All' ? 'Occurence' : _filterTitle,
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
            SizedBox(width: 5),
            Icon(Icons.filter_list_rounded),
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
                  children: [
                    "All",
                    "Weekly",
                    "Monthly",
                    "Yearly",
                  ].map((filter) {
                    return _buildCheckListTile(
                      context,
                      filter,
                      filters[filter] ?? false,
                      (value) => _updateSelection(filter, value, setStatePopup),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ];
      },
    );
  }

  Widget _buildCheckListTile(BuildContext context, String title, bool? value,
      void Function(bool?)? onChanged) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      activeColor: ColorConstants.buttonColor,
      controlAffinity: ListTileControlAffinity.leading,
      visualDensity: VisualDensity(horizontal: -4),
      value: value,
      title: Text(
        title,
        style: AppTextStyle().lableText,
      ),
      onChanged: onChanged,
    );
  }
}
