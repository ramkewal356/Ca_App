// To parse this JSON data, do
//
//     final getOccupationLIstModel = getOccupationLIstModelFromJson(jsonString);

import 'dart:convert';

GetOccupationLIstModel getOccupationLIstModelFromJson(String str) =>
    GetOccupationLIstModel.fromJson(json.decode(str));

String getOccupationLIstModelToJson(GetOccupationLIstModel data) =>
    json.encode(data.toJson());

class GetOccupationLIstModel {
  Status? status;
  List<OccupationData>? data;

  GetOccupationLIstModel({
    this.status,
    this.data,
  });

  factory GetOccupationLIstModel.fromJson(Map<String, dynamic> json) =>
      GetOccupationLIstModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null
            ? []
            : List<OccupationData>.from(
                json["data"]!.map((x) => OccupationData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class OccupationData {
  int? id;
  String? occupationName;

  OccupationData({
    this.id,
    this.occupationName,
  });

  factory OccupationData.fromJson(Map<String, dynamic> json) => OccupationData(
        id: json["id"],
        occupationName: json["occupationName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "occupationName": occupationName,
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
