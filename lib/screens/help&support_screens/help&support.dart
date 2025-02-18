
import 'package:flutter/material.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/utils/constanst/validator.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/textformfield_widget.dart';
import 'package:go_router/go_router.dart';

class HelpAndSupport extends StatefulWidget {
  final bool isLogin;
  const HelpAndSupport({super.key, required this.isLogin});

  @override
  State<HelpAndSupport> createState() => _HelpAndSupportState();
}

class _HelpAndSupportState extends State<HelpAndSupport> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  List<String> items = [
    'vinay',
    'mohan',
    'aman',
    'vishal',
    'varun',
    'ram',
    'ramkewal'
  ];
  List<String> selectedItems = [];
  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
      bgColor: ColorConstants.white,
      appBar: CustomAppbar(
        title: 'Help & Supprot',
        backIconVisible: true,
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: GestureDetector(
          onTap: () {
            debugPrint('dmscb hjnsmmn c  ');
          },
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 20),
                Text(
                  'A Help Center is a website where customers can find answers to their questions and solutions to their problems.',
                  style: AppTextStyle().hintText,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
              
                SizedBox(height: 20),
                widget.isLogin
                    ? SizedBox.shrink()
                    : TextformfieldWidget(
                        controller: _emailController,
                        hintText: 'Email',
                        validator: (email) {
                          return ValidatorClass.validateEmail(email);
                        },
                      ),
                widget.isLogin ? SizedBox.shrink() : SizedBox(height: 20),
                TextformfieldWidget(
                  controller: _subjectController,
                  hintText: 'Subject',
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'Please enter subject';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextformfieldWidget(
                  maxLines: 5,
                  minLines: 5,
                  controller: _messageController,
                  hintText: 'Message',
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'Please enter message';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CommonButtonWidget(
                        buttonWidth: 160,
                        buttonTitle: 'Send Message',
                        onTap: () {
                          if (_formKey.currentState!.validate()) {}
                        }),
                    widget.isLogin ? Spacer() : SizedBox.shrink(),
                    widget.isLogin
                        ? CommonButtonWidget(
                            buttonIconVisible: true,
                            buttonIcon: Icon(
                              Icons.history,
                              color: ColorConstants.white,
                            ),
                            buttonWidth: 170,
                            buttonTitle: 'Help History',
                            onTap: () {
                              context.push('/help&support_history');
                            })
                        : SizedBox.shrink()
                  ],
                ),
                SizedBox(height: 20),
                _listTile(
                    icon: Icon(
                      Icons.location_on_outlined,
                      size: 30,
                      color: ColorConstants.redColor,
                    ),
                    title: 'Our Address',
                    subTitle: '3481 Melrose Place, Berverly Hills'),
                _listTile(
                    icon: Icon(
                      Icons.email_outlined,
                      size: 30,
                      color: Colors.blue[100],
                    ),
                    title: 'Send your message',
                    subTitle: 'info@example.com'),
                _listTile(
                    icon: Icon(
                      Icons.call,
                      size: 30,
                      color: ColorConstants.darkGray,
                    ),
                    title: 'Call us on',
                    subTitle: '(+1) 517 788 6780'),
                _listTile(
                    icon: Icon(
                      Icons.timer_outlined,
                      size: 30,
                      color: Colors.orangeAccent,
                    ),
                    title: 'Work Time',
                    subTitle: 'Mon-Fri : 8:00-16:00 , Sat: 10:00-2:00')
              ],
            ),
          ),
        ),
      ),
    );
  }

  _listTile(
      {required Widget icon, required String title, required String subTitle}) {
    return ListTile(
      dense: true,
      titleAlignment: ListTileTitleAlignment.center,
      leading: icon,
      title: Text(
        title,
        style: AppTextStyle().textButtonStyle,
      ),
      subtitle: Text(
        subTitle,
        style: AppTextStyle().subTitleText,
      ),
    );
  }
}
