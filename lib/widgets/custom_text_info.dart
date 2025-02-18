import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:flutter/material.dart';

class CustomTextInfo extends StatelessWidget {
  final String lable;
  final String value;
  final int flex1;
  final int flex2;
  const CustomTextInfo(
      {super.key,
      required this.lable,
      required this.value,
      this.flex1 = 1,
      this.flex2 = 1});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: flex1,
          child: Text(
            lable,
            style: AppTextStyle().lableText,
          ),
        ),
        SizedBox(width: 5),
        Text(
          ':',
          style: AppTextStyle().cardLableText,
        ),
        SizedBox(width: 5),
        Expanded(
          flex: flex2,
          child: Text(
            value,
            style: AppTextStyle().cardValueText,
          ),
        )
      ],
    );
  }
}
