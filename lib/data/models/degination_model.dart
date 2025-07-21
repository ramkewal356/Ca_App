// To parse this JSON data, do
//
//     final deginationModel = deginationModelFromJson(jsonString);

import 'dart:convert';

DeginationModel deginationModelFromJson(String str) =>
    DeginationModel.fromJson(json.decode(str));

String deginationModelToJson(DeginationModel data) =>
    json.encode(data.toJson());

class DeginationModel {
  Status? status;
  List<DeginationData>? data;

  DeginationModel({
    this.status,
    this.data,
  });

  factory DeginationModel.fromJson(Map<String, dynamic> json) =>
      DeginationModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null
            ? []
            : List<DeginationData>.from(
                json["data"]!.map((x) => DeginationData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class DeginationData {
  int? designationId;
  String? designationName;

  DeginationData({
    this.designationId,
    this.designationName,
  });

  factory DeginationData.fromJson(Map<String, dynamic> json) => DeginationData(
        designationId: json["designationId"],
        designationName: json["designationName"],
      );

  Map<String, dynamic> toJson() => {
        "designationId": designationId,
        "designationName": designationName,
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
