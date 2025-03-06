// To parse this JSON data, do
//
//     final addServiceModel = addServiceModelFromJson(jsonString);

import 'dart:convert';

AddServiceModel addServiceModelFromJson(String str) =>
    AddServiceModel.fromJson(json.decode(str));

String addServiceModelToJson(AddServiceModel data) =>
    json.encode(data.toJson());

class AddServiceModel {
  Status? status;
  Data? data;

  AddServiceModel({
    this.status,
    this.data,
  });

  factory AddServiceModel.fromJson(Map<String, dynamic> json) =>
      AddServiceModel(
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
  int? serviceId;
  String? serviceName;
  String? serviceDesc;
  String? subService;
  int? caId;
  int? createdDate;
  int? modifiedDate;

  Data({
    this.id,
    this.serviceId,
    this.serviceName,
    this.serviceDesc,
    this.subService,
    this.caId,
    this.createdDate,
    this.modifiedDate,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        serviceId: json["serviceId"],
        serviceName: json["serviceName"],
        serviceDesc: json["serviceDesc"],
        subService: json["subService"],
        caId: json["caId"],
        createdDate: json["createdDate"],
        modifiedDate: json["modifiedDate"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "serviceId": serviceId,
        "serviceName": serviceName,
        "serviceDesc": serviceDesc,
        "subService": subService,
        "caId": caId,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
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
