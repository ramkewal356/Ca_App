import 'package:ca_app/utils/constanst/colors.dart';

import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_text_item.dart';
import 'package:flutter/material.dart';

class CustomRecentDocument extends StatelessWidget {
  final String id;
  final String clientName;
  final String documentName;
  final String category;
  final String subCategory;
  final String postedDate;
  final VoidCallback onTapDownload;
  final VoidCallback onTapReRequest;

  const CustomRecentDocument(
      {super.key,
      required this.id,
      required this.clientName,
      required this.documentName,
      required this.category,
      required this.subCategory,
      required this.postedDate,
      required this.onTapDownload,
      required this.onTapReRequest});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextItem(lable: 'ID', value: '#1234'),
        CustomTextItem(lable: 'CLIENT NAME', value: 'Vjhdfjhdsjf'),
        CustomTextItem(lable: 'DOCUMENT NAME', value: 'ddjhdjvdvcccc'),
        CustomTextItem(lable: 'CATEGORY', value: 'cxvbcvyu'),
        CustomTextItem(lable: 'SUBCATEGORY', value: 'dndjvhudu'),
        CustomTextItem(lable: 'POSTED DATE', value: 'dcjhbjhdcyu'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CommonButtonWidget(
                buttonColor: ColorConstants.greenColor,
                buttonWidth: 120,
                buttonTitle: 'Download',
                onTap: onTapDownload),
            CommonButtonWidget(
                buttonWidth: 130,
                buttonTitle: 'Re-Request',
                onTap: onTapReRequest)
          ],
        )
      ],
    );
  }
}
