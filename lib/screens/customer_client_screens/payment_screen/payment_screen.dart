import 'package:ca_app/blocs/auth/auth_bloc.dart';
import 'package:ca_app/blocs/auth/auth_event.dart';
import 'package:ca_app/blocs/auth/auth_state.dart';
import 'package:ca_app/data/models/user_model.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentScreen extends StatefulWidget {
  final int caId;
  const PaymentScreen({super.key, required this.caId});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    context
        .read<AuthBloc>()
        .add(GetUserByIdEvent(userId: widget.caId.toString()));
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('vxcvvcv${widget.caId}');
    return CustomLayoutPage(
      appBar: CustomAppbar(
        title: 'Payment',
        backIconVisible: true,
      ),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          UserModel? caData =
              state is GetUserByIdSuccess ? state.getUserByIdData : null;
          return Padding(
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
                            child: caData?.data?.profileUrl == null
                                ? Text(
                              '${caData?.data?.firstName?[0] ?? ''} ${caData?.data?.lastName?[0] ?? ''}',
                              style: AppTextStyle().buttontext,
                                  )
                                : ClipOval(
                                    child: Image.network(
                                      caData?.data?.profileUrl ?? '',
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                          ),
                          title: Text(
                            '${caData?.data?.firstName ?? ''} ${caData?.data?.lastName ?? ''}',
                            style: AppTextStyle().textButtonStyle,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                caData?.data?.email ?? '',
                                style: AppTextStyle().smallSubTitleText,
                              ),
                              Text(
                                '+${caData?.data?.countryCode ?? ''} ${caData?.data?.mobile ?? ''}',
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
          );
        },
      ),
    );
  }
}
