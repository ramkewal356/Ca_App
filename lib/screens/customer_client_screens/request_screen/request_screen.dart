import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_card.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/custom_text_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
      appBar: CustomAppbar(backIconVisible: true, title: 'Request Documents'),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: 'search',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5))),
                      )),
                  SizedBox(width: 10),
                  CommonButtonWidget(
                      buttonheight: 48,
                      buttonWidth: 150,
                      // buttonColor: ColorConstants.white,
                      // tileStyle: AppTextStyle().textMediumButtonStyle,
                      buttonTitle: 'Raise request',
                      onTap: () {
                        context.push('/raise_request',
                            extra: {'role': 'CUSTOMER'});
                      })
                ],
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return CustomCard(
                      child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child:
                                  CustomTextItem(lable: 'ID', value: '#234')),
                          Expanded(
                              child: CustomTextItem(
                                  lable: 'DATE', value: '28/01/2025'))
                        ],
                      ),
                      CustomTextItem(lable: 'CA NAME', value: 'Vishal kumar'),
                      CustomTextItem(
                          lable: 'DOCUMENT REQUEST', value: 'Submit ID'),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonButtonWidget(
                              buttonColor: ColorConstants.white,
                              tileStyle: AppTextStyle().textMediumButtonStyle,
                              buttonWidth: 150,
                              buttonheight: 45,
                              buttonTitle: 'Upload document',
                              onTap: () {
                                context.push(
                                    '/customer_dashboard/upload_document');
                              }),
                          SizedBox(width: 20),
                          CommonButtonWidget(
                              buttonWidth: 100,
                              buttonheight: 50,
                              buttonTitle: 'View',
                              onTap: () {
                                context.push('/request_details');
                              }),
                        ],
                      )
                    ],
                  ));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
