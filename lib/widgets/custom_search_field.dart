import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:flutter/material.dart';

class CustomSearchField extends StatelessWidget {
  final TextEditingController controller;
  final String serchHintText;
  final Function(String)? onChanged;
  const CustomSearchField(
      {super.key,
      required this.controller,
      required this.serchHintText,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: ColorConstants.darkGray)),
          hintText: serchHintText,
          hintStyle: AppTextStyle().hintText),
      onChanged: onChanged,
    );
  }
}
