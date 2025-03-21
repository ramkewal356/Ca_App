// To parse this JSON data, do
//
//     final taskDocumentUploadModel = taskDocumentUploadModelFromJson(jsonString);

import 'dart:convert';

TaskDocumentUploadModel taskDocumentUploadModelFromJson(String str) =>
    TaskDocumentUploadModel.fromJson(json.decode(str));

String taskDocumentUploadModelToJson(TaskDocumentUploadModel data) =>
    json.encode(data.toJson());

class TaskDocumentUploadModel {
  Status? status;
  Data? data;

  TaskDocumentUploadModel({
    this.status,
    this.data,
  });

  factory TaskDocumentUploadModel.fromJson(Map<String, dynamic> json) =>
      TaskDocumentUploadModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
  Headers? headers;
  String? body;
  String? statusCode;
  int? statusCodeValue;

  Data({
    this.headers,
    this.body,
    this.statusCode,
    this.statusCodeValue,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        headers:
            json["headers"] == null ? null : Headers.fromJson(json["headers"]),
        body: json["body"],
        statusCode: json["statusCode"],
        statusCodeValue: json["statusCodeValue"],
      );

  Map<String, dynamic> toJson() => {
        "headers": headers?.toJson(),
        "body": body,
        "statusCode": statusCode,
        "statusCodeValue": statusCodeValue,
      };
}

class Headers {
  Headers();

  factory Headers.fromJson(Map<String, dynamic> json) => Headers();

  Map<String, dynamic> toJson() => {};
}

class Status {
  String? httpCode;
  bool? success;
  String? message;

  Status({
    this.httpCode,
    this.success,
    this.message,
  });

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        httpCode: json["httpCode"],
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "httpCode": httpCode,
        "success": success,
        "message": message,
      };
}
