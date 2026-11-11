// To parse this JSON data, do
//
//     final staff = staffFromJson(jsonString);

import 'dart:convert';

Staff staffFromJson(String str) => Staff.fromJson(json.decode(str));

String staffToJson(Staff data) => json.encode(data.toJson());

class Staff {
  List<StaffElement>? staffs;

  Staff({
    this.staffs,
  });

  factory Staff.fromJson(Map<String, dynamic> json) => Staff(
    staffs: json["staffs"] == null ? [] : List<StaffElement>.from(json["staffs"]!.map((x) => StaffElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "staffs": staffs == null ? [] : List<dynamic>.from(staffs!.map((x) => x.toJson())),
  };
}

class StaffElement {
  int? id;
  String? names;

  StaffElement({
    this.id,
    this.names,
  });

  factory StaffElement.fromJson(Map<String, dynamic> json) => StaffElement(
    id: json["id"],
    names: json["names"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "names": names,
  };
}
