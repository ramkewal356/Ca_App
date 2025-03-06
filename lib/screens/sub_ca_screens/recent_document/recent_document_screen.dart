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
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';

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
      {required String docUrl, required var docName}) async {
    final status = await Permission.manageExternalStorage.request();

    if (status.isGranted) {
      final directory = Directory('/storage/emulated/0/Download');
      // Directory directory = await getExternalStorageDirectory() ?? directory1;
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }

      // File path
      final filePath = "${directory.path}/$docName";

      // Delete existing file to avoid conflict
      final file = File(filePath);
      if (file.existsSync()) {
        await file.delete();
        debugPrint("Existing file deleted: $docName");
      }

      final taskId = await FlutterDownloader.enqueue(
        url: docUrl,
        savedDir: directory.path,
        // savedDir: '/storage/emulated/0/Download',
        fileName: docName,
        // requiresStorageNotLow: true,
        showNotification: true,
        openFileFromNotification: true,
      );
      // Wait for download to complete before opening
      // FlutterDownloader.registerCallback((status, id, progress) {
      //   if (taskId == id.toString() && status == DownloadTaskStatus.complete) {
      debugPrint("Download complete: $docName");
      debugPrint("Download complete2: $docUrl");
      debugPrint("Download complete file path 3: $filePath");
      openWebPFile(filePath);
      // Open the file using open_filex
      // await OpenFilex.open(filePath).then((result) {
      //   debugPrint("File opened: ${result.message}");
      // }).catchError((e) {
      //   debugPrint("Error opening file: $e");
      // });
      //   }
      // });
      debugPrint("Download started: $taskId");
    } else {
      debugPrint("Storage permission denied!");
      openAppSettings();
    }
  }

  void openWebPFile(String filePath) async {
    final result = await OpenFilex.open(filePath);
    debugPrint("File opened: ${result.message}");

    if (result.type != ResultType.done) {
      debugPrint("Error opening file: ${result.message}");
    }
  }

// Track download tasks
  Map<String, String> downloadTasks = {};

// Callback to handle download completion
  void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    if (status == DownloadTaskStatus.complete) {
      debugPrint("Download complete: $id");

      // Get correct downloaded file path
      FlutterDownloader.loadTasks().then((tasks) {
        final task = tasks?.firstWhere(
          (task) => task.taskId == id,
        );
        if (task != null) {
          final filePath = task.savedDir + "/" + task.filename!;
          debugPrint("File downloaded to: $filePath");

          OpenFilex.open(filePath).then((result) {
            debugPrint("File opened: ${result.message}");
          }).catchError((e) {
            debugPrint("Error opening file: $e");
          });
        } else {
          debugPrint("Error: Could not find download task!");
        }
      });
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
      child: BlocConsumer<DocumentBloc, DocumentState>(
        listener: (context, state) {},
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
                  return BlocConsumer<DocumentBloc, DocumentState>(
                    listener: (context, state) {
                      if (state is DownloadDocumentFileSuccess) {
                        print('bvnbmnm,n,mnmvnmnmb n nmn,mm,');
                      }
                    },
                    builder: (context, state) {
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
                        downloadLoader: state is DocumentDownloading,
                        onTapDownload: () {
                          // context.read<DocumentBloc>().add(
                          //     DownloadDocumentFileEvent(
                          //         docUrl: data?.docUrl ?? '',
                          //         docName: data?.docName ?? ''));
                          downloadFile(
                              docUrl: data?.docUrl ?? '',
                              docName: data?.docName ?? '');

                          // context.read<DocumentBloc>().add(DownloadDocumentEvent(
                          //     docUrl: data?.docUrl ?? '',
                          //     docName: data?.docName ?? ''));
                        },
                        onTapReRequest: () {},
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
