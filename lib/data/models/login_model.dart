// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  Status? status;
  Data? data;

  LoginModel({
    this.status,
    this.data,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
  String? token;
  int? id;
  dynamic caUserId;
  dynamic superCaUserId;
  String? firstName;
  String? lastName;
  String? email;
  String? address;
  dynamic phone;
  dynamic mobile;
  String? role;
  bool? status;
  String? profileUrl;
  String? profileName;

  Data({
    this.token,
    this.id,
    this.caUserId,
    this.superCaUserId,
    this.firstName,
    this.lastName,
    this.email,
    this.address,
    this.phone,
    this.mobile,
    this.role,
    this.status,
    this.profileUrl,
    this.profileName,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        token: json["token"],
        id: json["id"],
        caUserId: json["caUserId"],
        superCaUserId: json["superCaUserId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        address: json["address"],
        phone: json["phone"],
        mobile: json["mobile"],
        role: json["role"],
        status: json["status"],
        profileUrl: json["profileUrl"],
        profileName: json["profileName"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "id": id,
        "caUserId": caUserId,
        "superCaUserId": superCaUserId,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "address": address,
        "phone": phone,
        "mobile": mobile,
        "role": role,
        "status": status,
        "profileUrl": profileUrl,
        "profileName": profileName,
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

