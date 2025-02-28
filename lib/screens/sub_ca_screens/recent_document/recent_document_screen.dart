import 'dart:io';

import 'package:ca_app/blocs/document/document_bloc.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/widgets/ca_subca_custom_widget/custom_recent_document.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_card.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class RecentDocumentScreen extends StatefulWidget {
  const RecentDocumentScreen({super.key});

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

  Future<void> downloadFile(
      {required String docUrl, required String docName}) async {
    // Request storage permissions
    // if (await Permission.storage.request().isGranted) {
    // Use public Downloads directory
    final directory = Directory('/storage/emulated/0/Download');

    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }

    final taskId = await FlutterDownloader.enqueue(
      url: docUrl, // Replace with actual URL
      savedDir: directory.path,
      fileName: docName,
      showNotification: true,
      openFileFromNotification: true,
    );

    print("Download started: $taskId");
    // } else {
    //   print("Storage permission denied!");
    // }
  }
  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
      bgColor: ColorConstants.white,
      appBar: CustomAppbar(
        title: 'Recent Document',
        backIconVisible: true,
      ),
      child: BlocConsumer<DocumentBloc, DocumentState>(
        listener: (context, state) {
          // TODO: implement listener
        },
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
              child: ListView.builder(
                controller: _scrollController,
                itemCount: (state.recentDocumnets ?? []).length +
                    (state.isLastPage ? 0 : 1),
                // shrinkWrap: true,
                // physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  if (index == state.recentDocumnets?.length) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: ColorConstants.buttonColor,
                      ),
                    );
                  }
                  var data = state.recentDocumnets?[index];
                  return CustomCard(
                      child: CustomRecentDocument(
                    id: '#${data?.uuid ?? 0}',
                    clientName: '${data?.customerName}',
                    documentName: data?.docName ?? 'N/A',
                    category: data?.serviceName ?? 'N/A',
                    subCategory: data?.subService ?? 'N/A',
                    postedDate: DateFormat('dd/MM/yyyy').format(
                        DateTime.fromMillisecondsSinceEpoch(
                            data?.createdDate ?? 0)),
                    onTapDownload: () {
                      downloadFile(
                          docUrl: data?.docUrl ?? '',
                          docName: data?.docName ?? '');
                    },
                    onTapReRequest: () {},
                  ));
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
