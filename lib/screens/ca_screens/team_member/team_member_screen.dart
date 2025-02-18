import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/utils/constanst/validator.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_bottomsheet_modal.dart';
import 'package:ca_app/widgets/custom_card.dart';
import 'package:ca_app/widgets/custom_filter_popup.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/custom_phone_field.dart';
import 'package:ca_app/widgets/custom_search_field.dart';
import 'package:ca_app/widgets/custom_text_item.dart';
import 'package:ca_app/widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TeamMemberScreen extends StatefulWidget {
  const TeamMemberScreen({super.key});

  @override
  State<TeamMemberScreen> createState() => _TeamMemberScreenState();
}

class _TeamMemberScreenState extends State<TeamMemberScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String countryCode = '91';
  Map<String, bool> filters = {
    "All": false,
    "Active": false,
    "Inactive": false,
  };
  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
        appBar: CustomAppbar(
          title: 'Team Member',
          backIconVisible: true,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
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
                    SizedBox(width: 5),
                    CustomFilterPopup(
                      filterTitle: 'All',
                      filterIcon: Icon(Icons.filter_list_rounded),
                      filterItems: ['All', 'Active', 'Inactive'],
                      selectedFilters: filters,
                      onFilterChanged: (value) {
                        setState(() {
                          filters = value;
                        });
                        print("Updated Filters: $filters");
                      },
                    ),
                    SizedBox(width: 10),
                    CustomBottomsheetModal(
                        buttonHieght: 48,
                        buttonWidth: 130,
                        buttonTitle: 'ADD TEAM',
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Add Team Member',
                                      style: AppTextStyle().headingtext,
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          context.pop();
                                        },
                                        icon: Icon(Icons.close)),
                                  ],
                                ),
                                Text('First Name',
                                    style: AppTextStyle().labletext),
                                SizedBox(height: 5),
                                TextformfieldWidget(
                                  controller: _firstNameController,
                                  hintText: 'Enter first name',
                                  validator: (p0) {
                                    if (p0 == null || p0.isEmpty) {
                                      return 'Please enter first name';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 10),
                                Text('Last Name',
                                    style: AppTextStyle().labletext),
                                SizedBox(height: 5),
                                TextformfieldWidget(
                                  controller: _lastNameController,
                                  hintText: 'Enter last Name',
                                  validator: (p0) {
                                    if (p0 == null || p0.isEmpty) {
                                      return 'Please enter last name';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 10),
                                Text('Email', style: AppTextStyle().labletext),
                                SizedBox(height: 5),
                                TextformfieldWidget(
                                  controller: _emailController,
                                  hintText: 'Enter email',
                                  validator: (p0) {
                                    if (p0 == null || p0.isEmpty) {
                                      return 'Please enter email';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 10),
                                Text('Mobile No',
                                    style: AppTextStyle().labletext),
                                SizedBox(height: 5),
                                CustomPhoneField(
                                  intialCountryCode: countryCode,
                                  controller: _phoneController,
                                  onChanged: (phone) {
                                    debugPrint(
                                        'complete phone number ${phone.completeNumber}');
                                  },
                                  onCountryChanged: (country) {
                                    setState(() {
                                      countryCode = country.dialCode;
                                    });
                                    debugPrint(
                                        'complete phone number ${country.name}');
                                  },
                                  validator: (value) {
                                    if (value == null ||
                                        value.completeNumber.isEmpty) {
                                      return 'Please enter phone number';
                                    } else if (value.completeNumber.length <
                                            10 ||
                                        value.completeNumber.length > 15) {
                                      return 'Please enter a valid phone number';
                                    } else {
                                      var isValid =
                                          ValidatorClass.isValidMobile(
                                              value.completeNumber);
                                      if (!isValid) {
                                        return 'Please enter a valid phone number';
                                      }
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 15),
                                CommonButtonWidget(
                                  buttonTitle: 'ADD TEAM',
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
                          children: [
                            Expanded(
                                child: CustomTextItem(
                                    lable: 'UserId', value: '#234')),
                            Expanded(
                                child: CustomTextItem(
                                    inOneLinetext: true,
                                    lable: 'Full Name',
                                    value: 'Vishal kumar '))
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: CustomTextItem(
                                    lable: 'Assignee to', value: '#234')),
                            Expanded(
                                child: CustomTextItem(
                                    lable: 'Mobile', value: '99891871247'))
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: CustomTextItem(
                                    lable: 'Status', value: 'active')),
                            Expanded(
                                child: CustomTextItem(
                                    lable: 'Acceptance', value: 'ACCEPTED'))
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // CommonButtonWidget(
                            //   buttonBorderColor: ColorConstants.buttonColor,
                            //   buttonColor: ColorConstants.white,
                            //   tileStyle: AppTextStyle().textMediumButtonStyle,
                            //   buttonWidth: 120,
                            //   buttonTitle: 'Request',
                            //   onTap: () {
                            //     context.push('/raise_request',
                            //         extra: {'role': 'CA'});
                            //   },
                            // ),
                            CommonButtonWidget(
                              buttonWidth: 100,
                              buttonTitle: 'View',
                              onTap: () {
                                context.push('/ca_dashboard/view_team_member');
                              },
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
        ));
  }
}
