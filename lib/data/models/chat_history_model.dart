// To parse this JSON data, do
//
//     final chatHistoryModel = chatHistoryModelFromJson(jsonString);

import 'dart:convert';

ChatHistoryModel chatHistoryModelFromJson(String str) =>
    ChatHistoryModel.fromJson(json.decode(str));

String chatHistoryModelToJson(ChatHistoryModel data) =>
    json.encode(data.toJson());

class ChatHistoryModel {
  Status? status;
  Data? data;

  ChatHistoryModel({
    this.status,
    this.data,
  });

  factory ChatHistoryModel.fromJson(Map<String, dynamic> json) =>
      ChatHistoryModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
  bool? receiverOnline;
  List<Messages>? messages;

  Data({
    this.receiverOnline,
    this.messages,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        receiverOnline: json["receiverOnline"],
        messages: json["messages"] == null
            ? []
            : List<Messages>.from(
                json["messages"]!.map((x) => Messages.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "receiverOnline": receiverOnline,
        "messages": messages == null
            ? []
            : List<dynamic>.from(messages!.map((x) => x.toJson())),
      };
}

class Messages {
  String? message;
  int? timestamp;
  int? messageId;
  bool? isForwarded;
  dynamic forwardedFromUserName;
  dynamic replyToMessageId;
  int? receiverId;
  int? senderId;
  dynamic editedAt;
  bool? isRead;
  bool? isEdited;
  dynamic replyToMessageText;

  Messages({
    this.message,
    this.timestamp,
    this.messageId,
    this.isForwarded,
    this.forwardedFromUserName,
    this.replyToMessageId,
    this.receiverId,
    this.senderId,
    this.editedAt,
    this.isRead,
    this.isEdited,
    this.replyToMessageText,
  });

  factory Messages.fromJson(Map<String, dynamic> json) => Messages(
        message: json["message"],
        timestamp: json["timestamp"],
        messageId: json["messageId"],
        isForwarded: json["isForwarded"],
        forwardedFromUserName: json["forwardedFromUserName"],
        replyToMessageId: json["replyToMessageId"],
        receiverId: json["receiverId"],
        senderId: json["senderId"],
        editedAt: json["editedAt"],
        isRead: json["isRead"],
        isEdited: json["isEdited"],
        replyToMessageText: json["replyToMessageText"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "timestamp": timestamp,
        "messageId": messageId,
        "isForwarded": isForwarded,
        "forwardedFromUserName": forwardedFromUserName,
        "replyToMessageId": replyToMessageId,
        "receiverId": receiverId,
        "senderId": senderId,
        "editedAt": editedAt,
        "isRead": isRead,
        "isEdited": isEdited,
        "replyToMessageText": replyToMessageText,
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
