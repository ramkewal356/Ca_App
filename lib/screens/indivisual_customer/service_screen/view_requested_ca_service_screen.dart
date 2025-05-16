import 'package:ca_app/blocs/service/service_bloc.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/utils/constanst/validator.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/custom_text_info.dart';
import 'package:ca_app/widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewRequestedCaServiceScreen extends StatefulWidget {
  final int serviceOrderId;
  const ViewRequestedCaServiceScreen({super.key, required this.serviceOrderId});

  @override
  State<ViewRequestedCaServiceScreen> createState() =>
      _ViewRequestedCaServiceScreenState();
}

class _ViewRequestedCaServiceScreenState
    extends State<ViewRequestedCaServiceScreen> {
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
                  Text(
                    'Ca Details',
                    style: AppTextStyle().textButtonStyle,
                  ),
                  Divider(),
                  CustomTextInfo(
                      flex1: 2,
                      flex2: 4,
                      lable: 'Ca Name',
                      value: '${data?.caName}'),
                  CustomTextInfo(
                      flex1: 2,
                      flex2: 4,
                      lable: 'Ca Email',
                      value: '${data?.caEmail}'),
                  CustomTextInfo(
                      flex1: 2,
                      flex2: 4,
                      lable: 'Ca Mobile No',
                      value: '${data?.caMobile}'),
                  CustomTextInfo(
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

  _textItem({required String lable, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lable,
          style: AppTextStyle().hintText,
        ),
        Text(
          value,
          style: AppTextStyle().cardValueText,
        )
      ],
    );
  }
}
