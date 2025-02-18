import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/custom_card.dart';
import 'package:ca_app/widgets/custom_search_field.dart';
import 'package:ca_app/widgets/custom_text_info.dart';
import 'package:ca_app/widgets/custom_text_item.dart';
import 'package:flutter/material.dart';

class ViewPreviousScreen extends StatefulWidget {
  const ViewPreviousScreen({super.key});

  @override
  State<ViewPreviousScreen> createState() => _ViewPreviousScreenState();
}

class _ViewPreviousScreenState extends State<ViewPreviousScreen> {
  final TextEditingController _searchcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: CustomSearchField(
              controller: _searchcontroller,
              serchHintText: 'Search..by service name,sub service,id'),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 6,
            itemBuilder: (context, index) {
              return CustomCard(
                  child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: CustomTextItem(lable: 'ID', value: '#245')),
                      // Spacer(),
                      Row(
                        children: [
                          // Text(
                          //   'Status : ',
                          //   style: AppTextStyle().lableText,
                          // ),
                          Container(
                            decoration: BoxDecoration(
                                color:
                                    // ignore: deprecated_member_use
                                    ColorConstants.greenColor.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: Text(
                                'Accepted',
                                style: AppTextStyle().statustext,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  CustomTextInfo(
                      flex1: 2,
                      flex2: 3,
                      lable: 'Service Name',
                      value: 'Pan Number'),
                  CustomTextInfo(
                      flex1: 2,
                      flex2: 3,
                      lable: 'Sub Service Name', value: 'Pan Number'),
                  CustomTextInfo(
                      flex1: 2,
                      flex2: 3,
                      lable: 'Created date',
                      value: '04/02/2025'),
                  CustomTextInfo(
                      flex1: 2,
                      flex2: 3,
                      lable: 'Service Description', value: 'Pan Number'),
                ],
              ));
            },
          ),
        )
      ],
    );
  }
}
