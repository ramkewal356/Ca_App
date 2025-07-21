import 'package:ca_app/blocs/auth/auth_bloc.dart';
import 'package:ca_app/blocs/auth/auth_event.dart';
import 'package:ca_app/blocs/auth/auth_state.dart';
import 'package:ca_app/utils/assets.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/utils/constanst/validator.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_text_button.dart';
import 'package:ca_app/widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();
  bool obsucePassword = false;
  @override
  Widget build(BuildContext context) {
    debugPrint('print long time');
    return Scaffold(
        backgroundColor: ColorConstants.white,
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 100),
                  Center(
                    child: Image.asset(
                      userLogo,
                      width: 250,
                      height: 150,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Sign In',
                    style: AppTextStyle().headingtext,
                  ),
                  SizedBox(height: 20),
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
                  Text('Password', style: AppTextStyle().labletext),
                  SizedBox(height: 5),
                  TextformfieldWidget(
                    focusNode: _passFocusNode,
                    fillColor: ColorConstants.white,
                    keyboardType: TextInputType.visiblePassword,
                    controller: _passwordController,
                    obscureText: !obsucePassword,
                    enableInteractiveSelection: obsucePassword,
                    hintText: 'Enter password',
                    suffixIcons: IconButton(
                      icon: Icon(
                        obsucePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: obsucePassword
                            ? ColorConstants.black
                            : ColorConstants.darkGray,
                      ),
                      onPressed: () {
                        setState(() {
                          obsucePassword = !obsucePassword;
                        });
                      },
                    ),
                    validator: (p0) {
                      if (p0 == null || p0.isEmpty) {
                        return 'Please enter password';
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  CustomTextButton(
                    buttonTitle: 'Forgot Password ?',
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      _emailFocusNode.unfocus();
                      _passFocusNode.unfocus();
                      context.push('/forgotPassword');
                    },
                  ),
                  SizedBox(height: 10),
                  BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is LoginSuccess) {
                        if (state.loginModel?.data?.role == 'CA') {
                          context.pushReplacement('/ca_dashboard');
                        } else if (state.loginModel?.data?.role == 'SUBCA') {
                          context.pushReplacement('/subca_dashboard');
                        } else if (state.loginModel?.data?.role == 'CUSTOMER') {
                          if (state.loginModel?.data?.selfRegistered == true) {
                            // context.pushReplacement('/indivisual_customer');
                            context.pushReplacement('/landing_screen');
                          } else {
                            context.pushReplacement('/customer_dashboard');
                          }
                        }

                        // Utils.toastSuccessMessage('Login Successfully');
                      }
                    },
                    builder: (context, state) {
                      // if (state is LoginSuccessState) {
                      // Future.microtask(() => context.pushReplacement('/'));

                      // }
                      return CommonButtonWidget(
                        loader: state is AuthLoading,
                        buttonTitle: 'Sign In',
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          _emailFocusNode.unfocus();
                          _passFocusNode.unfocus();
                          if (_formKey.currentState!.validate()) {
                            debugPrint('jcxbxjnmxcnmc');
                            BlocProvider.of<AuthBloc>(context).add(LoginEvent(
                                userName: _emailController.text,
                                password: _passwordController.text));
                          }
                        },
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'Not User ?',
                          style: AppTextStyle().cardLableText,
                        ),
                      ),
                      // SizedBox(width: 5),
                      CustomTextButton(
                          buttonTitle: 'Signup',
                          onTap: () {
                            context.push('/signup');
                          }),
                      Spacer(),
                      // CustomTextButton(
                      //   buttonTitle: 'Help & Support',
                      //   onTap: () {
                      //     FocusScope.of(context).unfocus();
                      //     _emailFocusNode.unfocus();
                      //     _passFocusNode.unfocus();
                      //     context.push('/help&support', extra: false);
                      //   },
                      // ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'Already have an OTP ?',
                          style: AppTextStyle().cardLableText,
                        ),
                      ),
                      CustomTextButton(
                        buttonTitle: 'Verify',
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          _emailFocusNode.unfocus();
                          _passFocusNode.unfocus();
                          context.push('/otpVerify');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            _emailFocusNode.unfocus();
            _passFocusNode.unfocus();
            context.push('/help&support', extra: false);
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          backgroundColor: ColorConstants.buttonColor,
          child: Icon(
            Icons.headset_mic_rounded,
            color: ColorConstants.white,
            size: 30,
          ),
        ));
  }
}
