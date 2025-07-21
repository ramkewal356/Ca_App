import 'package:ca_app/blocs/service/service_bloc.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/utils/constanst/validator.dart';
import 'package:ca_app/widgets/custom_card.dart';
import 'package:ca_app/widgets/custom_popup_filter.dart';
import 'package:ca_app/widgets/custom_search_field.dart';
import 'package:ca_app/widgets/custom_text_info.dart';
import 'package:ca_app/widgets/custom_text_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewPreviousScreen extends StatefulWidget {
  const ViewPreviousScreen({super.key});

  @override
  State<ViewPreviousScreen> createState() => _ViewPreviousScreenState();
}

class _ViewPreviousScreenState extends State<ViewPreviousScreen> {
  final TextEditingController _searchcontroller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String searchQuery = '';
  String filterText = '';
  String filterTitle = 'All';
  final _searchFocus = FocusNode();

  @override
  void initState() {
    _fetchViewservice();
    super.initState();
    _scrollController.addListener(_onSroll);
  }

  void _fetchViewservice(
      {bool isPagination = false,
      bool isSearch = true,
      bool isFilter = false}) {
    context.read<ServiceBloc>().add(GetViewServiceEvent(
        isPagination: isPagination,
        isSearch: isSearch,
        searchText: searchQuery,
        isFilter: isFilter,
        filterTex: filterText));
  }

  void _onSroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _fetchViewservice(isPagination: true);
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchQuery = value;
    });
    _fetchViewservice(isSearch: true);
  }

  void _onFilterChanged(String value) {
    setState(() {
      filterText = value;
      filterTitle = value == '0'
          ? 'Requested'
          : value == '1'
              ? 'Accespted'
              : value == '2'
                  ? 'Rejected'
                  : 'All';
    });
    _fetchViewservice(isFilter: true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomSearchField(
                focusNode: _searchFocus,
                controller: _searchcontroller,
                serchHintText: 'Search..by service name,sub service,id',
                onChanged: _onSearchChanged,
              ),
            ),
            SizedBox(width: 10),
            CustomFilterPopupWidget(
                title: filterTitle,
                filterOptions: {
                  "All": "",
                  "Accepted": "1",
                  "Requested": "0",
                  "Rejected": "2"
                },
                onFilterChanged: _onFilterChanged)
          ],
        ),
        BlocBuilder<ServiceBloc, ServiceState>(
          builder: (context, state) {
            if (state is ServiceLoading) {
              return Expanded(
                  child: Center(
                child: CircularProgressIndicator(
                  color: ColorConstants.buttonColor,
                ),
              ));
            } else if (state is GetViewServiceSuccess) {
              return Expanded(
                child: state.getViewServiceList.isEmpty
                    ? Center(
                        child: Text(
                          'No Data Found',
                          style: AppTextStyle().redText,
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: state.getViewServiceList.length +
                            (state.isLastPage ? 0 : 1),
                        itemBuilder: (context, index) {
                          if (index == state.getViewServiceList.length) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: ColorConstants.buttonColor,
                              ),
                            );
                          }
                          var data = state.getViewServiceList[index];
                          return CustomCard(
                              child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: CustomTextItem(
                                          lable: 'ID', value: '${data.id}')),
                                  // Spacer(),
                                  Row(
                                    children: [
                                      // Text(
                                      //   'Status : ',
                                      //   style: AppTextStyle().lableText,
                                      // ),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: data.serviceResponse ==
                                                    'ACCEPTED'
                                                ?
                                                // ignore: deprecated_member_use
                                                ColorConstants.greenColor
                                                    // ignore: deprecated_member_use
                                                    .withOpacity(0.8)
                                                : ColorConstants.darkRedColor
                                                    // ignore: deprecated_member_use
                                                    .withOpacity(0.8),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          child: Text(
                                            '${data.serviceResponse}',
                                            style: AppTextStyle().statustext,
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              CustomTextInfo(
                                  flex1: 2,
                                  flex2: 3,
                                  lable: 'Service Name',
                                  value: '${data.serviceName}'),
                              CustomTextInfo(
                                  flex1: 2,
                                  flex2: 3,
                                  lable: 'Sub Service Name',
                                  value: '${data.subService}'),
                              CustomTextInfo(
                                  flex1: 2,
                                  flex2: 3,
                                  lable: 'Created date',
                                  value: dateFormate(data.createdDate)),
                              CustomTextInfo(
                                  flex1: 2,
                                  flex2: 3,
                                  lable: 'Service Description',
                                  value: '${data.serviceDesc}'),
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
