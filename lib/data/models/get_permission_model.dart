// To parse this JSON data, do
//
//     final getPermissionModel = getPermissionModelFromJson(jsonString);

import 'dart:convert';

GetPermissionModel getPermissionModelFromJson(String str) =>
    GetPermissionModel.fromJson(json.decode(str));

String getPermissionModelToJson(GetPermissionModel data) =>
    json.encode(data.toJson());

class GetPermissionModel {
  Status? status;
  List<PermissionData>? data;

  GetPermissionModel({
    this.status,
    this.data,
  });

  factory GetPermissionModel.fromJson(Map<String, dynamic> json) =>
      GetPermissionModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null
            ? []
            : List<PermissionData>.from(
                json["data"]!.map((x) => PermissionData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class PermissionData {
  int? id;
  String? permissionName;
  String? type;

  PermissionData({
    this.id,
    this.permissionName,
    this.type,
  });

  factory PermissionData.fromJson(Map<String, dynamic> json) => PermissionData(
        id: json["id"],
        permissionName: json["permissionName"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "permissionName": permissionName,
        "type": type,
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
