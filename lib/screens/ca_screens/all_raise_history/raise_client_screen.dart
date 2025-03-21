import 'package:ca_app/blocs/raise_request/raise_request_bloc.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/utils/constanst/validator.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_card.dart';
import 'package:ca_app/widgets/custom_search_field.dart';
import 'package:ca_app/widgets/custom_text_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RaiseClientScreen extends StatefulWidget {
  const RaiseClientScreen({super.key});

  @override
  State<RaiseClientScreen> createState() => _RaiseClientScreenState();
}

class _RaiseClientScreenState extends State<RaiseClientScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String searchText = '';
  @override
  void initState() {
    _fetchRequestOfClient(isSearch: true);
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _fetchRequestOfClient({isPagination = false, isSearch = false}) {
    context.read<RaiseRequestBloc>().add(GetRequestOfClientEvent(
        isPagination: isPagination,
        isSearch: isSearch,
        searchText: searchText));
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _fetchRequestOfClient(isPagination: true);
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchText = value;
    });
    _fetchRequestOfClient(isSearch: true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomSearchField(
          controller: _searchController,
          serchHintText: 'search',
          onChanged: _onSearchChanged,
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
                                  lable: 'CA(RECEIVER)',
                                  value:
                                      '${data.receiverName}(#${data.receiverId})'),
                              CustomTextInfo(
                                  flex1: 2,
                                  flex2: 3,
                                  lable: 'CLIENT(SENDER)',
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
                                  lable: 'DESCRIPTION',
                                  value: '${data.text}'),
                              SizedBox(height: 10),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: CommonButtonWidget(
                                  buttonWidth: 100,
                                  buttonTitle: 'View',
                                  onTap: () {
                                    context.push('/request_details', extra: {
                                      "requestId": data.requestId
                                    }).then((onValue) {
                                      _fetchRequestOfClient(isSearch: true);
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
