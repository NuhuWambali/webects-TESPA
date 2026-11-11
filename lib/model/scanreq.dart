// To parse this JSON data, do
//
//     final scanReceiptReq = scanReceiptReqFromJson(jsonString);

import 'dart:convert';

ScanReceiptReq scanReceiptReqFromJson(String str) => ScanReceiptReq.fromJson(json.decode(str));

String scanReceiptReqToJson(ScanReceiptReq data) => json.encode(data.toJson());

class ScanReceiptReq {
  String? userId;
  String? receiptNo;

  ScanReceiptReq({
    this.userId,
    this.receiptNo,
  });

  factory ScanReceiptReq.fromJson(Map<String, dynamic> json) => ScanReceiptReq(
    userId: json["user_id"],
    receiptNo: json["receipt_no"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "receipt_no": receiptNo,
  };
}




class ScanReceipt {
  String? message;
  String? receiptNo;
  String? status;

  ScanReceipt({
    this.message,
    this.receiptNo,
    this.status
  });

  factory ScanReceipt.fromJson(Map<String, dynamic> json) =>
      ScanReceipt(
          message: json["message"],
          receiptNo: json["receipt_no"],
          status: json['status']
      );

  Map<String, dynamic> toJson() =>
      {
        "user_id": message,
        "receipt_no": receiptNo,
        "status": status
      };

}
