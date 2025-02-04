import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_card.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/custom_text_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class YourRequestScreen extends StatefulWidget {
  const YourRequestScreen({super.key});

  @override
  State<YourRequestScreen> createState() => _YourRequestScreenState();
}

class _YourRequestScreenState extends State<YourRequestScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
      appBar: CustomAppbar(
        title: 'Your Request',
        backIconVisible: true,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    border: OutlineInputBorder(),
                    hintText: 'Search'),
              ),
              SizedBox(height: 10),
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
                                  CustomTextItem(lable: 'ID', value: '#432')),
                          Expanded(
                              child: CustomTextItem(
                                  lable: 'DATE', value: '29/01/2025')),
                        ],
                      ),
                      CustomTextItem(lable: 'CA (RECEIVER)', value: 'vishal'),
                      CustomTextItem(lable: 'CLIENT (SENDER)', value: 'Vinay'),
                      CustomTextItem(
                          lable: 'DESCRIPTION',
                          value: 'vgghghjg ghghg gghjg g'),
                      Align(
                          alignment: Alignment.bottomRight,
                          child: CommonButtonWidget(
                              buttonWidth: 100,
                              buttonTitle: 'View',
                              onTap: () {
                                context.push('/request_details');
                              }))
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
