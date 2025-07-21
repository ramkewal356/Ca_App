// To parse this JSON PermissionData, do
//
//     final getPermissionModel = getPermissionModelFromJson(jsonString);

import 'dart:convert';



GetPermissionModel getPermissionModelFromJson(String str) =>
    GetPermissionModel.fromJson(json.decode(str));

String getPermissionModelToJson(GetPermissionModel data) =>
    json.encode(data.toJson());

class GetPermissionModel {
  Status? status;
  PermissionData? data;

  GetPermissionModel({
    this.status,
    this.data,
  });

  factory GetPermissionModel.fromJson(Map<String, dynamic> json) =>
      GetPermissionModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data:
            json["data"] == null ? null : PermissionData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };
}

class PermissionData {
  List<ClientActivityData>? clientActivities;
  List<ClientActivityData>? documentActivities;
  List<ClientActivityData>? general;
  List<ClientActivityData>? taskActivities;

  PermissionData({
    this.clientActivities,
    this.documentActivities,
    this.general,
    this.taskActivities,
  });

  factory PermissionData.fromJson(Map<String, dynamic> json) => PermissionData(
        clientActivities: json["CLIENT_ACTIVITIES"] == null
            ? []
            : List<ClientActivityData>.from(json["CLIENT_ACTIVITIES"]!
                .map((x) => ClientActivityData.fromJson(x))),
        documentActivities: json["DOCUMENT_ACTIVITIES"] == null
            ? []
            : List<ClientActivityData>.from(json["DOCUMENT_ACTIVITIES"]!
                .map((x) => ClientActivityData.fromJson(x))),
        general: json["GENERAL"] == null
            ? []
            : List<ClientActivityData>.from(
                json["GENERAL"]!.map((x) => ClientActivityData.fromJson(x))),
        taskActivities: json["TASK_ACTIVITIES"] == null
            ? []
            : List<ClientActivityData>.from(json["TASK_ACTIVITIES"]!
                .map((x) => ClientActivityData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "CLIENT_ACTIVITIES": clientActivities == null
            ? []
            : List<dynamic>.from(clientActivities!.map((x) => x.toJson())),
        "DOCUMENT_ACTIVITIES": documentActivities == null
            ? []
            : List<dynamic>.from(documentActivities!.map((x) => x.toJson())),
        "GENERAL": general == null
            ? []
            : List<dynamic>.from(general!.map((x) => x.toJson())),
        "TASK_ACTIVITIES": taskActivities == null
            ? []
            : List<dynamic>.from(taskActivities!.map((x) => x.toJson())),
      };
}

class ClientActivityData {
  int? id;
  String? permissionName;
  String? type;
  bool? isSelected;

  ClientActivityData(
      {
    this.id,
    this.permissionName,
    this.type,
    this.isSelected
  });

  factory ClientActivityData.fromJson(Map<String, dynamic> json) =>
      ClientActivityData(
        id: json["id"],
        permissionName: json["permissionName"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "permissionName": permissionName,
        "type": type,
      };
  // factory ClientActivityData.fromClientActivity(ClientActivity activity) {
  //   return ClientActivityData(
  //     id: activity.id,
  //     permissionName: activity.permissionName,
  //     isSelected: activity.isSelected,
  //   );
  // }
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
