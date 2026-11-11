// To parse this JSON data, do
//
//     final comfirmDevice = comfirmDeviceFromJson(jsonString);

import 'dart:convert';

ComfirmDevice comfirmDeviceFromJson(String str) => ComfirmDevice.fromJson(json.decode(str));

String comfirmDeviceToJson(ComfirmDevice data) => json.encode(data.toJson());

class ComfirmDevice {
  String? userId;
  List<Devicecomfirm>? devices;

  ComfirmDevice({
    this.userId,
    this.devices,
  });

  factory ComfirmDevice.fromJson(Map<String, dynamic> json) => ComfirmDevice(
    userId: json["user_id"],
    devices: json["devices"] == null ? [] : List<Devicecomfirm>.from(json["devices"]!.map((x) => Devicecomfirm.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "devices": devices == null ? [] : List<dynamic>.from(devices!.map((x) => x.toJson())),
  };
}

class Devicecomfirm {
  int? id;
  String? serialNo;

  Devicecomfirm({
    this.id,
    this.serialNo,
  });

  factory Devicecomfirm.fromJson(Map<String, dynamic> json) => Devicecomfirm(
    id: json["id"],
    serialNo: json["serial_no"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "serial_no": serialNo,
  };
}
