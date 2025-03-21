// To parse this JSON data, do
//
//     final getActionOnTaskModel = getActionOnTaskModelFromJson(jsonString);

import 'dart:convert';

GetActionOnTaskModel getActionOnTaskModelFromJson(String str) =>
    GetActionOnTaskModel.fromJson(json.decode(str));

String getActionOnTaskModelToJson(GetActionOnTaskModel data) =>
    json.encode(data.toJson());

class GetActionOnTaskModel {
  Status? status;
  Data? data;

  GetActionOnTaskModel({
    this.status,
    this.data,
  });

  factory GetActionOnTaskModel.fromJson(Map<String, dynamic> json) =>
      GetActionOnTaskModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
  int? id;
  String? name;
  String? description;
  dynamic duration;
  dynamic resolution;
  int? createdDate;
  int? modifiedDate;
  bool? taskStatus;
  int? assignedId;
  int? assigneeId;
  int? createdById;
  int? customerId;
  dynamic comment;
  String? taskResponse;
  String? priority;
  dynamic emailStatus;

  Data({
    this.id,
    this.name,
    this.description,
    this.duration,
    this.resolution,
    this.createdDate,
    this.modifiedDate,
    this.taskStatus,
    this.assignedId,
    this.assigneeId,
    this.createdById,
    this.customerId,
    this.comment,
    this.taskResponse,
    this.priority,
    this.emailStatus,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        duration: json["duration"],
        resolution: json["resolution"],
        createdDate: json["createdDate"],
        modifiedDate: json["modifiedDate"],
        taskStatus: json["taskStatus"],
        assignedId: json["assignedId"],
        assigneeId: json["assigneeId"],
        createdById: json["createdById"],
        customerId: json["customerId"],
        comment: json["comment"],
        taskResponse: json["taskResponse"],
        priority: json["priority"],
        emailStatus: json["emailStatus"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "duration": duration,
        "resolution": resolution,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "taskStatus": taskStatus,
        "assignedId": assignedId,
        "assigneeId": assigneeId,
        "createdById": createdById,
        "customerId": customerId,
        "comment": comment,
        "taskResponse": taskResponse,
        "priority": priority,
        "emailStatus": emailStatus,
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
