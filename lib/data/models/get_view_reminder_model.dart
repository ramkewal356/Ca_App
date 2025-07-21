// To parse this JSON Reminderdata, do
//
//     final getViewReminderByIdModel = getViewReminderByIdModelFromJson(jsonString);

import 'dart:convert';

GetViewReminderByIdModel getViewReminderByIdModelFromJson(String str) =>
    GetViewReminderByIdModel.fromJson(json.decode(str));

String getViewReminderByIdModelToJson(GetViewReminderByIdModel data) =>
    json.encode(data.toJson());

class GetViewReminderByIdModel {
  Status? status;
  ReminderData? data;

  GetViewReminderByIdModel({
    this.status,
    this.data,
  });

  factory GetViewReminderByIdModel.fromJson(Map<String, dynamic> json) =>
      GetViewReminderByIdModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null ? null : ReminderData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };
}

class ReminderData {
  int? id;
  String? title;
  String? description;
  String? occurrence;
  bool? status;
  int? createdBy;
  int? createdDate;
  int? modifiedDate;
  List<User>? users;

  ReminderData({
    this.id,
    this.title,
    this.description,
    this.occurrence,
    this.status,
    this.createdBy,
    this.createdDate,
    this.modifiedDate,
    this.users,
  });

  factory ReminderData.fromJson(Map<String, dynamic> json) => ReminderData(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        occurrence: json["occurrence"],
        status: json["status"],
        createdBy: json["createdBy"],
        createdDate: json["createdDate"],
        modifiedDate: json["modifiedDate"],
        users: json["users"] == null
            ? []
            : List<User>.from(json["users"]!.map((x) => User.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "occurrence": occurrence,
        "status": status,
        "createdBy": createdBy,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "users": users == null
            ? []
            : List<dynamic>.from(users!.map((x) => x.toJson())),
      };
}

class User {
  int? id;
  String? firstName;
  String? lastName;
  String? email;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
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
