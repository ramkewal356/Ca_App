import 'package:ca_app/blocs/raise_request/raise_request_bloc.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/utils/constanst/validator.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_card.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/custom_search_field.dart';
import 'package:ca_app/widgets/custom_text_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  String searchText = '';
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    _getRaiseRequest(isSearch: true);
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _getRaiseRequest({bool isPagination = false, bool isSearch = false}) {
    context.read<RaiseRequestBloc>().add(GetRequestByReceiverIdEvent(
        isPagination: isPagination,
        isSearch: isSearch,
        searchText: searchText));
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

  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
      appBar: CustomAppbar(backIconVisible: true, title: 'Request Documents'),
      onRefresh: () async {
        _getRaiseRequest(isSearch: true);
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(height: 8),
            Row(
              children: [
               
                Expanded(
                  child: CustomSearchField(
                    controller: _searchController,
                    serchHintText: 'search by id',
                    onChanged: _onSearchChanged,
                  ),
                ),
                SizedBox(width: 10),
                CommonButtonWidget(
                    buttonheight: 48,
                    buttonWidth: 130,
                    // buttonColor: ColorConstants.white,
                    // tileStyle: AppTextStyle().textMediumButtonStyle,
                    buttonTitle: 'Raise request',
                    onTap: () {
                      context
                          .push('/raise_request', extra: {'role': 'CUSTOMER'});
                    })
              ],
            ),
            SizedBox(height: 8),
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
                  return Center(
                    child: Text(
                      'No Data Found!',
                      style: AppTextStyle().redText,
                    ),
                  );
                } else if (state is GetRequestByRecieverIdSuccess) {
                  return Expanded(
                    child: state.requestData.isEmpty
                        ? Center(
                            child: Text(
                              'No Data Found!',
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
                                  Row(
                                    children: [
                                      Expanded(
                                          child: CustomTextItem(
                                              lable: 'ID',
                                              value: '#${data.requestId}')),
                                      Text(dateFormate(data.createdDate))
                                    ],
                                  ),
                                  CustomTextItem(
                                      lable: 'CA NAME',
                                      value: '${data.receiverName}'),
                                  CustomTextItem(
                                      lable: 'DOCUMENT REQUEST',
                                      value: '${data.text}'),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CommonButtonWidget(
                                          buttonColor: ColorConstants.white,
                                          tileStyle: AppTextStyle()
                                              .textMediumButtonStyle,
                                          buttonIconVisible: true,
                                          buttonIcon: Icon(Icons.upload_file),
                                          buttonWidth: 150,
                                          buttonheight: 45,
                                          buttonTitle: 'document',
                                          onTap: () {
                                            context.push(
                                                '/customer_dashboard/upload_document');
                                          }),
                                      SizedBox(width: 20),
                                      CommonButtonWidget(
                                          buttonWidth: 100,
                                          buttonheight: 45,
                                          buttonTitle: 'View',
                                          onTap: () {
                                            context.push('/request_details',
                                                extra: {
                                                  "requestId": data.requestId
                                                }).then((onValue) {
                                              _getRaiseRequest(isSearch: true);
                                            });
                                          }),
                                    ],
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
        ),
      ),
    );
  }
}
