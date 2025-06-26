import 'package:ca_app/blocs/raise_request/raise_request_bloc.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/utils/constanst/validator.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_card.dart';
import 'package:ca_app/widgets/custom_popup_filter.dart';
import 'package:ca_app/widgets/custom_search_field.dart';
import 'package:ca_app/widgets/custom_text_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RaiseTeamScreen extends StatefulWidget {
  const RaiseTeamScreen({super.key});

  @override
  State<RaiseTeamScreen> createState() => _RaiseTeamScreenState();
}

class _RaiseTeamScreenState extends State<RaiseTeamScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String searchText = '';
  String filterText = '';
  String title = 'All';
  final _searchFocus = FocusNode();

  @override
  void initState() {
    _fetchRequestOfTeam(isSearch: true);
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _fetchRequestOfTeam(
      {isPagination = false, isSearch = false, bool isFilter = false}) {
    context.read<RaiseRequestBloc>().add(GetRequestOfTeamEvent(
        isPagination: isPagination,
        isSearch: isSearch,
        searchText: searchText,
        isFilter: isFilter,
        filterText: filterText));
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _fetchRequestOfTeam(isPagination: true);
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchText = value;
    });
    _fetchRequestOfTeam(isSearch: true);
  }

  void _onFilterChanged(String value) {
    setState(() {
      title = value == '' ? 'All' : filtersList[value] ?? '';
      filterText = value;
    });
    _fetchRequestOfTeam(isFilter: true);
  }

  Map<String, String> filtersList = {
    "All": '',
    "Read": 'read',
    "Unread": 'unread',
  };
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomSearchField(
                focusNode: _searchFocus,
                controller: _searchController,
                serchHintText: 'search',
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
        BlocBuilder<RaiseRequestBloc, RaiseRequestState>(
          builder: (context, state) {
            if (state is RaiseRequestLoading) {
              return Expanded(
                  child: Center(
                child: CircularProgressIndicator(
                  color: ColorConstants.buttonColor,
                ),
              ));
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
                          return CustomCard(
                              child: Column(
                            children: [
                              CustomTextInfo(
                                  flex1: 2,
                                  flex2: 3,
                                  lable: 'ID',
                                  value: '#${data.requestId}'),
                              CustomTextInfo(
                                  flex1: 2,
                                  flex2: 3,
                                  lable: 'CLIENT(RECEIVER)',
                                  value:
                                      '${data.receiverName}(#${data.receiverId})'),
                              CustomTextInfo(
                                  flex1: 2,
                                  flex2: 3,
                                  lable: 'CA(SENDER)',
                                  value:
                                      '${data.senderName}(#${data.senderId})'),
                              CustomTextInfo(
                                  flex1: 2,
                                  flex2: 3,
                                  lable: 'DATE',
                                  value: dateFormate(data.createdDate)),
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
                              SizedBox(height: 10),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: CommonButtonWidget(
                                  buttonWidth: 100,
                                  buttonTitle: 'View',
                                  onTap: () {
                                    // context.read<ChangeStatusBloc>().add(
                                    //     UnreadToReadStatusEvent(
                                    //         requestId: data.requestId ?? 0));
                                    context.push('/request_details', extra: {
                                      "requestId": data.requestId
                                    }).then((onValue) {
                                      _fetchRequestOfTeam(isSearch: true);
                                    });
                                  },
                                ),
                              )
                            ],
                          ));
                        },
                      ),
              );
            }
            return Container();
          },
        )
      ],
    );
  }
}
