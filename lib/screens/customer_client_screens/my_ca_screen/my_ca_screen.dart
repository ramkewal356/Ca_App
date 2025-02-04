import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:flutter/material.dart';

class MyCaScreen extends StatefulWidget {
  const MyCaScreen({super.key});

  @override
  State<MyCaScreen> createState() => _MyCaScreenState();
}

class _MyCaScreenState extends State<MyCaScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
        appBar: CustomAppbar(
          title: 'My CA',
          backIconVisible: true,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        color: ColorConstants.buttonColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'V',
                          style: AppTextStyle().largWhitetext,
                        ),
                        Text(
                          'K',
                          style: AppTextStyle().mediumWhitetext,
                        ),
                      ],
                    )),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Viswash kumar',
                        style: AppTextStyle().textButtonStyle,
                      ),
                      subTitle(Icons.email, 'example@gmail.com'),
                      subTitle(Icons.call, '+91 9891773267'),
                      subTitle(Icons.location_on, 'H-15,sector 63,noida up '),
                    ],
                  ))
                ],
              ),
              SizedBox(height: 15),
              Container(
                decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: ColorConstants.darkGray.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column(
                    children: [
                      textItem(lable: 'Referral code', value: '978738348848'),
                      textItem(lable: 'Pan Card', value: '_'),
                      textItem(lable: 'Aadhaar Card', value: '_'),
                      textItem(lable: 'Phone', value: '978738348'),
                      textItem(lable: 'Created Date', value: '27/01/2028'),
                      textItem(lable: 'Gender', value: 'male'),
                      textItem(lable: 'Status', value: 'Active'),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  subTitle(IconData icon, String title) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: ColorConstants.buttonColor,
        ),
        SizedBox(width: 5),
        Expanded(
          child: Text(
            title,
            style: AppTextStyle().subTitleText,
          ),
        )
      ],
    );
  }

  textItem({required String lable, required String value}) {
    return Row(
      children: [
        Expanded(
            child: Text(
          lable,
          style: AppTextStyle().cardLableText,
        )),
        Expanded(
            child: Text(
          value,
          style: value == 'Active'
              ? AppTextStyle().getgreenText
              : value == 'In-Active'
                  ? AppTextStyle().getredText
                  : AppTextStyle().cardValueText,
        ))
      ],
    );
  }
}
