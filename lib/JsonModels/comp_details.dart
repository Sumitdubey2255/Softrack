import 'dart:convert';

/*

Author: Sumit Sunil Dubey
location: Thane
link: https://sumit-portfolio-4mn0.onrender.com/

*/
CompDetails usersFromMap(String str) => CompDetails.fromMap(json.decode(str));

String usersToMap(CompDetails data) => json.encode(data.toMap());

class CompDetails {
  final String usrId;
  final String usrUserName;
  final String usrName;
  final String usrEmail;
  final String usrPhone;
  final String usrShopName;
  final String usrShopAddress;
  final String usrCompKey;
  final String usrVerified;
  final String usrUniqueId;
  final String usrUserCount;
  final String usrPinCode;
  final String usrActiveStatus;
  final String usrCreationDate;

  CompDetails({
    this.usrId = "0",
    required this.usrUserName,
    required this.usrName,
    required this.usrEmail,
    required this.usrPhone,
    required this.usrShopName,
    required this.usrCompKey,
    required this.usrCreationDate,
    required this.usrShopAddress,
    required this.usrUniqueId,
    required this.usrUserCount,
    required this.usrPinCode,
    this.usrActiveStatus = "0",
    this.usrVerified = "yes",
  });

  factory CompDetails.fromMap(Map<String, dynamic> json) => CompDetails(
    usrId: json["id"].toString(),
    usrUserName: json["username"] ?? '',
    usrName: json["name"] ?? '',
    usrEmail: json['email'] ?? '',
    usrPhone: json['contact'] ?? '',
    usrShopName: json["shop_name"] ?? '',
    usrShopAddress: json["address"] ?? '',
    usrPinCode: json["pincode"] ?? '',
    usrCompKey: json["comp_key"] ?? '',
    usrCreationDate: json["createdAt"] ?? '',
    usrUniqueId: json["unique_id"] ?? '',
    usrUserCount: json["num_users"] ?? '',
    usrActiveStatus: json["active"] ?? '',
    usrVerified: json['verified'].toString(),

  );

  Map<String, dynamic> toMap() => {
    "id": usrId,
    "username": usrUserName,
    "name": usrName,
    "email": usrEmail,
    "phone": usrPhone,
    "shop_name": usrShopName,
    "address": usrShopAddress,
    "pincode": usrPinCode,
    "comp_key": usrCompKey,
    "createdAt": usrCreationDate,
    "unique_id": usrUniqueId,
    "num_users": usrUserCount,
    "active": usrActiveStatus,
    "verified": usrVerified,
  };
}
