// To parse this JSON data, do
//
//     final getUserByIdModel = getUserByIdModelFromJson(jsonString);

import 'dart:convert';

GetUserByIdModel getUserByIdModelFromJson(String str) =>
    GetUserByIdModel.fromJson(json.decode(str));

String getUserByIdModelToJson(GetUserByIdModel data) =>
    json.encode(data.toJson());

class GetUserByIdModel {
  Status? status;
  Data? data;

  GetUserByIdModel({
    this.status,
    this.data,
  });

  factory GetUserByIdModel.fromJson(Map<String, dynamic> json) =>
      GetUserByIdModel(
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
  String? firstName;
  String? lastName;
  String? email;
  String? address;
  dynamic mobile;
  dynamic phone;
  String? role;
  String? otp;
  bool? otpVerify;
  bool? status;
  int? createdDate;
  int? modifiedDate;
  String? profileUrl;
  String? profileName;
  String? gender;
  dynamic panCardNumber;
  dynamic aadhaarCardNumber;
  String? userResponse;
  String? countryCode;
  dynamic token;
  dynamic caEmail;
  dynamic caId;
  dynamic caName;

  Data({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.address,
    this.mobile,
    this.phone,
    this.role,
    this.otp,
    this.otpVerify,
    this.status,
    this.createdDate,
    this.modifiedDate,
    this.profileUrl,
    this.profileName,
    this.gender,
    this.panCardNumber,
    this.aadhaarCardNumber,
    this.userResponse,
    this.countryCode,
    this.token,
    this.caEmail,
    this.caId,
    this.caName,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        address: json["address"],
        mobile: json["mobile"],
        phone: json["phone"],
        role: json["role"],
        otp: json["otp"],
        otpVerify: json["otpVerify"],
        status: json["status"],
        createdDate: json["createdDate"],
        modifiedDate: json["modifiedDate"],
        profileUrl: json["profileUrl"],
        profileName: json["profileName"],
        gender: json["gender"],
        panCardNumber: json["panCardNumber"],
        aadhaarCardNumber: json["aadhaarCardNumber"],
        userResponse: json["userResponse"],
        countryCode: json["countryCode"],
        token: json["token"],
        caEmail: json["caEmail"],
        caId: json["caId"],
        caName: json["caName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "address": address,
        "mobile": mobile,
        "phone": phone,
        "role": role,
        "otp": otp,
        "otpVerify": otpVerify,
        "status": status,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "profileUrl": profileUrl,
        "profileName": profileName,
        "gender": gender,
        "panCardNumber": panCardNumber,
        "aadhaarCardNumber": aadhaarCardNumber,
        "userResponse": userResponse,
        "countryCode": countryCode,
        "token": token,
        "caEmail": caEmail,
        "caId": caId,
        "caName": caName,
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
