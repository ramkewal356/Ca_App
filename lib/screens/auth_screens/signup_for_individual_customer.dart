import 'package:ca_app/blocs/auth/auth_bloc.dart';
import 'package:ca_app/blocs/auth/auth_event.dart';
import 'package:ca_app/blocs/auth/auth_state.dart';
import 'package:ca_app/blocs/custom_dropdown/custom_dropdown_bloc.dart';
import 'package:ca_app/utils/assets.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/utils/constanst/validator.dart';
import 'package:ca_app/utils/utils.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_dropdown_button.dart';
import 'package:ca_app/widgets/custom_phone_field.dart';
import 'package:ca_app/widgets/custom_text_button.dart';
import 'package:ca_app/widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignupForIndividualCustomer extends StatefulWidget {
  const SignupForIndividualCustomer({super.key});

  @override
  State<SignupForIndividualCustomer> createState() =>
      _SignupForIndividualCustomerState();
}

class _SignupForIndividualCustomerState
    extends State<SignupForIndividualCustomer> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pancardController = TextEditingController();
  final _focusNode = FocusNode();
  bool obsuceNewPassword = false;
  bool obsuceConfirmPassword = false;
  String? selectedValue;
  String countryCode = '91';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Center(
                  child: Image.asset(
                    splashLogo,
                    height: 150,
                  ),
                ),
                SizedBox(height: 20),
                Text('First Name', style: AppTextStyle().labletext),
                SizedBox(height: 5),
                TextformfieldWidget(
                  controller: _firstNameController,
                  hintText: 'First name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter first name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                Text('Last Name', style: AppTextStyle().labletext),
                SizedBox(height: 5),
                TextformfieldWidget(
                  controller: _lastNameController,
                  hintText: 'Last name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter last name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                Text('Email', style: AppTextStyle().labletext),
                SizedBox(height: 5),
                TextformfieldWidget(
                  fillColor: ColorConstants.white,
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  hintText: 'Enter email id',
                  validator: (email) {
                    return ValidatorClass.validateEmail(email);
                  },
                ),
                SizedBox(height: 10),
                Text('Select Gender', style: AppTextStyle().labletext),
                SizedBox(height: 5),
                CustomDropdownButton(
                  hintText: 'Select gender',
                  fillColor: ColorConstants.white,
                  initialValue: selectedValue,
                  dropdownItems: ['Male', 'Female', 'Other'],
                  onChanged: (p0) {
                    setState(() {
                      selectedValue = p0;
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
                Text('Enter password', style: AppTextStyle().labletext),
                SizedBox(height: 5),
                TextformfieldWidget(
                  fillColor: ColorConstants.white,
                  controller: _newPassController,
                  obscureText: !obsuceNewPassword,
                  enableInteractiveSelection: obsuceNewPassword,
                  hintText: 'Enter password',
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^[\u0000-\u007F]*$'),
                    ),
                  ],
                  suffixIcons: IconButton(
                    icon: Icon(
                      obsuceNewPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: ColorConstants.black,
                    ),
                    onPressed: () {
                      setState(() {
                        obsuceNewPassword = !obsuceNewPassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    } else {
                      return ValidatorClass.validatePassword(value);
                    }
                  },
                ),
                SizedBox(height: 10),
                Text('Confirm password', style: AppTextStyle().labletext),
                SizedBox(height: 5),
                TextformfieldWidget(
                  fillColor: ColorConstants.white,
                  controller: _confirmPassController,
                  obscureText: !obsuceConfirmPassword,
                  enableInteractiveSelection: obsuceConfirmPassword,
                  hintText: 'Enter confirm password',
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^[\u0000-\u007F]*$'),
                    ),
                  ],
                  suffixIcons: IconButton(
                    icon: Icon(
                      obsuceConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: ColorConstants.black,
                    ),
                    onPressed: () {
                      setState(() {
                        obsuceConfirmPassword = !obsuceConfirmPassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter confirm password';
                    } else if (value != _newPassController.text) {
                      return "Password do not match";
                    } else {
                      return ValidatorClass.validatePassword(value);
                    }
                  },
                ),
                SizedBox(height: 10),
                Text('Pan Card', style: AppTextStyle().labletext),
                SizedBox(height: 5),
                TextformfieldWidget(
                  controller: _pancardController,
                  hintText: 'AAAAA9959A',
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
                Text('Mobile No', style: AppTextStyle().labletext),
                SizedBox(height: 5),
                CustomPhoneField(
                  intialCountryCode: countryCode,
                  focusNode: _focusNode,
                  controller: _phoneController,
                  onChanged: (phone) {
                    debugPrint('complete phone number ${phone.completeNumber}');
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
                      var isValid =
                          ValidatorClass.isValidMobile(value.completeNumber);
                      if (!isValid) {
                        return 'Please enter a valid phone number';
                      }
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AddUserSuccess) {
                      if (state.addUserModel?.data?.selfRegistered == true) {
                        _firstNameController.clear();
                        _lastNameController.clear();
                        _emailController.clear();
                        _phoneController.clear();
                        _pancardController.clear();
                        _newPassController.clear();

                        selectedValue = '';
                        context
                            .read<CustomDropdownBloc>()
                            .add(DropdownResetEvent());
                        context.push(
                          '/otpVerify',
                          extra: {
                            'email': state.addUserModel?.data?.email,
                            'selfRegistered': true,
                          },
                        );
                        Utils.toastSuccessMessage('Otp Sent Successfully');
                      }
                    }
                  },
                  builder: (context, state) {
                    return CommonButtonWidget(
                        loader: state is AuthLoading,
                        buttonTitle: 'Register',
                        onTap: () {
                          debugPrint('selected Value $countryCode');
                          debugPrint('phone number ${_phoneController.text}');

                          if (_formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(AddUserEvent(
                                firstName: _firstNameController.text,
                                lastName: _lastNameController.text,
                                email: _emailController.text,
                                countryCode: countryCode,
                                mobile: _phoneController.text,
                                role: 'CUSTOMER',
                                gender: selectedValue ?? '',
                                panCardNumber: _pancardController.text,
                                password: _newPassController.text,
                                selfRegistration: true));
                          }
                        });
                  },
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Allready Signup ?',
                        style: AppTextStyle().cardLableText,
                      ),
                    ),
                    // SizedBox(width: 5),
                    CustomTextButton(
                        buttonTitle: 'Login',
                        onTap: () {
                          context.pop();
                        }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
