import 'dart:async';

import 'package:ca_app/blocs/auth/auth_bloc.dart';
import 'package:ca_app/blocs/auth/auth_event.dart';
import 'package:ca_app/blocs/auth/auth_state.dart';
import 'package:ca_app/utils/assets.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/utils/constanst/validator.dart';
import 'package:ca_app/utils/utils.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String? email;
  const OtpVerificationScreen({super.key, this.email});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  // ignore: unused_field
  late Timer _timer; // Timer object
  int _start = 60; // Initial countdown time in seconds
  bool _isButtonDisabled = false;
  void startTimer() {
    _isButtonDisabled = true; // Disable the button when the timer starts
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _isButtonDisabled = false; // Enable the button when countdown is over
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('email:-- ${widget.email}');
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is VerifyOtpForUserSuccess) {
          context.push('/register', extra: state.verifiedUser);
        } else if (state is VerifyOtpSuccess) {
          context.push('/resetPassword',
              extra: {"userId": state.verifyModel?.data?.id});
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: ColorConstants.white,
          appBar: AppBar(
            backgroundColor: ColorConstants.white,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        verifyimg,
                      ),
                    ),
                    Text(
                      'Verify Yourself',
                      style: AppTextStyle().largHeadingtext,
                    ),
                    Text(
                      'Enter the 6-digit code sent on your email',
                      style: AppTextStyle().subheadingtext,
                    ),
                    SizedBox(height: 30),
                    widget.email == null || widget.email!.isEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Email', style: AppTextStyle().labletext),
                              SizedBox(height: 5),
                              TextformfieldWidget(
                                focusNode: _emailFocusNode,
                                fillColor: ColorConstants.white,
                                keyboardType: TextInputType.emailAddress,
                                controller: _emailController,
                                hintText: 'Enter email id',
                                validator: (email) {
                                  return ValidatorClass.validateEmail(email);
                                },
                              ),
                              SizedBox(height: 10),
                              Text('Enter OTP',
                                  style: AppTextStyle().labletext),
                            ],
                          )
                        : SizedBox.shrink(),
                    PinCodeTextField(
                      keyboardType: TextInputType.number,
                      enableActiveFill: true,
                      cursorColor: Colors.black,
                      // errorTextMargin: const EdgeInsets.only(top: 20),
                      errorTextSpace: 22,
                      appContext: context,
                      length: 6,
                      onChanged: (value) {
                        // Handle changes in the OTP input
                        debugPrint(value);
                      },
                      onCompleted: (value) {
                        // Handle when the user completes entering the OTP
                        debugPrint("Completed: $value");
                      },
                      // You can customize the appearance of the input field
                      pinTheme: PinTheme(
                          borderWidth: 1,
                          activeBorderWidth: 1,
                          inactiveBorderWidth: 1,
                          fieldOuterPadding: EdgeInsets.zero,
                          fieldWidth: 50,
                          fieldHeight: 50,
                          selectedFillColor: Colors.white,
                          shape: PinCodeFieldShape.box,
                          inactiveFillColor: Colors.white,
                          activeFillColor: Colors.white,
                          inactiveColor: Colors.grey,
                          activeColor: const Color.fromRGBO(0, 0, 0, 0.5),
                          borderRadius: BorderRadius.circular(5)),
                      controller: _otpController,
                      // Validator function for OTP
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the OTP';
                        }
                        if (value.length != 6) {
                          return 'OTP must be 6 digits long';
                        }
                        // You can add more custom validation here if needed
                        return null;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Didn't receive the code?",
                          style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 10),
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                            onPressed: _isButtonDisabled
                                ? null
                                : () {
                                    if (widget.email != null ||
                                        _emailController.text.isNotEmpty) {
                                      if (widget.email != null) {
                                        _otpController.clear();
                                        setState(() {
                                          _start =
                                              60; // Reset the countdown timer
                                          _isButtonDisabled = true;
                                        });
                                        startTimer();
                                        context.read<AuthBloc>().add(
                                            SendOtpEvent(
                                                email: widget.email ??
                                                    _emailController.text));
                                      } else {
                                        _otpController.clear();
                                        setState(() {
                                          _start =
                                              60; // Reset the countdown timer
                                          _isButtonDisabled = true;
                                        });
                                        startTimer();
                                        context.read<AuthBloc>().add(
                                            ReSendOtpEvent(
                                                email: widget.email ??
                                                    _emailController.text));
                                      }
                                    } else {
                                      Utils.toastErrorMessage(
                                          'Please enter your email');
                                    }
                                  },
                            child: state is SendOtpLoading
                                ? SizedBox(
                                    height: 25,
                                    width: 25,
                                    child: Center(
                                        child: CircularProgressIndicator(
                                      color: ColorConstants.buttonColor,
                                    )),
                                  )
                                : Text(
                                    _isButtonDisabled
                                        ? 'Resend OTP ($_start seconds)'
                                        : 'Resend OTP',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        color: _isButtonDisabled
                                            ? ColorConstants.buttonColor
                                            : ColorConstants.greenColor),
                                  ))
                      ],
                    ),
                    SizedBox(height: 10),
                    CommonButtonWidget(
                      loader: state is AuthLoading,
                      buttonTitle: 'Verify & Proceed',
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          if (widget.email == null || widget.email!.isEmpty) {
                            context.read<AuthBloc>().add(VerifyOtpForUserEvent(
                                email: _emailController.text,
                                otp: _otpController.text));
                          } else {
                            context.read<AuthBloc>().add(VerifyOtpEvent(
                                email: widget.email ?? _emailController.text,
                                otp: _otpController.text));
                          }
                        }
                      },
                    ),
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
