// To parse this JSON data:
//
//     final report = reportFromJson(jsonString);

import 'dart:convert';

Report reportFromJson(String str) => Report.fromJson(json.decode(str));

String reportToJson(Report data) => json.encode(data.toJson());

class Report {
  ReportClass? report;

  Report({
    this.report,
  });

  factory Report.fromJson(Map<String, dynamic> json) => Report(
    report: json["report"] == null
        ? null
        : ReportClass.fromJson(json["report"]),
  );

  Map<String, dynamic> toJson() => {
    "report": report?.toJson(),
  };
}

class ReportClass {
  int? totalNumberBillSales;
  double totalAmountBillSales;
  int? totalNumberCashSalesTzs;
  double totalAmountCashSalesTzs;
  int? totalNumberCashSalesUsd;
  double totalAmountCashSalesUsd;
  int? remainedDevices;
  double totalAmount;
  int totalNumber;

  ReportClass({
    this.totalNumberBillSales,
    this.totalAmountBillSales = 0,
    this.totalNumberCashSalesTzs,
    this.totalAmountCashSalesTzs = 0,
    this.totalNumberCashSalesUsd,
    this.totalAmountCashSalesUsd = 0,
    this.remainedDevices,
    this.totalAmount = 0,
    this.totalNumber = 0,
  });

  factory ReportClass.fromJson(Map<String, dynamic> json) => ReportClass(
    totalNumberBillSales: json["total_number_bill_sales"] ?? 0,
    totalAmountBillSales: json["total_amount_bill_sales"] != null
        ? double.tryParse(json["total_amount_bill_sales"].toString()) ?? 0
        : 0,
    totalNumberCashSalesTzs: json["total_number_cash_sales_tzs"] ?? 0,
    totalAmountCashSalesTzs: json["total_amount_cash_sales_tzs"] != null
        ? double.tryParse(json["total_amount_cash_sales_tzs"].toString()) ?? 0
        : 0,
    totalNumberCashSalesUsd: json["total_number_cash_sales_usd"] ?? 0,
    totalAmountCashSalesUsd: json["total_amount_cash_sales_usd"] != null
        ? double.tryParse(json["total_amount_cash_sales_usd"].toString()) ?? 0
        : 0,
    remainedDevices: json["remained_devices"] ?? 0,
    totalAmount: json["total_amount"] != null
        ? double.tryParse(json["total_amount"].toString()) ?? 0
        : 0,
    totalNumber: json["total_number"] != null
        ? int.tryParse(json["total_number"].toString()) ?? 0
        : 0,
  );

  Map<String, dynamic> toJson() => {
    "total_number_bill_sales": totalNumberBillSales,
    "total_amount_bill_sales": totalAmountBillSales,
    "total_number_cash_sales_tzs": totalNumberCashSalesTzs,
    "total_amount_cash_sales_tzs": totalAmountCashSalesTzs,
    "total_number_cash_sales_usd": totalNumberCashSalesUsd,
    "total_amount_cash_sales_usd": totalAmountCashSalesUsd,
    "remained_devices": remainedDevices,
    "total_amount": totalAmount,
    "total_number": totalNumber,
  };
}
