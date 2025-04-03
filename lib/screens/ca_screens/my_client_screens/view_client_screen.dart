import 'package:ca_app/blocs/auth/auth_bloc.dart';
import 'package:ca_app/blocs/auth/auth_event.dart';
import 'package:ca_app/blocs/auth/auth_state.dart';
import 'package:ca_app/data/models/user_model.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/utils/constanst/validator.dart';
import 'package:ca_app/widgets/active_deactive_widget.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_card.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/custom_text_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';


class ViewClientScreen extends StatefulWidget {
  final String userId;
  const ViewClientScreen({super.key, required this.userId});

  @override
  State<ViewClientScreen> createState() => _ViewClientScreenState();
}

class _ViewClientScreenState extends State<ViewClientScreen> {
  @override
  void initState() {
    super.initState();
    _getUserDetail();
  }

  void _getUserDetail() {
    context.read<AuthBloc>().add(GetUserByIdEvent(userId: widget.userId));
  }

  Data? data;
  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
        appBar: CustomAppbar(
          title: 'View Client',
          backIconVisible: true,
        ),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is AuthLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: ColorConstants.buttonColor,
                ),
              );
            } else if (state is AuthErrorState) {
              return Center(
                child: Text(
                  'No Data Found!',
                  style: AppTextStyle().redText,
                ),
              );
              // ignore: unnecessary_type_check
            } else if (state is GetUserByIdSuccess) {
              data = state.getUserByIdData?.data;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text(
                      //       '${data?.firstName ?? ''} ${data?.lastName ?? ''}',
                      //       style: AppTextStyle().headingtext,
                      //     ),

                      //   ],
                      // ),
                      SizedBox(height: 10),
                      Stack(
                        children: [
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
                                      '${data?.firstName?[0]}',
                                      style: AppTextStyle().largWhitetext,
                                    ),
                                    Text(
                                      '${data?.lastName?[0]}',
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
                                    '${data?.firstName ?? ''} ${data?.lastName ?? ''}',
                                    style: AppTextStyle().textButtonStyle,
                                  ),
                                  subTitle(Icons.email, data?.email ?? ''),
                                  subTitle(Icons.call,
                                      '+${data?.countryCode ?? ''} ${data?.mobile ?? ''}'),
                                  (data?.address ?? '').isEmpty
                                      ? SizedBox.shrink()
                                      : subTitle(Icons.location_on,
                                          data?.address ?? ''),
                                ],
                              ))
                            ],
                          ),
                          Positioned(
                            right: 0,
                            top: -10,
                            child: PopupMenuButton<String>(
                              position: PopupMenuPosition.under,
                              color: ColorConstants.white,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              constraints:
                                  BoxConstraints(minWidth: 90, maxWidth: 140),
                              offset: Offset(0, 0),
                              icon: Icon(
                                Icons.more_vert_rounded,
                                color: ColorConstants.buttonColor,
                              ),
                              onSelected: (value) {
                                debugPrint("Selected: $value");
                                if (value == 'Deactive' || value == 'Active') {
                                  _showModalBottomSheet(
                                      context: context,
                                      actionUponId: data?.id.toString() ?? '',
                                      action: value);
                                } else if (value == 'Logs') {
                                  context.push('/ca_dashboard/logs_history',
                                      extra: {"uponId": data?.id.toString()});
                                } else if (value == 'Update Service') {
                                  context.push('/ca_dashboard/assign_service',
                                      extra: {
                                        'clientId': data?.id.toString() ?? '',
                                        'serviceList': data?.services
                                                ?.map((toElement) =>
                                                    '${toElement.subService} (${toElement.serviceName})')
                                                .toList() ??
                                            [],
                                        'serviceIdList': data?.services
                                                ?.map((toElement) =>
                                                    toElement.serviceId)
                                                .toList() ??
                                            [],
                                      }).then((onValue) {
                                    _getUserDetail();
                                  });
                                }
                              },
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<String>>[
                                PopupMenuItem<String>(
                                    height: 45,
                                    value: data?.status == true
                                        ? 'Deactive'
                                        : 'Active',
                                    child: SizedBox(
                                        width: 120,
                                        child: Text(data?.status == true
                                            ? 'Deactive'
                                            : 'Active'))),
                                PopupMenuItem<String>(
                                    height: 45,
                                    value: 'Logs',
                                    child: SizedBox(
                                        width: 120, child: Text('Logs'))),
                                if ((data?.services ?? []).isNotEmpty)
                                  PopupMenuItem<String>(
                                      height: 45,
                                      value: 'Update Service',
                                      child: SizedBox(
                                          width: 120,
                                          child: Text('Update Service'))),
                              ],
                            ),
                          ),
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
                                  lable: 'Pan Card',
                                  value: data?.panCardNumber ?? '__'),
                              textItem(
                                  lable: 'Company Name',
                                  value: data?.companyName ?? '__'),
                              textItem(
                                  lable: 'Aadhaar Card',
                                  value: data?.aadhaarCardNumber ?? '__'),
                              textItem(
                                  lable: 'Created Date',
                                  value: dateFormate(data?.createdDate)),
                              textItem(
                                  lable: 'Gender', value: data?.gender ?? '__'),
                              textItem(
                                  lable: 'Status',
                                  value: data?.status == true
                                      ? 'Active'
                                      : "In-Active"),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Assigned CA Name',
                            style: AppTextStyle().cardLableText,
                          ),
                          SizedBox(width: 5),
                          Text(
                            ':',
                            style: AppTextStyle().cardLableText,
                          ),
                          SizedBox(width: 5),
                          Text(
                            '${data?.caName}',
                            style: AppTextStyle().listTileText,
                          )
                        ],
                      ),
                      (data?.services ?? []).isNotEmpty
                          ? Divider()
                          : SizedBox.shrink(),

                      (data?.services ?? []).isNotEmpty
                          ? Text(
                              'Assigned Services :->',
                              style: AppTextStyle().cardLableText,
                            )
                          : SizedBox.shrink(),

                      ...List.generate(
                        data?.services?.length ?? 0,
                        (index) {
                          return CustomCard(
                              child: Column(
                            children: [
                              CustomTextItem(
                                  lable: 'Service Name',
                                  value:
                                      data?.services?[index].serviceName ?? ''),
                              CustomTextItem(
                                  lable: 'Sub Service Name',
                                  value:
                                      data?.services?[index].subService ?? ''),
                              CustomTextItem(
                                  lable: 'Service Description',
                                  value:
                                      data?.services?[index].serviceDesc ?? ''),
                            ],
                          ));
                        },
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonButtonWidget(
                            buttonWidth: 140,
                            buttonColor: ColorConstants.white,
                            buttonBorderColor: ColorConstants.buttonColor,
                            tileStyle: AppTextStyle().textMediumButtonStyle,
                            buttonTitle: 'View Document',
                            onTap: () {
                              context.push('/ca_dashboard/view_document',
                                  extra: {"userId": data?.id.toString()});
                            },
                          ),
                          CommonButtonWidget(
                            buttonWidth: 150,
                            // buttonColor: ColorConstants.white,
                            // buttonBorderColor: ColorConstants.buttonColor,
                            // tileStyle: AppTextStyle().textMediumButtonStyle,
                            buttonTitle: 'Raise Request',
                            onTap: () {
                              context.push('/raise_request',
                                  extra: {'role': 'CA'});
                            },
                          ),
                        ],
                      ),
                      Divider(),
                      // CommonButtonWidget(
                      //   buttonWidth: 150,
                      //   buttonColor: ColorConstants.white,
                      //   buttonBorderColor: ColorConstants.buttonColor,
                      //   tileStyle: AppTextStyle().textMediumButtonStyle,
                      //   buttonTitle: 'Document Request',
                      //   onTap: () {},
                      // ),
                      // Divider(),
                    ],
                  ),
                ),
              );
            }
            return Container();
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

  Future<void> _showModalBottomSheet(
      {required BuildContext context,
      required String actionUponId,
      required String action}) {
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
                child: ActiveDeactiveWidget(
                  actionUponId: actionUponId,
                  action: action,
                ),
              ),
            );
          });
        });
  }
}
