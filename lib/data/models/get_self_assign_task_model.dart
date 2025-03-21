// To parse this JSON data, do
//
//     final getAssignTaskListModel = getAssignTaskListModelFromJson(jsonString);

import 'dart:convert';

GetAssignTaskListModel getAssignTaskListModelFromJson(String str) =>
    GetAssignTaskListModel.fromJson(json.decode(str));

String getAssignTaskListModelToJson(GetAssignTaskListModel data) =>
    json.encode(data.toJson());

class GetAssignTaskListModel {
  Status? status;
  List<AssignTaskData>? data;

  GetAssignTaskListModel({
    this.status,
    this.data,
  });

  factory GetAssignTaskListModel.fromJson(Map<String, dynamic> json) =>
      GetAssignTaskListModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null
            ? []
            : List<AssignTaskData>.from(
                json["data"]!.map((x) => AssignTaskData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class AssignTaskData {
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
  String? assigneeName;
  String? assignedName;
  String? assigneeEmail;
  String? assignedEmail;
  String? customerName;
  String? customerEmail;
  String? customerMobile;
  String? priority;
  dynamic emailStatus;

  AssignTaskData({
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
    this.assigneeName,
    this.assignedName,
    this.assigneeEmail,
    this.assignedEmail,
    this.customerName,
    this.customerEmail,
    this.customerMobile,
    this.priority,
    this.emailStatus,
  });

  factory AssignTaskData.fromJson(Map<String, dynamic> json) => AssignTaskData(
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
        assigneeName: json["assigneeName"],
        assignedName: json["assignedName"],
        assigneeEmail: json["assigneeEmail"],
        assignedEmail: json["assignedEmail"],
        customerName: json["customerName"],
        customerEmail: json["customerEmail"],
        customerMobile: json["customerMobile"],
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
        "assigneeName": assigneeName,
        "assignedName": assignedName,
        "assigneeEmail": assigneeEmail,
        "assignedEmail": assignedEmail,
        "customerName": customerName,
        "customerEmail": customerEmail,
        "customerMobile": customerMobile,
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
