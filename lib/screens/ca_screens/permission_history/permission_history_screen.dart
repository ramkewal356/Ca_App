import 'package:ca_app/blocs/permission/permission_bloc.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/utils/constanst/validator.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_card.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/custom_text_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PermissionHistoryScreen extends StatefulWidget {
  const PermissionHistoryScreen({super.key});

  @override
  State<PermissionHistoryScreen> createState() =>
      _PermissionHistoryScreenState();
}

class _PermissionHistoryScreenState extends State<PermissionHistoryScreen> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _fetPermission();
    _scrollController.addListener(_onScroll);
  }

  void _fetPermission({bool isPagination = false}) {
    context
        .read<PermissionBloc>()
        .add(GetPermissionHistoryEvent(isPagination: isPagination));
  }

  _onScroll() {
    if (_scrollController.position.pixels >
        _scrollController.position.maxScrollExtent - 200) {
      _fetPermission(isPagination: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
        appBar: CustomAppbar(
          title: 'Permission History',
          backIconVisible: true,
        ),
        onRefresh: () async {
          _fetPermission();
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: BlocBuilder<PermissionBloc, PermissionState>(
            builder: (context, state) {
              if (state is PermissionLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: ColorConstants.buttonColor,
                  ),
                );
              } else if (state is PermissionError) {
                return Center(child: Text('data'));
              } else if (state is GetPermissionHistorySuccess) {
                return state.getPermissionHistoryList.isEmpty
                    ? Center(
                        child: Text(
                          'No Data Found',
                          style: AppTextStyle().redText,
                        ),
                      )
                    : ListView.builder(
                  controller: _scrollController,
                  itemCount: state.getPermissionHistoryList.length +
                      (state.isLastPage ? 0 : 1),
                  itemBuilder: (context, index) {
                    if (index == state.getPermissionHistoryList.length) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: ColorConstants.buttonColor,
                        ),
                      );
                    }
                    var data = state.getPermissionHistoryList[index];
                    return CustomCard(
                        child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: CustomTextItem(
                                          lable: 'ID',
                                          value: '#${data.userId}')),
                                  Text(
                                      '${dateFormate(data.createdAt)} ${timeFormate(data.createdAt)}')
                          ],
                        ),
                        CustomTextItem(
                            lable: 'User Name', value: '${data.userName}'),
                        CustomTextItem(
                            lable: 'Permission Name',
                            value: '${data.permissionName}'),
                        CustomTextItem(lable: 'Status', value: '${data.action}')
                      ],
                    ));
                  },
                );
              }
              return Container();
            },
          ),
        ));
  }
}
