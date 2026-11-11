// To parse this JSON data, do
//
//     final userdata = userdataFromJson(jsonString);

import 'dart:convert';

Userdata userdataFromJson(String str) => Userdata.fromJson(json.decode(str));

String userdataToJson(Userdata data) => json.encode(data.toJson());

class Userdata {
  int? userId;
  String? name;
  String? username;
  String? email;
  int? status;
  String? message;
  String? accessToken;
  int? userType;
  dynamic borderPort;
  dynamic borderPortName;
  String? role;
  int? salesChannel;
  int? branch;

  Userdata({
    this.userId,
    this.name,
    this.username,
    this.email,
    this.status,
    this.message,
    this.accessToken,
    this.userType,
    this.borderPort,
    this.borderPortName,
    this.role,
    this.branch,
    this.salesChannel,
  });

  factory Userdata.fromJson(Map<String, dynamic> json) => Userdata(
    userId: json["user_id"],
    name: json["name"],
    username: json["username"],
    email: json["email"],
    status: json["status"],
    message: json["message"],
    accessToken: json["access_token"],
    userType: json["user_type"],
    borderPort: json["border_port"],
    borderPortName: json["border_port_name"],
    role: json["role"],
    salesChannel: json["sales_channel"],
    branch: json["branch"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "name": name,
    "username": username,
    "email": email,
    "status": status,
    "message": message,
    "access_token": accessToken,
    "user_type": userType,
    "border_port": borderPort,
    "border_port_name": borderPortName,
    "role": role,
    "sales_channel": salesChannel,
    "branch": branch,
  };
}
