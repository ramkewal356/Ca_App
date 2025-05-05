import 'package:ca_app/blocs/auth/auth_bloc.dart';
import 'package:ca_app/blocs/auth/auth_event.dart';
import 'package:ca_app/blocs/auth/auth_state.dart';
import 'package:ca_app/utils/assets.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/utils/constanst/validator.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordScreen extends StatefulWidget {
  final int userId;
  const ResetPasswordScreen({super.key, required this.userId});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  bool obsuceNewPassword = false;
  bool obsuceConfirmPassword = false;

  @override
  Widget build(BuildContext context) {
    debugPrint('email on reset screen:-- ${widget.userId}');

    return Scaffold(
      backgroundColor: ColorConstants.white,
      appBar: AppBar(
        backgroundColor: ColorConstants.white,
        leading: IconButton(
            onPressed: () {
              context.pop();
              context.pop();
              context.pop();
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Image.asset(forgotimg)),
                Center(
                  child: Text(
                    'Reset Password',
                    style: AppTextStyle().largHeadingtext,
                  ),
                ),
                SizedBox(height: 30),
                Text('New password', style: AppTextStyle().labletext),
                SizedBox(height: 5),
                TextformfieldWidget(
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
                SizedBox(height: 20),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is UpdateUserSuccess) {
                      // context.pop();
                      // context.pop();
                      // context.pop();
                      context.push('/login');
                    }
                  },
                  builder: (context, state) {
                    return CommonButtonWidget(
                        loader: state is AuthLoading,
                        buttonTitle: 'Reset Password',
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(UpdateUserEvent(
                                userId: widget.userId.toString(),
                                password: _newPassController.text));
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
