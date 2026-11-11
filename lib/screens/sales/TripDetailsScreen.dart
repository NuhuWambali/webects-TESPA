// screens/sales/trip_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constant/colorcontant.dart';
import '../../model/trip.dart';
import '../../controller/controllerconstant.dart';

class TripDetailScreen extends StatelessWidget {
  final Trip trip;

  const TripDetailScreen({super.key, required this.trip});

  /// New function: print only the trip details for duplicate receipt
  Future<void> printDuplicateReceipt(Trip trip) async {
    Map<String, dynamic> receiptData = {
      "branchId": apiController.userdata.value.branch ?? 1,
      "driver_name": trip.driverName ?? "N/A",
      "driver_number": trip.driverMobile ?? "N/A",
      "passport": trip.driverPassport ?? "N/A",
      "vehicle_number": trip.vehicleNo ?? "N/A",
      "trailerno": trip.trailerNo ?? "N/A",
      "container_number": trip.containerNo ?? "N/A",
      "company_name": trip.customerName ?? "N/A",
      "agent": trip.agentName ?? "N/A",
      "receipt_number": trip.receiptNo ?? "N/A",
      "borderName": trip.borderName ?? "N/A",
      "gateName": trip.gateName ?? "N/A",
      "tzl": apiController.tzdl.value,
      "offline_receipt_number": trip.receiptNo ?? "N/A",
      "prev_offline_receipt_number": "N/A",
      "chasis_number": "",
      "sale_date": trip.startDate ?? "N/A",
      "end_date": trip.endDate ?? "N/A",
      "sale_type": "CASH",
      "slaves": trip.slaves.map((s) => {"serial_no": s}).toList(),
      "master_device": trip.master ?? "N/A",
      "amount": "2000",
      "serial_no": "2000",
      "tagger":apiController.userdata.value.name ?? '',
      "currency": "TZS",
    };

    const platform = MethodChannel('com.webcorp.ects/ReceiptCoppy');

    try {
      final int result = await platform.invokeMethod('receiptPrint', receiptData);
      print('Duplicate receipt printed successfully, result: $result');
    } on PlatformException catch (e) {
      print("Failed to print: '${e.message}'.");
    }
  }

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Text(title,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal)),
  );

  Widget _detailRow(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text('$label:',
              style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                  fontSize: 14)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(value,
              style: const TextStyle(color: Colors.black87, fontSize: 14)),
        ),
      ],
    ),
  );

  Widget _infoCard(Widget child) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: child,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            // Top header
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: primarycolor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 20,
                    left: 20,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child:
                            const Icon(Icons.arrow_back, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text('Trip Details',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Trip No: ${trip.tripNo}',
                          style: const TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text('${trip.gateName} → ${trip.borderName}',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.white70)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Positioned(
              top: 160,
              left: 16,
              right: 16,
              bottom: 16,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4))
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status and Basic Info Card
                      _infoCard(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: trip.status == 'Created'
                                        ? Colors.green.shade100
                                        : Colors.orange.shade100,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    trip.status,
                                    style: TextStyle(
                                      color: trip.status == 'Created'
                                          ? Colors.green.shade800
                                          : Colors.orange.shade800,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(trip.receiptNo,
                                    style: const TextStyle(color: Colors.grey)),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _detailRow('Start Date', trip.startDate),
                            _detailRow('End Date', trip.endDate),
                            _detailRow('Merchant No', trip.merchantNo),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Route and Vehicle Info Card
                      _infoCard(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _sectionTitle('Route & Vehicle'),
                            _detailRow('From', trip.gateName),
                            _detailRow('To', trip.borderName),
                            _detailRow('Vehicle No', trip.vehicleNo),
                            if (trip.trailerNo != null &&
                                trip.trailerNo!.isNotEmpty)
                              _detailRow('Trailer No', trip.trailerNo!),
                            if (trip.containerNo != null &&
                                trip.containerNo!.isNotEmpty)
                              _detailRow('Container No', trip.containerNo!),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Customer and Cargo Info Card
                      _infoCard(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _sectionTitle('Customer & Cargo'),
                            _detailRow('Customer', trip.customerName),
                            _detailRow('Cargo Type', trip.cargoType),
                            _detailRow('Cargo Number', trip.cargoNo),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Agent Details Card
                      _infoCard(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _sectionTitle('Agent Details'),
                            _detailRow('Name', trip.agentName),
                            _detailRow('Phone', trip.agentPhoneNo),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Driver Details Card
                      _infoCard(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _sectionTitle('Driver Details'),
                            _detailRow('Name', trip.driverName),
                            _detailRow('Phone', trip.driverMobile),
                            _detailRow('License', trip.driverLicense),
                            _detailRow('Passport', trip.driverPassport),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Device Details Card
                      _infoCard(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _sectionTitle('Device Details'),
                            _detailRow('Master Device', trip.master),
                            _detailRow('Slave Devices', trip.slaves.join(', ')),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Swap Device functionality')));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primarycolor,
                                padding:
                                const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text('Swap Device',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () async {
                                await printDuplicateReceipt(trip);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Printing duplicate receipt...')));
                              },
                              style: OutlinedButton.styleFrom(
                                padding:
                                const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                side: BorderSide(color: primarycolor),
                              ),
                              child: Text('Reprint Receipt',
                                  style: TextStyle(color: primarycolor)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
