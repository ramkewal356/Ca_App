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
  Data? data;

  GetRequestByReceiverIdModel({
    this.status,
    this.data,
  });

  factory GetRequestByReceiverIdModel.fromJson(Map<String, dynamic> json) =>
      GetRequestByReceiverIdModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
  List<GetRequestData>? content;
  Pageable? pageable;
  int? totalPages;
  int? totalElements;
  bool? last;
  int? size;
  int? number;
  Sort? sort;
  int? numberOfElements;
  bool? first;
  bool? empty;

  Data({
    this.content,
    this.pageable,
    this.totalPages,
    this.totalElements,
    this.last,
    this.size,
    this.number,
    this.sort,
    this.numberOfElements,
    this.first,
    this.empty,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        content: json["content"] == null
            ? []
            : List<GetRequestData>.from(
                json["content"]!.map((x) => GetRequestData.fromJson(x))),
        pageable: json["pageable"] == null
            ? null
            : Pageable.fromJson(json["pageable"]),
        totalPages: json["totalPages"],
        totalElements: json["totalElements"],
        last: json["last"],
        size: json["size"],
        number: json["number"],
        sort: json["sort"] == null ? null : Sort.fromJson(json["sort"]),
        numberOfElements: json["numberOfElements"],
        first: json["first"],
        empty: json["empty"],
      );

  Map<String, dynamic> toJson() => {
        "content": content == null
            ? []
            : List<dynamic>.from(content!.map((x) => x.toJson())),
        "pageable": pageable?.toJson(),
        "totalPages": totalPages,
        "totalElements": totalElements,
        "last": last,
        "size": size,
        "number": number,
        "sort": sort?.toJson(),
        "numberOfElements": numberOfElements,
        "first": first,
        "empty": empty,
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
  String? readStatus;
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
      this.readStatus
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
        "requestDocumentStatus": requestDocumentStatus,
        "readStatus": readStatus
      };
}

class Pageable {
  Sort? sort;
  int? offset;
  int? pageNumber;
  int? pageSize;
  bool? paged;
  bool? unpaged;

  Pageable({
    this.sort,
    this.offset,
    this.pageNumber,
    this.pageSize,
    this.paged,
    this.unpaged,
  });

  factory Pageable.fromJson(Map<String, dynamic> json) => Pageable(
        sort: json["sort"] == null ? null : Sort.fromJson(json["sort"]),
        offset: json["offset"],
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        paged: json["paged"],
        unpaged: json["unpaged"],
      );

  Map<String, dynamic> toJson() => {
        "sort": sort?.toJson(),
        "offset": offset,
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "paged": paged,
        "unpaged": unpaged,
      };
}

class Sort {
  bool? empty;
  bool? sorted;
  bool? unsorted;

  Sort({
    this.empty,
    this.sorted,
    this.unsorted,
  });

  factory Sort.fromJson(Map<String, dynamic> json) => Sort(
        empty: json["empty"],
        sorted: json["sorted"],
        unsorted: json["unsorted"],
      );

  Map<String, dynamic> toJson() => {
        "empty": empty,
        "sorted": sorted,
        "unsorted": unsorted,
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
