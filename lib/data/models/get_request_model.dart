// To parse this JSON data, do
//
//     final getRequestBySenderIdModel = getRequestBySenderIdModelFromJson(jsonString);

import 'dart:convert';

GetRequestModel getRequestBySenderIdModelFromJson(String str) =>
    GetRequestModel.fromJson(json.decode(str));

String getRequestBySenderIdModelToJson(GetRequestModel data) =>
    json.encode(data.toJson());

class GetRequestModel {
  Status? status;
  List<RequestData>? data;

  GetRequestModel({
    this.status,
    this.data,
  });

  factory GetRequestModel.fromJson(Map<String, dynamic> json) =>
      GetRequestModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null
            ? []
            : List<RequestData>.from(
                json["data"]!.map((x) => RequestData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class RequestData {
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

  RequestData({
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
  });

  factory RequestData.fromJson(Map<String, dynamic> json) => RequestData(
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
