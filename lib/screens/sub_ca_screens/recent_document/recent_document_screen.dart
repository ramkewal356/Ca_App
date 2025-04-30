import 'package:ca_app/blocs/document/document_bloc.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/utils/constanst/validator.dart';
import 'package:ca_app/widgets/ca_subca_custom_widget/custom_recent_document.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_card.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';




class RecentDocumentScreen extends StatefulWidget {
  final String role;
  const RecentDocumentScreen({super.key, required this.role});

  @override
  State<RecentDocumentScreen> createState() => _RecentDocumentScreenState();
}

class _RecentDocumentScreenState extends State<RecentDocumentScreen> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    _getRecentDocument();
    _scrollController.addListener(_onScroll);

    super.initState();
  }

  Future<void> _getRecentDocument({bool isPagination = false}) async {
    context
        .read<DocumentBloc>()
        .add(GetRecentDocumentEvent(isPagination: isPagination));
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // 🔹 Trigger pagination event

      _getRecentDocument(isPagination: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
      bgColor: ColorConstants.white,
      appBar: CustomAppbar(
        title: 'Recent Document',
        backIconVisible: true,
      ),
      child: BlocBuilder<DocumentBloc, DocumentState>(
        builder: (context, state) {
          if (state is DocumentLoading && state is! RecentDocumentSuccess) {
            return Center(
              child: CircularProgressIndicator(
                color: ColorConstants.buttonColor,
              ),
            );
          } else if (state is RecentDocumentSuccess) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: (state.recentDocumnets ?? []).isEmpty
                  ? Center(
                      child: Text(
                        'No Data Found',
                        style: AppTextStyle().redText,
                      ),
                    )
                  : ListView.builder(
                controller: _scrollController,
                itemCount: (state.recentDocumnets ?? []).length +
                    (state.isLastPage ? 0 : 1),
            
                itemBuilder: (context, index) {
                  if (index == state.recentDocumnets?.length) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: ColorConstants.buttonColor,
                      ),
                    );
                  }
                  var data = state.recentDocumnets?[index];
                  return BlocBuilder<DownloadDocumentBloc, DocumentState>(
                    builder: (context, state) {
                      return CustomCard(
                          child: CustomRecentDocument(
                        id: '#${data?.uuid ?? 0}',
                              clientName:
                                  '${data?.customerName}(#${data?.userId})',
                        documentName: data?.docName ?? 'N/A',
                        category: data?.serviceName ?? 'General',
                        subCategory: data?.subService ?? 'General',
                        postedDate: dateFormate(data?.createdDate),
                        downloadLoader: state is DocumentDownloading &&
                            (state.docName == data?.docName),
                        onTapDownload: () {
                          context.read<DownloadDocumentBloc>().add(
                              DownloadDocumentFileEvent(
                                  docUrl: data?.docUrl ?? '',
                                  docName: data?.docName ?? ''));
                        },
                        onTapReRequest: () {
                          context.push('/raise_request',
                              extra: {
                                  'role': widget.role,
                                  "selectedUser": data?.customerName,
                                  "selectedId": data?.userId
                                });
                        },
                      ));
                    },
                  );
                },
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
