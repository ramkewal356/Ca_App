import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';

class HelpAndSupportViewScreen extends StatefulWidget {
  const HelpAndSupportViewScreen({super.key});

  @override
  State<HelpAndSupportViewScreen> createState() =>
      _HelpAndSupportViewScreenState();
}

class _HelpAndSupportViewScreenState extends State<HelpAndSupportViewScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
      appBar: CustomAppbar(
        title: 'View History',
        backIconVisible: true,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: _textItem(lable: 'Id', value: '#243'),
                ),
                Expanded(
                  child: _textItem(lable: 'Created Date', value: '28/01/2025'),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: _textItem(lable: 'User Name', value: 'Vishal Kumar'),
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Response',
                      style: AppTextStyle().hintText,
                    ),
                    SizedBox(height: 5),
                    Container(
                      decoration: BoxDecoration(
                          color: ColorConstants.greenColor,
                          borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: Text(
                          'Resolved',
                          style: AppTextStyle().statustext,
                        ),
                      ),
                    ),
                  ],
                ))
              ],
            ),
            SizedBox(height: 5),
            _textItem(lable: 'Subject', value: 'Swabi jhjndskjfjk'),
            SizedBox(height: 5),
            Text(
              'Message: ',
              style: AppTextStyle().hintText,
            ),
            SizedBox(height: 5),
            TextformfieldWidget(
                readOnly: true,
                maxLines: 3,
                minLines: 3,
                controller:
                    TextEditingController(text: 'fvfdvfdvfv ffsdfffsdfsdff'),
                hintText: 'Description'),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  _textItem({required String lable, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lable,
          style: AppTextStyle().hintText,
        ),
        Text(
          value,
          style: AppTextStyle().cardValueText,
        )
      ],
    );
  }
}
