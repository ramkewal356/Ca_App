// To parse this JSON data, do
//
//     final updateReminderModel = updateReminderModelFromJson(jsonString);

import 'dart:convert';

UpdateReminderModel updateReminderModelFromJson(String str) =>
    UpdateReminderModel.fromJson(json.decode(str));

String updateReminderModelToJson(UpdateReminderModel data) =>
    json.encode(data.toJson());

class UpdateReminderModel {
  Status? status;
  Data? data;

  UpdateReminderModel({
    this.status,
    this.data,
  });

  factory UpdateReminderModel.fromJson(Map<String, dynamic> json) =>
      UpdateReminderModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
  int? id;
  String? title;
  String? description;
  String? occurrence;
  bool? status;
  int? createdBy;
  int? createdDate;
  int? modifiedDate;
  List<User>? users;

  Data({
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

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
