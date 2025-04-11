import 'package:ca_app/blocs/help_and_support/help_and_support_bloc.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/utils/constanst/validator.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_card.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/custom_popup_filter.dart';
import 'package:ca_app/widgets/custom_search_field.dart';
import 'package:ca_app/widgets/custom_text_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HelpAndSupportHistoryScreen extends StatefulWidget {
  const HelpAndSupportHistoryScreen({super.key});

  @override
  State<HelpAndSupportHistoryScreen> createState() =>
      _HelpAndSupportHistoryScreenState();
}

class _HelpAndSupportHistoryScreenState
    extends State<HelpAndSupportHistoryScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String searchText = '';
  String filterText = '';
  String filterTitle = 'All';
  @override
  void initState() {
    _fetchContactHistory(isFilter: true);
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  _fetchContactHistory(
      {bool ispagination = false,
      bool isSearch = false,
      bool isFilter = false}) {
    context.read<HelpAndSupportBloc>().add(GetContactByUserIdEvent(
        isPagination: ispagination,
        isSearch: isSearch,
        isFilter: isFilter,
        searchText: searchText,
        filterText: filterText));
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // 🔹 Trigger pagination event

      _fetchContactHistory(ispagination: true);
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchText = value;
    });
    _fetchContactHistory(isSearch: true);
  }

  void _onFilterChanged(String value) {
    setState(() {
      filterText = value;
      filterTitle = value == '0'
          ? 'Open'
          : value == '3'
              ? 'Resoved'
              : 'All';
    });
    _fetchContactHistory(isFilter: true);
  }

  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
      appBar: CustomAppbar(
        title: 'Help & Supprot History',
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
                    serchHintText: 'Search by id...',
                    onChanged: _onSearchChanged,
                  ),
                ),
                SizedBox(width: 10),
                CustomFilterPopupWidget(
                    title: filterTitle,
                    filterOptions: {
                      "All": "",
                      "Open": "0",
                      "Resolved": "3",
                    },
                    onFilterChanged: _onFilterChanged)
              ],
            ),
            Expanded(
              child: BlocBuilder<HelpAndSupportBloc, HelpAndSupportState>(
                builder: (context, state) {
                  if (state is HelpAndSupportLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: ColorConstants.buttonColor,
                      ),
                    );
                  } else if (state is HelpAndSupportError) {
                    return Center(
                      child: Text(
                        'No Data Found',
                        style: AppTextStyle().redText,
                      ),
                    );
                  } else if (state is GetContactByUserIdSuccess) {
                    return state.getContactByUserIdList.isEmpty
                        ? Center(
                            child: Text(
                              'No Data Found',
                              style: AppTextStyle().redText,
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            itemCount: state.getContactByUserIdList.length +
                                (state.isLastPage ? 0 : 1),
                            itemBuilder: (context, index) {
                              if (index ==
                                  state.getContactByUserIdList.length) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: ColorConstants.buttonColor,
                                  ),
                                );
                              }
                              var data = state.getContactByUserIdList[index];
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
                                              value: '#${data.contactId}')),
                                      // Spacer(),
                                      Row(
                                        children: [
                                          Text(
                                            'Status : ',
                                            style: AppTextStyle().lableText,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: data.response == 'OPEN'
                                                    ? ColorConstants.yellowColor
                                                    : ColorConstants.greenColor,
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 10),
                                              child: Text(
                                                '${data.response}',
                                                style:
                                                    AppTextStyle().statustext,
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  CustomTextItem(
                                      lable: 'SUBJECT',
                                      value: '${data.subject}'),
                                  CustomTextItem(
                                      lable: 'CREATE DATE',
                                      value: dateFormate(data.createdDate)),
                                  CustomTextItem(
                                    lable: 'MESSAGE',
                                    value: '${data.message}',
                                    inOneLinetext: true,
                                    maxLine: 1,
                                  ),
                                  // CustomTextItem(
                                  //     lable: 'COMMENT', value: '${data.comment}'),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      // Container(
                                      //   height: 45,
                                      //   decoration: BoxDecoration(
                                      //       color: ColorConstants.greenColor,
                                      //       borderRadius: BorderRadius.circular(8)),
                                      //   child: Padding(
                                      //     padding: const EdgeInsets.symmetric(
                                      //         vertical: 5, horizontal: 10),
                                      //     child: Center(
                                      //       child: Text(
                                      //         'Resolved',
                                      //         style: AppTextStyle().statustext,
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                      CommonButtonWidget(
                                          buttonWidth: 100,
                                          buttonheight: 45,
                                          buttonTitle: 'View',
                                          onTap: () {
                                            context.push('/view_history',
                                                extra: {
                                                  "contactId": data.contactId
                                                }).then((onValue) {
                                              _fetchContactHistory();
                                            });
                                          }),
                                    ],
                                  )
                                ],
                              ));
                            },
                          );
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
