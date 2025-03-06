// To parse this JSON data, do
//
//     final getServiceAndSubServiceListModel = getServiceAndSubServiceListModelFromJson(jsonString);

import 'dart:convert';

GetServiceAndSubServiceListModel getServiceAndSubServiceListModelFromJson(
        String str) =>
    GetServiceAndSubServiceListModel.fromJson(json.decode(str));

String getServiceAndSubServiceListModelToJson(
        GetServiceAndSubServiceListModel data) =>
    json.encode(data.toJson());

class GetServiceAndSubServiceListModel {
  Status? status;
  List<ServiceAndSubServiceListData>? data;

  GetServiceAndSubServiceListModel({
    this.status,
    this.data,
  });

  factory GetServiceAndSubServiceListModel.fromJson(
          Map<String, dynamic> json) =>
      GetServiceAndSubServiceListModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null
            ? []
            : List<ServiceAndSubServiceListData>.from(json["data"]!
                .map((x) => ServiceAndSubServiceListData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ServiceAndSubServiceListData {
  int? id;
  String? serviceName;
  String? serviceDesc;
  String? subService;
  int? adminId;
  bool? serviceStatus;
  int? createdDate;
  int? modifiedDate;

  ServiceAndSubServiceListData({
    this.id,
    this.serviceName,
    this.serviceDesc,
    this.subService,
    this.adminId,
    this.serviceStatus,
    this.createdDate,
    this.modifiedDate,
  });

  factory ServiceAndSubServiceListData.fromJson(Map<String, dynamic> json) =>
      ServiceAndSubServiceListData(
        id: json["id"],
        serviceName: json["serviceName"],
        serviceDesc: json["serviceDesc"],
        subService: json["subService"],
        adminId: json["adminId"],
        serviceStatus: json["serviceStatus"],
        createdDate: json["createdDate"],
        modifiedDate: json["modifiedDate"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "serviceName": serviceName,
        "serviceDesc": serviceDesc,
        "subService": subService,
        "adminId": adminId,
        "serviceStatus": serviceStatus,
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
