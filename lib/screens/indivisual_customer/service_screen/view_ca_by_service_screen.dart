import 'package:ca_app/blocs/service/service_bloc.dart';
import 'package:ca_app/data/models/get_calist_by_servicename_model.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_card.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/custom_text_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewCaByServiceScreen extends StatefulWidget {
  final int serviceId;
  const ViewCaByServiceScreen({super.key, required this.serviceId});

  @override
  State<ViewCaByServiceScreen> createState() => _ViewCaByServiceScreenState();
}

class _ViewCaByServiceScreenState extends State<ViewCaByServiceScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _getViewCaByService();
    _scrollController.addListener(_onScroll);
  }

  _getViewCaByService({bool isPagination = false}) {
    context.read<ServiceBloc>().add(GetCaByServiceNameEvent(
        serviceId: widget.serviceId, isPagination: isPagination));
  }

  _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      debugPrint('nvbnxcbvbvmnxcbmnvcmn');
      _getViewCaByService(isPagination: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('serviceId ${widget.serviceId}');
    return CustomLayoutPage(
      appBar: CustomAppbar(
        title: 'View Services',
        backIconVisible: true,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
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
                child: Text('No Data Found'),
              );
            } else if (state is GetCaByServiceNameSuccess) {
              int serviceId = state.serviceId;
              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: ColorConstants.darkGray.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Service Name',
                                style: AppTextStyle().lableText,
                              ),
                              SizedBox(width: 5),
                              Text(
                                ':',
                                style: AppTextStyle().lableText,
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  state.serviceName,
                                  style: AppTextStyle().textMediumButtonStyle,
                                ),
                              )
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sub-Service',
                                style: AppTextStyle().lableText,
                              ),
                              SizedBox(width: 18),
                              Text(
                                ':',
                                style: AppTextStyle().lableText,
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  state.subService,
                                  style: AppTextStyle().cardValueText,
                                ),
                              )
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Description',
                                style: AppTextStyle().lableText,
                              ),
                              SizedBox(width: 22),
                              Text(
                                ':',
                                style: AppTextStyle().lableText,
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  state.serviceDesc,
                                  style: AppTextStyle().cardValueText,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount:
                          state.caList.length + (state.isLastPage ? 0 : 1),
                      itemBuilder: (context, index) {
                        if (index == state.caList.length) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: ColorConstants.buttonColor,
                            ),
                          );
                        }
                        List<CaList> caList = state.caList;
                        var caData = state.caList[index];
                        return CustomCard(
                            child: Column(
                          children: [
                            CustomTextInfo(
                                flex1: 2,
                                flex2: 3,
                                lable: 'Ca Name',
                                value: '${caData.fullName}'),
                            CustomTextInfo(
                                flex1: 2,
                                flex2: 3,
                                lable: 'Email id',
                                value: '${caData.email}'),
                            CustomTextInfo(
                                flex1: 2,
                                flex2: 3,
                                lable: 'Mobile No',
                                value: '${caData.mobile}'),
                            CustomTextInfo(
                                flex1: 2,
                                flex2: 3,
                                lable: 'Company Name',
                                value: '${caData.companyName}'),
                            (caData.orderStatus ?? '').isEmpty
                                ? SizedBox.shrink()
                                : CustomTextInfo(
                                    flex1: 2,
                                    flex2: 3,
                                    lable: 'Status',
                                    value: caData.orderStatus ?? '',
                                    textStyle: caData.orderStatus == 'PENDING'
                                        ? AppTextStyle().getYellowText
                                        : caData.orderStatus == 'ACCEPTED'
                                            ? AppTextStyle().getgreenText
                                            : caData.orderStatus == 'REJECTED'
                                                ? AppTextStyle().getredText
                                                : AppTextStyle().getredText,
                                  ),
                            (caData.orderStatus ?? '').isNotEmpty
                                ? SizedBox.shrink()
                                : BlocConsumer<AssignServiceBloc, ServiceState>(
                                    listener: (context, state) {
                                      if (state
                                          is SendSericeRequestOrderSuccess) {
                                        _getViewCaByService();
                                      }
                                    },
                                    builder: (context, state) {
                                      return Align(
                                        alignment: Alignment.bottomRight,
                                        child: CommonButtonWidget(
                                          disable: (caList.any((test) =>
                                              test.orderStatus == 'PENDING')),
                                          loader: state
                                                  is SendServiceRequestLoading &&
                                              (state.caId == caData.caId),
                                          buttonWidth: 130,
                                          buttonheight: 45,
                                          buttonTitle: 'Send Request',
                                          onTap: () {
                                            context
                                                .read<AssignServiceBloc>()
                                                .add(
                                                    SendSercieRequestOrderEvent(
                                                        serviceId: serviceId,
                                                        caId:
                                                            caData.caId ?? 0));
                                          },
                                        ),
                                      );
                                    },
                                  )
                          ],
                        ));
                      },
                    ),
                  )
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
