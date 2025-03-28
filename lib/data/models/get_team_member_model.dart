// To parse this JSON data, do
//
//     final getTeamMemberModel = getTeamMemberModelFromJson(jsonString);

import 'dart:convert';

GetTeamMemberModel getTeamMemberModelFromJson(String str) =>
    GetTeamMemberModel.fromJson(json.decode(str));

String getTeamMemberModelToJson(GetTeamMemberModel data) =>
    json.encode(data.toJson());

class GetTeamMemberModel {
  Status? status;
  List<Datum>? data;

  GetTeamMemberModel({
    this.status,
    this.data,
  });

  factory GetTeamMemberModel.fromJson(Map<String, dynamic> json) =>
      GetTeamMemberModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  int? id;
  int? userId;
  String? firstName;
  String? lastName;
  String? email;
  String? address;
  String? mobile;
  dynamic phone;
  String? userResponse;
  String? profileUrl;
  String? profileName;
  bool? status;
  String? designation;
  String? aadhaarCardNumber;
  String? gender;

  Datum({
    this.id,
    this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.address,
    this.mobile,
    this.phone,
    this.userResponse,
    this.profileUrl,
    this.profileName,
    this.status,
    this.designation,
    this.aadhaarCardNumber,
    this.gender,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["userId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        address: json["address"],
        mobile: json["mobile"],
        phone: json["phone"],
        userResponse: json["userResponse"],
        profileUrl: json["profileUrl"],
        profileName: json["profileName"],
        status: json["status"],
        designation: json["designation"],
        aadhaarCardNumber: json["aadhaarCardNumber"],
        gender: json["gender"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "address": address,
        "mobile": mobile,
        "phone": phone,
        "userResponse": userResponse,
        "profileUrl": profileUrl,
        "profileName": profileName,
        "status": status,
        "designation": designation,
        "aadhaarCardNumber": aadhaarCardNumber,
        "gender": gender,
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
