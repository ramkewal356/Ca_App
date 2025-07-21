// To parse this JSON data, do
//
//     final createNewServiceModel = createNewServiceModelFromJson(jsonString);

import 'dart:convert';

CreateNewServiceModel createNewServiceModelFromJson(String str) =>
    CreateNewServiceModel.fromJson(json.decode(str));

String createNewServiceModelToJson(CreateNewServiceModel data) =>
    json.encode(data.toJson());

class CreateNewServiceModel {
  Status? status;
  Data? data;

  CreateNewServiceModel({
    this.status,
    this.data,
  });

  factory CreateNewServiceModel.fromJson(Map<String, dynamic> json) =>
      CreateNewServiceModel(
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
  String? serviceName;
  String? serviceDesc;
  String? subService;
  int? caId;
  bool? status;
  int? createdDate;
  int? modifiedDate;
  String? serviceResponse;
  dynamic comment;

  Data({
    this.id,
    this.serviceName,
    this.serviceDesc,
    this.subService,
    this.caId,
    this.status,
    this.createdDate,
    this.modifiedDate,
    this.serviceResponse,
    this.comment,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        serviceName: json["serviceName"],
        serviceDesc: json["serviceDesc"],
        subService: json["subService"],
        caId: json["caId"],
        status: json["status"],
        createdDate: json["createdDate"],
        modifiedDate: json["modifiedDate"],
        serviceResponse: json["serviceResponse"],
        comment: json["comment"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "serviceName": serviceName,
        "serviceDesc": serviceDesc,
        "subService": subService,
        "caId": caId,
        "status": status,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "serviceResponse": serviceResponse,
        "comment": comment,
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
