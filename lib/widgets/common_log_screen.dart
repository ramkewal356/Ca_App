import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/custom_text_info.dart';
import 'package:ca_app/widgets/custom_text_item.dart';
import 'package:flutter/material.dart';

class CommonLogScreen extends StatefulWidget {
  final String id;
  final String action;
  final String performerName;
  final String performerEmail;
  final String uponName;
  final String uponEmail;
  final String createdDate;
  final String reason;

  const CommonLogScreen(
      {super.key,
      required this.id,
      required this.performerEmail,
      required this.performerName,
      required this.uponEmail,
      required this.uponName,
      required this.action,
      required this.createdDate,
      required this.reason});

  @override
  State<CommonLogScreen> createState() => _CommonLogScreenState();
}

class _CommonLogScreenState extends State<CommonLogScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: CustomTextItem(lable: 'Id', value: '#${widget.id}')),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: widget.action == 'ACTIVATE'
                      ? ColorConstants.greenColor
                      : ColorConstants.redColor),
              child: Text(
                widget.action,
                style: AppTextStyle().checkboxTitle,
              ),
            )
          ],
        ),
        Divider(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Text(
                'PERFORMER',
                style: AppTextStyle().textMediumButtonStyle,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'UPON',
                style: AppTextStyle().textMediumButtonStyle,
              ),
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                visualDensity: VisualDensity(vertical: -4),
                minVerticalPadding: 0,
                title: Text(
                  widget.performerName,
                  style: AppTextStyle().lableText,
                ),
                subtitle: Text(
                  widget.performerEmail,
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                dense: true,
                minVerticalPadding: 0,
                visualDensity: VisualDensity(vertical: -4),
                contentPadding: EdgeInsets.zero,
                title: Text(
                  widget.uponName,
                  style: AppTextStyle().lableText,
                ),
                subtitle: Text(widget.uponEmail),
              ),
            )
          ],
        ),
        Divider(),
        CustomTextInfo(
            flex1: 2,
            flex2: 3,
            lable: 'Created Date',
            value: widget.createdDate),
        Divider(),
        CustomTextInfo(
            flex1: 2, flex2: 3, lable: 'Reason', value: widget.reason)
      ],
    );
  }
}
