import 'package:ca_app/blocs/document/document_bloc.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/utils/constanst/validator.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_card.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/custom_text_info.dart';
import 'package:ca_app/widgets/custom_text_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryScreen extends StatefulWidget {
  final String userId;
  const HistoryScreen({super.key, required this.userId});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _fetchDocument();
    _scrollController.addListener(_onScroll);
  }

  void _fetchDocument({bool isPagination = false}) {
    context.read<DocumentBloc>().add(GetViewDocumentEvent(
        userId: widget.userId,
        searchText: '',
        filterText: '',
        isPagination: isPagination,
        isFilter: true,
        isSearch: false));
  }

  void _onScroll() {
    if (_scrollController.position.pixels >
        _scrollController.position.maxScrollExtent - 200) {
      _fetchDocument(isPagination: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
        appBar: CustomAppbar(
          title: 'Documents History',
          backIconVisible: true,
        ),
        child: BlocBuilder<DocumentBloc, DocumentState>(
          builder: (context, state) {
            if (state is DocumentLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: ColorConstants.buttonColor,
                ),
              );
            } else if (state is DocumentError) {
              return Center(
                child: Text('No Data'),
              );
            } else if (state is ViewDocumentSuccess) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Documents',
                          style: AppTextStyle().textButtonStyle,
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: ColorConstants.buttonColor,
                              shape: BoxShape.circle),
                          child: Text(
                            state.totalDocument.toString(),
                            style: AppTextStyle().statustext,
                          ),
                        )
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: (state.viewDocumnets ?? []).length +
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
                           
                              Row(
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: CustomTextItem(
                                          lable: 'ID',
                                          value: '# ${data?.docId}')),
                                  Text(dateFormate(data?.createdDate))
                                ],
                              ),
                              CustomTextInfo(
                                  flex1: 2,
                                  flex2: 3,
                                  lable: 'DOCUMENT NAME',
                                  value: '${data?.docName}'),
                              (data?.serviceName == 'null')
                                  ? SizedBox.shrink()
                                  : CustomTextInfo(
                                      flex1: 2,
                                      flex2: 3,
                                      lable: 'CATEGORY',
                                      value: data?.serviceName ?? ''),
                              (data?.subService == 'null')
                                  ? SizedBox.shrink()
                                  : CustomTextInfo(
                                      flex1: 2,
                                      flex2: 3,
                                      lable: 'SU CATEGORY',
                                      value: data?.subService ?? ''),
                              GestureDetector(
                                  onTap: () {
                                    context.read<DownloadDocumentBloc>().add(
                                        DownloadDocumentFileEvent(
                                            docUrl: data?.docUrl ?? '',
                                            docName: data?.docName ?? ''));
                                  },
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Icon(
                                      Icons.download,
                                      color: ColorConstants.greenColor,
                                      size: 20,
                                    ),
                                  ))
                            ],
                          ));
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
            return Container();
          },
        ));
  }
}
