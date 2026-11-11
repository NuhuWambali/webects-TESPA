class SaleAddTespa {
  final String? offlineReceiptNumber;
  final String? customerName;
  final String? master;
  final String? slaves;
  final String? gateName;
  final String? borderName;
  final String? tripNo;
  final String? vehicleNo;
  final String? trailerNo;
  final String? merchantNo;
  final String? receiptNo;
  final String? agentName;
  final String? agentPhoneNo;

  SaleAddTespa({
    this.offlineReceiptNumber,
    this.customerName,
    this.master,
    this.slaves,
    this.gateName,
    this.borderName,
    this.tripNo,
    this.vehicleNo,
    this.trailerNo,
    this.merchantNo,
    this.receiptNo,
    this.agentName,
    this.agentPhoneNo,
  });

  factory SaleAddTespa.fromApi(Map<String, dynamic> json) {
    return SaleAddTespa(
      customerName: json['customerName']?.toString(),
      master: json['master']?.toString(),
      slaves: json['slaves']?.toString(),
      gateName: json['gateName']?.toString(),
      borderName: json['borderName']?.toString(),
      tripNo: json['tripNo']?.toString(),
      vehicleNo: json['vehicleNo']?.toString(),
      trailerNo: json['trailerNo']?.toString(),
      merchantNo: json['merchantNo']?.toString(),
      receiptNo: json['receiptNo']?.toString(),
      agentName: json['agentName']?.toString(),
      agentPhoneNo: json['agentPhoneNo']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'offlineReceiptNumber': offlineReceiptNumber,
      'customerName': customerName,
      'master': master,
      'slaves': slaves,
      'gateName': gateName,
      'borderName': borderName,
      'tripNo': tripNo,
      'vehicleNo': vehicleNo,
      'trailerNo': trailerNo,
      'merchantNo': merchantNo,
      'receiptNo': receiptNo,
      'agentName': agentName,
      'agentPhoneNo': agentPhoneNo,
    };
  }
}
