// To parse this JSON data, do
//
//     final otpSendAndVerifyModel = otpSendAndVerifyModelFromJson(jsonString);

import 'dart:convert';

OtpSendAndVerifyModel otpSendAndVerifyModelFromJson(String str) =>
    OtpSendAndVerifyModel.fromJson(json.decode(str));

String otpSendAndVerifyModelToJson(OtpSendAndVerifyModel data) =>
    json.encode(data.toJson());

class OtpSendAndVerifyModel {
  Status? status;
  Data? data;

  OtpSendAndVerifyModel({
    this.status,
    this.data,
  });

  factory OtpSendAndVerifyModel.fromJson(Map<String, dynamic> json) =>
      OtpSendAndVerifyModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
  String? response;
  int? id;

  Data({
    this.response,
    this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        response: json["response"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "id": id,
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
