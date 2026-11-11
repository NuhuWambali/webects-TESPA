// screens/sales/trip_list_screen.dart
import 'dart:convert';
import 'package:ects/screens/sales/TripDetailsScreen.dart';
import 'package:flutter/material.dart';
import 'package:ects/services/trip_storage.dart';
import 'package:ects/model/trip.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ects/constant/colorcontant.dart';
import '../../generated/assets.dart';

class TripListScreen extends StatefulWidget {
  const TripListScreen({super.key});

  @override
  State<TripListScreen> createState() => _TripListScreenState();
}

class _TripListScreenState extends State<TripListScreen> {
  List<Trip> _trips = [];
  bool _isLoading = true;
  String _userId = '';

  @override
  void initState() {
    super.initState();
    _loadTrips();
  }

  Future<void> _loadTrips() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt("userId")?.toString() ?? '';
    setState(() => _userId = userId);

    final trips = await TripStorage.getTripsByUserId(userId);

    // Debug full trip objects with pretty-printed JSON
    print('===== FULL TRIP OBJECTS JSON =====');
    for (var trip in trips) {
      final prettyJson = const JsonEncoder.withIndent('  ').convert(trip.toJson());
      print(prettyJson);
    }
    print('==================================');

    // Sort trips descending and take only latest 50
    trips.sort((a, b) => b.startDate.compareTo(a.startDate));
    final limitedTrips = trips.length > 50 ? trips.sublist(0, 50) : trips;

    setState(() {
      _trips = limitedTrips;
      _isLoading = false;
    });
  }

  Future<void> _refreshTrips() async {
    setState(() => _isLoading = true);
    await _loadTrips();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            // Top Header
            Container(
              height: 267,
              width: double.infinity,
              padding: const EdgeInsets.all(21),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Assets.iconsTopheader),
                  fit: BoxFit.fill,
                ),
              ),
            ),

            Positioned(
              top: MediaQuery.of(context).padding.top + 20,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const CircleAvatar(
                          backgroundColor: Colors.transparent,
                          foregroundImage: AssetImage(Assets.iconsBack),
                          radius: 17,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "My Trips",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Icon(Icons.local_shipping, color: Colors.white, size: 80),
                ],
              ),
            ),

            // Trips Card
            Positioned(
              top: 200,
              left: 20,
              right: 20,
              bottom: 20,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: whitecolor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _trips.isEmpty
                    ? const Center(
                    child: Text('No trips found', style: TextStyle(fontSize: 16)))
                    : RefreshIndicator(
                  onRefresh: _refreshTrips,
                  child: ListView.builder(
                    itemCount: _trips.length,
                    itemBuilder: (context, index) =>
                        _buildTripCard(_trips[index]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripCard(Trip trip) {
    Color statusColor = trip.status == 'Created' ? Colors.green : Colors.orange;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TripDetailScreen(trip: trip)),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Trip header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Trip #${trip.tripNo}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(trip.status,
                        style: TextStyle(
                            color: statusColor, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text('Vehicle: ${trip.vehicleNo}'),
              Text('Customer: ${trip.customerName}'),

              // Route From → To
              const SizedBox(height: 4),
              Text(
                'Route: ${trip.gateName} → ${trip.borderName}',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),

              Text('Start Date: ${trip.startDate}'),
              Text('End Date: ${trip.endDate}'),
              const SizedBox(height: 8),

              // Receipt
              Text('Receipt: ${trip.receiptNo}'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
