import 'package:ca_app/blocs/auth/auth_bloc.dart';
import 'package:ca_app/blocs/auth/auth_event.dart';
import 'package:ca_app/blocs/auth/auth_state.dart';
import 'package:ca_app/utils/assets.dart';
// import 'package:ca_app/utils/assets.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/utils/utils.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

class CustomDrawer extends StatefulWidget {
  final String userName;
  final String emailAddress;
  final String profileUrl;
  final List<Map<String, dynamic>> menuItems;
  final String lastLogin;
  final bool isLogin;
  // final int selectedIndex;
  // final Function(int) onItemSelected;
  final bool activeButton;
  final String? activeTex;
  const CustomDrawer({
    super.key,
    required this.userName,
    required this.emailAddress,
    required this.profileUrl,
    required this.menuItems,
    required this.lastLogin,
    required this.isLogin,
    // required this.selectedIndex,
    // required this.onItemSelected,
    this.activeButton = false,
    this.activeTex,
  });

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          Utils.toastSuccessMessage('Logout successful!');
          context.pushReplacement('/landing_screen');
        }
      },
      child: Drawer(
        backgroundColor: ColorConstants.white,
        child: Column(children: [
          UserAccountsDrawerHeader(
            currentAccountPictureSize: Size.square(68),
            decoration: BoxDecoration(color: ColorConstants.buttonColor),
            otherAccountsPicturesSize: Size.square(70),
            otherAccountsPictures: [
              Image.asset(
                appLogo,
                color: ColorConstants.white,
              )
            ],
            accountName: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                widget.isLogin
                    ? Text(
                        widget.userName,
                        style: AppTextStyle().buttontext,
                      )
                    : SizedBox.shrink(),
                widget.activeButton
                    ? Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: ColorConstants.white),
                        child: Text(
                          widget.activeTex ?? '',
                          style: widget.activeTex == 'Active'
                              ? AppTextStyle().getgreenText
                              : AppTextStyle().getredText,
                        ),
                      )
                    : SizedBox.shrink()
              ],
            ),
            accountEmail: widget.isLogin
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.isLogin
                          ? Text(widget.emailAddress)
                          : SizedBox.shrink(),
                      (widget.lastLogin.isEmpty || widget.lastLogin == '')
                          ? SizedBox.shrink()
                          : Text('Last Login: ${widget.lastLogin}')
                    ],
                  )
                : SizedBox.shrink(),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                  child: (widget.profileUrl.isNotEmpty && widget.isLogin)
                      ? Image.network(
                          widget.profileUrl,
                          fit: BoxFit.fill,
                          width: double.infinity,
                          height: double.infinity,
                        )
                      : Image.asset(
                          appLogo,
                          height: double.infinity,
                          width: double.infinity,
                        )),
            ),
          ),
          widget.isLogin
              ? Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: widget.menuItems.length,
                      itemBuilder: (context, index) {
                        final item = widget.menuItems[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 15),
                          child: ListTile(
                            horizontalTitleGap: 10,
                            shape: RoundedRectangleBorder(
                                side:
                                    BorderSide(color: ColorConstants.darkGray),
                                borderRadius: BorderRadius.circular(10)),
                            // selected: widget.selectedIndex == index,
                            selected: selectedIndex == index,
                            selectedTileColor: ColorConstants.buttonColor,
                            onTap: () {
                              // widget.onItemSelected(index);
                              if (item['onTap'] != null) {
                                item['onTap']();
                                context.pop();
                              }

                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            leading: Icon(
                              item['imgUrl'],
                              color: selectedIndex == index
                                  ? ColorConstants.white
                                  : ColorConstants.black,
                            ),
                            title: Text(
                              item['label'],
                              style: selectedIndex == index
                                  ? AppTextStyle().menuSelectedText
                                  : AppTextStyle().menuUnselectedText,
                            ),
                            trailing: Icon(
                              Icons.keyboard_arrow_right_outlined,
                              color: selectedIndex == index
                                  ? ColorConstants.white
                                  : ColorConstants.black,
                            ),
                          ),
                        );
                      }))
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: CommonButtonWidget(
                    buttonTitle: 'Login/Register',
                    onTap: () {
                      context.push('/login');
                    },
                  ),
                ),
          widget.isLogin ? SizedBox.shrink() : Spacer(),
          SafeArea(
            child: Material(
              elevation: 4,
              color: ColorConstants.white,
              child: Container(
                decoration: BoxDecoration(
                    border:
                        Border(top: BorderSide(color: ColorConstants.darkGray)),
                    color: ColorConstants.white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ListTile(
                      onTap: () async {
                        context.pop();
                        final box = context.findRenderObject() as RenderBox?;

                        await Share.share(
                          'https://github.com/ramkewal356/Ca_App/releases/download/v1.0.0/Ca_App.V1.0._28May25.apk',
                          subject: 'download ca apk',
                          sharePositionOrigin:
                              box!.localToGlobal(Offset.zero) & box.size,
                        );
                        // Share.share(
                        //     'Check out this Flutter app: https://example.com');
                      },
                      leading: Icon(Icons.share_sharp),
                      title: Text(
                        'Share App',
                        style: AppTextStyle().menuUnselectedText,
                      ),
                    ),
                    ListTile(
                      // onTap: showConfimLogout,
                      onTap: !widget.isLogin
                          ? () {}
                          : () {
                              context.pop();
                              showConfimLogout();
                            },
                      leading: Icon(Icons.logout),
                      title: Text(
                        'Logout',
                        style: AppTextStyle().menuUnselectedText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }

  showConfimLogout() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: ColorConstants.white,
          insetPadding: EdgeInsets.all(20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text.rich(TextSpan(children: [
                      TextSpan(
                          text: 'Are you sure you want to ',
                          style: AppTextStyle().cardLableText),
                      TextSpan(text: 'Logout ?', style: AppTextStyle().redText)
                    ]))),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CommonButtonWidget(
                      buttonWidth: 70,
                      buttonTitle: 'No',
                      onTap: () {
                        context.pop();
                      },
                    ),
                    CommonButtonWidget(
                      buttonWidth: 70,
                      buttonTitle: 'Yes',
                      // onTap: onTap,
                      onTap: () {
                        context.pop();
                        context.read<AuthBloc>().add(LogoutEvent());
                        // SharedPrefsClass().removeToken();

                        // context.pushReplacement('/landing_screen');
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
