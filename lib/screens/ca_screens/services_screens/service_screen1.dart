import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_bottomsheet_modal.dart';
import 'package:ca_app/widgets/custom_card.dart';
import 'package:ca_app/widgets/custom_dropdown_button.dart';
import 'package:ca_app/widgets/custom_search_field.dart';
import 'package:ca_app/widgets/custom_text_info.dart';
import 'package:ca_app/widgets/custom_text_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ServiceScreen1 extends StatefulWidget {
  const ServiceScreen1({super.key});

  @override
  State<ServiceScreen1> createState() => _ServiceScreen1State();
}

class _ServiceScreen1State extends State<ServiceScreen1> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  String? selectedService;
  String? selectedSubService;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              Expanded(
                child: CustomSearchField(
                    controller: _searchController,
                    serchHintText:
                        'Search..by service name,subservice name,id'),
              ),
              SizedBox(width: 10),
              CustomBottomsheetModal(
                  buttonHieght: 48,
                  buttonWidth: 130,
                  buttonTitle: 'Add Service',
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
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
                                icon: Icon(Icons.close)),
                          ),
                          Text('Select Service',
                              style: AppTextStyle().labletext),
                          SizedBox(height: 5),
                          CustomDropdownButton(
                            dropdownItems: ['PAN NUMBER', 'AADHAR NUMBAR'],
                            initialValue: selectedService,
                            hintText: 'Select service',
                            validator: (p0) {
                              if (p0 == null || p0.isEmpty) {
                                return 'Please select service';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          Text('Select Sub Service',
                              style: AppTextStyle().labletext),
                          SizedBox(height: 5),
                          CustomDropdownButton(
                            dropdownItems: ['PAN NUMBER', 'AADHAR NUMBAR'],
                            initialValue: selectedSubService,
                            hintText: 'Select sub service',
                            validator: (p0) {
                              if (p0 == null || p0.isEmpty) {
                                return 'Please select sub service';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 15),
                          CommonButtonWidget(
                            buttonTitle: 'ADD SERVICE',
                            onTap: () {
                              if (_formKey.currentState!.validate()) {}
                            },
                          )
                        ],
                      ),
                    ),
                  ))
            ],
          ),
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
                          flex: 2,
                          child: CustomTextItem(lable: 'Id', value: '#234')),
                      Expanded(
                          flex: 3,
                          child: CustomTextItem(
                              lable: 'Created date', value: '04/02/2025'))
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
                      lable: 'SubService Name',
                      value: 'Panjhdjd Number'),
                  CustomTextInfo(
                      flex1: 2,
                      flex2: 3,
                      lable: 'Services Description',
                      value: 'Pan Number vfddsc dwdsdas'),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: CommonButtonWidget(
                      buttonWidth: 100,
                      buttonheight: 45,
                      buttonBorderColor: ColorConstants.darkRedColor,
                      tileStyle: AppTextStyle().getredText,
                      buttonColor: ColorConstants.white,
                      buttonTitle: 'Delete',
                      onTap: () {},
                    ),
                  )
                ],
              ));
            },
          ),
        )
      ],
    );
  }
}
