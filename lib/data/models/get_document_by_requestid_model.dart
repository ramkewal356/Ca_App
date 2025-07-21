// To parse this JSON data, do
//
//     final getDocumentByRequestIdModel = getDocumentByRequestIdModelFromJson(jsonString);

import 'dart:convert';

GetDocumentByRequestIdModel getDocumentByRequestIdModelFromJson(String str) =>
    GetDocumentByRequestIdModel.fromJson(json.decode(str));

String getDocumentByRequestIdModelToJson(GetDocumentByRequestIdModel data) =>
    json.encode(data.toJson());

class GetDocumentByRequestIdModel {
  Status? status;
  Data? data;

  GetDocumentByRequestIdModel({
    this.status,
    this.data,
  });

  factory GetDocumentByRequestIdModel.fromJson(Map<String, dynamic> json) =>
      GetDocumentByRequestIdModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
  RequestResponse? requestResponse;
  List<RequestDocument>? requestDocuments;

  Data({
    this.requestResponse,
    this.requestDocuments,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        requestResponse: json["requestResponse"] == null
            ? null
            : RequestResponse.fromJson(json["requestResponse"]),
        requestDocuments: json["requestDocuments"] == null
            ? []
            : List<RequestDocument>.from(json["requestDocuments"]!
                .map((x) => RequestDocument.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "requestResponse": requestResponse?.toJson(),
        "requestDocuments": requestDocuments == null
            ? []
            : List<dynamic>.from(requestDocuments!.map((x) => x.toJson())),
      };
}

class RequestDocument {
  int? id;
  int? requestId;
  String? docName;
  String? docUrl;
  int? createdDate;
  int? modifiedDate;
  bool? status;

  RequestDocument({
    this.id,
    this.requestId,
    this.docName,
    this.docUrl,
    this.createdDate,
    this.modifiedDate,
    this.status,
  });

  factory RequestDocument.fromJson(Map<String, dynamic> json) =>
      RequestDocument(
        id: json["id"],
        requestId: json["requestId"],
        docName: json["docName"],
        docUrl: json["docUrl"],
        createdDate: json["createdDate"],
        modifiedDate: json["modifiedDate"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "requestId": requestId,
        "docName": docName,
        "docUrl": docUrl,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "status": status,
      };
}

class RequestResponse {
  int? requestId;
  String? text;
  int? senderId;
  String? senderName;
  int? receiverId;
  String? receiverName;
  int? createdDate;
  int? modifiedDate;
  bool? isResolved;
  bool? requestStatus;
  String? readStatus;
  RequestResponse({
    this.requestId,
    this.text,
    this.senderId,
    this.senderName,
    this.receiverId,
    this.receiverName,
    this.createdDate,
    this.modifiedDate,
    this.isResolved,
    this.requestStatus,
      this.readStatus
  });

  factory RequestResponse.fromJson(Map<String, dynamic> json) =>
      RequestResponse(
        requestId: json["requestId"],
        text: json["text"],
        senderId: json["senderId"],
        senderName: json["senderName"],
        receiverId: json["receiverId"],
        receiverName: json["receiverName"],
        createdDate: json["createdDate"],
        modifiedDate: json["modifiedDate"],
        isResolved: json["isResolved"],
        requestStatus: json["requestStatus"],
          readStatus: json["readStatus"]
      );

  Map<String, dynamic> toJson() => {
        "requestId": requestId,
        "text": text,
        "senderId": senderId,
        "senderName": senderName,
        "receiverId": receiverId,
        "receiverName": receiverName,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "isResolved": isResolved,
        "requestStatus": requestStatus,
        "readStatus": readStatus
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
