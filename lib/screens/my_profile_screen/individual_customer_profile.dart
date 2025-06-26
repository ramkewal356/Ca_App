import 'package:ca_app/blocs/auth/auth_bloc.dart';
import 'package:ca_app/blocs/auth/auth_event.dart';
import 'package:ca_app/blocs/auth/auth_state.dart';
import 'package:ca_app/blocs/image_picker/image_picker_bloc.dart';
import 'package:ca_app/blocs/profile/profile_bloc.dart';
import 'package:ca_app/data/models/get_occupation_list_model.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/utils/constanst/validator.dart';
import 'package:ca_app/utils/utils.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_card.dart';
import 'package:ca_app/widgets/custom_dropdown_button.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/custom_phone_field.dart';
import 'package:ca_app/widgets/custom_search_location.dart';
import 'package:ca_app/widgets/image_picker.dart';
import 'package:ca_app/widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IndividualCustomerProfile extends StatefulWidget {
  const IndividualCustomerProfile({super.key});

  @override
  State<IndividualCustomerProfile> createState() =>
      _IndividualCustomerProfileState();
}

class _IndividualCustomerProfileState extends State<IndividualCustomerProfile> {
  bool isEditable = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pancardController = TextEditingController();
  final TextEditingController _adharcardController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  final TextEditingController _gstController = TextEditingController();
  String? selectedGender;
  String? selectedOccupation;
  String? selectedBusinessType;
  final _dobFocusNode = FocusNode();

  String countryCode = '91';
  int percentage = 80;
  @override
  void initState() {
    super.initState();
  }

  bool isDobSet = false;
  bool isOccupSet = false;
  bool isBussinesSet = false;

  Future<void> getUser() async {
    context.read<AuthBloc>().add(GetUserByIdEvent());
    setState(() {
      isDobSet = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UpdateUserSuccess) {
          Utils.toastSuccessMessage('Profile Updated Successfully');
          if (mounted) {
            setState(() => isEditable = false); // ✅ triggers AppBar rebuild
          }
          getUser();
        } else if (state is UpdateProfileImgSuccess) {
          context.read<ImagePickerBloc>().add(ResetImagePickerEvent());
          if (mounted) {
            setState(() => isEditable = false); // ✅ triggers AppBar rebuild
          }
          getUser();
        } else if (state is AuthErrorState) {
          if (mounted) {
            setState(() => isEditable = false); // ✅ triggers AppBar rebuild
          }
          getUser();
        }
      },
      child: CustomLayoutPage(
        appBar: CustomAppbar(
          title: 'My Profile',
          backIconVisible: true,
          actionIcons: [
            IconButton(
                onPressed: () {
                  setState(() {
                    isEditable = !isEditable;
                  });
                },
                icon: isEditable
                    ? Icon(
                        Icons.close,
                        color: ColorConstants.white,
                      )
                    : Icon(
                        Icons.edit_square,
                        color: ColorConstants.white,
                      ))
          ],
        ),
        onRefresh: () async {
          getUser();
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          buildWhen: (previous, current) =>
              (current is GetUserLoading || current is GetUserByIdSuccess),
          builder: (context, state) {
            if (state is GetUserLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: ColorConstants.buttonColor,
                ),
              );
            } else if (state is GetUserByIdSuccess) {
              var data = state.getUserByIdData?.data;

              // data = state.getUserByIdData?.data;

              _firstNameController.text = data?.firstName ?? '';
              _lastNameController.text = data?.lastName ?? '';
              _emailController.text = data?.email ?? '';
              countryCode = data?.countryCode ?? '91';
              _phoneController.text = data?.mobile ?? '';
              selectedGender = data?.gender ?? '';
              _locationController.text = data?.address ?? '';
              _pancardController.text = data?.panCardNumber ?? '';
              _adharcardController.text = data?.aadhaarCardNumber ?? '';
              _gstController.text = data?.gst ?? '';
              if (!isDobSet && data?.dateOfBirth != null ||
                  (data?.dateOfBirth ?? '').isNotEmpty) {
                _dobController.text = data?.dateOfBirth ?? '';
                isDobSet = true;
              }

              percentage = data?.profileCompletion ?? 0;
              if (!isOccupSet) {
                selectedOccupation = data?.occupation ?? '';
                isOccupSet = true;
              }
              if (!isBussinesSet) {
                selectedBusinessType = data?.typeOfBusiness ?? '';
                isBussinesSet = true;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Text(
                          'Manage your personal information and preferences',
                          style: AppTextStyle().chatButton,
                        ),
                        SizedBox(height: 10),
                        CustomCard(
                            child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BlocConsumer<ImagePickerBloc, ImagePickerState>(
                              listener: (context, state) {
                                if (state is ImagePickedSuccess) {
                                  context.read<AuthBloc>().add(
                                      UpdateProfileImageEvent(
                                          companyLogo: state.companyImage,
                                          imageUrl: state.imageFile));
                                }
                              },
                              builder: (context, state) {
                                return Center(
                                    child: Container(
                                  height: 75,
                                  width: 75,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          width: 4,
                                          color: ColorConstants.white)),
                                  child: ImagePickerWidget(
                                    userImg: data?.profileUrl,
                                    initialImage: null,
                                    isEditable: isEditable,
                                  ),
                                ));
                              },
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${data?.firstName ?? ''} ${data?.lastName ?? ''}',
                                        style: AppTextStyle().textCardStyle,
                                      ),
                                      SizedBox(width: 10),
                                      _commonContainer(text: 'Premium Member')
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    '${data?.email}',
                                    style: AppTextStyle().landingCardTitle,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    '+${data?.countryCode ?? ''} ${data?.mobile ?? ''}',
                                    style: AppTextStyle().landingCardTitle,
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _commonContainer(
                                          text: 'Member since 2023'),
                                      _commonContainer(
                                          text:
                                              'Profile ${percentage.round()}% Complete',
                                          color: data?.profileCompletion == 100
                                              ? ColorConstants.greenColor
                                              : null)
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        )),
                        CustomCard(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            cardTitile(
                                icon: Icons.person,
                                title: 'Persional information'),
                            SizedBox(height: 15),
                            lableText('First Name'),
                            TextformfieldWidget(
                                readOnly: true,
                                controller: _firstNameController,
                                hintText: 'Enter first name'),
                            SizedBox(height: 10),
                            lableText('Last Name'),
                            TextformfieldWidget(
                                readOnly: true,
                                controller: _lastNameController,
                                hintText: 'Enter last name'),
                            SizedBox(height: 10),
                            lableText('Date of Birth'),
                            TextformfieldWidget(
                              readOnly: true,
                              controller: _dobController,
                              focusNode: _dobFocusNode,
                              hintText: 'Select date of birth ',
                              validator: (p0) {
                                if (p0 == null || p0.isEmpty) {
                                  return 'Please select date of birth';
                                }
                                return null;
                              },
                              onTap: () async {
                                String? dob = await selectDateOfBirth(context);
                                if (dob != null) {
                                  _dobController.text = dob;
                                }
                              },
                            ),
                            SizedBox(height: 10),
                            lableText('Gender *'),
                            CustomDropdownButton(
                              hintText: 'Select gender',
                              fillColor: ColorConstants.white,
                              initialValue: selectedGender,
                              dropdownItems: ['Male', 'Female', 'Other'],
                              onChanged: (p0) {
                                setState(() {
                                  selectedGender = p0;
                                  debugPrint('BBNdjhfdhjdhjj$selectedGender');
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select gender';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            lableText('Occupation *'),
                            BlocProvider(
                              create: (context) =>
                                  ProfileBloc()..add(GetOccupationEvent()),
                              child: BlocBuilder<ProfileBloc, ProfileState>(
                                builder: (context, state) {
                                  List<OccupationData> data = state
                                          is GetOccupationSuccess
                                      ? state.getOccupationLIstModel.data ?? []
                                      : [];
                                  return CustomDropdownButton(
                                    hintText: 'Select occupation',
                                    fillColor: ColorConstants.white,
                                    initialValue: selectedOccupation,
                                    dropdownItems: data
                                        .map((toElement) =>
                                            toElement.occupationName ?? '')
                                        .toList(),
                                    onChanged: (p0) {
                                      setState(() {
                                        selectedOccupation = p0;
                                        debugPrint(
                                            'Occupation  $selectedOccupation');
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select occupation';
                                      }
                                      return null;
                                    },
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        )),
                        CustomCard(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            cardTitile(
                                icon: Icons.email_outlined,
                                title: 'Contact Information'),
                            SizedBox(height: 10),
                            lableText('Email Address *'),
                            TextformfieldWidget(
                              readOnly: true,
                              controller: _emailController,
                              hintText: 'Enter email address',
                              validator: (p0) {
                                return ValidatorClass.validateEmail(p0);
                              },
                            ),
                            SizedBox(height: 10),
                            lableText('Address'),
                            CustomSearchLocation(
                                controller: _locationController,
                                state: '',
                                hintText: 'Select address'),
                            SizedBox(height: 10),
                            lableText('Phone Number *'),
                            CustomPhoneField(
                              readOnly: true,
                              intialCountryCode: countryCode,
                              // focusNode: _focusNode,
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
                                } else if (value.completeNumber.length < 10 ||
                                    value.completeNumber.length > 15) {
                                  return 'Please enter a valid phone number';
                                } else {
                                  var isValid = ValidatorClass.isValidMobile(
                                      value.completeNumber);
                                  if (!isValid) {
                                    return 'Please enter a valid phone number';
                                  }
                                }
                                return null;
                              },
                            ),
                          ],
                        )),
                        CustomCard(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            cardTitile(
                                icon: Icons.settings,
                                title: 'Tax & Business Information'),
                            SizedBox(height: 10),
                            lableText('PAN Number'),
                            TextformfieldWidget(
                              readOnly: _pancardController.text.isNotEmpty
                                  ? true
                                  : false,
                              controller: _pancardController,
                              hintText: '******',
                              validator: (p0) {
                                if (p0 == null || p0.isEmpty) {
                                  return 'Please enter pan card';
                                } else if (!ValidatorClass.isValidPanCard(p0)) {
                                  return 'Please enter valid pan card';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            lableText('Gst Number (Optional)'),
                            TextformfieldWidget(
                              // readOnly: true,
                              fillColor: ColorConstants.white,
                              controller: _gstController,
                              hintText: 'Enter gst number',
                            ),
                            SizedBox(height: 10),
                            lableText('Aadhar Number'),
                            TextformfieldWidget(
                              readOnly: !isEditable
                                  ? true
                                  : _adharcardController.text.isNotEmpty
                                      ? true
                                      : false,
                              controller: _adharcardController,
                              // focusNode: _addharFocus,
                              hintText: 'xxx-xxxx-yyyyy',
                              validator: (p0) {
                                if (p0 == null || p0.isEmpty) {
                                  return 'Please enter addhar card';
                                } else if (!ValidatorClass.isValidAadhaar(p0)) {
                                  return 'Please enter valid addhar card';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            lableText('Business Type'),
                            CustomDropdownButton(
                              hintText: 'Select gender',
                              fillColor: ColorConstants.white,
                              initialValue: selectedBusinessType,
                              dropdownItems: [
                                'Sole Proprietorship',
                                'Partnership',
                                'Limited Liability Partnership (LLP)',
                                'Private Limited Company (Pvt Ltd)',
                                'Public Limited Company',
                                'One Person Company (OPC)',
                                'Non-Profit / NGO',
                                'Trust',
                                'Co-operative Society',
                                'Government Entity',
                                'Franchise',
                                'Freelancer / Consultant',
                                'Startup',
                                'Joint Venture',
                                'HUF (Hindu Undivided Family)'
                              ],
                              onChanged: (p0) {
                                setState(() {
                                  selectedBusinessType = p0;
                                  debugPrint(
                                      'Bussiness type $selectedBusinessType');
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select business type';
                                }
                                return null;
                              },
                            ),
                          ],
                        )),
                        SizedBox(height: 8),
                        Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color:
                                    // ignore: deprecated_member_use
                                    ColorConstants.buttonColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                cardTitile(
                                    icon: Icons.card_membership_outlined,
                                    title: 'Profile Completion'),
                                SizedBox(height: 10),
                                Text(
                                  'Complete your profile to get better service recommendations',
                                  style: AppTextStyle().landingCardSubTitle,
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                        child: LinearProgressIndicator(
                                      value: percentage / 100,
                                      minHeight: 15,
                                      borderRadius: BorderRadius.circular(8),
                                      backgroundColor: ColorConstants.darkGray,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        ColorConstants
                                            .buttonColor, // Dark progress bar color
                                      ),
                                    )),
                                    SizedBox(width: 10),
                                    Text(
                                      '${percentage.round()}%',
                                      style: AppTextStyle().textCardStyle,
                                    )
                                  ],
                                )
                              ],
                            )),
                        SizedBox(height: 5),
                        isEditable
                            ? BlocBuilder<AuthBloc, AuthState>(
                                buildWhen: (_, curr) =>
                                    curr is AuthLoading ||
                                    curr is UpdateUserSuccess,
                                builder: (context, state) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: CommonButtonWidget(
                                      buttonheight: 45,
                                      buttonTitle: 'Save & Update',
                                      loader: state is AuthLoading,
                                      onTap: () {
                                        Map<String, dynamic> body = {
                                          "userId": data?.id,
                                          "firstname":
                                              _firstNameController.text,
                                          "lastname": _lastNameController.text,
                                          "dateOfBirth": _dobController.text,
                                          "gender": selectedGender,
                                          "occupation": selectedOccupation,
                                          "email": _emailController.text,
                                          "address": _locationController.text,
                                          "mobile": _phoneController.text,
                                          "panCardNumber":
                                              _pancardController.text,
                                          "gst": _gstController.text,
                                          "aadhaarCardNumber":
                                              _adharcardController.text,
                                          "typeOfBusiness": selectedBusinessType
                                        };

                                        if (_formKey.currentState!.validate()) {
                                          context.read<AuthBloc>().add(
                                              UpdateCaProfileEvent(body: body));
                                        }
                                      },
                                    ),
                                  );
                                },
                              )
                            : SizedBox.shrink(),
                        SizedBox(height: 5)
                      ],
                    ),
                  ),
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  cardTitile({required IconData icon, required String title}) {
    return Row(
      children: [
        Icon(
          icon,
          color: ColorConstants.buttonColor,
        ),
        SizedBox(width: 5),
        Text(
          title,
          style: AppTextStyle().textButtonStyle,
        )
      ],
    );
  }

  lableText(String lable) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(
        lable,
        style: AppTextStyle().textCardStyle,
      ),
    );
  }

  _commonContainer({required String text, Color? color}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          border: Border.all(color: color ?? ColorConstants.buttonColor),
          borderRadius: BorderRadius.circular(10)),
      child: Text(
        text,
        style: color == null
            ? AppTextStyle().titletext8
            : AppTextStyle().titletext8green,
      ),
    );
  }
}

class User {
  final String name;
  final int id;

  User({required this.name, required this.id});

  @override
  String toString() {
    return 'User(name: $name, id: $id)';
  }
}
