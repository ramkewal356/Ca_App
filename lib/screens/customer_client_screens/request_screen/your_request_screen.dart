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
import 'package:intl/intl.dart';

class YourRequestScreen extends StatefulWidget {
  const YourRequestScreen({super.key});

  @override
  State<YourRequestScreen> createState() => _YourRequestScreenState();
}

class _YourRequestScreenState extends State<YourRequestScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _controller = TextEditingController();
  String searchText = '';
  @override
  void initState() {
    super.initState();
    _fetchRequestList(isSearch: true);
    _scrollController.addListener(_onSroll);
  }

  void _fetchRequestList({bool isPagination = false, bool isSearch = false}) {
    context.read<RaiseRequestBloc>().add(GetYourRequestEvent(
        isPagination: isPagination,
        isSearch: isSearch,
        searchText: searchText));
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
            CustomSearchField(
              controller: _controller,
              serchHintText: 'Search by  id',
              onChanged: _onSearchChanged,
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
                    child: Text('data'),
                  );
                } else if (state is GetYourRequestListSuccess) {
                  return Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount:
                          state.requestData.length + (state.isLastPage ? 0 : 1),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            CustomTextItem(
                                lable: 'CLIENT (RECEIVER)',
                                value:
                                    '${data.receiverName}(#${data.receiverId})'),
                            CustomTextItem(
                                lable: 'CA (SENDER)',
                                value: '${data.senderName}(#${data.senderId})'),
                            CustomTextItem(
                                lable: 'DESCRIPTION', value: '${data.text}'),
                            BlocBuilder<RaiseRequestBloc, RaiseRequestState>(
                              builder: (context, state) {
                                return Align(
                                    alignment: Alignment.bottomRight,
                                    child: CommonButtonWidget(
                                        buttonWidth: 100.0,
                                        loader: state
                                                is GetRequestDetailsLoading &&
                                            data.requestId == state.requsetId,
                                        buttonTitle: 'View',
                                        onTap: () {
                                          context.push('/request_details',
                                              extra: {
                                                "requestId": data.requestId
                                              }).then((onValue) {
                                            _fetchRequestList(isSearch: true);
                                          });
                                        }));
                              },
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
