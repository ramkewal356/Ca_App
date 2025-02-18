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

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.white,
      appBar: AppBar(
        backgroundColor: ColorConstants.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Image.asset(forgotimg),
              Text(
                'Forgot Password',
                style: AppTextStyle().largHeadingtext,
              ),
              Text(
                'Please enter your email',
                style: AppTextStyle().subheadingtext,
              ),
              SizedBox(height: 30),
              Form(
                key: _formKey,
                child: TextformfieldWidget(
                  visiblePrefixIcon: true,
                  prefixIcons: Icon(
                    Icons.person,
                    color: ColorConstants.darkGray,
                  ),
                  controller: _emailController,
                  hintText: 'Enter your email',
                  validator: (email) {
                    return ValidatorClass.validateEmail(email);
                  },
                ),
              ),
              SizedBox(height: 20),
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is SendOtpSuccess) {
                    context.push('/otpVerify', extra: _emailController.text);
                    Utils.toastSuccessMessage('Otp Sent Successfully');
                  }
                },
                builder: (context, state) {
                  return CommonButtonWidget(
                      loader: state is AuthLoading,
                      buttonTitle: 'Submit',
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          BlocProvider.of<AuthBloc>(context).add(
                              SendOtpEvent(email: _emailController.text));
                          // context.read<AuthBloc>().add(
                          //     AuthForgotEvent(email: _emailController.text));
                        }
                      });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
