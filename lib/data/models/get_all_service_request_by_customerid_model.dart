// To parse this JSON data, do
//
//     final getAllServiceRequestByCustomerIdModel = getAllServiceRequestByCustomerIdModelFromJson(jsonString);

import 'dart:convert';

GetAllServiceRequestByCustomerIdModel
    getAllServiceRequestByCustomerIdModelFromJson(String str) =>
        GetAllServiceRequestByCustomerIdModel.fromJson(json.decode(str));

String getAllServiceRequestByCustomerIdModelToJson(
        GetAllServiceRequestByCustomerIdModel data) =>
    json.encode(data.toJson());

class GetAllServiceRequestByCustomerIdModel {
  Status? status;
  Data? data;

  GetAllServiceRequestByCustomerIdModel({
    this.status,
    this.data,
  });

  factory GetAllServiceRequestByCustomerIdModel.fromJson(
          Map<String, dynamic> json) =>
      GetAllServiceRequestByCustomerIdModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
  List<RequestCaContent>? content;
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
            : List<RequestCaContent>.from(
                json["content"]!.map((x) => RequestCaContent.fromJson(x))),
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

class RequestCaContent {
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
  String? orderStatus;
  int? createdDate;

  RequestCaContent({
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
    this.orderStatus,
    this.createdDate,
  });

  factory RequestCaContent.fromJson(Map<String, dynamic> json) =>
      RequestCaContent(
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
        orderStatus: json["orderStatus"],
        createdDate: json["createdDate"],
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
        "orderStatus": orderStatus,
        "createdDate": createdDate,
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
