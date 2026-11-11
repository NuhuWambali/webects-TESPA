// To parse this JSON data, do
//
//     final device = deviceFromJson(jsonString);

import 'dart:convert';
import 'package:equatable/equatable.dart';
Device deviceFromJson(String str) => Device.fromJson(json.decode(str));

String deviceToJson(Device data) => json.encode(data.toJson());

class Device {
  List<DeviceElement>? devices;

  Device({
    this.devices,
  });

  factory Device.fromJson(Map<String, dynamic> json) => Device(
    devices: json["devices"] == null ? [] : List<DeviceElement>.from(json["devices"]!.map((x) => DeviceElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "devices": devices == null ? [] : List<dynamic>.from(devices!.map((x) => x.toJson())),
  };
}

class DeviceElement extends Equatable{
  int? id;
  String? serialNo;
  int? selected;

  DeviceElement({
    this.id,
    this.serialNo,
    this.selected,
  });

  factory DeviceElement.fromJson(Map<String, dynamic> json) => DeviceElement(
    id: json["id"],
    serialNo: json["serial_no"],
    selected: json["selected"]??0,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "serial_no": serialNo,
    "selected":selected
  };


  @override
  // TODO: implement props
  List<Object?> get props =>  [id,serialNo,selected];
}


class DeviceSlave {
  String? serialNo;

  DeviceSlave({
    this.serialNo,
  });

  factory  DeviceSlave.fromJson(Map<String, dynamic> json) =>  DeviceSlave(
    serialNo: json["serial_no"],
  );

  Map<String, dynamic> toJson() => {
    "serial_no": serialNo,
  };


  @override
  bool operator ==(Object other) {
    return other is DeviceSlave && this.serialNo == other.serialNo;
  }
}
