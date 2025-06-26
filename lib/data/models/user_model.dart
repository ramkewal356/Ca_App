// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  Status? status;
  Data? data;

  UserModel({
    this.status,
    this.data,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  dynamic address;
  String? mobile;
  dynamic phone;
  String? role;
  String? otp;
  bool? otpVerify;
  bool? status;
  int? createdDate;
  int? modifiedDate;
  dynamic profileUrl;
  dynamic profileName;
  dynamic gender;
  String? panCardNumber;
  dynamic aadhaarCardNumber;
  String? userResponse;
  String? countryCode;
  dynamic token;
  String? caEmail;
  int? caId;
  String? caName;
  String? caMobile;
  String? designation;
  String? lastLogin;
  Permissions? permissions;
  String? companyName;
  String? gst;
  dynamic companyLogo;

  List<Service>? services;
  bool? selfRegistered;
  List<CaEducation>? caEducations;
  List<String>? userCertifications;
  String? about;
  List<String>? specializations;
  String? icaiMembershipId;
  String? registrationNumber;
  String? years;
  String? months;
  String? firmAddress;
  String? professionalTitle;
  bool? isOnline;
  String? occupation;
  String? dateOfBirth;
  String? typeOfBusiness;
  int? profileCompletion;
  Data({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.address,
    this.mobile,
    this.phone,
    this.role,
    this.otp,
    this.otpVerify,
    this.status,
    this.createdDate,
    this.modifiedDate,
    this.profileUrl,
    this.profileName,
    this.gender,
    this.panCardNumber,
    this.aadhaarCardNumber,
    this.userResponse,
    this.countryCode,
    this.token,
    this.caEmail,
    this.caId,
    this.caName,
    this.caMobile,
    this.designation,
    this.lastLogin,
    this.permissions,
    this.companyName,
    this.gst,
    this.companyLogo,
    this.services,
    this.selfRegistered,
      this.caEducations,
      this.userCertifications,
      this.about,
      this.specializations,
      this.icaiMembershipId,
      this.registrationNumber,
      this.years,
      this.months,
      this.firmAddress,
      this.professionalTitle,
      this.isOnline,
      this.occupation,
      this.dateOfBirth,
      this.typeOfBusiness,
      this.profileCompletion
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        address: json["address"],
        mobile: json["mobile"],
        phone: json["phone"],
        role: json["role"],
        otp: json["otp"],
        otpVerify: json["otpVerify"],
        status: json["status"],
        createdDate: json["createdDate"],
        modifiedDate: json["modifiedDate"],
        profileUrl: json["profileUrl"],
        profileName: json["profileName"],
        gender: json["gender"],
        panCardNumber: json["panCardNumber"],
        aadhaarCardNumber: json["aadhaarCardNumber"],
        userResponse: json["userResponse"],
        countryCode: json["countryCode"],
        token: json["token"],
        caEmail: json["caEmail"],
        caId: json["caId"],
        caName: json["caName"],
        caMobile: json["caMobile"],
        designation: json["designation"],
        lastLogin: json["lastLogin"],
        permissions: json["permissions"] == null
            ? null
            : Permissions.fromJson(json["permissions"]),
        companyName: json["companyName"],
        gst: json["gst"],
        companyLogo: json["companyLogo"],
        services: json["services"] == null
            ? []
            : List<Service>.from(
                json["services"]!.map((x) => Service.fromJson(x))),
      selfRegistered: json["selfRegistered"],
      caEducations: json["caEducations"] == null
          ? []
          : List<CaEducation>.from(
              json["caEducations"]!.map((x) => CaEducation.fromJson(x))),
      userCertifications: json["userCertifications"] == null
          ? []
          : List<String>.from(json["userCertifications"]!.map((x) => x)),
      about: json["about"],
      specializations: json["specializations"] == null
          ? []
          : List<String>.from(json["specializations"]!.map((x) => x)),
      icaiMembershipId: json["icaiMembershipId"],
      registrationNumber: json["registrationNumber"],
      years: json["years"],
      months: json["months"],
      firmAddress: json["firmAddress"],
      professionalTitle: json["professionalTitle"],
      isOnline: json["isOnline"],
      occupation: json["occupation"],
      dateOfBirth: json["dateOfBirth"],
      typeOfBusiness: json["typeOfBusiness"],
      profileCompletion: json["profileCompletion"]
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "address": address,
        "mobile": mobile,
        "phone": phone,
        "role": role,
        "otp": otp,
        "otpVerify": otpVerify,
        "status": status,
        "createdDate": createdDate,
        "modifiedDate": modifiedDate,
        "profileUrl": profileUrl,
        "profileName": profileName,
        "gender": gender,
        "panCardNumber": panCardNumber,
        "aadhaarCardNumber": aadhaarCardNumber,
        "userResponse": userResponse,
        "countryCode": countryCode,
        "token": token,
        "caEmail": caEmail,
        "caId": caId,
        "caName": caName,
        "caMobile": caMobile,
        "designation": designation,
        "lastLogin": lastLogin,
        "permissions": permissions?.toJson(),
        "companyName": companyName,
        "gst": gst,
        "companyLogo": companyLogo,
        "services": services == null
            ? []
            : List<dynamic>.from(services!.map((x) => x.toJson())),
        "selfRegistered": selfRegistered,
        "caEducations": caEducations == null
            ? []
            : List<dynamic>.from(caEducations!.map((x) => x.toJson())),
        "userCertifications": userCertifications == null
            ? []
            : List<dynamic>.from(userCertifications!.map((x) => x)),
        "about": about,
        "specializations": specializations == null
            ? []
            : List<dynamic>.from(specializations!.map((x) => x)),
        "icaiMembershipId": icaiMembershipId,
        "registrationNumber": registrationNumber,
        "years": years,
        "months": months,
        "firmAddress": firmAddress,
        "professionalTitle": professionalTitle,
        "isOnline": isOnline,
        "occupation": occupation,
        "dateOfBirth": dateOfBirth,
        "typeOfBusiness": typeOfBusiness,
        "profileCompletion": profileCompletion
      };
}

class Permissions {
  List<ClientActivity>? clientActivities;
  List<ClientActivity>? documentActivities;
  List<ClientActivity>? general;
  List<ClientActivity>? taskActivities;

  Permissions({
    this.clientActivities,
    this.documentActivities,
    this.general,
    this.taskActivities,
  });

  factory Permissions.fromJson(Map<String, dynamic> json) => Permissions(
        clientActivities: json["CLIENT_ACTIVITIES"] == null
            ? []
            : List<ClientActivity>.from(json["CLIENT_ACTIVITIES"]!
                .map((x) => ClientActivity.fromJson(x))),
        documentActivities: json["DOCUMENT_ACTIVITIES"] == null
            ? []
            : List<ClientActivity>.from(json["DOCUMENT_ACTIVITIES"]!
                .map((x) => ClientActivity.fromJson(x))),
        general: json["GENERAL"] == null
            ? []
            : List<ClientActivity>.from(
                json["GENERAL"]!.map((x) => ClientActivity.fromJson(x))),
        taskActivities: json["TASK_ACTIVITIES"] == null
            ? []
            : List<ClientActivity>.from(json["TASK_ACTIVITIES"]!
                .map((x) => ClientActivity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "CLIENT_ACTIVITIES": clientActivities == null
            ? []
            : List<dynamic>.from(clientActivities!.map((x) => x.toJson())),
        "DOCUMENT_ACTIVITIES": documentActivities == null
            ? []
            : List<dynamic>.from(documentActivities!.map((x) => x.toJson())),
        "GENERAL": general == null
            ? []
            : List<dynamic>.from(general!.map((x) => x.toJson())),
        "TASK_ACTIVITIES": taskActivities == null
            ? []
            : List<dynamic>.from(taskActivities!.map((x) => x.toJson())),
      };
}

class ClientActivity {
  int? id;
  String? permissionName;
  String? type;
  bool? isSelected;

  ClientActivity({this.id, this.permissionName, this.type, this.isSelected});

  factory ClientActivity.fromJson(Map<String, dynamic> json) => ClientActivity(
        id: json["id"],
        permissionName: json["permissionName"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "permissionName": permissionName,
        "type": type,
      };
}
class CaEducation {
  String? degree;
  String? university;

  CaEducation({
    this.degree,
    this.university,
  });

  factory CaEducation.fromJson(Map<String, dynamic> json) => CaEducation(
        degree: json["degree"],
        university: json["university"],
      );

  Map<String, dynamic> toJson() => {
        "degree": degree,
        "university": university,
      };
}
class Service {
  int? serviceId;
  String? serviceName;
  String? serviceDesc;
  String? subService;

  Service({
    this.serviceId,
    this.serviceName,
    this.serviceDesc,
    this.subService,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        serviceId: json["serviceId"],
        serviceName: json["serviceName"],
        serviceDesc: json["serviceDesc"],
        subService: json["subService"],
      );

  Map<String, dynamic> toJson() => {
        "serviceId": serviceId,
        "serviceName": serviceName,
        "serviceDesc": serviceDesc,
        "subService": subService,
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
