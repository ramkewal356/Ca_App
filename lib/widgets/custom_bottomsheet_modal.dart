import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:flutter/material.dart';

class CustomBottomsheetModal extends StatefulWidget {
  final String buttonTitle;
  final double? buttonWidth;
  final double? buttonHieght;
  final Widget child;
  final bool buttonIcon;
  final VoidCallback? onTap;
  final bool isFlotingButton;
  const CustomBottomsheetModal(
      {super.key,
      required this.buttonTitle,
      this.isFlotingButton = false,
      this.buttonWidth,
      this.buttonHieght,
      required this.child,
      this.onTap,
      this.buttonIcon = false});

  @override
  State<CustomBottomsheetModal> createState() => _CustomBottomsheetModalState();
}

class _CustomBottomsheetModalState extends State<CustomBottomsheetModal> {
  @override
  Widget build(BuildContext context) {
    return widget.isFlotingButton
        ? FloatingActionButton(
            backgroundColor: ColorConstants.buttonColor,
            // ignore: sort_child_properties_last
            child: Icon(
              Icons.add,
              color: ColorConstants.white,
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            onPressed: () {
              _showModalBottomSheet(context);
              if (widget.onTap != null) {
                widget.onTap!();
              }
            },
          )
        : CommonButtonWidget(
      buttonWidth: widget.buttonWidth,
      buttonheight: widget.buttonHieght,
      buttonTitle: widget.buttonTitle,
      buttonIconVisible: widget.buttonIcon,
      buttonIcon: Icon(
        Icons.add,
        color: ColorConstants.white,
      ),
      onTap: () {
        _showModalBottomSheet(context);
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
    );
  }

  Future<void> _showModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isDismissible: false,
        backgroundColor: ColorConstants.white,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10),
          ),
        ),
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setstate) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: widget.child,
              ),
            );
          });
        });
  }
}
