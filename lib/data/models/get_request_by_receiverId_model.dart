// To parse this JSON data, do
//
//     final getRequestByReceiverIdModel = getRequestByReceiverIdModelFromJson(jsonString);

import 'dart:convert';

GetRequestByReceiverIdModel getRequestByReceiverIdModelFromJson(String str) =>
    GetRequestByReceiverIdModel.fromJson(json.decode(str));

String getRequestByReceiverIdModelToJson(GetRequestByReceiverIdModel data) =>
    json.encode(data.toJson());

class GetRequestByReceiverIdModel {
  Status? status;
  List<GetRequestData>? data;

  GetRequestByReceiverIdModel({
    this.status,
    this.data,
  });

  factory GetRequestByReceiverIdModel.fromJson(Map<String, dynamic> json) =>
      GetRequestByReceiverIdModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null
            ? []
            : List<GetRequestData>.from(
                json["data"]!.map((x) => GetRequestData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class GetRequestData {
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
  String? requestDocumentStatus;

  GetRequestData({
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
    this.requestDocumentStatus,
  });

  factory GetRequestData.fromJson(Map<String, dynamic> json) => GetRequestData(
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
        requestDocumentStatus: json["requestDocumentStatus"],
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
        "requestDocumentStatus": requestDocumentStatus,
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
