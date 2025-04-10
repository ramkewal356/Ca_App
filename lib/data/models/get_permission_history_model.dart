// To parse this JSON data, do
//
//     final getPermissionHistoryModel = getPermissionHistoryModelFromJson(jsonString);

import 'dart:convert';

GetPermissionHistoryModel getPermissionHistoryModelFromJson(String str) =>
    GetPermissionHistoryModel.fromJson(json.decode(str));

String getPermissionHistoryModelToJson(GetPermissionHistoryModel data) =>
    json.encode(data.toJson());

class GetPermissionHistoryModel {
  Status? status;
  Data? data;

  GetPermissionHistoryModel({
    this.status,
    this.data,
  });

  factory GetPermissionHistoryModel.fromJson(Map<String, dynamic> json) =>
      GetPermissionHistoryModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
  List<Content>? content;
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
            : List<Content>.from(
                json["content"]!.map((x) => Content.fromJson(x))),
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

class Content {
  int? id;
  String? userName;
  int? userId;
  String? permissionName;
  int? updatedById;
  String? updatedByName;
  int? createdAt;
  String? action;

  Content({
    this.id,
    this.userName,
    this.userId,
    this.permissionName,
    this.updatedById,
    this.updatedByName,
    this.createdAt,
    this.action,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        id: json["id"],
        userName: json["userName"],
        userId: json["userId"],
        permissionName: json["permissionName"],
        updatedById: json["updatedById"],
        updatedByName: json["updatedByName"],
        createdAt: json["createdAt"],
        action: json["action"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userName": userName,
        "userId": userId,
        "permissionName": permissionName,
        "updatedById": updatedById,
        "updatedByName": updatedByName,
        "createdAt": createdAt,
        "action": action,
      };
}

// enum UpdatedByName { DIVYA_PROJECT }

// final updatedByNameValues =
//     EnumValues({"Divya Project": UpdatedByName.DIVYA_PROJECT});

// enum UserName { BRIJESH_KUMAR, PHIL_SALT, SPORT_ONE }

// final userNameValues = EnumValues({
//   "Brijesh  kumar ": UserName.BRIJESH_KUMAR,
//   "Phil Salt": UserName.PHIL_SALT,
//   "Sport one": UserName.SPORT_ONE
// });

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
