import 'package:ca_app/blocs/document/document_bloc.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ViewDocumentScreen extends StatefulWidget {
  final int userId;
  final String role;
  final String userName;
  const ViewDocumentScreen(
      {super.key,
      required this.userId,
      required this.role,
      required this.userName});

  @override
  State<ViewDocumentScreen> createState() => _ViewDocumentScreenState();
}

class _ViewDocumentScreenState extends State<ViewDocumentScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String selectedFilter = '';
  String searchQuery = '';
  String filterTitle = 'All';
  final _searchFocus = FocusNode();

  Map<String, String> filtersList = {
    "All": '',
    "General": '-1',
    "Service": '1',
  };

  @override
  void initState() {
    super.initState();
    _getViewDocument(isFilter: true);
    _scrollController.addListener(_onScroll);
  }

  void _getViewDocument(
      {bool isPagination = false,
      bool isFilter = false,
      bool isSearch = false}) {
    context.read<DocumentBloc>().add(GetViewDocumentEvent(
        userId: widget.userId.toString(),
        searchText: searchQuery,
        filterText: selectedFilter,
        isPagination: isPagination,
        isFilter: isFilter,
        isSearch: isSearch));
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // 🔹 Trigger pagination event

      _getViewDocument(isPagination: true);
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchQuery = value;
    });
    _getViewDocument(isSearch: true);
  }

  void _onFilterChanged(String value) {
    setState(() {
      selectedFilter = value;
      filterTitle = value == '' ? 'All' : filtersList[value] ?? '';
      debugPrint('selected Item $selectedFilter');
    });
    _getViewDocument(isFilter: true);
  }

  int totalDocument = 0;
  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
      appBar: CustomAppbar(
        title: 'View Document',
        backIconVisible: true,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(children: [
                  Expanded(
                    child: CustomSearchField(
                      focusNode: _searchFocus,
                      controller: _searchController,
                      serchHintText:
                          'Search..by service name,subservice name,id',
                      onChanged: _onSearchChanged,
                    ),
                  ),
                  SizedBox(width: 10),
                  CustomFilterPopupWidget(
                      title: filterTitle,
                      filterOptions: filtersList,
                      onFilterChanged: _onFilterChanged)

                  // FilterPopup(
                  //   onFilterChanged: _onFilterChanged,
                  // ),
                ])),
            BlocConsumer<DocumentBloc, DocumentState>(
              listener: (context, state) {
                if (state is ViewDocumentSuccess) {
                  totalDocument = state.totalDocument;
                }
              },
              builder: (context, state) {
                if (state is DocumentLoading && state is! ViewDocumentSuccess) {
                  return Expanded(
                      child: Center(
                          child: CircularProgressIndicator(
                    color: ColorConstants.buttonColor,
                  )));
                } else if (state is DocumentError) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        'No Data Found !',
                        style: AppTextStyle().redText,
                      ),
                    ),
                  );
                } else if (state is ViewDocumentSuccess) {
                  return Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Total Documents',
                              style: AppTextStyle().textButtonStyle,
                            ),
                            SizedBox(width: 10),
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ColorConstants.buttonColor),
                              child: Text(
                                '$totalDocument',
                                style: AppTextStyle().buttontext,
                              ),
                            )
                          ],
                        ),
                        Expanded(
                          child: (state.viewDocumnets ?? []).isEmpty
                              ? Center(
                                  child: Text(
                                    'No Data Found !',
                                    style: AppTextStyle().redText,
                                  ),
                                )
                              : ListView.builder(
                                  controller: _scrollController,
                                  itemCount:
                                      (state.viewDocumnets ?? []).length +
                                          (state.isLastPage ? 0 : 1),
                                  itemBuilder: (context, index) {
                                    if (index == state.viewDocumnets?.length) {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: ColorConstants.buttonColor,
                                        ),
                                      );
                                    }
                                    var data = state.viewDocumnets?[index];
                                    return CustomCard(
                                        child: Column(
                                      children: [
                                        CustomTextInfo(
                                            flex1: 2,
                                            flex2: 3,
                                            lable: 'ID',
                                            value: '# ${data?.uuid ?? 0}'),
                                        CustomTextInfo(
                                            flex1: 2,
                                            flex2: 3,
                                            lable: 'DOCUMENT NAME',
                                            value: '${data?.docName}'),
                                        CustomTextInfo(
                                            flex1: 2,
                                            flex2: 3,
                                            lable: 'DOCUMENT TYPE',
                                            value: data?.serviceName == 'null'
                                                ? 'N/A'
                                                : data?.serviceName ?? 'N/A'),
                                        CustomTextInfo(
                                            flex1: 2,
                                            flex2: 3,
                                            lable: 'CREATED DATE',
                                            value:
                                                dateFormate(data?.createdDate)),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            BlocBuilder<DownloadDocumentBloc,
                                                DocumentState>(
                                              builder: (context, state) {
                                                return CommonButtonWidget(
                                                    buttonColor:
                                                        ColorConstants.white,
                                                    buttonBorderColor:
                                                        ColorConstants
                                                            .greenColor,
                                                    tileStyle: AppTextStyle()
                                                        .getgreenText,
                                                    buttonWidth: 120,
                                                    loader: state
                                                            is DocumentDownloading &&
                                                        (state.docName ==
                                                            data?.docName),
                                                    loaderColor: ColorConstants
                                                        .greenColor,
                                                    buttonTitle: 'Download',
                                                    onTap: () {
                                                      context
                                                          .read<
                                                              DownloadDocumentBloc>()
                                                          .add(DownloadDocumentFileEvent(
                                                              docUrl:
                                                                  data?.docUrl ??
                                                                      '',
                                                              docName:
                                                                  data?.docName ??
                                                                      ''));
                                                    });
                                              },
                                            ),
                                            CommonButtonWidget(
                                                buttonWidth: 130,
                                                buttonTitle: 'Re-Request',
                                                onTap: () {
                                                  context.push('/raise_request',
                                                      extra: {
                                                        'role': widget.role,
                                                        "selectedUser":
                                                            widget.userName,
                                                        "selectedId":
                                                            widget.userId
                                                      }).then((onValue) {
                                                    _getViewDocument(
                                                        isFilter: true);
                                                  });
                                                })
                                          ],
                                        )
                                      ],
                                    ));
                                  },
                                ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
