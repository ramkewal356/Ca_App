// To parse this JSON data, do
//
//     final getCaByServiceNameModel = getCaByServiceNameModelFromJson(jsonString);

import 'dart:convert';

GetCaByServiceNameModel getCaByServiceNameModelFromJson(String str) =>
    GetCaByServiceNameModel.fromJson(json.decode(str));

String getCaByServiceNameModelToJson(GetCaByServiceNameModel data) =>
    json.encode(data.toJson());

class GetCaByServiceNameModel {
  Status? status;
  Data? data;

  GetCaByServiceNameModel({
    this.status,
    this.data,
  });

  factory GetCaByServiceNameModel.fromJson(Map<String, dynamic> json) =>
      GetCaByServiceNameModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
  int? serviceId;
  String? serviceName;
  String? serviceDesc;
  String? subService;
  int? totalItems;
  int? pageNumber;
  int? pageSize;
  int? totalPages;
  List<CaList>? caList;

  Data({
    this.serviceId,
    this.serviceName,
    this.serviceDesc,
    this.subService,
    this.totalItems,
    this.pageNumber,
    this.pageSize,
    this.totalPages,
    this.caList,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        serviceId: json["serviceId"],
        serviceName: json["serviceName"],
        serviceDesc: json["serviceDesc"],
        subService: json["subService"],
        totalItems: json["totalItems"],
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        totalPages: json["totalPages"],
        caList: json["caList"] == null
            ? []
            : List<CaList>.from(json["caList"]!.map((x) => CaList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "serviceId": serviceId,
        "serviceName": serviceName,
        "serviceDesc": serviceDesc,
        "subService": subService,
        "totalItems": totalItems,
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "totalPages": totalPages,
        "caList": caList == null
            ? []
            : List<dynamic>.from(caList!.map((x) => x.toJson())),
      };
}

class CaList {
  int? caId;
  String? fullName;
  String? email;
  String? mobile;
  String? companyName;
  String? countryCode;
  String? profileUrl;
  DateTime? lastLogin;
  dynamic lastLogout;
  bool? isOnline;
  String? address;
  String? firmAddress;
  String? professionalTitle;
  CaList(
      {this.caId,
      this.fullName,
      this.email,
      this.mobile,
      this.companyName,
      this.countryCode,
      this.profileUrl,
      this.lastLogin,
      this.lastLogout,
      this.isOnline,
      this.address,
      this.firmAddress,
      this.professionalTitle});

  factory CaList.fromJson(Map<String, dynamic> json) => CaList(
      caId: json["caId"],
      fullName: json["fullName"],
      email: json["email"],
      mobile: json["mobile"],
      companyName: json["companyName"],
      countryCode: json["countryCode"],
      profileUrl: json["profileUrl"],
      lastLogin:
          json["lastLogin"] == null ? null : DateTime.parse(json["lastLogin"]),
      lastLogout: json["lastLogout"],
      isOnline: json["isOnline"],
      address: json["address"],
      firmAddress: json["firmAddress"],
      professionalTitle: json["professionalTitle"]
      );

  Map<String, dynamic> toJson() => {
        "caId": caId,
        "fullName": fullName,
        "email": email,
        "mobile": mobile,
        "companyName": companyName,
        "countryCode": countryCode,
        "profileUrl": profileUrl,
        "lastLogin": lastLogin?.toIso8601String(),
        "lastLogout": lastLogout,
        "isOnline": isOnline,
        "address": address,
        "firmAddress": firmAddress,
        "professionalTitle": professionalTitle
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
