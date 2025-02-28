import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashboardCard extends StatelessWidget {
  final Widget icon;
  final String total;
  final String lable;
  const DashboardCard(
      {super.key,
      required this.icon,
      required this.total,
      required this.lable});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: ColorConstants.darkGray,
      color: ColorConstants.white,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          height: 110.h,
          width: 110.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: ColorConstants.buttonColor,
                child: icon,
              ),
              SizedBox(height: 5),
              Text(
                total,
                style: AppTextStyle().labletext,
              ),
              SizedBox(height: 5),
              Text(
                lable,
                style: AppTextStyle().labletext,
              )
            ],
          ),
        ),
      ),
    );
  }
}
