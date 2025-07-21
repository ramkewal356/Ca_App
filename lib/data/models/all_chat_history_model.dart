// To parse this JSON data, do
//
//     final allChatHistoryModel = allChatHistoryModelFromJson(jsonString);

import 'dart:convert';

AllChatHistoryModel allChatHistoryModelFromJson(String str) =>
    AllChatHistoryModel.fromJson(json.decode(str));

String allChatHistoryModelToJson(AllChatHistoryModel data) =>
    json.encode(data.toJson());

class AllChatHistoryModel {
  Status? status;
  List<AllChatData>? data;

  AllChatHistoryModel({
    this.status,
    this.data,
  });

  factory AllChatHistoryModel.fromJson(Map<String, dynamic> json) =>
      AllChatHistoryModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null
            ? []
            : List<AllChatData>.from(
                json["data"]!.map((x) => AllChatData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class AllChatData {
  int? userId;
  String? fullName;
  String? lastMessage;
  int? lastMessageTime;
  String? profileUrl;
  int? unreadCount;

  AllChatData({
    this.userId,
    this.fullName,
    this.lastMessage,
    this.lastMessageTime,
    this.profileUrl,
    this.unreadCount,
  });

  factory AllChatData.fromJson(Map<String, dynamic> json) => AllChatData(
        userId: json["userId"],
        fullName: json["fullName"],
        lastMessage: json["lastMessage"],
        lastMessageTime: json["lastMessageTime"],
        profileUrl: json["profileUrl"],
        unreadCount: json["unreadCount"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "fullName": fullName,
        "lastMessage": lastMessage,
        "lastMessageTime": lastMessageTime,
        "profileUrl": profileUrl,
        "unreadCount": unreadCount,
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
