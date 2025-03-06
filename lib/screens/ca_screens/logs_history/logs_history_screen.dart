import 'package:ca_app/blocs/logs/logs_bloc.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/common_log_screen.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_card.dart';
import 'package:ca_app/widgets/custom_layout.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class LogsHistoryScreen extends StatefulWidget {
  final String? uponId;
  const LogsHistoryScreen({super.key, this.uponId});

  @override
  State<LogsHistoryScreen> createState() => _LogsHistoryScreenState();
}

class _LogsHistoryScreenState extends State<LogsHistoryScreen> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    _fetchLogs();
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _fetchLogs({bool isPagination = false}) {
    context.read<LogsBloc>().add(GetLogsEvent(
        byCaId: (widget.uponId ?? '').isEmpty ? true : false,
        uponId: widget.uponId ?? '',
        isPagination: isPagination));
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // 🔹 Trigger pagination event

      _fetchLogs(isPagination: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
        appBar: CustomAppbar(
          title: 'Logs History',
          backIconVisible: true,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: BlocConsumer<LogsBloc, LogsState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              if (state is LogsLoading) {
                return Center(child: CircularProgressIndicator());
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
                    : Column(children: [
                        Expanded(
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
                                performerEmail: '${data?.actionPerformerEmail}',
                                uponName: '${data?.actionUponName}',
                                uponEmail: '${data?.actionUponEmail}',
                                createdDate: DateFormat('dd/MM/yyyy').format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        data?.createdDate ?? 0)),
                                reason: '${data?.reason}',
                              ));
                            },
                          ),
                        )
                      ]);
              }
              return Container();
            },
          ),
        ));
  }
}
