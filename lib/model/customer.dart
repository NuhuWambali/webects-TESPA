// To parse this JSON data, do
//
//     final customer = customerFromJson(jsonString);

import 'dart:convert';

Customer customerFromJson(String str) => Customer.fromJson(json.decode(str));

String customerToJson(Customer data) => json.encode(data.toJson());

class Customer {
  List<CustomerElement>? customers;

  Customer({
    this.customers,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    customers: json["customers"] == null ? [] : List<CustomerElement>.from(json["customers"]!.map((x) => CustomerElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "customers": customers == null ? [] : List<dynamic>.from(customers!.map((x) => x.toJson())),
  };
}

class CustomerElement {
  int? id;
  String? companyName;

  CustomerElement({
    this.id,
    this.companyName,
  });

  factory CustomerElement.fromJson(Map<String, dynamic> json) => CustomerElement(
    id: json["id"],
    companyName: json["company_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "company_name": companyName,
  };
}
