// To parse this JSON data, do
//
//     final border = borderFromJson(jsonString);

import 'dart:convert';

Borderd borderFromJson(String str) => Borderd.fromJson(json.decode(str));

String borderToJson(Borderd data) => json.encode(data.toJson());

class Borderd {
  List<BorderElement>? borders;

  Borderd({
    this.borders,
  });

  factory Borderd.fromJson(Map<String, dynamic> json) => Borderd(
    borders: json["borders"] == null ? [] : List<BorderElement>.from(json["borders"]!.map((x) => BorderElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "borders": borders == null ? [] : List<dynamic>.from(borders!.map((x) => x.toJson())),
  };
}

class BorderElement {
  int? id;
  String? title;

  BorderElement({
    this.id,
    this.title,
  });

  factory BorderElement.fromJson(Map<String, dynamic> json) => BorderElement(
    id: json["id"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
  };
}
