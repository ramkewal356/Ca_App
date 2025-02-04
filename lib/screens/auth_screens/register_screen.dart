import 'package:ca_app/blocs/register/register_bloc.dart';
import 'package:ca_app/data/models/register_request_model.dart';
import 'package:ca_app/utils/assets.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/utils/constanst/validator.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_dropdown_button.dart';
import 'package:ca_app/widgets/custom_phone_field.dart';
import 'package:ca_app/widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final _focusNode = FocusNode();
  bool obsuceNewPassword = false;
  bool obsuceConfirmPassword = false;
  String? selectedValue;
  String? countryCode = '91';
  @override
  void initState() {
    super.initState();
    _phoneController.text = '9919523123';
    _emailController.text = 'emial@gmail.com';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      backgroundColor: ColorConstants.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
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
                  validator: (email) {
                    return ValidatorClass.validateEmail(email);
                  },
                ),
                SizedBox(height: 10),
                Text('New password', style: AppTextStyle().labletext),
                SizedBox(height: 5),
                TextformfieldWidget(
                  fillColor: ColorConstants.white,
                  controller: _newPassController,
                  obscureText: !obsuceNewPassword,
                  enableInteractiveSelection: obsuceNewPassword,
                  hintText: 'New password',
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
                      return 'Please enter new password';
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
                  hintText: 'Confirm new password',
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
                Text('Mobile No', style: AppTextStyle().labletext),
                SizedBox(height: 5),
                CustomPhoneField(
                  readOnly: true,
                  intialCountryCode: countryCode,
                  focusNode: _focusNode,
                  controller: TextEditingController(text: '9917823234'),
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
                SizedBox(height: 10),
                Text('Select Gender', style: AppTextStyle().labletext),
                SizedBox(height: 5),
                CustomDropdownButton(
                  hintText: 'Select gender',
                  fillColor: ColorConstants.white,
                  initialValue: selectedValue,
                  dropdownItems: ['male', 'female', 'other'],
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
                SizedBox(height: 20),
                BlocConsumer<RegisterBloc, RegisterState>(
                  listener: (context, state) {
                    if (state is RegisterSuccess) {
                      context.push('/login');
                    }
                  },
                  builder: (context, state) {
                    return CommonButtonWidget(
                        loader: state is RegisterLoading,
                        buttonTitle: 'Register',
                        onTap: () {
                          debugPrint('selected Value $countryCode');
                          debugPrint('phone number ${_phoneController.text}');

                          if (_formKey.currentState!.validate()) {
                            BlocProvider.of<RegisterBloc>(context).add(Register(
                                registerRequest: RegisterRequestModel(
                                    firstName: _firstNameController.text,
                                    address: _emailController.text,
                                    password: _newPassController.text,
                                    gender: selectedValue,
                                    userId: 13)));
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
  }
}
