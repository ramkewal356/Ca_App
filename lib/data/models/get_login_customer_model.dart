// To parse this JSON data, do
//
//     final getLoginCustomerModel = getLoginCustomerModelFromJson(jsonString);

import 'dart:convert';

GetLoginCustomerModel getLoginCustomerModelFromJson(String str) =>
    GetLoginCustomerModel.fromJson(json.decode(str));

String getLoginCustomerModelToJson(GetLoginCustomerModel data) =>
    json.encode(data.toJson());

class GetLoginCustomerModel {
  Status? status;
  List<LoginCustomerData>? data;

  GetLoginCustomerModel({
    this.status,
    this.data,
  });

  factory GetLoginCustomerModel.fromJson(Map<String, dynamic> json) =>
      GetLoginCustomerModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null
            ? []
            : List<LoginCustomerData>.from(
                json["data"]!.map((x) => LoginCustomerData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class LoginCustomerData {
  int? id;
  int? userId;
  int? caId;
  String? caName;
  String? firstName;
  String? lastName;
  String? email;
  String? address;
  String? mobile;
  dynamic phone;
  String? panCardNumber;
  String? aadhaarCardNumber;
  String? gender;
  String? userResponse;
  int? createdDate;
  int? modifiedDate;
  String? profileUrl;
  String? profileName;
  bool? status;
  String? countryCode;

  LoginCustomerData({
    this.id,
    this.userId,
    this.caId,
    this.caName,
    this.firstName,
    this.lastName,
    this.email,
    this.address,
    this.mobile,
    this.phone,
    this.panCardNumber,
    this.aadhaarCardNumber,
    this.gender,
    this.userResponse,
    this.createdDate,
    this.modifiedDate,
    this.profileUrl,
    this.profileName,
    this.status,
    this.countryCode,
  });

  factory LoginCustomerData.fromJson(Map<String, dynamic> json) =>
      LoginCustomerData(
        id: json["id"],
        userId: json["userId"],
        caId: json["caId"],
        caName: json["caName"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        address: json["address"],
        mobile: json["mobile"],
        phone: json["phone"],
        panCardNumber: json["panCardNumber"],
        aadhaarCardNumber: json["aadhaarCardNumber"],
        gender: json["gender"],
        userResponse: json["userResponse"],
        createdDate: json["createdDate"],
        modifiedDate: json["modifiedDate"],
        profileUrl: json["profileUrl"],
        profileName: json["profileName"],
        status: json["status"],
        countryCode: json["countryCode"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "caId": caId,
        "caName": caName,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "address": address,
        "mobile": mobile,
        "phone": phone,
        "panCardNumber": panCardNumber,
        "aadhaarCardNumber": aadhaarCardNumber,
        "gender": gender,
        "userResponse": userResponse,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "profileUrl": profileUrl,
        "profileName": profileName,
        "status": status,
        "countryCode": countryCode,
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
