import 'package:ca_app/blocs/service/service_bloc.dart';
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

class RequestedCaServiceScreen extends StatefulWidget {
  const RequestedCaServiceScreen({super.key});

  @override
  State<RequestedCaServiceScreen> createState() =>
      _RequestedCaServiceScreenState();
}

class _RequestedCaServiceScreenState extends State<RequestedCaServiceScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String title = 'All';
  String filterText = '';
  String searchText = '';
  @override
  void initState() {
    super.initState();
    _getRequestedCalist(isFilter: true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.addListener(_onScroll);
    });
  }

  _getRequestedCalist(
      {bool isFilter = false,
      bool isSearch = false,
      bool isPagination = false}) {
    context.read<ServiceBloc>().add(GetServiceRequestedCaEvent(
        isPagination: isPagination,
        isSearch: isSearch,
        searchText: searchText,
        isFilter: isFilter,
        filterTex: filterText));
  }

  void _onFilterChanged(String value) {
    setState(() {
      filterText = value;
      title = value == '' ? 'All' : filtersList[value] ?? '';
    });
    _getRequestedCalist(isFilter: true);
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchText = value;
    });
    _getRequestedCalist(isSearch: true);
  }

  _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _getRequestedCalist(isPagination: true);
    }
  }

  Map<String, String> filtersList = {
    "All": '',
    "Pending": 'PENDING',
    "Rejected": 'REJECTED',
    "Accepted": 'ACCEPTED',
  };
  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
      appBar: CustomAppbar(
        title: 'Requested CA By Services',
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
                    serchHintText: 'Search by ca name ',
                    onChanged: _onSearchChanged,
                  ),
                ),
                SizedBox(width: 10),
                CustomFilterPopupWidget(
                    title: title,
                    filterOptions: filtersList,
                    onFilterChanged: _onFilterChanged),
              ],
            ),
            SizedBox(height: 10),
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
                      style: AppTextStyle().getgreenText,
                    ),
                  );
                } else if (state is GetAllServiceRequestedCaSuccess) {
                  return state.requestedCaList.isEmpty
                      ? Center(
                          child: Text(
                            'No Data Found',
                            style: AppTextStyle().getredText,
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: state.requestedCaList.length +
                              (state.isLastPage ? 0 : 1),
                          itemBuilder: (context, index) {
                            if (index == state.requestedCaList.length) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: ColorConstants.buttonColor,
                                ),
                              );
                            }
                            var data = state.requestedCaList[index];
                            return GestureDetector(
                              onTap: () {
                                context.push(
                                    '/indivisual_customer/view_requested_ca',
                                    extra: {
                                      "serviceOrderId": data.serviceOrderId
                                    }).then((onValue) {
                                  _getRequestedCalist(isFilter: true);
                                });
                              },
                              child: CustomCard(
                                  child: Column(
                                children: [
                                  CustomTextInfo(
                                      flex1: 2,
                                      flex2: 3,
                                      lable: 'Ca Name',
                                      value: '${data.caName}'),
                                  // CustomTextInfo(
                                  //     flex1: 2,
                                  //     flex2: 3,
                                  //     lable: 'Email',
                                  //     value: '${data.caEmail}'),
                                  CustomTextInfo(
                                      flex1: 2,
                                      flex2: 3,
                                      lable: 'Company Name',
                                      value: '${data.caCompanyName}'),
                                  // CustomTextInfo(
                                  //     flex1: 2,
                                  //     flex2: 3,
                                  //     lable: 'Mobile no',
                                  //     value: '${data.caMobile}'),
                                  CustomTextInfo(
                                      flex1: 2,
                                      flex2: 3,
                                      lable: 'Service Name',
                                      value: '${data.serviceName}'),
                                  CustomTextInfo(
                                    flex1: 2,
                                    flex2: 3,
                                    lable: 'Status',
                                    value: '${data.orderStatus}',
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
