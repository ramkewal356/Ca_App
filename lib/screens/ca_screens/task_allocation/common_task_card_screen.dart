import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_text_info.dart';
import 'package:flutter/material.dart';


class CommonTaskCardScreen extends StatelessWidget {
  final bool isMytaskScreen;
  final String taskId;
  final String assignDate;
  final String taskName;
  final String clientEmail;
  final String priority;
  final String assignTo;
  final String status;
  final VoidCallback? onCompleteTap;
  final VoidCallback? onUploadTap;
  final VoidCallback? onViewTap;
  final bool completeLoader;
  final bool uploadLoader;
  const CommonTaskCardScreen(
      {super.key,
      this.isMytaskScreen = false,
      required this.taskId,
      required this.assignDate,
      required this.taskName,
      required this.clientEmail,
      required this.priority,
      required this.assignTo,
      required this.status,
      this.onUploadTap,
      this.onCompleteTap,
      this.onViewTap,
      this.completeLoader = false,
      this.uploadLoader = false});

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
                  flex1: 2, flex2: 3, lable: 'TASKID', value: '#$taskId'),
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
              CustomTextInfo(
                flex1: 2,
                flex2: 3,
                lable: 'STATUS',
                value: status,
                textStyle: status == 'COMPLETED'
                    ? AppTextStyle().getgreenText
                    : status == 'NOT_STARTED'
                        ? AppTextStyle().getredText
                        : AppTextStyle().getYellowText,
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  isMytaskScreen
                      ? CommonButtonWidget(
                          buttonWidth: 120,
                          buttonheight: 45,
                          buttonColor: ColorConstants.white,
                          buttonBorderColor: ColorConstants.greenColor,
                          tileStyle: AppTextStyle().getgreenText,
                          loaderColor: ColorConstants.greenColor,
                          buttonTitle: 'COMPLETE',
                          loader: completeLoader,
                          onTap: onCompleteTap)
                      : CommonButtonWidget(
                          buttonWidth: 120,
                          buttonheight: 45,
                          buttonColor: ColorConstants.white,
                          buttonBorderColor: ColorConstants.buttonColor,
                          loaderColor: ColorConstants.buttonColor,
                          tileStyle: AppTextStyle().textButtonStyle,
                          buttonTitle: 'Upload',
                          loader: uploadLoader,
                          onTap: onUploadTap),
                  CommonButtonWidget(
                    buttonWidth: 100,
                    buttonheight: 45,
                    buttonTitle: 'View',
                    onTap: onViewTap,
                  )
                ],
              )
            ],
          ),
        ));
  }
}
