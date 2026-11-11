// To parse this JSON data, do
//
//     final port = portFromJson(jsonString);

import 'dart:convert';

Port portFromJson(String str) => Port.fromJson(json.decode(str));

String portToJson(Port data) => json.encode(data.toJson());

class Port {
  List<PortPoint>? portPoints;

  Port({
    this.portPoints,
  });

  factory Port.fromJson(Map<String, dynamic> json) => Port(
    portPoints: json["portPoints"] == null ? [] : List<PortPoint>.from(json["portPoints"]!.map((x) => PortPoint.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "portPoints": portPoints == null ? [] : List<dynamic>.from(portPoints!.map((x) => x.toJson())),
  };
}

class PortPoint {
  int? id;
  String? gateName;

  PortPoint({
    this.id,
    this.gateName,
  });

  factory PortPoint.fromJson(Map<String, dynamic> json) => PortPoint(
    id: json["id"],
    gateName: json["gate_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "gate_name": gateName,
  };
}
