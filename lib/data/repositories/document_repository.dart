import 'dart:io';

import 'package:ca_app/data/models/get_view_document_by_userid_model.dart';
import 'package:ca_app/data/models/recent_document_model.dart';
import 'package:ca_app/data/providers/end_points.dart';
import 'package:ca_app/data/providers/http_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';

class DocumentRepository {
  //**** Get Recent Document by Customer Id API ****//
  Future<DocumnetModel> getRecentDocumentByCustomerIdApi(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.getRecentDocumentUrl,
        queryParameters: query,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.GET);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('GetRecentDocumentResponse ${response?.data}');
      return DocumnetModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

  //**** Get Recent Document by Customer Id API ****//
  Future<GetDocumentByUserIdModel> getViewDocumentByUserIdApi(
      {required Map<String, dynamic> query}) async {
    var http = HttpService(
        isAuthorizeRequest: true,
        baseURL: EndPoints.baseUrl,
        endURL: EndPoints.getViewDocumentUrl,
        queryParameters: query,
        bodyType: HttpBodyType.JSON,
        methodType: HttpMethodType.GET);
    try {
      Response<dynamic>? response = await http.request<dynamic>();
      debugPrint('GetViewDocumentResponse ${response?.data}');
      return GetDocumentByUserIdModel.fromJson(response?.data);
    } catch (e) {
      debugPrint('error $e');
      http.handleErrorResponse(error: e);
      rethrow;
    }
  }

//**** Download Document file by Dio API ****//
  Future<void> downloadFile(
      {required String docUrl, required String docName}) async {
    Dio dio = Dio();
    try {
      final directory = Directory('/storage/emulated/0/Download');

      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }

      final filePath = "${directory.path}/$docName";
      final file = File(filePath);

      if (file.existsSync()) {
        await file.delete();
        debugPrint("Existing file deleted: $docName");
      }
      Response<dynamic> response = await dio.download(docUrl, filePath);
      debugPrint('GetViewDocumentResponse ${response.statusCode}');
      // return response.data;
    } catch (e) {
      debugPrint('error $e');

      rethrow;
    }
  }

  //**** Download Document file API ****//
  Map<String, String> downloadTasks = {};

  Future<void> downloadDocumentFile(
      {required String docUrl, required String docName}) async {
    // final status = await Permission.storage.request();

    final status = await Permission.manageExternalStorage.request();

    if (status.isGranted) {
      final directory = Directory('/storage/emulated/0/Download');

      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }

      final filePath = "${directory.path}/$docName";
      final file = File(filePath);

      if (file.existsSync()) {
        await file.delete();
        debugPrint("Existing file deleted: $docName");
      }

      final taskId = await FlutterDownloader.enqueue(
        url: docUrl,
        savedDir: directory.path,
        fileName: docName,
        showNotification: true,
        openFileFromNotification: true,
      );
      // if (await File(filePath).exists()) {
      //   OpenFilex.open(filePath).then((result) {
      //     debugPrint("File opened: ${result.message}");
      //   }).catchError((e) {
      //     debugPrint("Error opening file: $e");
      //   });
      // } else {
      //   debugPrint("Error: File does not exist!");
      // }
      // if (taskId != null) {
      //   downloadTasks[taskId] = filePath;
      //   debugPrint("Download started: $taskId");
      // }

      debugPrint("Download started: $taskId");
    } else {
      debugPrint("Storage permission denied!");
      openAppSettings();
    }
  }

  // // **✅ Static Callback Fix**
  // @pragma('vm:entry-point')
  // static void downloadCallback(String id, int status, int progress) async {
  //   if (status == DownloadTaskStatus.complete.index) {
  //     debugPrint("Download complete: $id");

  //     FlutterDownloader.loadTasks().then((tasks) async {
  //       final task = tasks?.firstWhere(
  //         (task) => task.taskId == id,
  //         orElse: () => DownloadTask(
  //           taskId: '',
  //           status: DownloadTaskStatus.undefined,
  //           progress: 0,
  //           url: '',
  //           filename: '',
  //           savedDir: '',
  //           timeCreated: 0,
  //           allowCellular: false,
  //         ), // Provide a default empty task
  //       );

  //       if (task != null) {
  //         final filePath = "${task.savedDir}/${task.filename!}";
  //         debugPrint("File downloaded to: $filePath");

  //         if (await File(filePath).exists()) {
  //           OpenFilex.open(filePath).then((result) {
  //             debugPrint("File opened: ${result.message}");
  //           }).catchError((e) {
  //             debugPrint("Error opening file: $e");
  //           });
  //         } else {
  //           debugPrint("Error: File does not exist!");
  //         }
  //       } else {
  //         debugPrint("Error: Could not find download task!");
  //       }
  //     }).catchError((e) {
  //       debugPrint("Error fetching download tasks: $e");
  //     });
  //   }
  // }
}
