import 'package:ca_app/utils/constanst/colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String buttonHeading;
  final double? height;
  final double? width;
  final Color? buttonColor;
  const CustomButton(
      {super.key,
      required this.buttonHeading,
      this.height,
      this.width,
      this.buttonColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: buttonColor ?? ColorConstants.buttonColor),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Text(buttonHeading),
      ),
    );
  }
}
