import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:flutter/material.dart';

class CustomTextInfo extends StatelessWidget {
  final String lable;
  final String value;
  final bool inOneLinetext;
  final int maxLine;
  final int flex1;
  final int flex2;
  const CustomTextInfo(
      {super.key,
      required this.lable,
      required this.value,
      this.maxLine = 1,
      this.inOneLinetext = false,
      this.flex1 = 1,
      this.flex2 = 1});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
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
            maxLines: inOneLinetext ? maxLine : maxLine,
            overflow: inOneLinetext ? TextOverflow.ellipsis : null,
            value,
            style: AppTextStyle().cardValueText,
          ),
        )
      ],
    );
  }
}
