import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/custom_search_field.dart';
import 'package:ca_app/widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ViewTeamMemberScreen extends StatefulWidget {
  const ViewTeamMemberScreen({super.key});

  @override
  State<ViewTeamMemberScreen> createState() => _ViewTeamMemberScreenState();
}

class _ViewTeamMemberScreenState extends State<ViewTeamMemberScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  ScrollController controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
        appBar: CustomAppbar(
          title: 'View Team Member',
          backIconVisible: true,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Vishwas kumar',
                      style: AppTextStyle().headingtext,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: ColorConstants.buttonColor,
                          borderRadius: BorderRadius.circular(8)),
                      child: PopupMenuButton<String>(
                        position: PopupMenuPosition.under,
                        color: ColorConstants.white,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        constraints:
                            BoxConstraints(minWidth: 90, maxWidth: 140),
                        offset: Offset(0, 0),
                        icon: Row(
                          children: [
                            Text(
                              'More options',
                              style: AppTextStyle().buttontext,
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: ColorConstants.white,
                            )
                          ],
                        ), // Custom icon
                        onSelected: (value) {
                          debugPrint("Selected: $value");
                          if (value == 'Deactive') {
                            _showModalBottomSheet();
                          }
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                              height: 45,
                              value: 'Deactive',
                              child: SizedBox(
                                  width: 120, child: Text('Deactive'))),
                          PopupMenuItem<String>(
                              height: 45,
                              value: 'Logs',
                              child: SizedBox(width: 120, child: Text('Logs'))),
                        ],
                      ),
                    ),
                  ],
                ),
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Column(
                      children: [
                        textItem(lable: 'Pan Card', value: '_'),
                        textItem(lable: 'Aadhaar Card', value: '_'),
                        textItem(lable: 'Created Date', value: '27/01/2028'),
                        textItem(lable: 'Gender', value: 'male'),
                        textItem(lable: 'Status', value: 'Active'),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Total Assigned Clients',
                      style: AppTextStyle().labletext,
                    ),
                    SizedBox(width: 5),
                    Container(
                      decoration: BoxDecoration(
                          color: ColorConstants.buttonColor,
                          shape: BoxShape.circle),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          '0',
                          style: AppTextStyle().smallbuttontext,
                        ),
                      ),
                    )
                  ],
                ),
                CustomSearchField(
                    controller: _searchController, serchHintText: 'search'),
                SizedBox(height: 10),
                Scrollbar(
                  controller: controller,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.only(bottom: 5),
                    controller: controller,
                    child: DataTable(
                        headingRowColor:
                            WidgetStatePropertyAll(ColorConstants.buttonColor),
                        headingTextStyle: AppTextStyle().buttontext,
                        columns: [
                          DataColumn(label: Text('ID')),
                          DataColumn(label: Text('NAME')),
                          DataColumn(label: Text('EMAIL')),
                          DataColumn(label: Text('MOBILE'))
                        ],
                        rows: [
                          DataRow(cells: [
                            DataCell(
                              Text('#1234'),
                            ),
                            DataCell(
                              Text('Ramkewal'),
                            ),
                            DataCell(
                              Text('ramkewal@gmail.com'),
                            ),
                            DataCell(
                              Text('992954721'),
                            )
                          ]),
                          DataRow(cells: [
                            DataCell(
                              Text('#1234'),
                            ),
                            DataCell(
                              Text('Ramkewal'),
                            ),
                            DataCell(
                              Text('ramkewal@gmail.com'),
                            ),
                            DataCell(
                              Text('992954721'),
                            )
                          ])
                        ]),
                  ),
                )
              ],
            ),
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

  Future<void> _showModalBottomSheet() {
    return showModalBottomSheet(
        context: context,
        isDismissible: false,
        backgroundColor: ColorConstants.white,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10),
          ),
        ),
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setstate) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                            onPressed: () {
                              context.pop();
                            },
                            icon: Icon(
                              Icons.close,
                              color: ColorConstants.darkRedColor,
                            )),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text.rich(TextSpan(children: [
                            TextSpan(
                                text: 'Note : ',
                                style: AppTextStyle().cardLableText),
                            TextSpan(
                                text: 'Are you sure you want to ',
                                style: AppTextStyle().cardValueText),
                            TextSpan(
                                text: 'Deactive ?',
                                style: AppTextStyle().getredText)
                          ]))),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: TextformfieldWidget(
                          maxLines: 3,
                          minLines: 3,
                          controller: _descriptionController,
                          hintText: 'Reason...',
                          validator: (p0) {
                            if (p0 == null || p0.isEmpty) {
                              return 'Please enter reason';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: CommonButtonWidget(
                          buttonTitle: 'De-Active',
                          onTap: () {
                            if (_formKey.currentState!.validate()) {}
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }
}
