// To parse this JSON data, do
//
//     final transfer = transferFromJson(jsonString);

import 'dart:convert';

import 'alldevice.dart';

Transfer transferFromJson(String str) => Transfer.fromJson(json.decode(str));

String transferToJson(Transfer data) => json.encode(data.toJson());

class Transfer {
  String? fromId;
  String? toId;
  List<AllnDevice>? devices;

  Transfer({
    this.fromId,
    this.toId,
    this.devices,
  });

  factory Transfer.fromJson(Map<String, dynamic> json) => Transfer(
    fromId: json["from_id"],
    toId: json["to_id"],
    devices: json["devices"] == null ? [] : List<AllnDevice>.from(json["devices"]!.map((x) => AllnDevice.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "from_id": fromId,
    "to_id": toId,
    "devices": devices == null ? [] : List<dynamic>.from(devices!.map((x) => x.toJson())),
  };
}

// class Devicetr {
//   int? id;
//   String? serialNo;
//
//   Devicetr({
//     this.id,
//     this.serialNo,
//   });
//
//   factory Devicetr.fromJson(Map<String, dynamic> json) => Devicetr(
//     id: json["id"],
//     serialNo: json["serial_no"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "serial_no": serialNo,
//   };
// }
