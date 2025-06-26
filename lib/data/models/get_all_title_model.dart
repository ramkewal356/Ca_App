// To parse this JSON data, do
//
//     final getAllTitleModel = getAllTitleModelFromJson(jsonString);

import 'dart:convert';

GetAllTitleModel getAllTitleModelFromJson(String str) =>
    GetAllTitleModel.fromJson(json.decode(str));

String getAllTitleModelToJson(GetAllTitleModel data) =>
    json.encode(data.toJson());

class GetAllTitleModel {
  Status? status;
  List<Datum>? data;

  GetAllTitleModel({
    this.status,
    this.data,
  });

  factory GetAllTitleModel.fromJson(Map<String, dynamic> json) =>
      GetAllTitleModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  int? id;
  String? title;
  bool? status;

  Datum({
    this.id,
    this.title,
    this.status,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        title: json["title"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "status": status,
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
