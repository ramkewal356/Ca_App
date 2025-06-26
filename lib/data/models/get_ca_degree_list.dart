// To parse this JSON data, do
//
//     final getCaDegreeListModel = getCaDegreeListModelFromJson(jsonString);

import 'dart:convert';

GetCaDegreeListModel getCaDegreeListModelFromJson(String str) =>
    GetCaDegreeListModel.fromJson(json.decode(str));

String getCaDegreeListModelToJson(GetCaDegreeListModel data) =>
    json.encode(data.toJson());

class GetCaDegreeListModel {
  Status? status;
  List<Datum>? data;

  GetCaDegreeListModel({
    this.status,
    this.data,
  });

  factory GetCaDegreeListModel.fromJson(Map<String, dynamic> json) =>
      GetCaDegreeListModel(
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
  String? degreeName;

  Datum({
    this.id,
    this.degreeName,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        degreeName: json["degreeName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "degreeName": degreeName,
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
