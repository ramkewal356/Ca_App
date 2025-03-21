// To parse this JSON data, do
//
//     final getViewTaskByTaskIdModel = getViewTaskByTaskIdModelFromJson(jsonString);

import 'dart:convert';

GetViewTaskByTaskIdModel getViewTaskByTaskIdModelFromJson(String str) =>
    GetViewTaskByTaskIdModel.fromJson(json.decode(str));

String getViewTaskByTaskIdModelToJson(GetViewTaskByTaskIdModel data) =>
    json.encode(data.toJson());

class GetViewTaskByTaskIdModel {
  Status? status;
  Data? data;

  GetViewTaskByTaskIdModel({
    this.status,
    this.data,
  });

  factory GetViewTaskByTaskIdModel.fromJson(Map<String, dynamic> json) =>
      GetViewTaskByTaskIdModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
  TaskResponseDto? taskResponseDto;
  List<TaskDocument>? taskDocuments;

  Data({
    this.taskResponseDto,
    this.taskDocuments,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        taskResponseDto: json["taskResponseDto"] == null
            ? null
            : TaskResponseDto.fromJson(json["taskResponseDto"]),
        taskDocuments: json["taskDocuments"] == null
            ? []
            : List<TaskDocument>.from(
                json["taskDocuments"]!.map((x) => TaskDocument.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "taskResponseDto": taskResponseDto?.toJson(),
        "taskDocuments": taskDocuments == null
            ? []
            : List<dynamic>.from(taskDocuments!.map((x) => x.toJson())),
      };
}

class TaskDocument {
  int? id;
  int? taskId;
  String? docName;
  String? docUrl;
  int? createdDate;
  int? modifiedDate;
  bool? status;

  TaskDocument({
    this.id,
    this.taskId,
    this.docName,
    this.docUrl,
    this.createdDate,
    this.modifiedDate,
    this.status,
  });

  factory TaskDocument.fromJson(Map<String, dynamic> json) => TaskDocument(
        id: json["id"],
        taskId: json["taskId"],
        docName: json["docName"],
        docUrl: json["docUrl"],
        createdDate: json["createdDate"],
        modifiedDate: json["modifiedDate"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "taskId": taskId,
        "docName": docName,
        "docUrl": docUrl,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "status": status,
      };
}

class TaskResponseDto {
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
  bool? emailStatus;

  TaskResponseDto({
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

  factory TaskResponseDto.fromJson(Map<String, dynamic> json) =>
      TaskResponseDto(
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
