// To parse this JSON data, do
//
//     final logsModel = logsModelFromJson(jsonString);

import 'dart:convert';

LogsModel logsModelFromJson(String str) => LogsModel.fromJson(json.decode(str));

String logsModelToJson(LogsModel data) => json.encode(data.toJson());

class LogsModel {
  Status? status;
  List<LogsData>? data;

  LogsModel({
    this.status,
    this.data,
  });

  factory LogsModel.fromJson(Map<String, dynamic> json) => LogsModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null
            ? []
            : List<LogsData>.from(
                json["data"]!.map((x) => LogsData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class LogsData {
  int? id;
  int? actionPerformerId;
  String? actionPerformerName;
  String? actionPerformerEmail;
  int? actionUponId;
  String? actionUponEmail;
  String? actionUponName;
  String? reason;
  String? action;
  int? createdDate;
  int? modifiedDate;

  LogsData({
    this.id,
    this.actionPerformerId,
    this.actionPerformerName,
    this.actionPerformerEmail,
    this.actionUponId,
    this.actionUponEmail,
    this.actionUponName,
    this.reason,
    this.action,
    this.createdDate,
    this.modifiedDate,
  });

  factory LogsData.fromJson(Map<String, dynamic> json) => LogsData(
        id: json["id"],
        actionPerformerId: json["actionPerformerId"],
        actionPerformerName: json["actionPerformerName"],
        actionPerformerEmail: json["actionPerformerEmail"],
        actionUponId: json["actionUponId"],
        actionUponEmail: json["actionUponEmail"],
        actionUponName: json["actionUponName"],
        reason: json["reason"],
        action: json["action"],
        createdDate: json["createdDate"],
        modifiedDate: json["modifiedDate"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "actionPerformerId": actionPerformerId,
        "actionPerformerName": actionPerformerName,
        "actionPerformerEmail": actionPerformerEmail,
        "actionUponId": actionUponId,
        "actionUponEmail": actionUponEmail,
        "actionUponName": actionUponName,
        "reason": reason,
        "action": action,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
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
