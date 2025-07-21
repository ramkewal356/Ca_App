// To parse this JSON data, do
//
//     final getViewServiceModel = getViewServiceModelFromJson(jsonString);

import 'dart:convert';

GetViewServiceModel getViewServiceModelFromJson(String str) =>
    GetViewServiceModel.fromJson(json.decode(str));

String getViewServiceModelToJson(GetViewServiceModel data) =>
    json.encode(data.toJson());

class GetViewServiceModel {
  Status? status;
  Data? data;

  GetViewServiceModel({
    this.status,
    this.data,
  });

  factory GetViewServiceModel.fromJson(Map<String, dynamic> json) =>
      GetViewServiceModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
  List<ViewServiceData>? content;
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
            : List<ViewServiceData>.from(
                json["content"]!.map((x) => ViewServiceData.fromJson(x))),
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

class ViewServiceData {
  int? id;
  String? serviceName;
  String? serviceDesc;
  String? subService;
  int? caId;
  bool? status;
  int? createdDate;
  int? modifiedDate;
  String? serviceResponse;
  dynamic comment;

  ViewServiceData({
    this.id,
    this.serviceName,
    this.serviceDesc,
    this.subService,
    this.caId,
    this.status,
    this.createdDate,
    this.modifiedDate,
    this.serviceResponse,
    this.comment,
  });

  factory ViewServiceData.fromJson(Map<String, dynamic> json) =>
      ViewServiceData(
        id: json["id"],
        serviceName: json["serviceName"],
        serviceDesc: json["serviceDesc"],
        subService: json["subService"],
        caId: json["caId"],
        status: json["status"],
        createdDate: json["createdDate"],
        modifiedDate: json["modifiedDate"],
        serviceResponse: json["serviceResponse"],
        comment: json["comment"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "serviceName": serviceName,
        "serviceDesc": serviceDesc,
        "subService": subService,
        "caId": caId,
        "status": status,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "serviceResponse": serviceResponse,
        "comment": comment,
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
