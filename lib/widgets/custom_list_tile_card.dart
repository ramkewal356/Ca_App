import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:flutter/material.dart';

class CustomListTileCard extends StatelessWidget {
  final String title;
  final String subtitle1;
  final String subtitle2;
  final Widget? isSecondary;
  final String id;
  final bool status;
  final String imgUrl;
  final String letter;
  const CustomListTileCard(
      {super.key,
      required this.title,
      required this.subtitle1,
      required this.subtitle2,
      this.isSecondary,
      required this.id,
      required this.status,
      required this.imgUrl,
      required this.letter});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: ColorConstants.buttonColor,
          child: letter.isNotEmpty
              ? ClipOval(
              child: imgUrl.isEmpty
                  ? Text(
                      letter,
                      style: AppTextStyle().appbartext,
                    )
                  : Image.network(
                      imgUrl,
                      fit: BoxFit.fill,
                        ))
              : Icon(
                  Icons.notifications,
                  color: ColorConstants.white,
                ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title),
              Text(subtitle1),
              subtitle2.isEmpty ? SizedBox.shrink() : Text(subtitle2),
              isSecondary ?? SizedBox.shrink()
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('#$id'),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: status
                      ? ColorConstants.greenColor
                      : ColorConstants.redColor),
            ),
            SizedBox(
              height: 20,
            )
          ],
        )
      ],
    );
  }
}
