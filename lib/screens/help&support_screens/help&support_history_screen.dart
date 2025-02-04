import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_card.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/custom_text_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HelpAndSupportHistoryScreen extends StatefulWidget {
  const HelpAndSupportHistoryScreen({super.key});

  @override
  State<HelpAndSupportHistoryScreen> createState() =>
      _HelpAndSupportHistoryScreenState();
}

class _HelpAndSupportHistoryScreenState
    extends State<HelpAndSupportHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
      appBar: CustomAppbar(
        title: 'Help & Supprot History',
        backIconVisible: true,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return CustomCard(
                      child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child:
                                  CustomTextItem(lable: 'ID', value: '#245')),
                          // Spacer(),
                          Row(
                            children: [
                              Text(
                                'Status : ',
                                style: AppTextStyle().lableText,
                              ),
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
                              )
                            ],
                          )
                        ],
                      ),
                      CustomTextItem(lable: 'SUBJECT', value: 'nnvcbcvbbv'),
                      CustomTextItem(lable: 'MESSAGE', value: 'nnvcbcvbbv'),
                      CustomTextItem(lable: 'COMMENT', value: 'nnvcbcvbbv'),
                      CustomTextItem(lable: 'CREATE DATE', value: 'nnvcbcvbbv'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Container(
                          //   height: 45,
                          //   decoration: BoxDecoration(
                          //       color: ColorConstants.greenColor,
                          //       borderRadius: BorderRadius.circular(8)),
                          //   child: Padding(
                          //     padding: const EdgeInsets.symmetric(
                          //         vertical: 5, horizontal: 10),
                          //     child: Center(
                          //       child: Text(
                          //         'Resolved',
                          //         style: AppTextStyle().statustext,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          CommonButtonWidget(
                              buttonWidth: 100,
                              buttonheight: 45,
                              buttonTitle: 'View',
                              onTap: () {
                                context.push('/view_history');
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
