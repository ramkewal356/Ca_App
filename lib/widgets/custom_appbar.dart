import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? time;
  final Color? bgColor;
  final bool backIconVisible;
  final Widget? backIcon;
  final Widget? centerIcon;
  final void Function()? onTapBack;
  final List<Widget>? actionIcons;
  const CustomAppbar(
      {super.key,
      required this.title,
      this.time,
      this.backIconVisible = false,
      this.backIcon,
      this.onTapBack,
      this.centerIcon,
      this.bgColor,
      this.actionIcons});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 1,
      shadowColor: bgColor,
      surfaceTintColor: bgColor ?? ColorConstants.buttonColor,
      centerTitle: true,
      titleSpacing: 0,
      backgroundColor: bgColor ?? ColorConstants.buttonColor,
      title: backIconVisible
          ? Row(
        children: [
          Text(
            time ?? '',
            style: AppTextStyle().smallbuttontext,
          ),
          Expanded(
            child: Text(
              title,
              style: AppTextStyle().appbartext,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
            )
          : centerIcon,
      leading: backIconVisible
          // ? backIconVisible
          ? backIcon ??
              IconButton(
                  onPressed: onTapBack ??
                      () {
                        context.pop();
                      },
                  icon: Icon(
                    Icons.arrow_back,
                    color: ColorConstants.white,
                  ))
          : null,
      actions: [...?actionIcons],
    );
  }
}
