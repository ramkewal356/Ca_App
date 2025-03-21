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
  List<ContactData>? data;

  GetContactByUserIdModel({
    this.status,
    this.data,
  });

  factory GetContactByUserIdModel.fromJson(Map<String, dynamic> json) =>
      GetContactByUserIdModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null
            ? []
            : List<ContactData>.from(
                json["data"]!.map((x) => ContactData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
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
