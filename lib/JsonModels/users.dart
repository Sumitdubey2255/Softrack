import 'dart:convert';

/*

Author: Sumit Sunil Dubey
location: Thane
link: https://sumit-portfolio-4mn0.onrender.com/

*/
Users usersFromMap(String str) => Users.fromMap(json.decode(str));
String usersToMap(Users data) => json.encode(data.toMap());

class Users {
  final String usrId;
  final String usrName;
  final String usrEmail;
  final String usrPhone;
  final String usrUserName;
  final String usrPassword;
  final String usrActive;

  Users({
    this.usrId = "0",
    required this.usrName,
    required this.usrEmail,
    required this.usrPhone,
    required this.usrUserName,
    required this.usrPassword,
    this.usrActive = "1/distributor",
  });

  factory Users.fromMap(Map<String, dynamic> json) => Users(
    usrId: json["id"].toString(),
    usrName: json["name"] ?? '',
    usrEmail: json['email'] ?? '',
    usrPhone: json['phone'] ?? '',
    usrUserName: json["username"] ?? '',
    usrPassword: json["password"] ?? '',
    usrActive: json['active_status'].toString(),
  );

  Map<String, dynamic> toMap() => {
    "id": usrId,
    "name": usrName,
    "email": usrEmail,
    "phone": usrPhone,
    "username": usrUserName,
    "password": usrPassword,
    "active_status": usrActive,
  };
}
