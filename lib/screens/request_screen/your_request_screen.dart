import 'package:ca_app/blocs/raise_request/raise_request_bloc.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/utils/constanst/validator.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_card.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/custom_popup_filter.dart';
import 'package:ca_app/widgets/custom_search_field.dart';
import 'package:ca_app/widgets/custom_text_info.dart';
import 'package:ca_app/widgets/custom_text_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class YourRequestScreen extends StatefulWidget {
  final String role;
  const YourRequestScreen({super.key, required this.role});

  @override
  State<YourRequestScreen> createState() => _YourRequestScreenState();
}

class _YourRequestScreenState extends State<YourRequestScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _controller = TextEditingController();
  String searchText = '';
  String filterText = '';
  String title = 'All';
  final _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _fetchRequestList(isSearch: true);
    _scrollController.addListener(_onSroll);
  }

  void _fetchRequestList(
      {bool isPagination = false,
      bool isSearch = false,
      bool isFilter = false}) {
    context.read<RaiseRequestBloc>().add(GetYourRequestEvent(
        isPagination: isPagination,
        isSearch: isSearch,
        searchText: searchText,
        isFilter: isFilter,
        filterText: filterText));
  }

  void _onSroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _fetchRequestList(isPagination: true);
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchText = value;
    });
    _fetchRequestList(isSearch: true);
  }

  void _onFilterChanged(String value) {
    setState(() {
      title = value == '' ? 'All' : filtersList[value] ?? '';
      filterText = value;
    });
    _fetchRequestList(isFilter: true);
  }

  Map<String, String> filtersList = {
    "All": '',
    "Read": 'read',
    "Unread": 'unread',
  };
  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
      appBar: CustomAppbar(
        title: 'Your Request',
        backIconVisible: true,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: CustomSearchField(
                    focusNode: _searchFocus,
                    controller: _controller,
                    serchHintText: 'Search by id & name',
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
            BlocConsumer<RaiseRequestBloc, RaiseRequestState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is RaiseRequestLoading) {
                  return Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: ColorConstants.buttonColor,
                      ),
                    ),
                  );
                } else if (state is RaiseRequestError) {
                  return Center(
                    child: Text('No Data Found'),
                  );
                } else if (state is GetYourRequestListSuccess) {
                  return Expanded(
                    child: state.requestData.isEmpty
                        ? Center(
                            child: Text(
                              'No Data Found',
                              style: AppTextStyle().redText,
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            itemCount: state.requestData.length +
                                (state.isLastPage ? 0 : 1),
                            itemBuilder: (context, index) {
                              if (index == state.requestData.length) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: ColorConstants.buttonColor,
                                  ),
                                );
                              }
                              var data = state.requestData[index];
                              return GestureDetector(
                                onTap: () {
                                  context.push('/request_details', extra: {
                                    "requestId": data.requestId
                                  }).then((onValue) {
                                    _fetchRequestList(isSearch: true);
                                  });
                                },
                                child: CustomCard(
                                    child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: CustomTextItem(
                                                lable: 'ID',
                                                value: '#${data.requestId}')),
                                        Text(
                                          dateFormate(data.createdDate),
                                          style: AppTextStyle().cardValueText,
                                        ),
                                      ],
                                    ),
                                    CustomTextInfo(
                                        flex1: 2,
                                        flex2: 3,
                                        lable: widget.role == 'CUSTOMER'
                                            ? 'CA (SENDER)'
                                            : 'CLIENT (RECEIVER)',
                                        value:
                                            '${data.receiverName ?? ''}(#${data.receiverId})'),
                                    CustomTextInfo(
                                        flex1: 2,
                                        flex2: 3,
                                        lable: widget.role == 'CUSTOMER'
                                            ? 'CLIENT (RECEIVER)'
                                            : 'CA (SENDER)',
                                        value:
                                            '${data.senderName}(#${data.senderId})'),
                                    CustomTextInfo(
                                      flex1: 2,
                                      flex2: 3,
                                      lable: 'READ STATUS',
                                      value: data.readStatus == null
                                          ? 'N/A'
                                          : '${data.readStatus}',
                                      textStyle: data.readStatus == 'READ'
                                          ? AppTextStyle().getgreenText
                                          : AppTextStyle().getredText,
                                    ),
                                    CustomTextInfo(
                                        flex1: 2,
                                        flex2: 3,
                                        lable: 'DESCRIPTION',
                                        value: '${data.text}'),
                                    // BlocBuilder<RaiseRequestBloc,
                                    //     RaiseRequestState>(
                                    //   builder: (context, state) {
                                    //     return Align(
                                    //         alignment: Alignment.bottomRight,
                                    //         child: CommonButtonWidget(
                                    //             buttonWidth: 100.0,
                                    //             loader: state
                                    //                     is GetRequestDetailsLoading &&
                                    //                 data.requestId ==
                                    //                     state.requsetId,
                                    //             buttonTitle: 'View',
                                    //             onTap: () {
                                    //               // if (widget.role == 'CUSTOMER') {
                                    //               //   context
                                    //               //       .read<ChangeStatusBloc>()
                                    //               //       .add(UnreadToReadStatusEvent(
                                    //               //           requestId:
                                    //               //               data.requestId ??
                                    //               //                   0));
                                    //               // }
                                    //               // context.push('/request_details',
                                    //               //     extra: {
                                    //               //       "requestId":
                                    //               //           data.requestId
                                    //               //     }).then((onValue) {
                                    //               //   _fetchRequestList(
                                    //               //       isSearch: true);
                                    //               // });
                                    //             }));
                                    //   },
                                    // )
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
