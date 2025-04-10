import 'package:ca_app/blocs/document/document_bloc.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/utils/constanst/validator.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_card.dart';
import 'package:ca_app/widgets/custom_layout.dart';
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
  Map<String, bool> filters = {
    "All": false,
    "General": false,
    "Service": false,
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
                      controller: _searchController,
                      serchHintText:
                          'Search..by service name,subservice name,id',
                      onChanged: _onSearchChanged,
                    ),
                  ),
                  SizedBox(width: 10),
                  // CustomFilterPopup(
                  //     // filterTitle: '',
                  //     filterIcon: Icon(Icons.filter_list_rounded),
                  //     filterItems: ['All', 'General', 'Service'],
                  //     selectedFilters: filters,
                  //     onFilterChanged: _onFilterChanged),

                  FilterPopup(
                    onFilterChanged: _onFilterChanged,
                  ),
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

class FilterPopup extends StatefulWidget {
  final ValueChanged<String> onFilterChanged;

  const FilterPopup({super.key, required this.onFilterChanged});

  @override
  State<FilterPopup> createState() => _FilterPopupState();
}

class _FilterPopupState extends State<FilterPopup> {
  Map<String, bool> filters = {
    "All": true, // Default selection
    "General": false,
    "Service": false,
  };

  String _filterTitle = "All"; // Default title

  void _updateSelection(String filter, bool? value, StateSetter setStatePopup) {
    // Reset all filters to false first
    filters.updateAll((key, _) => false);

    // Set only the selected filter to true
    filters[filter] = value ?? false;

    // Update filter title
    setStatePopup(() {});
    setState(() {
      _filterTitle = filter;
    });

    // Apply filters & send correct numeric value
    _applyFilters();
  }

  void _applyFilters() {
    String filterValue;

    if (filters["All"] == true) {
      filterValue = '';
    } else if (filters["General"] == true) {
      filterValue = '-1';
    } else if (filters["Service"] == true) {
      filterValue = '1';
    } else {
      filterValue = ''; // Default if no filter is selected
    }

    // Callback to parent widget
    widget.onFilterChanged(filterValue);
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      position: PopupMenuPosition.under,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10),
      constraints: BoxConstraints(minWidth: 150, maxWidth: 150),
      offset: Offset(0, 0),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Text(
              _filterTitle,
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
            SizedBox(width: 5),
            Icon(Icons.filter_list_rounded),
          ],
        ),
      ),
      onSelected: (value) {},
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<String>>[
          PopupMenuItem(
            padding: EdgeInsets.zero,
            enabled: false,
            child: StatefulBuilder(
              builder: (context, setStatePopup) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: ["All", "General", "Service"].map((filter) {
                    return _buildCheckListTile(
                      context,
                      filter,
                      filters[filter] ?? false,
                      (value) => _updateSelection(filter, value, setStatePopup),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ];
      },
    );
  }

  Widget _buildCheckListTile(BuildContext context, String title, bool? value,
      void Function(bool?)? onChanged) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      activeColor: ColorConstants.buttonColor,
      controlAffinity: ListTileControlAffinity.leading,
      value: value,
      title: Text(
        title,
        style: AppTextStyle().lableText,
      ),
      onChanged: onChanged,
    );
  }
}
