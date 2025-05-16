import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Color? cardColor;
  final Widget child;
  const CustomCard({super.key, required this.child, this.cardColor});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      surfaceTintColor: ColorConstants.white,
      shape: RoundedRectangleBorder(
          // ignore: deprecated_member_use
          side: BorderSide(
              // ignore: deprecated_member_use
              color: cardColor ?? ColorConstants.darkGray.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(10)),
      color: ColorConstants.white,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: child,
      ),
    );
  }

  textItem({required String lable, required String value}) {
    return Row(
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
    );
  }
}
