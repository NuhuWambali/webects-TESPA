// To parse this JSON data, do
//
//     final receipt = receiptFromJson(jsonString);

import 'dart:convert';

Receipt receiptFromJson(String str) => Receipt.fromJson(json.decode(str));

String receiptToJson(Receipt data) => json.encode(data.toJson());

class Receipt {
  ReceiptClass? receipt;

  Receipt({
    this.receipt,
  });

  factory Receipt.fromJson(Map<String, dynamic> json) => Receipt(
    receipt: json["receipt"] == null ? null : ReceiptClass.fromJson(json["receipt"]),
  );

  Map<String, dynamic> toJson() => {
    "receipt": receipt?.toJson(),
  };
}

class ReceiptClass {
  Portr? port;
  String? driverName;
  int? saleId;
  int? userId;
  String? username;
  String? amount;
  String? companyName;
  String? agent;
  String? currency;
  String? vehicleNumber;
  String? tzl;
  Borderr? border;
  Devicer? device;
  String? passport;
  String? containerNumber;
  String ?prev_offline_receipt_number;
  String ? offline_receipt_number;
  Customerr? customer;
  String? driverNumber;
  String? receiptNumber;
  String? chasisNumber;
  String? vehicleTypeId;
  String? customerTypeId;
  int? saleType;
  String? trailerno;
  String? startDateTime;
 String? endDate;
  List<Slaver>? slaves;

  ReceiptClass({
    this.port,
    this.driverName,
    this.saleId,
    this.userId,
    this.username,
    this.amount,
    this.companyName,
    this.offline_receipt_number,
    this.prev_offline_receipt_number,

    this.agent,
    this.currency,
    this.vehicleNumber,
    this.tzl,
    this.border,
    this.device,
    this.passport,
    this.containerNumber,
    this.customer,
    this.driverNumber,
    this.receiptNumber,
    this.chasisNumber,
    this.vehicleTypeId,
    this.customerTypeId,
    this.saleType,
    this.trailerno,
    this.startDateTime,
    this.endDate,
    this.slaves,
  });

  factory ReceiptClass.fromJson(Map<String, dynamic> json) => ReceiptClass(
    port: json["port"] == null ? null : Portr.fromJson(json["port"]),
    driverName: json["driver_name"],
    saleId: json["sale_id"],
    userId: json["user_id"],
    username: json["username"],
    prev_offline_receipt_number:json["prev_offline_receipt_number"],
    offline_receipt_number:json['offline_receipt_number'],
    amount: json["amount"],
    companyName: json["company_name"],
    agent: json["agent"],
    currency: json["currency"],
    vehicleNumber: json["vehicle_number"],
    tzl: json["tzl"],
    border: json["border"] == null ? null : Borderr.fromJson(json["border"]),
    device: json["device"] == null ? null : Devicer.fromJson(json["device"]),
    passport: json["passport"],
    containerNumber: json["container_number"],
    customer: json["customer"] == null ? null : Customerr.fromJson(json["customer"]),
    driverNumber: json["driver_number"],
    receiptNumber: json["receipt_number"],
    chasisNumber: json["chasis_number"],
    vehicleTypeId: json["vehicle_type_id"],
    customerTypeId: json["customer_type_id"],
    saleType: json["sale_type"],
    trailerno: json["trailerno"],
    startDateTime: json["start_date_time"],
    endDate: json["end_date"] ,
    slaves: json["slaves"] == null ? [] : List<Slaver>.from(json["slaves"]!.map((x) => Slaver.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "port": port?.toJson(),
    "driver_name": driverName,
    "sale_id": saleId,
    "user_id": userId,
    "username": username,
    "amount": amount,
    "company_name": companyName,
    "agent": agent,
    "currency": currency,
    "vehicle_number": vehicleNumber,
    "prev_offline_receipt_number":prev_offline_receipt_number,
     "offline_receipt_number":offline_receipt_number,

    "tzl": tzl,
    "border": border?.toJson(),
    "device": device?.toJson(),
    "passport": passport,
    "container_number": containerNumber,
    "customer": customer?.toJson(),
    "driver_number": driverNumber,
    "receipt_number": receiptNumber,
    "chasis_number": chasisNumber,
    "vehicle_type_id": vehicleTypeId,
    "customer_type_id": customerTypeId,
    "sale_type": saleType,
    "trailerno": trailerno,
    "start_date_time": startDateTime,
    "end_date": endDate,
    "slaves": slaves == null ? [] : List<dynamic>.from(slaves!.map((x) => x.toJson())),
  };
}

class Borderr {
  int? borderId;
  String? borderName;

  Borderr({
    this.borderId,
    this.borderName,
  });

  factory Borderr.fromJson(Map<String, dynamic> json) => Borderr(
    borderId: json["border_id"],
    borderName: json["border_name"],
  );

  Map<String, dynamic> toJson() => {
    "border_id": borderId,
    "border_name": borderName,
  };
}

class Customerr {
  int? customerId;
  String? customerName;

  Customerr({
    this.customerId,
    this.customerName,
  });

  factory Customerr.fromJson(Map<String, dynamic> json) => Customerr(
    customerId: json["customer_id"],
    customerName: json["customer_name"],
  );

  Map<String, dynamic> toJson() => {
    "customer_id": customerId,
    "customer_name": customerName,
  };
}

class Devicer {
  int? deviceId;
  String? deviceSerial;

  Devicer({
    this.deviceId,
    this.deviceSerial,
  });

  factory Devicer.fromJson(Map<String, dynamic> json) => Devicer(
    deviceId: json["device_id"],
    deviceSerial: json["device_serial"],
  );

  Map<String, dynamic> toJson() => {
    "device_id": deviceId,
    "device_serial": deviceSerial,
  };
}

class Portr {
  int? portPointId;
  String? portPointName;

  Portr({
    this.portPointId,
    this.portPointName,
  });

  factory Portr.fromJson(Map<String, dynamic> json) => Portr(
    portPointId: json["port_point_id"],
    portPointName: json["port_point_name"],
  );

  Map<String, dynamic> toJson() => {
    "port_point_id": portPointId,
    "port_point_name": portPointName,
  };
}

class Slaver {
  int? id;
  String? serialNo;

  Slaver({
    this.id,
    this.serialNo,
  });

  factory Slaver.fromJson(Map<String, dynamic> json) => Slaver(
    id: json["id"],
    serialNo: json["serial_no"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "serial_no": serialNo,
  };
}
