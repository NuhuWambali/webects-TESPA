
// To parse this JSON data, do
//
//     final reportReq = reportReqFromJson(jsonString);

import 'dart:convert';

ReportReq reportReqFromJson(String str) => ReportReq.fromJson(json.decode(str));

String reportReqToJson(ReportReq data) => json.encode(data.toJson());

class ReportReq {
  String? fromDate;
  String? toDate;
  int? userId;

  ReportReq({
    this.fromDate,
    this.toDate,
    this.userId,
  });

  factory ReportReq.fromJson(Map<String, dynamic> json) => ReportReq(
    fromDate: json["from_date"],
    toDate: json["to_date"],
    userId: json["user_id"],
  );

  Map<String, dynamic> toJson() => {
    "from_date":fromDate,
    "to_date": toDate,
    "user_id": userId,
  };
}
