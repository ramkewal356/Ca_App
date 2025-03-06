// To parse this JSON data, do
//
//     final getServicesListModel = getServicesListModelFromJson(jsonString);

import 'dart:convert';

GetServicesListModel getServicesListModelFromJson(String str) =>
    GetServicesListModel.fromJson(json.decode(str));

String getServicesListModelToJson(GetServicesListModel data) =>
    json.encode(data.toJson());

class GetServicesListModel {
  Status? status;
  List<ServicesListData>? data;

  GetServicesListModel({
    this.status,
    this.data,
  });

  factory GetServicesListModel.fromJson(Map<String, dynamic> json) =>
      GetServicesListModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null
            ? []
            : List<ServicesListData>.from(
                json["data"]!.map((x) => ServicesListData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ServicesListData {
  int? id;
  int? serviceId;
  String? serviceName;
  String? serviceDesc;
  String? subService;
  int? caId;
  int? createdDate;
  int? modifiedDate;

  ServicesListData({
    this.id,
    this.serviceId,
    this.serviceName,
    this.serviceDesc,
    this.subService,
    this.caId,
    this.createdDate,
    this.modifiedDate,
  });

  factory ServicesListData.fromJson(Map<String, dynamic> json) =>
      ServicesListData(
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
