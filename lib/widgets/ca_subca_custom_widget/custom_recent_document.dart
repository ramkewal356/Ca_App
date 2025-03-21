import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/utils/constanst/validator.dart';

import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_text_info.dart';
import 'package:ca_app/widgets/custom_text_item.dart';
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
        // CustomTextInfo(flex1: 2, flex2: 3, lable: 'ID', value: id),
        Row(
          children: [
            Expanded(child: CustomTextItem(lable: 'ID', value: id)),
            Text(postedDate)
          ],
        ),
        CustomTextInfo(
            flex1: 2, flex2: 3, lable: 'CLIENT NAME', value: clientName),
        CustomTextInfo(flex1: 2, flex2: 3, lable: 'CATEGORY', value: category),
        CustomTextInfo(
            flex1: 2, flex2: 3, lable: 'SUBCATEGORY', value: subCategory),
        // CustomTextInfo(
        //     flex1: 2, flex2: 3, lable: 'POSTED DATE', value: postedDate),
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
                loaderColor: ColorConstants.greenColor,
                buttonWidth: 80,
                buttonheight: 45,
                buttonTitle: '',
                buttonIconVisible: true,
                buttonIcon: Icon(
                  Icons.download_rounded,
                  color: ColorConstants.greenColor,
                ),
                onTap: onTapDownload),
            CommonButtonWidget(
                buttonWidth: 120,
                buttonheight: 45,
                buttonTitle: 'Re-Request',
                onTap: onTapReRequest)
          ],
        )
      ],
    );
  }
}
