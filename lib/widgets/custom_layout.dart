import 'package:ca_app/utils/constanst/colors.dart';
import 'package:flutter/material.dart';

class CustomLayoutPage extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Color? bgColor;
  final Widget child;
  final Future<void> Function()? onRefresh;
  const CustomLayoutPage(
      {super.key,
      this.appBar,
      this.bgColor,
      required this.child,
      this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor ?? ColorConstants.white,
      appBar: appBar,
      body: LayoutBuilder(
        builder: (context, constraints) => Container(
          width: double.infinity,
          decoration: BoxDecoration(color: ColorConstants.white),
          child: RefreshIndicator(
            color: ColorConstants.buttonColor,
            onRefresh: onRefresh ?? () async {},
            child: child,
          ),
        ),
      ),
    );
  }
}
