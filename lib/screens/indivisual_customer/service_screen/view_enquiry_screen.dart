import 'package:ca_app/blocs/indivisual_customer/indivisual_customer_bloc.dart';
import 'package:ca_app/blocs/service/service_bloc.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/utils/constanst/validator.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/custom_text_info.dart';
import 'package:ca_app/widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ViewEnquiryScreen extends StatefulWidget {
  final int serviceOrderId;
  final bool caSide;
  const ViewEnquiryScreen(
      {super.key, required this.serviceOrderId, this.caSide = false});

  @override
  State<ViewEnquiryScreen> createState() => _ViewEnquiryScreenState();
}

class _ViewEnquiryScreenState extends State<ViewEnquiryScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _commentController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _getViewDetails();
  }

  _getViewDetails() {
    context
        .read<ServiceBloc>()
        .add(ViewRequestedCaByServiceIdEvent(serviceId: widget.serviceOrderId));
  }

  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
      appBar: CustomAppbar(
        title: 'View Requested Ca Services',
        backIconVisible: true,
      ),
      child: BlocBuilder<ServiceBloc, ServiceState>(
        builder: (context, state) {
          if (state is ServiceLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: ColorConstants.buttonColor,
              ),
            );
          } else if (state is ServiceError) {
            return Center(
              child: Text(
                'No Data Found',
                style: AppTextStyle().getredText,
              ),
            );
          } else if (state is ViewRequestedCaByServiceIdSuccess) {
            var data = state.getViewRequestedCaByServiceIdModel.data;
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.caSide ? 'Customer details' : 'Ca Details',
                        style: AppTextStyle().textButtonStyle,
                      ),
                      (widget.caSide && data?.orderStatus == 'PENDING')
                          ? BlocConsumer<IndivisualCustomerBloc,
                              IndivisualCustomerState>(
                              listener: (context, state) {
                                if (state is AcceptOrRejectServiceSuccess) {
                                  _getViewDetails();
                                }
                              },
                              builder: (context, state) {
                                return PopupMenuButton<String>(
                                  surfaceTintColor: ColorConstants.white,
                                  color: ColorConstants.white,
                                  position: PopupMenuPosition.under,
                                  onSelected: (value) {
                                    if (value == 'Accept') {
                                      debugPrint('vcvcv$value');
                                      context
                                          .read<IndivisualCustomerBloc>()
                                          .add(AcceptOrRejectServiceEvent(
                                              serviceOrderId:
                                                  data?.serviceOrderId ?? 0,
                                              orderStatus: 'ACCEPTED'));
                                    } else if (value == 'Reject') {
                                      debugPrint('vcvc1v$value');
                                      _showCommentDailog(
                                        context: context,
                                        onTap: () {
                                          debugPrint(
                                              ' bnmmn     mnmnmnmbnmn   mnmnnm');
                                          context
                                              .read<IndivisualCustomerBloc>()
                                              .add(AcceptOrRejectServiceEvent(
                                                  serviceOrderId:
                                                      data?.serviceOrderId ?? 0,
                                                  orderStatus: 'REJECTED',
                                                  comment:
                                                      _commentController.text));
                                        },
                                      );
                                    }
                                  },
                                  itemBuilder: (context) {
                                    return <PopupMenuEntry<String>>[
                                      PopupMenuItem<String>(
                                          value: 'Accept',
                                          child: Text(
                                            'Accept',
                                            style: AppTextStyle().getgreenText,
                                          )),
                                      PopupMenuItem<String>(
                                          value: 'Reject',
                                          child: Text(
                                            'Reject',
                                            style: AppTextStyle().getredText,
                                          )),
                                    ];
                                  },
                                );
                              },
                            )
                          : SizedBox.shrink()
                    ],
                  ),
                  Divider(),
                  CustomTextInfo(
                      flex1: 2,
                      flex2: 4,
                      lable: widget.caSide ? 'Customer Name' : 'Ca Name',
                      value: widget.caSide
                          ? data?.customerName ?? ''
                          : '${data?.caName}'),
                  CustomTextInfo(
                      flex1: 2,
                      flex2: 4,
                      lable: widget.caSide ? 'Customer Email' : 'Ca Email',
                      value: widget.caSide
                          ? data?.customerEmail ?? ''
                          : '${data?.caEmail}'),
                  CustomTextInfo(
                      flex1: 2,
                      flex2: 4,
                      lable: widget.caSide ? 'Customer Mobile' : 'Ca Mobile No',
                      value: widget.caSide
                          ? '+${data?.caCountryCode ?? ''} ${data?.customerMobile ?? ''}'
                          : '+${data?.caCountryCode ?? ''} ${data?.caMobile ?? ''}'),
                  widget.caSide
                      ? SizedBox.shrink()
                      : CustomTextInfo(
                          flex1: 2,
                          flex2: 4,
                          lable: 'Company Name',
                          value: '${data?.caCompanyName}'),
                  SizedBox(height: 20),
                  Text(
                    'Service Details',
                    style: AppTextStyle().textButtonStyle,
                  ),
                  Divider(),
                  CustomTextInfo(
                      flex1: 2,
                      flex2: 4,
                      lable: 'Service Name',
                      value: '${data?.serviceName}'),
                  CustomTextInfo(
                      flex1: 2,
                      flex2: 4,
                      lable: 'Sub-Service',
                      value: '${data?.subService}'),
                  CustomTextInfo(
                      flex1: 2,
                      flex2: 4,
                      lable: 'Urgency Level',
                      value: '${data?.urgencyLevel}'),
                  CustomTextInfo(
                      flex1: 2,
                      flex2: 4,
                      lable: 'Created date',
                      value: dateFormate(data?.createdDate)),
                  CustomTextInfo(
                    flex1: 2,
                    flex2: 4,
                    lable: 'OrderStatus',
                    value: '${data?.orderStatus}',
                    textStyle: data?.orderStatus == 'PENDING'
                        ? AppTextStyle().getYellowText
                        : data?.orderStatus == 'ACCEPTED'
                            ? AppTextStyle().getgreenText
                            : data?.orderStatus == 'REJECTED'
                                ? AppTextStyle().getredText
                                : AppTextStyle().getredText,
                  ),
                  data?.orderStatus == 'REJECTED'
                      ? CustomTextInfo(
                          flex1: 2,
                          flex2: 4,
                          lable: 'Comment',
                          value: '${data?.rejectionComment}')
                      : SizedBox.shrink(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Description',
                          style: AppTextStyle().lableText,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        ':',
                        style: AppTextStyle().lableText,
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        flex: 4,
                        child: Text(
                          data?.serviceDesc ?? '',
                          style: AppTextStyle().cardValueText,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  data?.orderStatus == 'ACCEPTED'
                      ? CommonButtonWidget(
                          buttonTitle: 'Raise Request',
                          onTap: () {
                            context.push('/raise_request', extra: {
                              'role': widget.caSide ? 'CA' : 'CUSTOMER',
                              "selectedUser": widget.caSide
                                  ? data?.customerName
                                  : data?.caName,
                              "selectedId": data?.serviceOrderId
                            });
                          },
                        )
                      : SizedBox(),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     Expanded(
                  //       child: _textItem(
                  //           lable: 'ServiceOrderId',
                  //           value: '#${data?.serviceOrderId}'),
                  //     ),
                  //     Expanded(
                  //         child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       mainAxisAlignment: MainAxisAlignment.start,
                  //       children: [
                  //         Text(
                  //           'Status',
                  //           style: AppTextStyle().hintText,
                  //         ),
                  //         SizedBox(height: 5),
                  //         Text(
                  //           data?.orderStatus ?? 'N/A',
                  //           style: data?.orderStatus == 'PENDING'
                  //               ? AppTextStyle().getYellowText
                  //               : data?.orderStatus == 'ACCEPTED'
                  //                   ? AppTextStyle().getgreenText
                  //                   : data?.orderStatus == 'REJECTED'
                  //                       ? AppTextStyle().getredText
                  //                       : AppTextStyle().getredText,
                  //         ),
                  //       ],
                  //     ))
                  //   ],
                  // ),
                  // SizedBox(height: 5),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: _textItem(
                  //           lable: 'Ca Name', value: '${data?.caName}'),
                  //     ),
                  //     Expanded(
                  //       child: _textItem(
                  //           lable: 'Created Date',
                  //           value: dateFormate(data?.createdDate)),
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(height: 5),
                  // // _textItem(lable: 'Subject', value: 'Swabi jhjndskjfjk'),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     Expanded(
                  //       child: _textItem(
                  //           lable: 'Ca Email', value: '${data?.caEmail}'),
                  //     ),
                  //     Expanded(
                  //       child: _textItem(
                  //           lable: 'Ca Mobile', value: '${data?.caMobile}'),
                  //     )
                  //   ],
                  // ),
                  // SizedBox(height: 5),

                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     Expanded(
                  //       child: _textItem(
                  //           lable: 'Company Name',
                  //           value: '${data?.caCompanyName}'),
                  //     ),
                  //     Expanded(
                  //       child: _textItem(
                  //           lable: 'Service Name',
                  //           value: '${data?.serviceName}'),
                  //     )
                  //   ],
                  // ),
                  // SizedBox(height: 5),
                  // _textItem(
                  //     lable: 'Sub-Service Name', value: '${data?.subService}'),
                  // SizedBox(height: 5),

                  // Text(
                  //   'Service Description : ',
                  //   style: AppTextStyle().lableText,
                  // ),
                  // SizedBox(height: 5),
                  // TextformfieldWidget(
                  //     readOnly: true,
                  //     maxLines: 3,
                  //     minLines: 3,
                  //     controller:
                  //         TextEditingController(text: '${data?.serviceDesc}'),
                  //     hintText: 'Description'),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  Future<void> _showCommentDailog({
    required BuildContext context,
    required VoidCallback onTap,
  }) {
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
                child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text.rich(TextSpan(children: [
                                TextSpan(
                                    text: 'Note : ',
                                    style: AppTextStyle().cardLableText),
                                TextSpan(
                                    text: 'Are you sure you want to ',
                                    style: AppTextStyle().cardValueText),
                                TextSpan(
                                    text: 'Reject ?',
                                    style: AppTextStyle().getredText)
                              ])),
                              IconButton(
                                  onPressed: () {
                                    context.pop();
                                  },
                                  icon: Icon(Icons.close))
                            ],
                          ),
                          SizedBox(height: 15),
                          TextformfieldWidget(
                            controller: _commentController,
                            hintText: 'Please enter comment',
                            validator: (p0) {
                              if (p0 == null || p0.isEmpty) {
                                return 'Please enter comment';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 15),
                          BlocConsumer<IndivisualCustomerBloc,
                              IndivisualCustomerState>(
                            listener: (context, state) {
                              if (state is AcceptOrRejectServiceSuccess) {
                                _commentController.clear();
                                context.pop();
                              }
                            },
                            builder: (context, state) {
                              return CommonButtonWidget(
                                buttonTitle: 'Reject',
                                loader: state is IndivisualCustomerLoading,
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    onTap();
                                  }
                                },
                              );
                            },
                          )
                        ],
                      ),
                    )),
              ),
            );
          });
        });
  }

  // _textItem({required String lable, required String value}) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         lable,
  //         style: AppTextStyle().hintText,
  //       ),
  //       Text(
  //         value,
  //         style: AppTextStyle().cardValueText,
  //       )
  //     ],
  //   );
  // }
}
