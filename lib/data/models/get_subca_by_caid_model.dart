// To parse this JSON data, do
//
//     final getSubCaByCaIdModel = getSubCaByCaIdModelFromJson(jsonString);

import 'dart:convert';

GetSubCaByCaIdModel getSubCaByCaIdModelFromJson(String str) =>
    GetSubCaByCaIdModel.fromJson(json.decode(str));

String getSubCaByCaIdModelToJson(GetSubCaByCaIdModel data) =>
    json.encode(data.toJson());

class GetSubCaByCaIdModel {
  Status? status;
  List<Datum>? data;

  GetSubCaByCaIdModel({
    this.status,
    this.data,
  });

  factory GetSubCaByCaIdModel.fromJson(Map<String, dynamic> json) =>
      GetSubCaByCaIdModel(
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
