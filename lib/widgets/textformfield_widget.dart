// ignore_for_file: deprecated_member_use

import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextformfieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final bool? obscureText;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final int? textLength;
  final String? obscuringCharacter;
  final TextInputType? keyboardType;
  final TextAlignVertical? textAlignVertical;
  final bool? enableInteractiveSelection;
  final Color? fillColor;
  final FocusNode? focusNode;
  final bool visiblePrefixIcon;
  final Widget? prefixIcons;
  final Widget? suffixIcons;
  final VoidCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;

  const TextformfieldWidget(
      {super.key,
      required this.controller,
      required this.hintText,
      this.validator,
      this.onChanged,
      this.obscureText,
      this.readOnly = false,
      this.maxLines = 1,
      this.minLines = 1,
      this.textLength,
      this.obscuringCharacter,
      this.focusNode,
      this.enableInteractiveSelection,
      this.fillColor,
      this.keyboardType,
      this.textAlignVertical,
      this.inputFormatters,
      this.visiblePrefixIcon = false,
      this.prefixIcons,
      this.suffixIcons,
      this.onTap});

  @override
  State<TextformfieldWidget> createState() => _TextformfieldWidgetState();
}

class _TextformfieldWidgetState extends State<TextformfieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enableInteractiveSelection: widget.enableInteractiveSelection,
      focusNode: widget.focusNode,
      readOnly: widget.readOnly,
      obscureText: widget.obscureText ?? false,
      obscuringCharacter: widget.obscuringCharacter ?? '•',
      controller: widget.controller,
      textAlignVertical: widget.textAlignVertical,
      onTap: widget.onTap,
      inputFormatters: [
        LengthLimitingTextInputFormatter(widget.textLength),
        FilteringTextInputFormatter.allow(
          RegExp(r'^[\u0000-\u007F]*$'), // Allows ASCII characters only
        ),
        ...?widget.inputFormatters
      ],
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      maxLength: widget.textLength,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: AppTextStyle().hintText,
        prefixIcon: widget.visiblePrefixIcon ? widget.prefixIcons : null,
        suffixIcon: widget.suffixIcons,
        filled: widget.readOnly,
        fillColor: widget.readOnly
            ? ColorConstants.buttonColor.withOpacity(0.1)
            : widget.fillColor,
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: ColorConstants.darkGray,
            // width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: ColorConstants.darkGray,
            // width: 2.0,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: ColorConstants.darkGray,
            // width: 2.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: ColorConstants.darkGray,
            // width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: ColorConstants.darkGray,
            // color: redColor,
            // width: 2.0,
          ),
        ),
        errorStyle: TextStyle(
          // color: ColorConstants.redColor,
          fontSize: 13,
        ),
      ),
      onChanged: widget.onChanged,
      validator: widget.validator,
    );
  }
}
