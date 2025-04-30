import 'package:ca_app/blocs/document/document_bloc.dart';
import 'package:ca_app/blocs/task/task_bloc.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/utils/constanst/validator.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ViewTaskScreen extends StatefulWidget {
  final String taskId;
  const ViewTaskScreen({super.key, required this.taskId});

  @override
  State<ViewTaskScreen> createState() => _ViewTaskScreenState();
}

class _ViewTaskScreenState extends State<ViewTaskScreen> {
  @override
  void initState() {
    _getViewTaskDetails();
    super.initState();
  }

  _getViewTaskDetails() {
    context
        .read<TaskBloc>()
        .add(GetViewTaskDetailsEvent(taskId: widget.taskId));
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('taskId.....${widget.taskId}');
    return CustomLayoutPage(
        appBar: CustomAppbar(
          title: 'View Task',
          backIconVisible: true,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: BlocBuilder<TaskBloc, TaskState>(
            builder: (context, state) {
              if (state is TaskLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: ColorConstants.buttonColor,
                  ),
                );
              } else if (state is GetViewTaskDetailsSuccess) {
                var data = state.getViewTaskDetails.data;
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _textItem(
                                lable: 'Task Id',
                                value: '#${data?.taskResponseDto?.id}'),
                          ),
                          Expanded(
                            child: _textItem(
                                lable: 'Created Date',
                                value: dateFormate(
                                    data?.taskResponseDto?.createdDate)),
                          )
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: _textItem(
                                lable: 'CA Name',
                                value:
                                    '${data?.taskResponseDto?.assigneeName} (#${data?.taskResponseDto?.assigneeId})'),
                          ),
                          Expanded(
                            child: _textItem(
                                lable: 'Priority',
                                value: '${data?.taskResponseDto?.priority}'),
                          )
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: _textItem(
                                lable: 'Assigned Client',
                                value:
                                    '${data?.taskResponseDto?.customerName} (#${data?.taskResponseDto?.customerId})'),
                          ),
                          Expanded(
                            child: _textItem(
                                lable: 'Client Email',
                                value:
                                    '${data?.taskResponseDto?.customerEmail}'),
                          )
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: _textItem(
                                lable: 'Client Mobile No',
                                value:
                                    '+91 ${data?.taskResponseDto?.customerMobile}'),
                          ),
                          Expanded(
                            child: _textItem(
                                lable: 'Task Name',
                                value: '${data?.taskResponseDto?.name}'),
                          )
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: _textItem(
                                lable: 'Due Date',
                                value: data?.taskResponseDto?.dueDate ?? 'N/A'),
                          ),
                          Expanded(
                            child: _textItem(
                                lable: 'Desciption',
                                value: '${data?.taskResponseDto?.description}'),
                          )
                        ],
                      ),
                      // Text(
                      //   'Desciption : ',
                      //   style: AppTextStyle().hintText,
                      // ),
                      // SizedBox(height: 5),
                      // TextformfieldWidget(
                      //     readOnly: true,
                      //     maxLines: 3,
                      //     minLines: 3,
                      //     controller: TextEditingController(
                      //         text: '${data?.taskResponseDto?.description}'),
                      //     hintText: 'Description'),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Documents',
                            style: AppTextStyle().labletext,
                          ),
                          SizedBox(width: 5),
                          Container(
                            decoration: BoxDecoration(
                                color: ColorConstants.buttonColor,
                                shape: BoxShape.circle),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                '${data?.taskDocuments?.length}',
                                style: AppTextStyle().smallbuttontext,
                              ),
                            ),
                          )
                        ],
                      ),
                      ...List.generate(
                        data?.taskDocuments?.length ?? 0,
                        (index) {
                          return Container(
                            padding: EdgeInsets.all(4),
                            margin: EdgeInsets.only(bottom: 10),
                            height: 225,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: ColorConstants.darkGray),
                                borderRadius: BorderRadius.circular(5)),
                            width: double.infinity,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 160,
                                  width: double.infinity,
                                  child: Image.network(
                                    data?.taskDocuments?[index].docUrl ?? '',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          data?.taskDocuments?[index].docName ??
                                              '',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: AppTextStyle().labletext,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      CommonButtonWidget(
                                        buttonWidth: 70,
                                        buttonheight: 45,
                                        buttonColor: ColorConstants.white,
                                        buttonIconVisible: true,
                                        buttonIcon: Icon(
                                          Icons.cloud_download_outlined,
                                          color: ColorConstants.black,
                                        ),
                                        buttonTitle: '',
                                        onTap: () {
                                          context
                                              .read<DownloadDocumentBloc>()
                                              .add(DownloadDocumentFileEvent(
                                                  docUrl: data
                                                          ?.taskDocuments?[
                                                              index]
                                                          .docUrl ??
                                                      '',
                                                  docName: data
                                                          ?.taskDocuments?[
                                                              index]
                                                          .docName ??
                                                      ''));
                                        },
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      )
                    ],
                  ),
                );
              }
              return Container();
            },
          ),
        ));
  }

  _textItem({required String lable, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lable,
          style: AppTextStyle().smallSubTitleText,
        ),
        Text(
          value,
          style: AppTextStyle().lableText,
        )
      ],
    );
  }
}
