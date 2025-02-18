import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? time;

  final bool backIconVisible;
  final Widget? backIcon;
  final void Function()? onTapBack;
  final List<Widget>? actionIcons;
  const CustomAppbar(
      {super.key,
      required this.title,
      this.time,
      this.backIconVisible = false,
      this.backIcon,
      this.onTapBack,
      this.actionIcons});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 1,
      // shadowColor: ColorConstants.white,
      centerTitle: true,
      titleSpacing: 0,
      backgroundColor: ColorConstants.buttonColor,
      title: Row(
       
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
      ),
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
