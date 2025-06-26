import 'package:ca_app/blocs/task/task_bloc.dart';
import 'package:ca_app/screens/ca_screens/task_allocation/common_task_card_screen.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/utils/constanst/validator.dart';
import 'package:ca_app/widgets/custom_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MyTaskListScreen extends StatefulWidget {
  const MyTaskListScreen({super.key});

  @override
  State<MyTaskListScreen> createState() => _MyTaskListScreenState();
}

class _MyTaskListScreenState extends State<MyTaskListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String searchQuery = '';
  final _searchFocus = FocusNode();

  @override
  void initState() {
    _fetchAssignTask();
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _fetchAssignTask({bool isSearch = true, bool isPagination = false}) {
    context.read<TaskBloc>().add(GetSelfAssignTaskEvent(
        isSearch: isSearch,
        searchText: searchQuery,
        isPagination: isPagination));
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
      searchQuery = value;
    });
    _fetchAssignTask(isSearch: true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 5),
        CustomSearchField(
          focusNode: _searchFocus,
          controller: _searchController,
          serchHintText: 'search task',
          onChanged: _onSearchChanged,
        ),
        SizedBox(height: 10),
        BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            if (state is TaskLoading) {
              return Expanded(
                  child: Center(
                child: CircularProgressIndicator(
                  color: ColorConstants.buttonColor,
                ),
              ));
            } else if (state is GetSelfAssignTaskSuccess) {
              return Expanded(
                  child: state.getSelfAssignTaskList.isEmpty
                      ? Center(
                          child: Text(
                            'No Data Found',
                            style: AppTextStyle().redText,
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: state.getSelfAssignTaskList.length +
                              (state.isLastPage ? 0 : 1),
                          itemBuilder: (context, index) {
                            if (index == state.getSelfAssignTaskList.length) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: ColorConstants.buttonColor,
                                ),
                              );
                            }
                            var data = state.getSelfAssignTaskList[index];
                            return BlocConsumer<ActionOnTaskBloc, TaskState>(
                                listener: (context, state) {
                              if (state is ActionOnTaskSuccess) {
                                _fetchAssignTask();
                              }
                            },
                                //     buildWhen: (previous, current) {
                                //   // Only rebuild the specific item when its status changes
                                //   if (current is ActionOnTaskSuccess &&
                                //       current.actionOnTaskData.data?.id ==
                                //           data.id) {
                                //     return true;
                                //   }
                                //   return false;
                                // },

                                builder: (context, state) {
                              // String status =
                              //     data.taskResponse ?? ''; // Default from API
                              // if (state is ActionOnTaskSuccess &&
                              //     (state.actionOnTaskData.data?.id ==
                              //         data.id)) {
                              //   status =
                              //       state.actionOnTaskData.data?.taskResponse ??
                              //           ''; // Update status if success
                              // }
                              return CommonTaskCardScreen(
                                isMytaskScreen: true,
                                taskId: '${data.id}',
                                assignDate: dateFormate(data.createdDate),
                                taskName: '${data.name}',
                                clientEmail: '${data.customerEmail}',
                                priority: '${data.priority}',
                                assignTo: '${data.assignedName}',
                                status: '${data.taskResponse}',
                                completeLoader: state is ActionOnTaskLoading &&
                                    (state.taskId == data.id.toString()),
                                onCompleteTap: () {
                                  context.read<ActionOnTaskBloc>().add(
                                      ActionOnTaskEvent(
                                          taskId: data.id.toString(),
                                          taskResponse: 'COMPLETED'));
                                },
                                onViewTap: () {
                                  context.push('/ca_dashboard/view_task',
                                      extra: {
                                        "taskId": data.id.toString()
                                      }).then((onValue) {
                                    _fetchAssignTask();
                                  });
                                },
                              );
                            });
                          },
                        ));
            }
            return Container();
          },
        )
      ],
    );
  }
}
