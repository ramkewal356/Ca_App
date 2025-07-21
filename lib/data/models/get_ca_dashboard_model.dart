// To parse this JSON data, do
//
//     final getCaDashboardDataModel = getCaDashboardDataModelFromJson(jsonString);

import 'dart:convert';

GetCaDashboardDataModel getCaDashboardDataModelFromJson(String str) =>
    GetCaDashboardDataModel.fromJson(json.decode(str));

String getCaDashboardDataModelToJson(GetCaDashboardDataModel data) =>
    json.encode(data.toJson());

class GetCaDashboardDataModel {
  Status? status;
  Data? data;

  GetCaDashboardDataModel({
    this.status,
    this.data,
  });

  factory GetCaDashboardDataModel.fromJson(Map<String, dynamic> json) =>
      GetCaDashboardDataModel(
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
  int? totalTeamMember;
  int? totalServiceOpted;

  Data({
    this.totalClient,
    this.totalTeamMember,
    this.totalServiceOpted,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalClient: json["totalClient"],
        totalTeamMember: json["totalTeamMember"],
        totalServiceOpted: json["totalServiceOpted"],
      );

  Map<String, dynamic> toJson() => {
        "totalClient": totalClient,
        "totalTeamMember": totalTeamMember,
        "totalServiceOpted": totalServiceOpted,
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
