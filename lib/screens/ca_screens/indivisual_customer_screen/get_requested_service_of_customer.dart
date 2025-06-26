import 'package:ca_app/blocs/indivisual_customer/indivisual_customer_bloc.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_card.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/custom_popup_filter.dart';
import 'package:ca_app/widgets/custom_search_field.dart';
import 'package:ca_app/widgets/custom_text_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class GetRequestedServiceOfCustomer extends StatefulWidget {
  const GetRequestedServiceOfCustomer({super.key});

  @override
  State<GetRequestedServiceOfCustomer> createState() =>
      _GetRequestedServiceOfCustomerState();
}

class _GetRequestedServiceOfCustomerState
    extends State<GetRequestedServiceOfCustomer> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String filterText = '';
  String searchText = '';
  String title = 'All';
  final _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _getRequestedService(isFilter: true);
    _scrollController.addListener(_onScroll);
  }

  _getRequestedService(
      {bool isFilter = false,
      bool isSearch = false,
      bool isPagination = false}) {
    context.read<IndivisualCustomerBloc>().add(GetRequestedServiceByCaIdEvent(
        isFilter: isFilter,
        filterText: filterText,
        isPagination: isPagination));
  }

  onFilterChanged(String value) {
    setState(() {
      filterText = value;
      title = value == '' ? 'All' : filtersList[value] ?? '';
    });
    _getRequestedService(isFilter: true);
  }

  _onSearchChanged(String value) {
    setState(() {
      searchText = value;
    });
    _getRequestedService(isSearch: true);
  }

  _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _getRequestedService(isPagination: true);
    }
  }

  Map<String, String> filtersList = {
    "All": '',
    "Pending": 'PENDING',
    "Rejected": 'REJECTED',
    "Accepted": 'ACCEPTED'
  };
  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
      appBar: CustomAppbar(
        title: 'Enquiry History',
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
                  focusNode: _searchFocus,
                  controller: _searchController,
                  serchHintText: 'Search by name.',
                  onChanged: _onSearchChanged,
                )),
                SizedBox(width: 10),
                CustomFilterPopupWidget(
                    title: title,
                    filterOptions: filtersList,
                    onFilterChanged: onFilterChanged)
              ],
            ),
            SizedBox(height: 10),
            BlocBuilder<IndivisualCustomerBloc, IndivisualCustomerState>(
              builder: (context, state) {
                if (state is IndivisualCustomerLoading) {
                  return Expanded(
                      child: Center(
                    child: CircularProgressIndicator(
                      color: ColorConstants.buttonColor,
                    ),
                  ));
                } else if (state is IndivisualCustomerError) {
                  return Expanded(
                      child: Center(
                    child: Text(
                      'No Data Found',
                      style: AppTextStyle().getredText,
                    ),
                  ));
                } else if (state is GetRequestedServiceByCaIdSuccess) {
                  return Expanded(
                    child: state.getRequestedServiceList.isEmpty
                        ? Center(
                            child: Text(
                              'No Data Found',
                              style: AppTextStyle().getredText,
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            itemCount: state.getRequestedServiceList.length +
                                (state.isLastPage ? 0 : 1),
                            itemBuilder: (context, index) {
                              if (index ==
                                  state.getRequestedServiceList.length) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: ColorConstants.buttonColor,
                                  ),
                                );
                              }
                              var data = state.getRequestedServiceList[index];
                              return GestureDetector(
                                onTap: () {
                                  context.push(
                                      '/indivisual_customer/view_requested_ca',
                                      extra: {
                                        "serviceOrderId": data.serviceOrderId,
                                        "caSide": true
                                      }).then((onValue) {
                                    _getRequestedService(isFilter: true);
                                  });
                                },
                                child: CustomCard(
                                    child: Column(
                                  children: [
                                    CustomTextInfo(
                                        flex1: 2,
                                        flex2: 3,
                                        lable: 'Customer Name',
                                        value: data.customerName ?? ''),
                                    CustomTextInfo(
                                        flex1: 2,
                                        flex2: 3,
                                        lable: 'Customer No',
                                        value:
                                            '+${data.caCountryCode} ${data.caMobile}'),
                                    CustomTextInfo(
                                        flex1: 2,
                                        flex2: 3,
                                        lable: 'Service Name',
                                        value: data.serviceName ?? ''),
                                    CustomTextInfo(
                                        flex1: 2,
                                        flex2: 3,
                                        lable: 'Ca Name',
                                        value: data.caName ?? ''),
                                    CustomTextInfo(
                                      flex1: 2,
                                      flex2: 3,
                                      lable: 'Order Status',
                                      value: data.orderStatus ?? '',
                                      textStyle: data.orderStatus == 'PENDING'
                                          ? AppTextStyle().getYellowText
                                          : data.orderStatus == 'ACCEPTED'
                                              ? AppTextStyle().getgreenText
                                              : data.orderStatus == 'REJECTED'
                                                  ? AppTextStyle().getredText
                                                  : AppTextStyle().getredText,
                                    ),
                                  ],
                                )),
                              );
                            },
                          ),
                  );
                }
                return Container();
              },
            )
          ],
        ),
      ),
    );
  }
}
