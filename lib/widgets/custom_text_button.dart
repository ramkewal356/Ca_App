import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String buttonTitle;
  final Function()? onTap;
  const CustomTextButton(
      {super.key, required this.buttonTitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        buttonTitle,
        style: AppTextStyle().textButtonStyle,
      ),
    );
  }
}
