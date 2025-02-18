import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_card.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/custom_search_field.dart';
import 'package:ca_app/widgets/custom_text_info.dart';
import 'package:flutter/material.dart';

class ViewDocumentScreen extends StatefulWidget {
  const ViewDocumentScreen({super.key});

  @override
  State<ViewDocumentScreen> createState() => _ViewDocumentScreenState();
}

class _ViewDocumentScreenState extends State<ViewDocumentScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> filterItems = ['All', 'Active', 'Inactive'];
  List<String> selectedFilters = [];
  bool all = false;
  bool active = false;
  bool inActive = false;
  void _updateSelection(String filter, bool? value, StateSetter setStatePopup) {
    if (filter == "All") {
      if (value == true) {
        all = true;
        active = true;
        inActive = true;
      } else {
        all = false;
        active = false;
        inActive = false;
      }
    } else if (filter == "Active") {
      active = value ?? false;
      inActive = false;
      all = active && inActive;
    } else if (filter == "InActive") {
      inActive = value ?? false;
      active = false;
      all = active && inActive;
    }
    setStatePopup(() {}); // Updates Popup UI
    setState(() {}); // Updates main UI
  }

  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
      appBar: CustomAppbar(
        title: 'View Document',
        backIconVisible: true,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(children: [
                  Expanded(
                    child: CustomSearchField(
                        controller: _searchController,
                        serchHintText:
                            'Search..by service name,subservice name,id'),
                  ),
                  SizedBox(width: 10),
                  PopupMenuButton<String>(
                      position: PopupMenuPosition.under,
                      color: ColorConstants.white,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      constraints: BoxConstraints(minWidth: 150, maxWidth: 150),
                      offset: Offset(0, 0),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          children: [
                            Text(
                              'All',
                              style: AppTextStyle().cardValueText,
                            ),
                            Icon(
                              Icons.filter_alt_outlined,
                              // ignore: deprecated_member_use
                              color: ColorConstants.black.withOpacity(0.5),
                            )
                          ],
                        ),
                      ),
                      onSelected: (value) {},
                      itemBuilder: (BuildContext context) {
                        return <PopupMenuEntry<String>>[
                          PopupMenuItem(
                            padding: EdgeInsets.zero,
                            enabled: false,
                            child: StatefulBuilder(
                              builder: (context, setStatePopup) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _buildCheckListTiel(
                                      context,
                                      'All',
                                      all,
                                      (value) => _updateSelection(
                                          "All", value, setStatePopup),
                                    ),
                                    _buildCheckListTiel(
                                      context,
                                      'Active',
                                      active,
                                      (value) => _updateSelection(
                                          "Active", value, setStatePopup),
                                    ),
                                    _buildCheckListTiel(
                                      context,
                                      'InActive',
                                      inActive,
                                      (value) => _updateSelection(
                                          "InActive", value, setStatePopup),
                                    )
                                  ],
                                );
                              },
                            ),
                          ),
                        ];
                      }),
                ])),
            Row(
              children: [
                Text(
                  'Total Documents',
                  style: AppTextStyle().textButtonStyle,
                ),
                SizedBox(width: 10),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorConstants.buttonColor),
                  child: Text(
                    '0',
                    style: AppTextStyle().buttontext,
                  ),
                )
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) {
                  return CustomCard(
                      child: Column(
                    children: [
                      CustomTextInfo(
                          flex1: 2, flex2: 3, lable: 'ID', value: '#234'),
                      CustomTextInfo(
                          flex1: 2,
                          flex2: 3,
                          lable: 'DOCUMENT NAME',
                          value: 'ID Proof'),
                      CustomTextInfo(
                          flex1: 2,
                          flex2: 3,
                          lable: 'DOCUMENT TYPE',
                          value: 'Aadhar number'),
                      CustomTextInfo(
                          flex1: 2,
                          flex2: 3,
                          lable: 'CREATED DATE',
                          value: '07/02/2025'),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonButtonWidget(
                            buttonWidth: 130,
                            buttonTitle: 'Re-Request',
                            onTap: () {},
                          ),
                          CommonButtonWidget(
                            buttonWidth: 120,
                            buttonColor: ColorConstants.white,
                            buttonBorderColor: ColorConstants.buttonColor,
                            tileStyle: AppTextStyle().textMediumButtonStyle,
                            buttonTitle: 'Download',
                            onTap: () {},
                          )
                        ],
                      )
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

  _buildCheckListTiel(BuildContext context, String title, bool? value,
      void Function(bool?)? onChanged) {
    return CheckboxListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        activeColor: ColorConstants.buttonColor,
        controlAffinity: ListTileControlAffinity.leading,
        value: value,
        title: Text(
          title,
          style: AppTextStyle().lableText,
        ),
        onChanged: onChanged);
  }
}
