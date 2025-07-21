// To parse this JSON data, do
//
//     final subCaDashboardModel = subCaDashboardModelFromJson(jsonString);

import 'dart:convert';

SubCaDashboardModel subCaDashboardModelFromJson(String str) =>
    SubCaDashboardModel.fromJson(json.decode(str));

String subCaDashboardModelToJson(SubCaDashboardModel data) =>
    json.encode(data.toJson());

class SubCaDashboardModel {
  Status? status;
  Data? data;

  SubCaDashboardModel({
    this.status,
    this.data,
  });

  factory SubCaDashboardModel.fromJson(Map<String, dynamic> json) =>
      SubCaDashboardModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
  int? totalClient;
  int? totalService;
  int? totalTask;

  Data({
    this.totalClient,
    this.totalService,
    this.totalTask,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalClient: json["totalClient"],
        totalService: json["totalService"],
        totalTask: json["totalTask"],
      );

  Map<String, dynamic> toJson() => {
        "totalClient": totalClient,
        "totalService": totalService,
        "totalTask": totalTask,
      };
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
