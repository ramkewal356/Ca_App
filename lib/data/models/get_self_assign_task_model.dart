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
  Data? data;

  GetAssignTaskListModel({
    this.status,
    this.data,
  });

  factory GetAssignTaskListModel.fromJson(Map<String, dynamic> json) =>
      GetAssignTaskListModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
  List<AssignTaskData>? content;
  Pageable? pageable;
  int? totalElements;
  int? totalPages;
  bool? last;
  int? size;
  int? number;
  Sort? sort;
  int? numberOfElements;
  bool? first;
  bool? empty;

  Data({
    this.content,
    this.pageable,
    this.totalElements,
    this.totalPages,
    this.last,
    this.size,
    this.number,
    this.sort,
    this.numberOfElements,
    this.first,
    this.empty,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        content: json["content"] == null
            ? []
            : List<AssignTaskData>.from(
                json["content"]!.map((x) => AssignTaskData.fromJson(x))),
        pageable: json["pageable"] == null
            ? null
            : Pageable.fromJson(json["pageable"]),
        totalElements: json["totalElements"],
        totalPages: json["totalPages"],
        last: json["last"],
        size: json["size"],
        number: json["number"],
        sort: json["sort"] == null ? null : Sort.fromJson(json["sort"]),
        numberOfElements: json["numberOfElements"],
        first: json["first"],
        empty: json["empty"],
      );

  Map<String, dynamic> toJson() => {
        "content": content == null
            ? []
            : List<dynamic>.from(content!.map((x) => x.toJson())),
        "pageable": pageable?.toJson(),
        "totalElements": totalElements,
        "totalPages": totalPages,
        "last": last,
        "size": size,
        "number": number,
        "sort": sort?.toJson(),
        "numberOfElements": numberOfElements,
        "first": first,
        "empty": empty,
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
  bool? emailStatus;

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

class Pageable {
  Sort? sort;
  int? offset;
  int? pageNumber;
  int? pageSize;
  bool? paged;
  bool? unpaged;

  Pageable({
    this.sort,
    this.offset,
    this.pageNumber,
    this.pageSize,
    this.paged,
    this.unpaged,
  });

  factory Pageable.fromJson(Map<String, dynamic> json) => Pageable(
        sort: json["sort"] == null ? null : Sort.fromJson(json["sort"]),
        offset: json["offset"],
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        paged: json["paged"],
        unpaged: json["unpaged"],
      );

  Map<String, dynamic> toJson() => {
        "sort": sort?.toJson(),
        "offset": offset,
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "paged": paged,
        "unpaged": unpaged,
      };
}

class Sort {
  bool? empty;
  bool? sorted;
  bool? unsorted;

  Sort({
    this.empty,
    this.sorted,
    this.unsorted,
  });

  factory Sort.fromJson(Map<String, dynamic> json) => Sort(
        empty: json["empty"],
        sorted: json["sorted"],
        unsorted: json["unsorted"],
      );

  Map<String, dynamic> toJson() => {
        "empty": empty,
        "sorted": sorted,
        "unsorted": unsorted,
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
