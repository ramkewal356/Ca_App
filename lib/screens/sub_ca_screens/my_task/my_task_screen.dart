import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_card.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/custom_search_field.dart';
import 'package:ca_app/widgets/custom_text_info.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyTaskScreen extends StatefulWidget {
  const MyTaskScreen({super.key});

  @override
  State<MyTaskScreen> createState() => _MyTaskScreenState();
}

class _MyTaskScreenState extends State<MyTaskScreen> {
  final TextEditingController _serchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
      appBar: CustomAppbar(
        title: 'My Tasks',
        backIconVisible: true,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(height: 5),

            CustomSearchField(
                controller: _serchController,
                serchHintText: 'search..by id ,service name,subservice name'),
            SizedBox(height: 5),
            Expanded(
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      CustomCard(
                          child: Column(
                        children: [
                          CustomTextInfo(
                              flex1: 2,
                              flex2: 3,
                              lable: 'TASK ID',
                              value: '#123'),
                          CustomTextInfo(
                              flex1: 2,
                              flex2: 3,
                              lable: 'ASSIGNED DATE',
                              value: 'GST service'),
                          CustomTextInfo(
                              flex1: 2,
                              flex2: 3,
                              lable: 'TASK NAME',
                              value: 'gst number'),
                          CustomTextInfo(
                              flex1: 2,
                              flex2: 3,
                              lable: 'ASSIGNEE NAME',
                              value: 'Vishal Singh'),
                          CustomTextInfo(
                              flex1: 2,
                              flex2: 3,
                              lable: 'CLIENT EMAIL',
                              value: 'ramk@shilshatech.com'),
                          CustomTextInfo(
                              flex1: 2,
                              flex2: 3,
                              lable: 'DESCRIPTION',
                              value: 'vbncvncb jccnb hjbcbcbnm '),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                decoration: BoxDecoration(
                                    color: ColorConstants.greenColor,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Text(
                                  'COMPLETED',
                                  style: AppTextStyle().buttontext,
                                ),
                              ),
                              CommonButtonWidget(
                                buttonWidth: 100,
                                buttonTitle: 'View',
                                onTap: () {
                                  context.push('/subca_dashboard/task_view');
                                },
                              )
                            ],
                          )
                        ],
                      )),
                      Positioned(
                        top: 10,
                        right: 0,
                        child: PopupMenuButton<String>(
                          position: PopupMenuPosition.under,
                          color: ColorConstants.white,
                          padding: EdgeInsets.zero,
                          menuPadding: EdgeInsets.zero,
                          icon: Icon(Icons.more_vert), // Custom icon
                          onSelected: (value) {
                            debugPrint("Selected: $value");
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                                height: 45,
                                value: 'ACCEPTED',
                                child: Text('ACCEPTED')),
                            PopupMenuItem<String>(
                                height: 45,
                                value: 'REJECTED',
                                child: Text('REJECTED')),
                            PopupMenuItem<String>(
                                height: 45,
                                value: 'COMPLETED',
                                child: Text('COMPLETED')),
                          ],
                        ),
                      )
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
