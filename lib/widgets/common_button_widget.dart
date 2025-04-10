// ignore_for_file: deprecated_member_use

import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:flutter/material.dart';

class CommonButtonWidget extends StatefulWidget {
  final double? buttonWidth;
  final double? buttonheight;
  final String buttonTitle;
  final TextStyle? tileStyle;
  final bool loader;
  final bool disable;
  final Color? buttonColor;
  final bool buttonIconVisible;
  final Widget? buttonIcon;
  final Function()? onTap;
  final Color? buttonBorderColor;
  final Color? loaderColor;
  const CommonButtonWidget(
      {super.key,
      this.buttonWidth,
      this.buttonheight,
      required this.buttonTitle,
      this.buttonColor,
      this.tileStyle,
      this.buttonIconVisible = false,
      this.buttonIcon,
      this.loader = false,
      this.disable = false,
      this.buttonBorderColor,
      this.loaderColor,
      required this.onTap});

  @override
  State<CommonButtonWidget> createState() => _CommonButtonWidgetState();
}

class _CommonButtonWidgetState extends State<CommonButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      color: widget.disable
          ? ColorConstants.buttonColor.withOpacity(0.2)
          : widget.buttonColor ?? ColorConstants.buttonColor,
      shadowColor: widget.buttonColor ?? ColorConstants.buttonColor,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: (widget.disable || widget.loader) ? null : widget.onTap,
        child: Container(
          width: widget.buttonWidth ?? double.infinity,
          height: widget.buttonheight ?? 50,
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          decoration: BoxDecoration(
              color: widget.disable
                  ? ColorConstants.buttonColor.withOpacity(0.2)
                  : widget.buttonColor ?? ColorConstants.buttonColor,
              border: Border.all(
                color: widget.buttonBorderColor ??
                    ColorConstants.darkGray.withOpacity(0.2),
              ),
              borderRadius: BorderRadius.circular(8)),
          child: Center(
              child: widget.loader
                  ? CircularProgressIndicator(
                      color: widget.loaderColor ?? ColorConstants.white,
                   
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        widget.buttonIconVisible
                            ? Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: widget.buttonIcon,
                              )
                            : SizedBox.shrink(),
                        Text(
                          widget.buttonTitle,
                          style: widget.tileStyle ?? AppTextStyle().buttontext,
                        ),
                      ],
                    )),
        ),
      ),
    );
  }
}
