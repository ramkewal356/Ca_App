// To parse this JSON data, do
//
//     final addContactModel = addContactModelFromJson(jsonString);

import 'dart:convert';

AddContactModel addContactModelFromJson(String str) =>
    AddContactModel.fromJson(json.decode(str));

String addContactModelToJson(AddContactModel data) =>
    json.encode(data.toJson());

class AddContactModel {
  Status? status;
  Data? data;

  AddContactModel({
    this.status,
    this.data,
  });

  factory AddContactModel.fromJson(Map<String, dynamic> json) =>
      AddContactModel(
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
  dynamic userId;
  String? message;
  bool? status;
  String? response;
  dynamic comment;
  dynamic adminId;
  int? createdDate;
  int? modifiedDate;
  String? email;
  dynamic mobile;

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
    this.email,
    this.mobile,
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
