// To parse this JSON data, do
//
//     final getCustomerBySubCaIdModel = getCustomerBySubCaIdModelFromJson(jsonString);

import 'dart:convert';

GetCustomerBySubCaIdModel getCustomerBySubCaIdModelFromJson(String str) =>
    GetCustomerBySubCaIdModel.fromJson(json.decode(str));

String getCustomerBySubCaIdModelToJson(GetCustomerBySubCaIdModel data) =>
    json.encode(data.toJson());

class GetCustomerBySubCaIdModel {
  Status? status;
  List<Datum>? data;

  GetCustomerBySubCaIdModel({
    this.status,
    this.data,
  });

  factory GetCustomerBySubCaIdModel.fromJson(Map<String, dynamic> json) =>
      GetCustomerBySubCaIdModel(
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
  int? caId;
  String? caName;
  String? firstName;
  String? lastName;
  String? email;
  dynamic address;
  String? mobile;
  dynamic phone;
  dynamic panCardNumber;
  dynamic aadhaarCardNumber;
  String? gender;
  String? userResponse;
  int? createdDate;
  int? modifiedDate;
  String? profileUrl;
  String? profileName;
  bool? status;
  String? countryCode;

  Datum({
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

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
