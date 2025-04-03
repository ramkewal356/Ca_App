// To parse this JSON data, do
//
//     final getDocumentByUserIdModel = getDocumentByUserIdModelFromJson(jsonString);

import 'dart:convert';

GetDocumentByUserIdModel getDocumentByUserIdModelFromJson(String str) =>
    GetDocumentByUserIdModel.fromJson(json.decode(str));

String getDocumentByUserIdModelToJson(GetDocumentByUserIdModel data) =>
    json.encode(data.toJson());

class GetDocumentByUserIdModel {
  Status? status;
  Data? data;

  GetDocumentByUserIdModel({
    this.status,
    this.data,
  });

  factory GetDocumentByUserIdModel.fromJson(Map<String, dynamic> json) =>
      GetDocumentByUserIdModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
  List<ViewDocument>? content;
  Pageable? pageable;
  int? totalElements;
  int? totalPages;
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
    this.totalElements,
    this.totalPages,
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
            : List<ViewDocument>.from(
                json["content"]!.map((x) => ViewDocument.fromJson(x))),
        pageable: json["pageable"] == null
            ? null
            : Pageable.fromJson(json["pageable"]),
        totalElements: json["totalElements"],
        totalPages: json["totalPages"],
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
        "totalElements": totalElements,
        "totalPages": totalPages,
        "last": last,
        "size": size,
        "number": number,
        "sort": sort?.toJson(),
        "numberOfElements": numberOfElements,
        "first": first,
        "empty": empty,
      };
}

class ViewDocument {
  int? docId;
  String? docName;
  int? userId;
  String? docUrl;
  dynamic serviceId;
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

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
