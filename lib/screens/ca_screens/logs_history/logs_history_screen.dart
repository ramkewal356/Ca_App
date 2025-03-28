import 'package:ca_app/blocs/logs/logs_bloc.dart';
import 'package:ca_app/utils/assets.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/utils/constanst/validator.dart';
import 'package:ca_app/widgets/common_log_screen.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_card.dart';
import 'package:ca_app/widgets/custom_layout.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class LogsHistoryScreen extends StatefulWidget {
  final String? uponId;
  const LogsHistoryScreen({super.key, this.uponId});

  @override
  State<LogsHistoryScreen> createState() => _LogsHistoryScreenState();
}

class _LogsHistoryScreenState extends State<LogsHistoryScreen> {
  final ScrollController _scrollController = ScrollController();
  String filterText = '';
  @override
  void initState() {
    _fetchLogs();
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _fetchLogs({
    bool isPagination = false,
    bool isSortList = false,
    bool isFilter = false,
  }) {
    context.read<LogsBloc>().add(GetLogsEvent(
        byCaId: (widget.uponId ?? '').isEmpty ? true : false,
        uponId: widget.uponId ?? '',
        isPagination: isPagination,
        action: filterText,
        sorthing: selectedValue ? 'asc' : 'desc'));
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // 🔹 Trigger pagination event

      _fetchLogs(isPagination: true);
    }
  }

  _onFilterChanged(String value) {
    setState(() {
      filterText = value;
    });
    _fetchLogs(isFilter: true);
  }

  void _onSortList() {
    setState(() {
      selectedValue = !selectedValue;
    });
    _fetchLogs(isSortList: true);
  }

  bool selectedValue = false;
  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
        appBar: CustomAppbar(
          title: 'Logs History',
          backIconVisible: true,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  FilterPopup(
                    onFilterChanged: _onFilterChanged,
                  ),
                  SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: ColorConstants.darkGray)),
                    child: IconButton(
                        padding: EdgeInsets.zero,
                        visualDensity:
                            VisualDensity(horizontal: 2, vertical: -1),
                        onPressed: _onSortList,
                        icon: Image.asset(
                          selectedValue ? assendingSortimg : desendingSortimg,
                          width: 24,
                          height: 24,
                        )),
                  )
                ],
              ),
              SizedBox(height: 5),
              BlocConsumer<LogsBloc, LogsState>(
                listener: (context, state) {
                  // TODO: implement listener
                },
                builder: (context, state) {
                  if (state is LogsLoading) {
                    return Expanded(
                        child: Center(child: CircularProgressIndicator()));
                  } else if (state is LogsError) {
                    return Center(
                      child: Text(
                        'No Data Found',
                        style: AppTextStyle().redText,
                      ),
                    );
                  } else if (state is LogsSuccess) {
                    return (state.logsModel ?? []).isEmpty
                        ? Center(
                            child: Text(
                              'No Data Found !',
                              style: AppTextStyle().redText,
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              controller: _scrollController,
                              shrinkWrap: true,
                              itemCount: (state.logsModel ?? []).length +
                                  (state.isLastPage ? 0 : 1),
                              itemBuilder: (context, index) {
                                if (index == state.logsModel?.length) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                                var data = state.logsModel?[index];
                                return CustomCard(
                                    child: CommonLogScreen(
                                  id: data?.id.toString() ?? '',
                                  action: '${data?.action}',
                                  performerName: '${data?.actionPerformerName}',
                                  performerEmail:
                                      '${data?.actionPerformerEmail}',
                                  uponName: '${data?.actionUponName}',
                                  uponEmail: '${data?.actionUponEmail}',
                                  createdDate: dateFormate(data?.createdDate),
                                  reason: '${data?.reason}',
                                ));
                              },
                            ),
                          );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ));
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
    "Activate": false,
    "Deactivate": false,
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
    } else if (filters["Activate"] == true) {
      filterValue = 'Activate';
    } else if (filters["Deactivate"] == true) {
      filterValue = 'Deactivate';
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
                  children: [
                    "All",
                    "Activate",
                    "Deactivate",
                  ].map((filter) {
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
      visualDensity: VisualDensity(horizontal: -4),
      value: value,
      title: Text(
        title,
        style: AppTextStyle().lableText,
      ),
      onChanged: onChanged,
    );
  }
}
