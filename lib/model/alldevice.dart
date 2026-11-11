// To parse this JSON data, do
//
//     final allDevice = allDeviceFromJson(jsonString);

import 'dart:convert';

AllDevice allDeviceFromJson(String str) => AllDevice.fromJson(json.decode(str));

String allDeviceToJson(AllDevice data) => json.encode(data.toJson());

class AllDevice {
  List<AllnDevice>? devices;

  AllDevice({
    this.devices,
  });

  factory AllDevice.fromJson(Map<String, dynamic> json) => AllDevice(
    devices: json["devices"] == null ? [] : List<AllnDevice>.from(json["devices"]!.map((x) => AllnDevice.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "devices": devices == null ? [] : List<dynamic>.from(devices!.map((x) => x.toJson())),
  };
}

class AllnDevice {
  int? id;
  String? serialNo;
  bool? selected;

  AllnDevice({
    this.id,
    this.serialNo,
    this.selected
  });

  factory AllnDevice.fromJson(Map<String, dynamic> json) => AllnDevice(
    id: json["id"],
    serialNo: json["serial_no"],
    selected: json['selected']??false,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "serial_no": serialNo,
    "selected":selected
  };
}
