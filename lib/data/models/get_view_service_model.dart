// To parse this JSON data, do
//
//     final getViewServiceModel = getViewServiceModelFromJson(jsonString);

import 'dart:convert';

GetViewServiceModel getViewServiceModelFromJson(String str) =>
    GetViewServiceModel.fromJson(json.decode(str));

String getViewServiceModelToJson(GetViewServiceModel data) =>
    json.encode(data.toJson());

class GetViewServiceModel {
  Status? status;
  List<ViewServiceData>? data;

  GetViewServiceModel({
    this.status,
    this.data,
  });

  factory GetViewServiceModel.fromJson(Map<String, dynamic> json) =>
      GetViewServiceModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null
            ? []
            : List<ViewServiceData>.from(
                json["data"]!.map((x) => ViewServiceData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ViewServiceData {
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

  ViewServiceData({
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

  factory ViewServiceData.fromJson(Map<String, dynamic> json) =>
      ViewServiceData(
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
