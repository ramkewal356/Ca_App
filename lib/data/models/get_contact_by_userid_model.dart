// To parse this JSON data, do
//
//     final getContactByUserIdModel = getContactByUserIdModelFromJson(jsonString);

import 'dart:convert';

GetContactByUserIdModel getContactByUserIdModelFromJson(String str) =>
    GetContactByUserIdModel.fromJson(json.decode(str));

String getContactByUserIdModelToJson(GetContactByUserIdModel data) =>
    json.encode(data.toJson());

class GetContactByUserIdModel {
  Status? status;
  Data? data;

  GetContactByUserIdModel({
    this.status,
    this.data,
  });

  factory GetContactByUserIdModel.fromJson(Map<String, dynamic> json) =>
      GetContactByUserIdModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
  List<ContactData>? content;
  Pageable? pageable;
  bool? last;
  int? totalElements;
  int? totalPages;
  int? size;
  int? number;
  Sort? sort;
  bool? first;
  int? numberOfElements;
  bool? empty;

  Data({
    this.content,
    this.pageable,
    this.last,
    this.totalElements,
    this.totalPages,
    this.size,
    this.number,
    this.sort,
    this.first,
    this.numberOfElements,
    this.empty,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        content: json["content"] == null
            ? []
            : List<ContactData>.from(
                json["content"]!.map((x) => ContactData.fromJson(x))),
        pageable: json["pageable"] == null
            ? null
            : Pageable.fromJson(json["pageable"]),
        last: json["last"],
        totalElements: json["totalElements"],
        totalPages: json["totalPages"],
        size: json["size"],
        number: json["number"],
        sort: json["sort"] == null ? null : Sort.fromJson(json["sort"]),
        first: json["first"],
        numberOfElements: json["numberOfElements"],
        empty: json["empty"],
      );

  Map<String, dynamic> toJson() => {
        "content": content == null
            ? []
            : List<dynamic>.from(content!.map((x) => x.toJson())),
        "pageable": pageable?.toJson(),
        "last": last,
        "totalElements": totalElements,
        "totalPages": totalPages,
        "size": size,
        "number": number,
        "sort": sort?.toJson(),
        "first": first,
        "numberOfElements": numberOfElements,
        "empty": empty,
      };
}

class ContactData {
  int? contactId;
  String? subject;
  int? userId;
  String? message;
  bool? status;
  String? response;
  String? comment;
  dynamic adminId;
  int? createdDate;
  int? modifiedDate;
  dynamic email;
  dynamic mobile;

  ContactData({
    this.contactId,
    this.subject,
    this.userId,
    this.message,
    this.status,
    this.response,
    this.comment,
    this.adminId,
    this.createdDate,
    this.modifiedDate,
    this.email,
    this.mobile,
  });

  factory ContactData.fromJson(Map<String, dynamic> json) => ContactData(
        contactId: json["contactId"],
        subject: json["subject"],
        userId: json["userId"],
        message: json["message"],
        status: json["status"],
        response: json["response"],
        comment: json["comment"],
        adminId: json["adminId"],
        createdDate: json["createdDate"],
        modifiedDate: json["modifiedDate"],
        email: json["email"],
        mobile: json["mobile"],
      );

  Map<String, dynamic> toJson() => {
        "contactId": contactId,
        "subject": subject,
        "userId": userId,
        "message": message,
        "status": status,
        "response": response,
        "comment": comment,
        "adminId": adminId,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "email": email,
        "mobile": mobile,
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
