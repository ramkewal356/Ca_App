import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_card.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/custom_search_field.dart';
import 'package:ca_app/widgets/custom_text_info.dart';
import 'package:flutter/material.dart';

class MyClientsScreen extends StatefulWidget {
  const MyClientsScreen({super.key});

  @override
  State<MyClientsScreen> createState() => _MyClientsScreenState();
}

class _MyClientsScreenState extends State<MyClientsScreen> {
  final TextEditingController _serchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
      appBar: CustomAppbar(
        title: 'My Clients',
        backIconVisible: true,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(height: 5),
            CustomSearchField(
                controller: _serchController,
                serchHintText: 'search..by user id ,user name,email'),
            SizedBox(height: 5),
            Expanded(
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) {
                  return CustomCard(
                      child: Column(
                    children: [
                      CustomTextInfo(
                          flex1: 2, flex2: 3, lable: 'ID', value: '#123'),
                      CustomTextInfo(
                          flex1: 2,
                          flex2: 3,
                          lable: 'NAME',
                          value: 'Vishal singh'),
                      CustomTextInfo(
                          flex1: 2,
                          flex2: 3,
                          lable: 'EMAIL',
                          value: 'vishal@gmail.com'),
                      CustomTextInfo(
                          flex1: 2,
                          flex2: 3,
                          lable: 'MOBILE',
                          value: '9898999999'),
                      CustomTextInfo(
                          flex1: 2,
                          flex2: 3,
                          lable: 'REQUEST STATUS',
                          value: 'Accepted by client'),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonButtonWidget(
                            buttonBorderColor: ColorConstants.buttonColor,
                            buttonColor: ColorConstants.white,
                            tileStyle: AppTextStyle().textMediumButtonStyle,
                            buttonWidth: 130,
                            buttonTitle: 'Documents',
                            onTap: () {},
                          ),
                          CommonButtonWidget(
                            buttonWidth: 100,
                            buttonTitle: 'View',
                            onTap: () {},
                          )
                        ],
                      )

                      // CustomTextItem(lable: 'ID', value: '#123'),
                      // CustomTextItem(lable: 'NAME', value: 'GST service'),
                      // CustomTextItem(lable: 'EMAIL', value: 'gst number'),
                      // CustomTextItem(lable: 'MOBILE', value: '99195676586'),
                      // CustomTextItem(
                      // lable: 'REQUEST STATUS', value: 'Accepted by clint'),
                    ],
                  ));
                },
              ),
            )
          ],
        ),
      ),
    );
  }

}
