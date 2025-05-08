import 'dart:convert';

/*

Author: Sumit Sunil Dubey
location: Thane
link: https://sumit-portfolio-4mn0.onrender.com/

*/
CreateComp usersFromMap(String str) => CreateComp.fromMap(json.decode(str));
String usersToMap(CreateComp data) => json.encode(data.toMap());

class CreateComp {
  final String usrId;
  final String usrUserName;
  final String usrName;
  final String usrEmail;
  final String usrPhone;
  final String usrShopName;
  final String usrCompKey;
  final String usrVerified;
  final String createdAt;
  final String usrAddress;
  final String usrAppName;
  final String usrServiceType;
  final String usrUsersCount;
  final String usrPayType;
  final String usrAadharNo;
  final String usrPaidAmt;
  late final String usrNoOfDays;
  final String usrDeploymentType;

  CreateComp({
    this.usrId = "0",
    required this.usrUserName,
    required this.usrName,
    required this.usrEmail,
    required this.usrPhone,
    required this.usrShopName,
    required this.usrCompKey,
    this.createdAt="",
    this.usrVerified = "yes",
    this.usrAddress="",
    required this.usrAppName,
    required this.usrServiceType,
    required this.usrUsersCount,
    required this.usrPayType,
    required this.usrAadharNo,
    required this.usrPaidAmt,
    required this.usrNoOfDays,
    required this.usrDeploymentType,
  });

  factory CreateComp.fromMap(Map<String, dynamic> json) => CreateComp(
    usrId: json["id"].toString(),
    usrUserName: json["username"] ?? '',
    usrName: json["name"] ?? '',
    usrEmail: json['email'] ?? '',
    usrPhone: json['phone'] ?? '',
    usrShopName: json["shop_name"] ?? '',
    usrCompKey: json["comp_key"] ?? '',
    createdAt: json["createdAt"] ?? '',
    usrVerified: json['verified'].toString(),
    usrAddress: json['address'].toString() ?? '',
    usrAppName: json["app_name"] ?? '',
    usrServiceType: json["service_type"] ?? '',
    usrUsersCount:json["users_count"] ?? '',
    usrPayType: json["pay_type"] ?? '',
    usrAadharNo: json["aadhar_no"] ?? '',
    usrPaidAmt: json["paid_amt"] ?? '',
    usrNoOfDays: json["NoOfDays"] ?? '',
    usrDeploymentType: json["deployment_type"] ?? '',
  );

  Map<String, dynamic> toMap() => {
    "id": usrId,
    "username": usrUserName,
    "name": usrName,
    "email": usrEmail,
    "phone": usrPhone,
    "shop_name": usrShopName,
    "comp_key": usrCompKey,
    "createdAt": createdAt,
    "verified": usrVerified,
    "address": usrAddress,
    "app_name": usrAppName,
    "service_type": usrServiceType,
    "users_count": usrUsersCount,
    "pay_type": usrPayType,
    "aadhar_no": usrAadharNo,
    "paid_amt": usrPaidAmt,
    "NoOfDays": usrNoOfDays,
    "deployment_type": usrDeploymentType,
  };
}
