import 'package:ca_app/blocs/service/service_bloc.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_card.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/custom_search_field.dart';
import 'package:ca_app/widgets/custom_text_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CustomerServicesScreen extends StatefulWidget {
  const CustomerServicesScreen({super.key});

  @override
  State<CustomerServicesScreen> createState() => _CustomerServicesScreenState();
}

class _CustomerServicesScreenState extends State<CustomerServicesScreen> {
  final _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String searchText = '';
  @override
  void initState() {
    super.initState();
    _getServiceList(isSearch: true);
    _scrollController.addListener(_onScroll);
  }

  void _getServiceList(
      {bool isSearch = false,
      bool isPagination = false,
      bool isFilterByLocation = false}) {
    context.read<ServiceBloc>().add(GetServiceForCustomerEvent(
        isFilterByLocation: isFilterByLocation,
        location: '',
        isSearch: isSearch,
        searchText: searchText,
        isPagination: isPagination));
  }

  _onSearchChanged(String value) {
    setState(() {
      searchText = value;
    });
    _getServiceList(isSearch: true);
  }

  _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _getServiceList(isPagination: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
      appBar: CustomAppbar(
        title: 'Services',
        backIconVisible: true,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomSearchField(
                    controller: _searchController,
                    serchHintText: 'search services',
                    onChanged: _onSearchChanged,
                  ),
                ),
                SizedBox(width: 10),
                CommonButtonWidget(
                  buttonWidth: 130,
                  buttonheight: 45,
                  buttonTitle: 'Requested CA',
                  onTap: () {
                    context
                        .push('/indivisual_customer/requested_ca')
                        .then((onValue) {
                      _getServiceList(isSearch: true);
                    });
                  },
                )
              ],
            ),
            SizedBox(height: 5),
            Expanded(child: BlocBuilder<ServiceBloc, ServiceState>(
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
                } else if (state is GetServiceForIndivisualCustomerSuccess) {
                  return state.serviceForCustomerList.isEmpty
                      ? Center(
                          child: Text(
                            'No Data Found',
                            style: AppTextStyle().getredText,
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: state.serviceForCustomerList.length +
                              (state.isLastPage ? 0 : 1),
                          itemBuilder: (context, index) {
                            if (index == state.serviceForCustomerList.length) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: ColorConstants.buttonColor,
                                ),
                              );
                            }
                            var data = state.serviceForCustomerList[index];
                            return GestureDetector(
                              onTap: () {
                                context.push(
                                    '/indivisual_customer/view_service',
                                    extra: {
                                      'serviceId': data.serviceId
                                    }).then((onValue) {
                                  _getServiceList(isSearch: true);
                                });
                              },
                              child: CustomCard(
                                  child: Column(
                                children: [
                                  CustomTextInfo(
                                      flex1: 2,
                                      flex2: 4,
                                      lable: 'Service Name',
                                      value: '${data.serviceName}'),
                                  CustomTextInfo(
                                      flex1: 2,
                                      flex2: 4,
                                      lable: 'Sub-Service',
                                      value: '${data.subService}'),
                                  CustomTextInfo(
                                      flex1: 2,
                                      flex2: 4,
                                      lable: 'Description',
                                      value: '${data.serviceDesc}')
                                ],
                              )),
                            );
                          },
                        );
                }
                return Container();
              },
            ))
          ],
        ),
      ),
    );
  }
}
