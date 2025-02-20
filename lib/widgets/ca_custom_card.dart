import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:flutter/material.dart';

class CaCustomCard extends StatelessWidget {
  final String id;
  final String date;
  final String clintName;
  final String document;
  final String catogory;
  final String download;
  final VoidCallback onReRequestTap;
  final VoidCallback onTap;
  const CaCustomCard(
      {super.key,
      required this.id,
      required this.clintName,
      required this.date,
      required this.catogory,
      required this.document,
      required this.download,
      required this.onReRequestTap,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: textItem(lable: 'ID', value: id),
                ),
                Expanded(child: textItem(lable: 'DATE', value: date))
              ],
            ),
            SizedBox(height: 5),
            textItem(lable: 'CLIENT NAME', value: clintName),
            SizedBox(height: 5),
            textItem(lable: 'DOCUMENT', value: document),
            SizedBox(height: 5),
            textItem(lable: 'CATEGORY', value: catogory),
            SizedBox(height: 5),
            textItem(lable: 'DOWNLOAD', value: download),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.bottomRight,
              child: CommonButtonWidget(
                buttonWidth: 150,
                buttonheight: 50,
                buttonTitle: 'Re-Request',
                onTap: onTap,
              ),
            )
          ],
        ),
      ),
    );
  }

  textItem({required String lable, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lable,
          style: AppTextStyle().cardLableText,
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
