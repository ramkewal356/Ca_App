import 'package:ca_app/blocs/logs/logs_bloc.dart';
import 'package:ca_app/utils/assets.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/utils/constanst/validator.dart';
import 'package:ca_app/widgets/common_log_screen.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_card.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/custom_popup_filter.dart';

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
  String filterTitle = 'All';
  @override
  void initState() {
    _fetchLogs();
    super.initState();
    _scrollController.addListener(_onScroll);
  }
  Map<String, String> filters = {
    "All": '', // Default selection
    "Activate": 'Activate',
    "Deactivate": 'Deactivate',
  };
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
      filterTitle = value == '' ? 'All' : filters[value] ?? '';
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
                
                  CustomFilterPopupWidget(
                      title: filterTitle,
                      filterOptions: filters,
                      onFilterChanged: _onFilterChanged),
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
                listener: (context, state) {},
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
                        ? Expanded(
                            child: Center(
                              child: Text(
                                'No Data Found !',
                                style: AppTextStyle().redText,
                              ),
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
