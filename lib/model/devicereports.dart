// To parse this JSON data, do
//
//     final deviceReportz = deviceReportzFromJson(jsonString);

import 'dart:convert';

DeviceReportz deviceReportzFromJson(String str) => DeviceReportz.fromJson(json.decode(str));

String deviceReportzToJson(DeviceReportz data) => json.encode(data.toJson());

class DeviceReportz {
  String? user;
  int? total;
  String? border;
  DateTime? dateFrom;
  DateTime? dateTo;
  List<Devicetrp>? devices;

  DeviceReportz({
    this.user,
    this.total,
    this.border,
    this.dateFrom,
    this.dateTo,
    this.devices,
  });

  factory DeviceReportz.fromJson(Map<String, dynamic> json) => DeviceReportz(
    user: json["user"],
    total: json["total"],
    border: json["border"],
    dateFrom: json["date_from"] == null ? null : DateTime.parse(json["date_from"]),
    dateTo: json["date_to"] == null ? null : DateTime.parse(json["date_to"]),
    devices: json["devices"] == null ? [] : List<Devicetrp>.from(json["devices"]!.map((x) => Devicetrp.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "user": user,
    "total": total,
    "border": border,
    "date_from": "${dateFrom!.year.toString().padLeft(4, '0')}-${dateFrom!.month.toString().padLeft(2, '0')}-${dateFrom!.day.toString().padLeft(2, '0')}",
    "date_to": "${dateTo!.year.toString().padLeft(4, '0')}-${dateTo!.month.toString().padLeft(2, '0')}-${dateTo!.day.toString().padLeft(2, '0')}",
    "devices": devices == null ? [] : List<dynamic>.from(devices!.map((x) => x.toJson())),
  };
}

class Devicetrp {
  int? id;
  String? serialNo;
  String? borderName;
  DateTime? createdAt;

  Devicetrp({
    this.id,
    this.serialNo,
    this.borderName,
    this.createdAt,
  });

  factory Devicetrp.fromJson(Map<String, dynamic> json) => Devicetrp(
    id: json["id"],
    serialNo: json["serial_no"],
    borderName: json["borderName"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "serial_no": serialNo,
    "borderName": borderName,
    "created_at": createdAt?.toIso8601String(),
  };
}
