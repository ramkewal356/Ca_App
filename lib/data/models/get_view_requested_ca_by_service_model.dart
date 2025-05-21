// To parse this JSON data, do
//
//     final getViewRequestedCaByServiceIdModel = getViewRequestedCaByServiceIdModelFromJson(jsonString);

import 'dart:convert';

GetViewRequestedCaByServiceIdModel getViewRequestedCaByServiceIdModelFromJson(
        String str) =>
    GetViewRequestedCaByServiceIdModel.fromJson(json.decode(str));

String getViewRequestedCaByServiceIdModelToJson(
        GetViewRequestedCaByServiceIdModel data) =>
    json.encode(data.toJson());

class GetViewRequestedCaByServiceIdModel {
  Status? status;
  Data? data;

  GetViewRequestedCaByServiceIdModel({
    this.status,
    this.data,
  });

  factory GetViewRequestedCaByServiceIdModel.fromJson(
          Map<String, dynamic> json) =>
      GetViewRequestedCaByServiceIdModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
  int? serviceOrderId;
  int? serviceId;
  String? serviceName;
  String? serviceDesc;
  String? subService;
  int? caId;
  String? caName;
  String? caEmail;
  String? caMobile;
  String? caCompanyName;
  String? caCountryCode;
  int? customerId;
  String? customerName;
  String? customerEmail;
  String? customerMobile;
  String? orderStatus;
  int? createdDate;
  dynamic rejectionComment;

  Data({
    this.serviceOrderId,
    this.serviceId,
    this.serviceName,
    this.serviceDesc,
    this.subService,
    this.caId,
    this.caName,
    this.caEmail,
    this.caMobile,
    this.caCompanyName,
    this.caCountryCode,
    this.customerId,
    this.customerName,
    this.customerEmail,
    this.customerMobile,
    this.orderStatus,
    this.createdDate,
    this.rejectionComment,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        serviceOrderId: json["serviceOrderId"],
        serviceId: json["serviceId"],
        serviceName: json["serviceName"],
        serviceDesc: json["serviceDesc"],
        subService: json["subService"],
        caId: json["caId"],
        caName: json["caName"],
        caEmail: json["caEmail"],
        caMobile: json["caMobile"],
        caCompanyName: json["caCompanyName"],
        caCountryCode: json["caCountryCode"],
        customerId: json["customerId"],
        customerName: json["customerName"],
        customerEmail: json["customerEmail"],
        customerMobile: json["customerMobile"],
        orderStatus: json["orderStatus"],
        createdDate: json["createdDate"],
        rejectionComment: json["rejectionComment"],
      );

  Map<String, dynamic> toJson() => {
        "serviceOrderId": serviceOrderId,
        "serviceId": serviceId,
        "serviceName": serviceName,
        "serviceDesc": serviceDesc,
        "subService": subService,
        "caId": caId,
        "caName": caName,
        "caEmail": caEmail,
        "caMobile": caMobile,
        "caCompanyName": caCompanyName,
        "caCountryCode": caCountryCode,
        "customerId": customerId,
        "customerName": customerName,
        "customerEmail": customerEmail,
        "customerMobile": customerMobile,
        "orderStatus": orderStatus,
        "createdDate": createdDate,
        "rejectionComment": rejectionComment,
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
