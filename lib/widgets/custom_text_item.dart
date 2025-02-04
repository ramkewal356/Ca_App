import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:flutter/material.dart';

class CustomTextItem extends StatelessWidget {
  final String lable;
  final String value;
  const CustomTextItem({super.key, required this.lable, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
              value,
              style: AppTextStyle().cardValueText,
            ),
          )
        ],
      ),
    );
  }
}
