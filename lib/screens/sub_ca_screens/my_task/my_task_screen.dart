import 'package:ca_app/blocs/task/task_bloc.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/utils/constanst/validator.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_card.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/custom_popup_filter.dart';
import 'package:ca_app/widgets/custom_search_field.dart';
import 'package:ca_app/widgets/custom_text_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MyTaskScreen extends StatefulWidget {
  const MyTaskScreen({super.key});

  @override
  State<MyTaskScreen> createState() => _MyTaskScreenState();
}

class _MyTaskScreenState extends State<MyTaskScreen> {
  final TextEditingController _serchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String searchText = '';
  String filterText = '';
  String filterTitle = 'All';
  @override
  void initState() {
    super.initState();
    _getTaskList(isFilter: true);
    _scrollController.addListener(_onScroll);
  }

  void _getTaskList(
      {bool isSearch = false,
      bool isPagination = false,
      bool isFilter = false}) {
    context.read<TaskBloc>().add(GetTaskByAssignIdEvent(
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

      _getTaskList(isSearch: true);
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchText = value;
    });
    _getTaskList(isSearch: true);
  }

  void _onFilterChanged(String value) {
    setState(() {
      filterText = value;
      filterTitle = value == '' ? 'All' : filterOptions[value] ?? '';
    });
    _getTaskList(isFilter: true);
  }

  Map<String, String> filterOptions = {
    "All": "",
    "Not Started": "0",
    "Cencelled": "1",
    "Completed": "2"
  };
  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
      appBar: CustomAppbar(
        title: 'My Tasks',
        backIconVisible: true,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: CustomSearchField(
                    controller: _serchController,
                    serchHintText:
                        'search..by id ,service name,subservice name',
                    onChanged: _onSearchChanged,
                  ),
                ),
                SizedBox(width: 10),
                CustomFilterPopupWidget(
                    title: filterTitle,
                    filterOptions: filterOptions,
                    onFilterChanged: _onFilterChanged)
              ],
            ),
            SizedBox(height: 5),
            Expanded(
              child: BlocBuilder<TaskBloc, TaskState>(
                builder: (context, state) {
                  if (state is TaskLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: ColorConstants.buttonColor,
                      ),
                    );
                  } else if (state is TaskError) {
                    return Center(
                      child: Text(
                        'No Data Found',
                        style: AppTextStyle().getredText,
                      ),
                    );
                  } else if (state is GetTaskByAssignIdSuccess) {
                    return state.getTaskList.isEmpty
                        ? Center(
                            child: Text(
                              'No Data Found',
                              style: AppTextStyle().getredText,
                            ),
                          )
                        : ListView.builder(
                            itemCount: state.getTaskList.length +
                                (state.isLastPage ? 0 : 1),
                            itemBuilder: (context, index) {
                              if (index == state.getTaskList.length) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: ColorConstants.buttonColor,
                                  ),
                                );
                              }
                              var data = state.getTaskList[index];
                              return Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      context.push('/ca_dashboard/view_task',
                                          extra: {
                                            "taskId": data.id.toString()
                                          }).then((value) {
                                        _getTaskList(isFilter: true);
                                      });
                                    },
                                    child: CustomCard(
                                        child: Column(
                                      children: [
                                        CustomTextInfo(
                                            flex1: 2,
                                            flex2: 3,
                                            lable: 'TASK ID',
                                            value: '#${data.id}'),
                                        CustomTextInfo(
                                            flex1: 2,
                                            flex2: 3,
                                            lable: 'ASSIGNED DATE',
                                            value:
                                                '${dateFormate(data.createdDate)} / ${timeFormate(data.createdDate)}'),
                                        CustomTextInfo(
                                            flex1: 2,
                                            flex2: 3,
                                            lable: 'TASK NAME',
                                            value: '${data.name}'),
                                        CustomTextInfo(
                                            flex1: 2,
                                            flex2: 3,
                                            lable: 'ASSIGNEE NAME',
                                            value: '${data.assigneeName}'),
                                        CustomTextInfo(
                                            flex1: 2,
                                            flex2: 3,
                                            lable: 'CLIENT NAME',
                                            value: '${data.customerName}'),
                                        CustomTextInfo(
                                            flex1: 2,
                                            flex2: 3,
                                            lable: 'CLIENT EMAIL',
                                            value: '${data.customerEmail}'),
                                        CustomTextInfo(
                                            flex1: 2,
                                            flex2: 3,
                                            lable: 'DESCRIPTION',
                                            value: '${data.description}'),
                                        CustomTextInfo(
                                          flex1: 2,
                                          flex2: 3,
                                          lable: 'STATUS',
                                          value: '${data.taskResponse}',
                                          textStyle: data.taskResponse ==
                                                  'CANCELLED'
                                              ? AppTextStyle().getredText
                                              : data.taskResponse == 'COMPLETED'
                                                  ? AppTextStyle().getgreenText
                                                  : data.taskResponse ==
                                                          'IN_PROGRESS'
                                                      ? AppTextStyle()
                                                          .getYellowText
                                                      : data.taskResponse ==
                                                              'NOT_STARTED'
                                                          ? AppTextStyle()
                                                              .getredText
                                                          : AppTextStyle()
                                                              .getgreenText,
                                        ),

                                        // Row(
                                        //   mainAxisAlignment:
                                        //       MainAxisAlignment.spaceBetween,
                                        //   children: [
                                        //     Container(
                                        //       padding: EdgeInsets.symmetric(
                                        //           vertical: 10, horizontal: 10),
                                        //       decoration: BoxDecoration(
                                        //           color: data.taskResponse ==
                                        //                   'CANCELLED'
                                        //               ? Colors.red.shade100
                                        //               : data.taskResponse ==
                                        //                       'COMPLETED'
                                        //                   ? ColorConstants
                                        //                       .greenColor
                                        //                       .withOpacity(0.8)
                                        //                   : data.taskResponse ==
                                        //                           'IN_PROGRESS'
                                        //                       ? ColorConstants
                                        //                           .yellowColor
                                        //                           .withOpacity(
                                        //                               0.8)
                                        //                       : data.taskResponse ==
                                        //                               'NOT_STARTED'
                                        //                           ? ColorConstants
                                        //                               .darkGray
                                        //                           : ColorConstants
                                        //                               .greenColor
                                        //                               .withOpacity(
                                        //                                   0.6),
                                        //           borderRadius:
                                        //               BorderRadius.circular(8)),
                                        //       child: Text(
                                        //         '${data.taskResponse}',
                                        //         style: TextStyle(
                                        //             color: data.taskResponse ==
                                        //                     'CANCELLED'
                                        //                 ? Colors.red
                                        //                 : Colors.green,
                                        //             fontWeight: FontWeight.w600),
                                        //       ),
                                        //     ),
                                        //     // CommonButtonWidget(
                                        //     //   buttonWidth: 100,
                                        //     //   buttonTitle: 'View',
                                        //     //   onTap: () {
                                        //     //     context.push(
                                        //     //         '/subca_dashboard/task_view');
                                        //     //   },
                                        //     // )
                                        //   ],
                                        // )
                                      ],
                                    )),
                                  ),
                                  (data.taskResponse == 'CANCELLED' ||
                                          data.taskResponse == 'COMPLETED')
                                      ? SizedBox.shrink()
                                      : Positioned(
                                          top: 10,
                                          right: 0,
                                          child: BlocConsumer<ActionOnTaskBloc,
                                              TaskState>(
                                            listener: (context, state) {
                                              if (state
                                                  is ActionOnTaskSuccess) {
                                                _getTaskList(isFilter: true);
                                              }
                                            },
                                            builder: (context, state) {
                                              return PopupMenuButton<String>(
                                                position:
                                                    PopupMenuPosition.under,
                                                color: ColorConstants.white,
                                                padding: EdgeInsets.zero,
                                                menuPadding: EdgeInsets.zero,
                                                icon: Icon(Icons
                                                    .more_vert), // Custom icon
                                                onSelected: (value) {
                                                  debugPrint(
                                                      "Selected: $value");
                                                  context
                                                      .read<ActionOnTaskBloc>()
                                                      .add(ActionOnTaskEvent(
                                                          taskId: data.id
                                                              .toString(),
                                                          taskResponse: value));
                                                },
                                                itemBuilder: (BuildContext
                                                        context) =>
                                                    <PopupMenuEntry<String>>[
                                                  PopupMenuItem<String>(
                                                      height: 45,
                                                      value: 'IN_PROGRESS',
                                                      child: Text('ACCEPTED')),
                                                  PopupMenuItem<String>(
                                                      height: 45,
                                                      value: 'CANCELLED',
                                                      child: Text('REJECTED')),
                                                  PopupMenuItem<String>(
                                                      height: 45,
                                                      value: 'COMPLETED',
                                                      child: Text('COMPLETED')),
                                                ],
                                              );
                                            },
                                          ),
                                        )
                                ],
                              );
                            },
                          );
                  }
                  return Container();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
