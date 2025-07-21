import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String buttonTitle;
  final Function()? onTap;
  const CustomTextButton(
      {super.key, required this.buttonTitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // return TextButton(
    //   onPressed: onTap,

    //   child: Text(
    //     buttonTitle,
    //     style: AppTextStyle().textButtonStyle,
    //   ),
    // );
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          buttonTitle,
          style: AppTextStyle().textButtonStyle,
        ),
      ),
    );
  }
}
