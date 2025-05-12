import 'package:ca_app/blocs/raise_request/raise_request_bloc.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/utils/constanst/validator.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
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

class ClientRequestScreen extends StatefulWidget {
  final String role;
  const ClientRequestScreen({super.key, required this.role});

  @override
  State<ClientRequestScreen> createState() => _ClientRequestScreenState();
}

class _ClientRequestScreenState extends State<ClientRequestScreen> {
  String searchText = '';
  String filterText = '';
  String title = 'All';
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    _getRaiseRequest(isSearch: true);
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _getRaiseRequest(
      {bool isPagination = false,
      bool isSearch = false,
      bool isFilter = false}) {
    context.read<RaiseRequestBloc>().add(GetRequestByReceiverIdEvent(
        isPagination: isPagination,
        isSearch: isSearch,
        searchText: searchText,
        isFilter: isFilter,
        filterText: filterText));
  }

  void _onScroll() {
    if (_scrollController.position.pixels >
        _scrollController.position.maxScrollExtent - 200) {
      _getRaiseRequest(isPagination: true);
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchText = value;
    });
    _getRaiseRequest(isSearch: true);
  }

  void _onFilterChanged(String value) {
    setState(() {
      title = value == '' ? 'All' : filtersList[value] ?? '';
      filterText = value;
    });
    _getRaiseRequest(isFilter: true);
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
        title: 'Client Request',
        backIconVisible: true,
      ),
      onRefresh: () async {
        _getRaiseRequest(isSearch: true);
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomSearchField(
                    controller: _searchController,
                    serchHintText: 'search by userId',
                    onChanged: _onSearchChanged,
                  ),
                ),
                SizedBox(width: 10),
                CustomFilterPopupWidget(
                    title: title,
                    filterOptions: filtersList,
                    onFilterChanged: _onFilterChanged)
              ],
            ),
            // SizedBox(height: 5),
            BlocBuilder<RaiseRequestBloc, RaiseRequestState>(
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
                return Expanded(
                  child: Center(
                    child: Text(
                      'No Data Found!',
                      style: AppTextStyle().redText,
                    ),
                  ),
                );
              } else if (state is GetRequestByRecieverIdSuccess) {
                return state.requestData.isEmpty
                    ? Expanded(
                        child: Center(
                          child: Text(
                            'No Data Found',
                            style: AppTextStyle().redText,
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
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
                            return CustomCard(
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
                                    Text(dateFormate(data.createdDate)),
                                  ],
                                ),
                                CustomTextInfo(
                                    flex1: 2,
                                    flex2: 3,
                                    lable: 'CA (RECEIVER)',
                                    value:
                                        '${data.receiverName} (#${data.receiverId})'),
                                CustomTextInfo(
                                    flex1: 2,
                                    flex2: 3,
                                    lable: 'CLIENT (SENDER)',
                                    value:
                                        '${data.senderName} (#${data.senderId})'),
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
                                SizedBox(height: 5),
                                Align(
                                    alignment: Alignment.bottomRight,
                                    child: CommonButtonWidget(
                                        buttonWidth: 100,
                                        buttonTitle: 'View',
                                        onTap: () {
                                          if (widget.role == 'SUBCA') {
                                            context
                                                .read<ChangeStatusBloc>()
                                                .add(UnreadToReadStatusEvent(
                                                    requestId:
                                                        data.requestId ?? 0));
                                          }
                                          context.push('/request_details',
                                              extra: {
                                                "requestId": data.requestId
                                              }).then((onValue) {
                                            _getRaiseRequest(isSearch: true);
                                          });
                                        }))
                              ],
                            ));
                          },
                        ),
                      );
              }
              return Container();
            })
          ],
        ),
      ),
    );
  }
}
