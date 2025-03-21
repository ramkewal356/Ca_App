import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  // final String id;
  // final String date;
  // final String senderCa;
  // final String description;
  // final VoidCallback onTap;
  final Widget child;
  const CustomCard(
      {super.key,
      // required this.id,
      // required this.date,
      // required this.senderCa,
      // required this.description,
      // required this.onTap
      required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      surfaceTintColor: ColorConstants.white,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: ColorConstants.darkGray.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(10)),
      color: ColorConstants.white,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: child,
        // child: Column(
        //   children: [
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         Expanded(
        //           child: textItem(lable: 'ID', value: id),
        //         ),
        //         Expanded(child: textItem(lable: 'DATE', value: date))
        //       ],
        //     ),
        //     SizedBox(height: 5),
        //     textItem(lable: 'SENDER(CA)', value: senderCa),
        //     SizedBox(height: 5),
        //     textItem(lable: 'DESCRIPTION', value: description),
        //     SizedBox(height: 10),
        //     Align(
        //       alignment: Alignment.bottomRight,
        //       child: CommonButtonWidget(
        //         buttonWidth: 120,
        //         buttonheight: 50,
        //         buttonTitle: 'View',
        //         onTap: onTap,
        //       ),
        //     )
        //   ],
        // ),
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
