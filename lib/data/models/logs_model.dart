// To parse this JSON data, do
//
//     final logsModel = logsModelFromJson(jsonString);

import 'dart:convert';

LogsModel logsModelFromJson(String str) => LogsModel.fromJson(json.decode(str));

String logsModelToJson(LogsModel data) => json.encode(data.toJson());

class LogsModel {
  Status? status;
  Data? data;

  LogsModel({
    this.status,
    this.data,
  });

  factory LogsModel.fromJson(Map<String, dynamic> json) => LogsModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
  List<LogsData>? content;
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
            : List<LogsData>.from(
                json["content"]!.map((x) => LogsData.fromJson(x))),
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

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
