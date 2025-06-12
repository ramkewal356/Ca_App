import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:flutter/material.dart';

class CustomSearchField extends StatelessWidget {
  final TextEditingController controller;
  final String serchHintText;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final double? borderRadius;
  final Widget? prefixIcon;
  final Color? borderColor;
  const CustomSearchField(
      {super.key,
      required this.controller,
      this.focusNode,
      required this.serchHintText,
      this.onChanged,
      this.borderRadius,
      this.prefixIcon,
      this.borderColor});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
        focusNode?.unfocus();
      },
      decoration: InputDecoration(
          prefixIcon: prefixIcon,
          prefixIconConstraints: BoxConstraints(maxWidth: 35, minWidth: 30),
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
            borderSide: BorderSide(
              color: borderColor ?? ColorConstants.darkGray,
              // width: 2.0,
            ),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
              borderSide:
                  BorderSide(color: borderColor ?? ColorConstants.darkGray)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
              borderSide:
                  BorderSide(color: borderColor ?? ColorConstants.darkGray)),
          hintText: serchHintText,
          hintStyle: AppTextStyle().hintText),
      onChanged: onChanged,
    );
  }
}
