import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
      appBar: CustomAppbar(
        title: 'Payment',
        backIconVisible: true,
      ),
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                  border: Border.all(
                      // ignore: deprecated_member_use
                      color: ColorConstants.darkGray.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(10)),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      horizontalTitleGap: 5,
                      leading: CircleAvatar(
                        radius: 35,
                        backgroundColor: ColorConstants.buttonColor,
                        child: Text(
                          'XY',
                          style: AppTextStyle().buttontext,
                        ),
                      ),
                      title: Text(
                        'Vinay kumar',
                        style: AppTextStyle().textButtonStyle,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'xyz@gmail.com',
                            style: AppTextStyle().smallSubTitleText,
                          ),
                          Text(
                            '+91 9891735242',
                            style: AppTextStyle().smallSubTitleText,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Enter Payment Amount',
                      style: AppTextStyle().cardLableText,
                    ),
                    SizedBox(height: 5),
                    TextformfieldWidget(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      hintText: 'Enter amount',
                      validator: (p0) {
                        if (p0 == null || p0.isEmpty) {
                          return 'Please enter amount';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    CommonButtonWidget(
                        buttonTitle: 'Pay',
                        onTap: () {
                          if (_formKey.currentState!.validate()) {}
                        })
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
