import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:flutter/material.dart';

class CustomBottomsheetModal extends StatefulWidget {
  final String buttonTitle;
  final double? buttonWidth;
  final double? buttonHieght;
  final Widget child;
  final bool buttonIcon;
  const CustomBottomsheetModal(
      {super.key,
      required this.buttonTitle,
      this.buttonWidth,
      this.buttonHieght,
      required this.child,
      this.buttonIcon = false});

  @override
  State<CustomBottomsheetModal> createState() => _CustomBottomsheetModalState();
}

class _CustomBottomsheetModalState extends State<CustomBottomsheetModal> {
  @override
  Widget build(BuildContext context) {
    return CommonButtonWidget(
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
