import 'package:ca_app/blocs/auth/auth_bloc.dart';
import 'package:ca_app/blocs/auth/auth_event.dart';
import 'package:ca_app/blocs/auth/auth_state.dart';
import 'package:ca_app/data/models/user_model.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/utils/constanst/validator.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyCaScreen extends StatefulWidget {
  final int caId;
  const MyCaScreen({super.key, required this.caId});

  @override
  State<MyCaScreen> createState() => _MyCaScreenState();
}

class _MyCaScreenState extends State<MyCaScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<AuthBloc>()
        .add(GetUserByIdEvent(userId: widget.caId.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
        appBar: CustomAppbar(
          title: 'My CA',
          backIconVisible: true,
        ),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            UserModel? caData =
                state is GetUserByIdSuccess ? state.getUserByIdData : null;
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            color: ColorConstants.buttonColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              caData?.data?.firstName?[0] ?? 'X',
                              style: AppTextStyle().largWhitetext,
                            ),
                            Text(
                              caData?.data?.lastName?[0] ?? 'y',
                              style: AppTextStyle().mediumWhitetext,
                            ),
                          ],
                        )),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${caData?.data?.firstName ?? ''} ${caData?.data?.lastName ?? ''}',
                            style: AppTextStyle().textButtonStyle,
                          ),
                          subTitle(Icons.email, caData?.data?.email ?? ''),
                          subTitle(Icons.call,
                              '+${caData?.data?.countryCode ?? ''} ${caData?.data?.mobile ?? ''}'),
                          subTitle(
                              Icons.location_on, caData?.data?.address ?? ''),
                        ],
                      ))
                    ],
                  ),
                  SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: ColorConstants.darkGray.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Column(
                        children: [
                          textItem(
                              lable: 'Referral code', value: 'SID465879879'),
                          textItem(
                              lable: 'Pan Card',
                              value: caData?.data?.panCardNumber ?? '_'),
                          textItem(
                              lable: 'Aadhaar Card',
                              value: caData?.data?.aadhaarCardNumber ?? '_'),
                          textItem(
                              lable: 'Phone',
                              value:
                                  '+${caData?.data?.countryCode ?? ''} ${caData?.data?.mobile ?? ''}'),
                          textItem(
                              lable: 'Created Date',
                              value: dateFormate(caData?.data?.createdDate)),
                          textItem(
                              lable: 'Gender',
                              value: '${caData?.data?.gender}'),
                          textItem(
                              lable: 'Status',
                              value: caData?.data?.status == true
                                  ? 'Active'
                                  : 'Inactive'),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ));
  }

  subTitle(IconData icon, String title) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: ColorConstants.buttonColor,
        ),
        SizedBox(width: 5),
        Expanded(
          child: Text(
            title,
            style: AppTextStyle().subTitleText,
          ),
        )
      ],
    );
  }

  textItem({required String lable, required String value}) {
    return Row(
      children: [
        Expanded(
            child: Text(
          lable,
          style: AppTextStyle().cardLableText,
        )),
        Expanded(
            child: Text(
          value,
          style: value == 'Active'
              ? AppTextStyle().getgreenText
              : value == 'In-Active'
                  ? AppTextStyle().getredText
                  : AppTextStyle().cardValueText,
        ))
      ],
    );
  }
}
