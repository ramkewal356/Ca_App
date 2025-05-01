import 'package:ca_app/blocs/customer/customer_bloc.dart';
import 'package:ca_app/blocs/task/task_bloc.dart';
import 'package:ca_app/blocs/team_member/team_member_bloc.dart';
import 'package:ca_app/data/models/get_login_customer_model.dart';
import 'package:ca_app/data/models/get_subca_by_caid_model.dart';
import 'package:ca_app/screens/ca_screens/task_allocation/common_task_card_screen.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/utils/constanst/validator.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_bottomsheet_modal.dart';
import 'package:ca_app/widgets/custom_dropdown_button.dart';
import 'package:ca_app/widgets/custom_popup_filter.dart';
import 'package:ca_app/widgets/custom_search_field.dart';
import 'package:ca_app/widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AssignTaskListScreen extends StatefulWidget {
  const AssignTaskListScreen({super.key});

  @override
  State<AssignTaskListScreen> createState() => _AssignTaskListScreenState();
}

class _AssignTaskListScreenState extends State<AssignTaskListScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  DateTime? _selectedDate;
  String selectedDateTime = '';
  // DateFormat('yyyy-MM-dd').format(DateTime.now());
  String countryCode = '91';
  Map<String, bool> selectedFilter = {
    "All": false,
    "Active": false,
    "Inactive": false
  };
  String filterText = '';
  String searchText = '';
  String filterTitle = 'All';
  String? selectedSubCaName;
  String? selectedClientName;
  String? selectedPriority;
  int? assignedId;
  int? assigneeId;
  int? customerId;

  @override
  void initState() {
    _fetchAssignTask(isFilter: true);
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _fetchAssignTask(
      {bool isSearch = false,
      bool isPagination = false,
      bool isFilter = false}) {
    context.read<TaskBloc>().add(GetAssignTaskEvent(
        isSearch: isSearch,
        searchText: searchText,
        isPagination: isPagination,
        isFilter: isFilter,
        filterText: filterText));
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // 🔹 Trigger pagination event

      _fetchAssignTask(isPagination: true);
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchText = value;
    });
    _fetchAssignTask(isSearch: true);
  }

  void _onFilterChanged(String value) {
    setState(() {
      filterText = value;
      filterTitle = value == '' ? "All" : filtersList[value] ?? '';
    });
    _fetchAssignTask(isFilter: true);
  }

  void _onTaskCreated() {
    _fetchAssignTask(isFilter: true);
  }

  Map<String, String> filtersList = {
    "All": '', // Default selection
    "Not-Started": '0',
    "In-Progress": '3',
    "Cancelled": '1',
    "Completed": '2'
  };
  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(), // default to today
      firstDate: DateTime.now(), // earliest date
      lastDate: DateTime(2101), // latest date
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd-MM-yyyy').format(picked);
        selectedDateTime = DateFormat('yyyy-MM-dd').format(picked);
        debugPrint('selected Date:- $selectedDateTime');
      });
    }
  }

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
                  serchHintText: 'Search..by task name,id',
                  onChanged: _onSearchChanged,
                ),
              ),
              SizedBox(width: 5),
              CustomFilterPopupWidget(
                  title: filterTitle,
                  filterOptions: filtersList,
                  onFilterChanged: _onFilterChanged),
              SizedBox(width: 10),
              CustomBottomsheetModal(
                  buttonHieght: 48,
                  buttonWidth: 130,
                  buttonTitle: 'CREATE TASK',
                  onTap: () {
                    context.read<TeamMemberBloc>().add(
                        GetVerifiedSubCaByCaIdEvent(
                            selectedSubCaName: selectedSubCaName ?? ''));
                    context.read<CustomerBloc>().add(GetLogincutomerEvent(
                        selectedClientName: selectedClientName ?? ''));
                  },
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
                          BlocBuilder<TeamMemberBloc, TeamMemberState>(
                            builder: (context, state) {
                              List<Datum> getSubCa = [];
                              if (state is GetVerifiedSubCaByCaIdSuccess) {
                                getSubCa = state.getTeamMemberModel;
                              }
                              return CustomDropdownButton(
                                dropdownItems: [
                                  'Self',
                                  ...getSubCa.map((toElement) =>
                                      '${toElement.firstName} ${toElement.lastName}'),
                                ],
                                initialValue:
                                    (state is GetVerifiedSubCaByCaIdSuccess)
                                        ? state.selectedSubCaName
                                        : null,
                                hintText: 'Select sub ca',
                                onChanged: (p0) {
                                  setState(() {
                                    selectedSubCaName = p0;
                                    if (p0 == 'Self') {
                                      assignedId = 0;
                                    } else {
                                      assignedId = getSubCa
                                          .firstWhere(
                                            (test) =>
                                                '${test.firstName} ${test.lastName}' ==
                                                p0,
                                            orElse: () => Datum(id: -1),
                                          )
                                          .id;
                                    }
                                  });
                                  context.read<TeamMemberBloc>().add(
                                      UpdateSubCaNameEvent(
                                          selectedSubCaName: p0 ?? ''));
                                  debugPrint('assigned id $assignedId');
                                },
                                validator: (p0) {
                                  if (p0 == null || p0.isEmpty) {
                                    return 'Please select sub ca';
                                  }
                                  return null;
                                },
                              );
                            },
                          ),
                          SizedBox(height: 10),
                          Text('Client Name', style: AppTextStyle().labletext),
                          SizedBox(height: 5),
                          BlocBuilder<CustomerBloc, CustomerState>(
                            builder: (context, state) {
                              List<LoginCustomerData> getLoginCustomer = [];
                              if (state is GetLoginCustomerSuccess) {
                                getLoginCustomer = state.getLoginCustomers;
                              }
                              return CustomDropdownButton(
                                dropdownItems: [
                                  ...getLoginCustomer.map((toElement) =>
                                      '${toElement.firstName} ${toElement.lastName}'),
                                ],
                                initialValue: (state is GetLoginCustomerSuccess)
                                    ? state.selectedClientName
                                    : null,
                                hintText: 'Select client',
                                onChanged: (p0) {
                                  setState(() {
                                    selectedClientName = p0;
                                    customerId = getLoginCustomer
                                        .firstWhere(
                                          (test) =>
                                              '${test.firstName} ${test.lastName}' ==
                                              p0,
                                          orElse: () =>
                                              LoginCustomerData(userId: -1),
                                        )
                                        .userId;
                                  });
                                  context.read<CustomerBloc>().add(
                                      UpdateClientEvent(
                                          selectedClientName: p0 ?? ''));
                                  debugPrint('customer id $customerId');
                                },
                                validator: (p0) {
                                  if (p0 == null || p0.isEmpty) {
                                    return 'Please select client';
                                  }
                                  return null;
                                },
                              );
                            },
                          ),
                          SizedBox(height: 10),
                          Text('Priority', style: AppTextStyle().labletext),
                          SizedBox(height: 5),
                          CustomDropdownButton(
                            dropdownItems: ['URGENT', 'IMPORTANT', 'STANDARD'],
                            initialValue: selectedPriority,
                            hintText: 'Select priority',
                            onChanged: (p0) {
                              selectedPriority = p0;
                              debugPrint('selected priority $selectedPriority');
                            },
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
                            hintText: 'Enter task name',
                            validator: (p0) {
                              if (p0 == null || p0.isEmpty) {
                                return 'Please enter task';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          Text('Due Date', style: AppTextStyle().labletext),
                          SizedBox(height: 5),
                          TextformfieldWidget(
                            controller: _dateController,
                            hintText: 'Select due date',
                            readOnly: true,
                            fillColor: ColorConstants.white,
                            suffixIcons: Icon(Icons.calendar_month),
                            onTap: _pickDate,
                            validator: (p0) {
                              if (p0 == null ||
                                  p0.isEmpty ||
                                  selectedDateTime.isEmpty) {
                                return 'Please select due date';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          Text('Description', style: AppTextStyle().labletext),
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
                          BlocConsumer<CreateNewTaskBloc, TaskState>(
                            listener: (context, state) {
                              if (state is CreateTaskSuccess) {
                                context.pop();
                                _onTaskCreated();
                                selectedPriority = '';
                                selectedClientName = '';
                                selectedSubCaName = '';
                                _taskNameController.clear();
                                _descriptionController.clear();
                              }
                            },
                            builder: (context, state) {
                              return CommonButtonWidget(
                                buttonTitle: 'CREATE TASK',
                                loader: state is TaskLoading,
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<CreateNewTaskBloc>().add(
                                        CreateTaskEvent(
                                            assignedId: assignedId ?? 0,
                                            customerId: customerId ?? 0,
                                            priority: selectedPriority ?? '',
                                            taskName: _taskNameController.text,
                                            description:
                                                _descriptionController.text,
                                            dueDate: selectedDateTime));
                                  }
                                },
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ))
            ],
          ),
        ),
        BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            if (state is TaskLoading) {
              return Expanded(
                  child: Center(
                child: CircularProgressIndicator(
                  color: ColorConstants.buttonColor,
                ),
              ));
            } else if (state is GetAssignTaskSuccess) {
              return Expanded(
                child: state.getAssignTaskList.isEmpty
                    ? Center(
                        child: Text(
                          'No Data Found',
                          style: AppTextStyle().redText,
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: state.getAssignTaskList.length +
                            (state.isLastPage ? 0 : 1),
                        itemBuilder: (context, index) {
                          if (index == state.getAssignTaskList.length) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          var data = state.getAssignTaskList[index];
                          return CommonTaskCardScreen(
                            taskId: '${data.id}',
                            assignDate: dateFormate(data.createdDate),
                            taskName: '${data.name}',
                            clientEmail: '${data.customerEmail}',
                            priority: '${data.priority}',
                            assignTo: '${data.assignedName}',
                            status: '${data.taskResponse}',
                            disabledownload:
                                (data.taskResponse == 'COMPLETED' ||
                                        data.taskResponse == 'REJECTED')
                                    ? true
                                    : false,
                            onUploadTap: () {
                              context.push('/ca_dashboard/upload_task_document',
                                  extra: {"taskId": data.id}).then((onValue) {
                                _fetchAssignTask(isFilter: true);
                              });
                            },
                            onViewTap: () {
                              context.push('/ca_dashboard/view_task', extra: {
                                "taskId": data.id.toString()
                              }).then((onValue) {
                                _fetchAssignTask(isFilter: true);
                              });
                            },
                          );
                        },
                      ),
              );
            }
            return Container();
          },
        )
      ],
    );
  }
}
