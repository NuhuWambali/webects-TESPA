// To parse this JSON data, do
//
//     final saleResult = saleResultFromJson(jsonString);

import 'dart:convert';

SaleResult saleResultFromJson(String str) => SaleResult.fromJson(json.decode(str));

String saleResultToJson(SaleResult data) => json.encode(data.toJson());

class SaleResult {
  String? receiptNumber;
  dynamic amount;
  int? saleId;
  int? status;
  String? message;

  SaleResult({
    this.receiptNumber,
    this.amount,
    this.saleId,
    this.status,
    this.message,
  });

  factory SaleResult.fromJson(Map<String, dynamic> json) => SaleResult(
    receiptNumber: json["receipt_number"],
    amount: json["amount"],
    saleId: json["sale_id"],
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "receipt_number": receiptNumber,
    "amount": amount,
    "sale_id": saleId,
    "status": status,
    "message": message,
  };
}
