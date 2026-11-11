class SaleAdd {
  String? receiptNo;
  String? offline_receipt_number;
  String? customerName;
  String? driverName;
  String? driverMobile;
  String? driverLicense;
  String? driverPassport;
  String? vehicleNo;
  String? trailerNo;
  String? containerNo;
  String? cargoType;
  String? cargoNo;
  String? gateName;
  String? borderName;
  String? agentName;
  String? agentPhoneNo;
  String? master;
  List<String>? slaves;

  SaleAdd({
    this.receiptNo,
    this.offline_receipt_number,
    this.customerName,
    this.driverName,
    this.driverMobile,
    this.driverLicense,
    this.driverPassport,
    this.vehicleNo,
    this.trailerNo,
    this.containerNo,
    this.cargoType,
    this.cargoNo,
    this.gateName,
    this.borderName,
    this.agentName,
    this.agentPhoneNo,
    this.master,
    this.slaves,
  });

  /// ✅ Add this factory to parse API response
  factory SaleAdd.fromApi(Map<String, dynamic> json) {
    return SaleAdd(
      receiptNo: json['receiptNo']?.toString(),
      customerName: json['customerName']?.toString(),
      driverName: json['driverName']?.toString(),
      driverMobile: json['driverMobile']?.toString(),
      driverLicense: json['driverLicense']?.toString(),
      driverPassport: json['driverPassport']?.toString(),
      vehicleNo: json['vehicleNo']?.toString(),
      trailerNo: json['trailerNo']?.toString(),
      containerNo: json['containerNo']?.toString(),
      cargoType: json['cargoType']?.toString(),
      cargoNo: json['cargoNo']?.toString(),
      gateName: json['gateName']?.toString(),
      borderName: json['borderName']?.toString(),
      agentName: json['agentName']?.toString(),
      agentPhoneNo: json['agentPhoneNo']?.toString(),
      master: json['master']?.toString(),
      slaves: (json['slaves'] as String?)?.split(",").map((e) => e.trim()).toList() ?? [],
    );
  }

  Map<String, dynamic> tooMap() {
    return {
      "receiptNo": receiptNo,
      "customerName": customerName,
      "driverName": driverName,
      "driverMobile": driverMobile,
      "driverLicense": driverLicense,
      "driverPassport": driverPassport,
      "vehicleNo": vehicleNo,
      "trailerNo": trailerNo,
      "containerNo": containerNo,
      "cargoType": cargoType,
      "cargoNo": cargoNo,
      "gateName": gateName,
      "borderName": borderName,
      "agentName": agentName,
      "agentPhoneNo": agentPhoneNo,
      "master": master,
      "slaves": slaves,
    };
  }
}
