// models/trip.dart
class Trip {
  final String tripNo;
  final String vehicleNo;
  final String? trailerNo;
  final String? containerNo;
  final String customerName;
  final String startDate;
  final String endDate;
  final String status;
  final String merchantNo;
  final String receiptNo;
  final String agentName;
  final String agentPhoneNo;
  final String driverName;
  final String driverMobile;
  final String driverLicense;
  final String driverPassport;
  final String cargoType;
  final String cargoNo;

  final String gateName;
  final String borderName;
  final String master;
  final List<String> slaves;
  final String userId;
  final int? salesTripId; // Added based on API response

  Trip({
    required this.tripNo,
    required this.vehicleNo,
    this.trailerNo,
    this.containerNo,
    required this.customerName,
    required this.startDate,
    required this.endDate,
    required this.status,

    required this.merchantNo,
    required this.receiptNo,
    required this.agentName,
    required this.agentPhoneNo,
    required this.driverName,
    required this.driverMobile,
    required this.driverLicense,
    required this.driverPassport,
    required this.cargoType,
    required this.cargoNo,
    required this.gateName,
    required this.borderName,
    required this.master,
    required this.slaves,
    required this.userId,
    this.salesTripId,
  });

  Map<String, dynamic> toJson() {
    return {
      'tripNo': tripNo,
      'vehicleNo': vehicleNo,
      'trailerNo': trailerNo,
      'containerNo': containerNo,
      'customerName': customerName,
      'startDate': startDate,
      'endDate': endDate,
      'status': status,
      'merchantNo': merchantNo,
      'receiptNo': receiptNo,
      'agentName': agentName,
      'agentPhoneNo': agentPhoneNo,
      'driverName': driverName,
      'driverMobile': driverMobile,
      'driverLicense': driverLicense,
      'driverPassport': driverPassport,
      'cargoType': cargoType,
      'cargoNo': cargoNo,
      'gateName': gateName,

      'borderName': borderName,
      'master': master,
      'slaves': slaves,
      'userId': userId,
      'salesTripId': salesTripId,
    };
  }

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      tripNo: json['tripNo'] ?? '',
      vehicleNo: json['vehicleNo'] ?? '',
      trailerNo: json['trailerNo'],
      containerNo: json['containerNo'],
      customerName: json['customerName'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      status: json['status'] ?? 'Created',
      merchantNo: json['merchantNo'] ?? '',
      receiptNo: json['receiptNo'] ?? '',
      agentName: json['agentName'] ?? '',
      agentPhoneNo: json['agentPhoneNo'] ?? '',
      driverName: json['driverName'] ?? '',

      driverMobile: json['driverMobile'] ?? '',
      driverLicense: json['driverLicense'] ?? '',
      driverPassport: json['driverPassport'] ?? '',
      cargoType: json['cargoType'] ?? '',
      cargoNo: json['cargoNo'] ?? '',
      gateName: json['gateName'] ?? '',
      borderName: json['borderName'] ?? '',
      master: json['master'] ?? '',
      slaves: (json['slaves'] is String)
          ? (json['slaves'] as String).split(',').map((e) => e.trim()).toList()
          : List<String>.from(json['slaves'] ?? []),
      userId: json['userId'] ?? '',
      salesTripId: json['salesTripId'],
    );
  }

  // Helper method to create Trip from API response
  factory Trip.fromApiResponse(Map<String, dynamic> receipt, String userId) {
    return Trip(
      tripNo: receipt["tripNo"] ?? '',
      vehicleNo: receipt["vehicleNo"] ?? '',
      trailerNo: receipt["trailerNo"],
      containerNo: receipt["containerNo"],
      customerName: receipt["customerName"] ?? '',
      startDate: receipt["startDate"] ?? '',
      endDate: receipt["endDate"] ?? '',
      status: "Created",

      merchantNo: receipt["merchantNo"] ?? '',
      receiptNo: receipt["receiptNo"] ?? '',
      agentName: receipt["agentName"] ?? '',
      agentPhoneNo: receipt["agentPhoneNo"] ?? '',
      driverName: receipt["driverName"] ?? '',
      driverMobile: receipt["driverMobile"] ?? '',
      driverLicense: receipt["driverLicense"] ?? '',
      driverPassport: receipt["driverPassport"] ?? '',
      cargoType: receipt["cargoType"] ?? '',
      cargoNo: receipt["cargoNo"] ?? '',
      gateName: receipt["gateName"] ?? '',
      borderName: receipt["borderName"] ?? '',
      master: receipt["master"] ?? '',
      slaves: (receipt["slaves"] is String)
          ? (receipt["slaves"] as String).split(',').map((e) => e.trim()).toList()
          : List<String>.from(receipt["slaves"] ?? []),
      userId: userId,
      salesTripId: receipt["salesTripId"],
    );
  }
}