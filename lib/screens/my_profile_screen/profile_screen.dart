
import 'package:ca_app/blocs/auth/auth_bloc.dart';
import 'package:ca_app/blocs/auth/auth_event.dart';
import 'package:ca_app/blocs/auth/auth_state.dart';
import 'package:ca_app/blocs/image_picker/image_picker_bloc.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/utils/constanst/validator.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_bottomsheet_image_modal.dart';
import 'package:ca_app/widgets/custom_dropdown_button.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/custom_phone_field.dart';
import 'package:ca_app/widgets/custom_search_location.dart';
import 'package:ca_app/widgets/image_picker.dart';
import 'package:ca_app/widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pancardController = TextEditingController();
  final TextEditingController _adharcardController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final FocusNode _addharFocus = FocusNode();
  String countryCode = '91';
  String? selectedGender;
  String imageUrl = '';
  String companyLogoUrl = '';
  String userId = '';
 
  @override
  void initState() {
    getUser();
    super.initState();
  }

  Future<void> getUser() async {
    context.read<AuthBloc>().add(GetUserByIdEvent());
  }

  @override
  void dispose() {
    _addharFocus.dispose();
    _adharcardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UpdateUserSuccess) {
          getUser();
          _addharFocus.unfocus();
        }
      },
      builder: (context, state) {
        if (state is GetUserByIdSuccess) {
          var data = state.getUserByIdData?.data;
          userId = data?.id.toString() ?? '';
          _firstNameController.text = data?.firstName ?? '';
          _lastNameController.text = data?.lastName ?? '';
          _emailController.text = data?.email ?? '';
          countryCode = data?.countryCode ?? '91';
          _phoneController.text = data?.mobile ?? '';
          selectedGender = data?.gender;
          imageUrl = data?.profileUrl ?? '';
          _pancardController.text = data?.panCardNumber ?? '';
          _adharcardController.text = data?.aadhaarCardNumber ?? '';
          _locationController.text = data?.address ?? '';
          companyLogoUrl = data?.companyLogo ?? '';
        }
        return CustomLayoutPage(
          appBar: CustomAppbar(
            title: 'My Profile',
            backIconVisible: true,
          ),
          onRefresh: () async {
            getUser();
          },
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    SizedBox(
                      height: 160,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            height: 130,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color:
                                    ColorConstants.buttonColor.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(5)),
                          ),
                          Positioned(
                              left: 8,
                              top: 8,
                              child: CircleAvatar(
                                radius: 32,
                                backgroundColor: ColorConstants.white,
                                child: CircleAvatar(
                                  radius: 30,
                                  child: ClipOval(
                                      child: Image.network(companyLogoUrl)),
                                ),
                              )),
                          Positioned(
                              right: 10,
                              top: 10,
                              child: Row(
                                    children: [
                                      Text(
                                        'Edit Firm Logo..',
                                        style: AppTextStyle().buttontext,
                                      ),
                                      CustomBottomsheetImageModal(
                                        icon: Icon(
                                          Icons.edit,
                                          color: ColorConstants.white,
                                        ),
                                      )
                                    ],
                              )),
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
                              return Positioned(
                                top: 60,
                                left: 0,
                                right: 0,
                                child: Center(
                                    child: Container(
                                  height: 125,
                                  width: 125,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          width: 4,
                                          color: ColorConstants.white)),
                                  child: ImagePickerWidget(
                                    userImg: imageUrl,
                                    initialImage: null,
                                  ),
                                )),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 80),
                    Text('First Name', style: AppTextStyle().labletext),
                    SizedBox(height: 5),
                    TextformfieldWidget(
                        readOnly: true,
                        controller: _firstNameController,
                        hintText: 'First name'),
                    SizedBox(height: 10),
                    Text('Last Name', style: AppTextStyle().labletext),
                    SizedBox(height: 5),
                    TextformfieldWidget(
                        readOnly: true,
                        controller: _lastNameController,
                        hintText: 'Last name'),
                    SizedBox(height: 10),
                    Text('Email', style: AppTextStyle().labletext),
                    SizedBox(height: 5),
                    TextformfieldWidget(
                      readOnly: true,
                      fillColor: ColorConstants.white,
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      hintText: 'Enter email id',
                      // validator: (email) {
                      //   return ValidatorClass.validateEmail(email);
                      // },
                    ),
                    SizedBox(height: 10),
                    Text('Mobile No', style: AppTextStyle().labletext),
                    SizedBox(height: 5),
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
                        debugPrint('complete phone number ${country.name}');
                      },
                      validator: (value) {
                        if (value == null || value.completeNumber.isEmpty) {
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
                    SizedBox(height: 10),
                    Text('Select Gender', style: AppTextStyle().labletext),
                    SizedBox(height: 5),
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
                    Text('Pan Card', style: AppTextStyle().labletext),
                    SizedBox(height: 5),
                    TextformfieldWidget(
                      readOnly:
                          _pancardController.text.isNotEmpty ? true : false,
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
                    Text('Aadhar Card', style: AppTextStyle().labletext),
                    SizedBox(height: 5),
                    TextformfieldWidget(
                      readOnly:
                          _adharcardController.text.isNotEmpty ? true : false,
                      controller: _adharcardController,
                      focusNode: _addharFocus,
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
                    Text('Location', style: AppTextStyle().labletext),
                    SizedBox(height: 5),
                    CustomSearchLocation(
                        controller: _locationController,
                        state: '',
                        hintText: 'Select location'),
                    SizedBox(height: 10),
                    SizedBox(height: 20),
                    BlocConsumer<AuthBloc, AuthState>(
                      listener: (context, state) {
                        // if (state is RegisterSuccess) {
                        //   context.push('/login');
                        // }
                      },
                      builder: (context, state) {
                        return CommonButtonWidget(
                            loader: state is AuthLoading,
                            buttonTitle: 'Save & Update',
                            onTap: () {
                              debugPrint('selected Value $countryCode');
                              debugPrint(
                                  'phone number ${_phoneController.text}');

                              if (_formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(UpdateUserEvent(
                                    userId: userId,
                                    email: _emailController.text,
                                    gender: selectedGender ?? '',
                                    mobile: _phoneController.text,
                                    firstName: _firstNameController.text,
                                    lastName: _lastNameController.text,
                                    panCard: _pancardController.text,
                                    addharCard: _adharcardController.text,
                                    address: _locationController.text));
                              }
                            });
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
