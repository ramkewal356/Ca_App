import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_card.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/custom_text_item.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
        appBar: CustomAppbar(
          title: 'Documents History',
          backIconVisible: true,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Documents',
                      style: AppTextStyle().textButtonStyle,
                    ),
                    Text(
                      '5',
                      style: AppTextStyle().labletext,
                    )
                  ],
                ),
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
                                flex: 2,
                                child: CustomTextItem(lable: 'ID', value: '1')),
                            Expanded(
                                flex: 4,
                                child: CustomTextItem(
                                    lable: 'CREATED DATE', value: '23/01/2023'))
                          ],
                        ),
                        CustomTextItem(
                            lable: 'DOCUMENT NAME', value: 'jdbjhdjhj'),
                        CustomTextItem(
                            lable: 'CATEGORY', value: 'dhjbjhjdhvjdv'),
                        CustomTextItem(
                            lable: 'SU CATEGORY', value: 'dhjbjhjdhvjdv'),
                        CustomTextItem(
                            lable: 'DOWNLOAD', value: 'dhjbjhjdhvjdv'),
                        SizedBox(height: 5),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: CommonButtonWidget(
                              buttonWidth: 100,
                              buttonheight: 50,
                              buttonTitle: 'View',
                              onTap: () {}),
                        )
                      ],
                    ));
                  },
                )
              ],
            ),
          ),
        ));
  }
}
