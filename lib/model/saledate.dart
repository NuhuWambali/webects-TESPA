// To parse this JSON data, do
//
//     final saleAdd = saleAddFromJson(jsonString);

import 'dart:convert';

SaleAdd saleAddFromJson(String str) => SaleAdd.fromJson(json.decode(str));

String saleAddToJson(SaleAdd data) => json.encode(data.toJson());

class SaleAdd {
  int?  id;
  String? saleDate;
  String ? receipt_number;
  String? startDateTime;
  String? endDate;
  String? vehicleNumber;
  String? chasisNumber;
  String? tzl;
  String? offline_receipt_number;
  String? prev_offline_receipt_number;
  String? driverName;
  String? borderId;
  String? tripStatus;
  String? driverNumber;
  String? serialNo;
  String? amount;
  String? currency;
  String? gateNumber;
  String? gateName;
  String? borderName;
  String? salesPerson;

  String? tagger;
  String? passport;
  String? containerNumber;
  String? vehicleTypeId;
  String? customerTypeId;
  String? companyName;
  String? customerId;
  String? trailerNo;
  String? agent;
  String? saleType;
  String? saleId;
  String? trailerno;
  List<Slave>? slaves;

  SaleAdd({
    this.id,
    this.saleDate,
    this.receipt_number,
    this.offline_receipt_number,
    this.prev_offline_receipt_number,
    this.startDateTime,
    this.endDate,
    this.tagger,
    this.trailerNo,
    this.vehicleNumber,
    this.chasisNumber,
    this.tzl,
    this.driverName,
    this.borderId,
    this.borderName,
    this.gateName,
    this.tripStatus,
    this.driverNumber,
    this.serialNo,
    this.amount,
    this.currency,
    this.gateNumber,
    this.salesPerson,
    this.passport,
    this.containerNumber,
    this.vehicleTypeId,
    this.customerTypeId,
    this.companyName,
    this.customerId,
    this.agent,
    this.saleType,
    this.saleId,
    this.slaves,
    this.trailerno
  });

  factory SaleAdd.fromJson(Map<String, dynamic> json) => SaleAdd(
    id : json['id'],
    saleDate: json["sale_date"],
    receipt_number: json['receipt_number'],
    offline_receipt_number: json['offline_receipt_number'],
    prev_offline_receipt_number:json['prev_offline_receipt_number'],
    startDateTime: json["start_date_time"],
    tagger: json['tagger'],
    endDate: json["end_date"],
    vehicleNumber: json["vehicle_number"],
    chasisNumber: json["chasis_number"],
    tzl: json["tzl"],
    driverName: json["driver_name"],
    trailerNo: json["trailer_no"],
    borderId: json["border_id"],
    borderName: json["borderName"],
    gateName: json["gateName"],
    tripStatus: json["trip_status"],
    driverNumber: json["driver_number"],
    serialNo: json["serial_no"],
    amount: json["amount"],
    currency: json["currency"],
    gateNumber: json["gate_number"],
    salesPerson: json["sales_person"],
    passport: json["passport"],
    containerNumber: json["container_number"],
    vehicleTypeId: json["vehicle_type_id"],
    customerTypeId: json["customer_type_id"],
    companyName: json["company_name"],
    customerId: json["customer_id"],
    agent: json["agent"],
    saleType: json["sale_type"],
    saleId: json["sale_id"],
    trailerno: json["trailerno"],
    // slaves: json["slaves"] == null ? [] : List<Slave>.from(json["slaves"]!.map((x) => Slave.fromJson(x))),
  );




  Map<String, dynamic> toJson() => {
    "sale_date": saleDate,
    "start_date_time": startDateTime,
    "end_date": endDate,
    "receipt_number": receipt_number,
    "offline_receipt_number":offline_receipt_number,
    "prev_offline_receipt_number":prev_offline_receipt_number,
    "vehicle_number": vehicleNumber,
    "chasis_number": chasisNumber,
    "tzl": tzl,
    "driver_name": driverName,
    "tagger": tagger,
    "border_id": borderId,
    "trip_status": tripStatus,
    "driver_number": driverNumber,
    "serial_no": serialNo,
    "amount": amount,
    "currency": currency,
    "gate_number": gateNumber,
    "sales_person": salesPerson,
    "passport": passport,
    "container_number": containerNumber,
    "vehicle_type_id": vehicleTypeId,
    "customer_type_id": customerTypeId,
    "company_name": companyName,
    "customer_id": customerId,
    "agent": agent,
    "sale_type": saleType,
    "sale_id": saleId,
    "trailerno":trailerno,
    "slaves": slaves == null ? [] : List<dynamic>.from(slaves!.map((x) => x.toJson())),
  };

  Map<String, dynamic> toMap() => {
    "sale_date": saleDate,
    "start_date_time": startDateTime,
    "end_date": endDate,
    "vehicle_number": vehicleNumber,
    "tagger": tagger,
    "receipt_number": receipt_number,
    "offline_receipt_number":offline_receipt_number,
    "prev_offline_receipt_number":prev_offline_receipt_number,
    "chasis_number": chasisNumber,
    "tzl": tzl,
    "driver_name": driverName,
    "border_id": borderId,
    "borderName":borderName,
    "gateName":gateName,
    "trip_status": tripStatus,
    "driver_number": driverNumber,
    "serial_no": serialNo,
    "amount": amount,
    "currency": currency,
    "gate_number": gateNumber,
    "sales_person": salesPerson,
    "passport": passport,
    "container_number": containerNumber,
    "vehicle_type_id": vehicleTypeId,
    "customer_type_id": customerTypeId,
    "company_name": companyName,
    "customer_id": customerId,
    "agent": agent,
    "sale_type": saleType,
    "sale_id": saleId,
    "trailerno":trailerno,
    // "slaves": slaves == null ? [] : List<dynamic>.from(slaves!.map((x) => x.toJson())),
  };


  Map<String, dynamic> tooMap() => {
    "sale_date": saleDate,
    "start_date_time": startDateTime,
    "end_date": endDate,
    "vehicle_number": vehicleNumber,
    "receipt_number": receipt_number,
    "offline_receipt_number":offline_receipt_number,
    "prev_offline_receipt_number":prev_offline_receipt_number,
    "chasis_number": chasisNumber,
    "tzl": tzl,
    "tagger": tagger,
    "driver_name": driverName,
    "border_id": borderId,
    "borderName":borderName,
    "gateName":gateName,
    "trip_status": tripStatus,
    "driver_number": driverNumber,
    "serial_no": serialNo,
    "amount": amount,
    "currency": currency,
    "gate_number": gateNumber,
    "sales_person": salesPerson,
    "passport": passport,
    "container_number": containerNumber,
    "vehicle_type_id": vehicleTypeId,
    "customer_type_id": customerTypeId,
    "company_name": companyName,
    "customer_id": customerId,
    "agent": agent,
    "sale_type": saleType,
    "sale_id": saleId,
    "trailerno":trailerno,
    "slaves": slaves == null ? [] : List<dynamic>.from(slaves!.map((x) => x.toJson())),
  };


}

class Slave {
  String? serialNo;
  int?  saleId;
  int?  id;
  Slave({
    this.id,
    this.serialNo,
  this.saleId
  });

  factory Slave.fromJson(Map<String, dynamic> json) => Slave(
      id : json['id'],
    serialNo: json["serial_no"],
    saleId:  json['saleId']

  );

  Map<String, dynamic> toJson() => {
    "serial_no": serialNo,
  };

  Map<String, dynamic> toMap() => {
    "serial_no": serialNo,
    "saleId": saleId
  };



}
