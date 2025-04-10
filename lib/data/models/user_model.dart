// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  Status? status;
  Data? data;

  UserModel({
    this.status,
    this.data,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
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
  dynamic address;
  String? mobile;
  dynamic phone;
  String? role;
  String? otp;
  bool? otpVerify;
  bool? status;
  int? createdDate;
  int? modifiedDate;
  dynamic profileUrl;
  dynamic profileName;
  dynamic gender;
  String? panCardNumber;
  dynamic aadhaarCardNumber;
  String? userResponse;
  String? countryCode;
  dynamic token;
  String? caEmail;
  int? caId;
  String? caName;
  String? caMobile;
  String? designation;
  List<Permission>? permissions;
  String? companyName;
  String? gst;
  dynamic companyLogo;
  List<Service>? services;

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
    this.caMobile,
    this.designation,
    this.permissions,
    this.companyName,
    this.gst,
    this.companyLogo,
    this.services,
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
        caMobile: json["caMobile"],
        designation: json["designation"],
        permissions: json["permissions"] == null
            ? []
            : List<Permission>.from(
                json["permissions"]!.map((x) => Permission.fromJson(x))),
        companyName: json["companyName"],
        gst: json["gst"],
        companyLogo: json["companyLogo"],
        services: json["services"] == null
            ? []
            : List<Service>.from(
                json["services"]!.map((x) => Service.fromJson(x))),
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
        "caMobile": caMobile,
        "designation": designation,
        "permissions": permissions == null
            ? []
            : List<dynamic>.from(permissions!.map((x) => x.toJson())),
        "companyName": companyName,
        "gst": gst,
        "companyLogo": companyLogo,
        "services": services == null
            ? []
            : List<dynamic>.from(services!.map((x) => x.toJson())),
      };
}

class Permission {
  int? id;
  String? permissionName;
  String? type;

  Permission({
    this.id,
    this.permissionName,
    this.type,
  });

  factory Permission.fromJson(Map<String, dynamic> json) => Permission(
        id: json["id"],
        permissionName: json["permissionName"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "permissionName": permissionName,
        "type": type,
      };
}

class Service {
  int? serviceId;
  String? serviceName;
  String? serviceDesc;
  String? subService;

  Service({
    this.serviceId,
    this.serviceName,
    this.serviceDesc,
    this.subService,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        serviceId: json["serviceId"],
        serviceName: json["serviceName"],
        serviceDesc: json["serviceDesc"],
        subService: json["subService"],
      );

  Map<String, dynamic> toJson() => {
        "serviceId": serviceId,
        "serviceName": serviceName,
        "serviceDesc": serviceDesc,
        "subService": subService,
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
