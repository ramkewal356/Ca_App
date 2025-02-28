import 'dart:convert';

GetDocumentByUserIdModel getDocumentByUserIdModelFromJson(String str) =>
    GetDocumentByUserIdModel.fromJson(json.decode(str));

String getDocumentByUserIdModelToJson(GetDocumentByUserIdModel data) =>
    json.encode(data.toJson());

class GetDocumentByUserIdModel {
  Status? status;
  List<ViewDocument>? data;

  GetDocumentByUserIdModel({
    this.status,
    this.data,
  });

  factory GetDocumentByUserIdModel.fromJson(Map<String, dynamic> json) =>
      GetDocumentByUserIdModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null
            ? []
            : List<ViewDocument>.from(
                json["data"]!.map((x) => ViewDocument.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ViewDocument {
  int? docId;
  String? docName;
  int? userId;
  String? docUrl;
  int? serviceId;
  int? createdDate;
  int? modifiedDate;
  String? serviceName;
  String? subService;
  dynamic customerName;
  int? uuid;

  ViewDocument({
    this.docId,
    this.docName,
    this.userId,
    this.docUrl,
    this.serviceId,
    this.createdDate,
    this.modifiedDate,
    this.serviceName,
    this.subService,
    this.customerName,
    this.uuid,
  });

  factory ViewDocument.fromJson(Map<String, dynamic> json) => ViewDocument(
        docId: json["docId"],
        docName: json["docName"],
        userId: json["userId"],
        docUrl: json["docUrl"],
        serviceId: json["serviceId"],
        createdDate: json["createdDate"],
        modifiedDate: json["modifiedDate"],
        serviceName: json["serviceName"],
        subService: json["subService"],
        customerName: json["customerName"],
        uuid: json["uuid"],
      );

  Map<String, dynamic> toJson() => {
        "docId": docId,
        "docName": docName,
        "userId": userId,
        "docUrl": docUrl,
        "serviceId": serviceId,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "serviceName": serviceName,
        "subService": subService,
        "customerName": customerName,
        "uuid": uuid,
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
