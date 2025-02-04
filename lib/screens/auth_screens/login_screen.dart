import 'package:ca_app/blocs/login/login_bloc.dart';
import 'package:ca_app/data/local_storage/shared_prefs_class.dart';
import 'package:ca_app/utils/assets.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/utils/constanst/validator.dart';
import 'package:ca_app/utils/utils.dart';
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
                      obsucePassword ? Icons.visibility : Icons.visibility_off,
                      color: ColorConstants.black,
                    ),
                    onPressed: () {
                      setState(() {
                        obsucePassword = !obsucePassword;
                      });
                    },
                  ),
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'Enter password';
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
                BlocConsumer<LoginBloc, LoginState>(
                  listener: (context, state) {
                    if (state is LoginSuccessState) {
                      SharedPrefsClass()
                          .saveToken(state.loginModel?.token ?? '');
                      // context.pushReplacement('/ca_dashboard');
                      context.pushReplacement('/customer_dashboard');

                      Utils.toastSuccessMessage('Login Successfully');
                    } else if (state is LoginErrorState) {
                      Utils.toastErrorMessage(state.errorMessage);
                    }
                  },
                  builder: (context, state) {
                    // if (state is LoginSuccessState) {
                    // Future.microtask(() => context.pushReplacement('/'));

                    // }
                    return CommonButtonWidget(
                      loader: state is LoginLoadingState,
                      buttonTitle: 'Sign In',
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          debugPrint('jcxbxjnmxcnmc');
                          BlocProvider.of<LoginBloc>(context).add(LoginApi(
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
                    CustomTextButton(
                      buttonTitle: 'Not User ?',
                      onTap: () {},
                    ),
                    SizedBox(width: 10),
                    CustomTextButton(
                      buttonTitle: 'Already have an OTP ?',
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        _emailFocusNode.unfocus();
                        _passFocusNode.unfocus();
                        context.push('/otpVerify');
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
                CustomTextButton(
                  buttonTitle: 'Help & Support',
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    _emailFocusNode.unfocus();
                    _passFocusNode.unfocus();
                    context.push('/help&support', extra: false);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
