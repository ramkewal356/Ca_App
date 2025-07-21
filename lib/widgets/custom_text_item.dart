import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:flutter/material.dart';

class CustomTextItem extends StatelessWidget {
  final String lable;
  final String value;
  final bool inOneLinetext;
  final int? maxLine;
  const CustomTextItem(
      {super.key,
      required this.lable,
      required this.value,
      this.maxLine,
      this.inOneLinetext = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lable,
            style: AppTextStyle().lableText,
          ),
          SizedBox(width: 5),
          Text(
            ':',
            style: AppTextStyle().cardLableText,
          ),
          SizedBox(width: 5),
          Expanded(
            child: Text(
              maxLines: inOneLinetext ? maxLine : 1,
              overflow: inOneLinetext ? TextOverflow.ellipsis : null,
              value,
              style: AppTextStyle().cardValueText,
            ),
          )
        ],
      ),
    );
  }
}
