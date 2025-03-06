import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';

import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_text_info.dart';
import 'package:flutter/material.dart';

class CustomRecentDocument extends StatelessWidget {
  final String id;
  final String clientName;
  final String documentName;
  final String category;
  final String subCategory;
  final String postedDate;
  final bool downloadLoader;
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
      this.downloadLoader = false,
      required this.onTapDownload,
      required this.onTapReRequest});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextInfo(flex1: 2, flex2: 3, lable: 'ID', value: id),
        CustomTextInfo(
            flex1: 2, flex2: 3, lable: 'CLIENT NAME', value: clientName),
        CustomTextInfo(flex1: 2, flex2: 3, lable: 'CATEGORY', value: category),
        CustomTextInfo(
            flex1: 2, flex2: 3, lable: 'SUBCATEGORY', value: subCategory),
        CustomTextInfo(
            flex1: 2, flex2: 3, lable: 'POSTED DATE', value: postedDate),
        CustomTextInfo(
            inOneLinetext: true,
            maxLine: 2,
            flex1: 2,
            flex2: 3,
            lable: 'DOCUMENT NAME',
            value: documentName),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CommonButtonWidget(
                loader: downloadLoader,
                buttonColor: ColorConstants.white,
                buttonBorderColor: ColorConstants.greenColor,
                tileStyle: AppTextStyle().getgreenText,
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
