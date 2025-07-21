// To parse this JSON data, do
//
//     final getContactByContactIdModel = getContactByContactIdModelFromJson(jsonString);

import 'dart:convert';

GetContactByContactIdModel getContactByContactIdModelFromJson(String str) =>
    GetContactByContactIdModel.fromJson(json.decode(str));

String getContactByContactIdModelToJson(GetContactByContactIdModel data) =>
    json.encode(data.toJson());

class GetContactByContactIdModel {
  Status? status;
  Data? data;

  GetContactByContactIdModel({
    this.status,
    this.data,
  });

  factory GetContactByContactIdModel.fromJson(Map<String, dynamic> json) =>
      GetContactByContactIdModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
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
  String? userName;
  String? email;

  Data({
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
    this.userName,
    this.email,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
        userName: json["userName"],
        email: json["email"],
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
        "userName": userName,
        "email": email,
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
