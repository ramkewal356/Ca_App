// To parse this JSON data, do
//
//     final getActiveCaWithServicesModel = getActiveCaWithServicesModelFromJson(jsonString);

import 'dart:convert';

GetActiveCaWithServicesModel getActiveCaWithServicesModelFromJson(String str) =>
    GetActiveCaWithServicesModel.fromJson(json.decode(str));

String getActiveCaWithServicesModelToJson(GetActiveCaWithServicesModel data) =>
    json.encode(data.toJson());

class GetActiveCaWithServicesModel {
  Status? status;
  Data? data;

  GetActiveCaWithServicesModel({
    this.status,
    this.data,
  });

  factory GetActiveCaWithServicesModel.fromJson(Map<String, dynamic> json) =>
      GetActiveCaWithServicesModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
  List<Content>? content;
  Pageable? pageable;
  int? totalPages;
  int? totalElements;
  bool? last;
  int? size;
  int? number;
  Sort? sort;
  int? numberOfElements;
  bool? first;
  bool? empty;

  Data({
    this.content,
    this.pageable,
    this.totalPages,
    this.totalElements,
    this.last,
    this.size,
    this.number,
    this.sort,
    this.numberOfElements,
    this.first,
    this.empty,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        content: json["content"] == null
            ? []
            : List<Content>.from(
                json["content"]!.map((x) => Content.fromJson(x))),
        pageable: json["pageable"] == null
            ? null
            : Pageable.fromJson(json["pageable"]),
        totalPages: json["totalPages"],
        totalElements: json["totalElements"],
        last: json["last"],
        size: json["size"],
        number: json["number"],
        sort: json["sort"] == null ? null : Sort.fromJson(json["sort"]),
        numberOfElements: json["numberOfElements"],
        first: json["first"],
        empty: json["empty"],
      );

  Map<String, dynamic> toJson() => {
        "content": content == null
            ? []
            : List<dynamic>.from(content!.map((x) => x.toJson())),
        "pageable": pageable?.toJson(),
        "totalPages": totalPages,
        "totalElements": totalElements,
        "last": last,
        "size": size,
        "number": number,
        "sort": sort?.toJson(),
        "numberOfElements": numberOfElements,
        "first": first,
        "empty": empty,
      };
}

class Content {
  int? userId;
  String? firstName;
  String? lastName;
  String? email;
  String? address;
  String? mobile;
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
  String? panCardNumber;
  dynamic aadhaarCardNumber;
  String? userResponse;
  String? countryCode;
  dynamic reason;
  dynamic lastDeactivatedAt;
  bool? isOnline;
  Content({
    this.userId,
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
    this.reason,
    this.lastDeactivatedAt,
      this.isOnline
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        userId: json["userId"],
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
        reason: json["reason"],
        lastDeactivatedAt: json["lastDeactivatedAt"],
      isOnline: json["isOnline"]
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
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
        "reason": reason,
        "lastDeactivatedAt": lastDeactivatedAt,
        "isOnline": isOnline
      };
}

class Pageable {
  Sort? sort;
  int? offset;
  int? pageNumber;
  int? pageSize;
  bool? paged;
  bool? unpaged;

  Pageable({
    this.sort,
    this.offset,
    this.pageNumber,
    this.pageSize,
    this.paged,
    this.unpaged,
  });

  factory Pageable.fromJson(Map<String, dynamic> json) => Pageable(
        sort: json["sort"] == null ? null : Sort.fromJson(json["sort"]),
        offset: json["offset"],
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        paged: json["paged"],
        unpaged: json["unpaged"],
      );

  Map<String, dynamic> toJson() => {
        "sort": sort?.toJson(),
        "offset": offset,
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "paged": paged,
        "unpaged": unpaged,
      };
}

class Sort {
  bool? empty;
  bool? sorted;
  bool? unsorted;

  Sort({
    this.empty,
    this.sorted,
    this.unsorted,
  });

  factory Sort.fromJson(Map<String, dynamic> json) => Sort(
        empty: json["empty"],
        sorted: json["sorted"],
        unsorted: json["unsorted"],
      );

  Map<String, dynamic> toJson() => {
        "empty": empty,
        "sorted": sorted,
        "unsorted": unsorted,
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
