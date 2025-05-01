import 'package:ca_app/data/local_storage/shared_prefs_class.dart';
import 'package:ca_app/utils/assets.dart';
// import 'package:ca_app/utils/assets.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

class CustomDrawer extends StatefulWidget {
  final String userName;
  final String emailAddress;
  final String profileUrl;
  final List<Map<String, dynamic>> menuItems;
  final String lastLogin;
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
    return Drawer(
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
            
              Text(
                widget.userName,
                style: AppTextStyle().buttontext,
              ),
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
          accountEmail: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.emailAddress),
              Text('Last Login: ${widget.lastLogin}')
            ],
          ),
          currentAccountPicture: CircleAvatar(
          
            child: ClipOval(
                child: widget.profileUrl.isNotEmpty
                    ? Image.network(
                        widget.profileUrl,
                        fit: BoxFit.fill,
                      )
                    : Image.asset(appLogo)),
          ),
        ),
        Expanded(
          child: ListView.builder(
              // shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: widget.menuItems.length,
              itemBuilder: (context, index) {
                final item = widget.menuItems[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                  child: ListTile(
                    horizontalTitleGap: 10,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: ColorConstants.darkGray),
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
              }),
        ),
        Material(
          elevation: 4,
          color: ColorConstants.white,
          child: Container(
            decoration: BoxDecoration(
                border: Border(top: BorderSide(color: ColorConstants.darkGray)),
                color: ColorConstants.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListTile(
                  onTap: () async {
                    context.pop();
                    final box = context.findRenderObject() as RenderBox?;

                    await Share.share(
                      'Check out this Flutter app: https://example.com',
                      subject: 'ram',
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
                  onTap: () {
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
        )
      ]),
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
                    padding: const EdgeInsets.symmetric(horizontal: 20),
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
                      onTap: () {
                        context.pushReplacement('/login');
                        SharedPrefsClass().removeToken();
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
