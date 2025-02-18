import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_text_info.dart';
import 'package:flutter/material.dart';

class CommonTaskCardScreen extends StatelessWidget {
  final String taskId;
  final String assignDate;
  final String taskName;
  final String clientEmail;
  final String priority;
  final String assignTo;
  final String status;

  const CommonTaskCardScreen(
      {super.key,
      required this.taskId,
      required this.assignDate,
      required this.taskName,
      required this.clientEmail,
      required this.priority,
      required this.assignTo,
      required this.status});

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.symmetric(vertical: 8),
        elevation: 2,
        surfaceTintColor: ColorConstants.white,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: ColorConstants.darkGray),
            borderRadius: BorderRadius.circular(10)),
        color: ColorConstants.white,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              CustomTextInfo(
                  flex1: 2, flex2: 3, lable: 'TASKID', value: taskId),
              CustomTextInfo(
                  flex1: 2, flex2: 3, lable: 'ASSIGN DATE', value: assignDate),
              CustomTextInfo(
                  flex1: 2, flex2: 3, lable: 'TASK NAME', value: taskName),
              CustomTextInfo(
                  flex1: 2, flex2: 3, lable: 'CIENT EMAIL', value: clientEmail),
              CustomTextInfo(
                  flex1: 2, flex2: 3, lable: 'PRIORITY', value: priority),
              CustomTextInfo(
                  flex1: 2, flex2: 3, lable: 'ASSIGN TO', value: assignTo),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 45,
                    decoration: BoxDecoration(
                        color: ColorConstants.greenColor,
                        borderRadius: BorderRadius.circular(5)),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Text(
                      status,
                      style: AppTextStyle().smallbuttontext,
                    ),
                  ),
                  CommonButtonWidget(
                    buttonWidth: 100,
                    buttonheight: 45,
                    buttonTitle: 'View',
                    onTap: () {},
                  )
                ],
              )
            ],
          ),
        ));
  }
}
