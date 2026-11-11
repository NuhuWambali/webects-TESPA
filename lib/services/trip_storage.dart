// services/trip_storage.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/trip.dart';

class TripStorage {
  static String _getUserKey(String userId) => "trips_user_$userId";

  // Save a trip for a specific user
  static Future<void> saveTrip(Trip trip) async {
    final prefs = await SharedPreferences.getInstance();
    final userKey = _getUserKey(trip.userId);
    final trips = await getTripsByUserId(trip.userId);

    // Check if trip already exists (update if it does)
    final existingIndex = trips.indexWhere((t) => t.tripNo == trip.tripNo);
    if (existingIndex != -1) {
      trips[existingIndex] = trip;
    } else {
      trips.insert(0, trip); // add new trip at the top
    }

    if (trips.length > 50) trips.removeLast(); // keep only 50

    final encoded = trips.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(userKey, encoded);
  }

  // Get all trips for a specific user
  static Future<List<Trip>> getTripsByUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final userKey = _getUserKey(userId);
    final List<String>? data = prefs.getStringList(userKey);

    if (data == null) return [];
    return data.map((e) => Trip.fromJson(jsonDecode(e))).toList();
  }

  // Get a specific trip by trip number for a user
  static Future<Trip?> getTripByTripNo(String userId, String tripNo) async {
    final trips = await getTripsByUserId(userId);
    try {
      return trips.firstWhere((trip) => trip.tripNo == tripNo);
    } catch (e) {
      return null; // No trip found
    }
  }

  // Get a specific trip by salesTripId for a user - FIXED VERSION
  static Future<Trip?> getTripBySalesId(String userId, int salesTripId) async {
    final trips = await getTripsByUserId(userId);
    try {
      return trips.firstWhere((trip) => trip.salesTripId == salesTripId);
    } catch (e) {
      return null; // No trip found
    }
  }

  // Check if a trip number already exists for a user
  static Future<bool> doesTripNoExist(String userId, String tripNo) async {
    final trips = await getTripsByUserId(userId);
    return trips.any((trip) => trip.tripNo == tripNo);
  }

  // Update a trip
  static Future<void> updateTrip(Trip updatedTrip) async {
    final prefs = await SharedPreferences.getInstance();
    final userKey = _getUserKey(updatedTrip.userId);
    final trips = await getTripsByUserId(updatedTrip.userId);

    // Remove the old trip and add the updated one
    trips.removeWhere((trip) => trip.tripNo == updatedTrip.tripNo);
    trips.insert(0, updatedTrip);

    final encoded = trips.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(userKey, encoded);
  }

  // Delete a trip
  static Future<void> deleteTrip(String userId, String tripNo) async {
    final prefs = await SharedPreferences.getInstance();
    final userKey = _getUserKey(userId);
    final trips = await getTripsByUserId(userId);

    trips.removeWhere((trip) => trip.tripNo == tripNo);

    final encoded = trips.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(userKey, encoded);
  }

  // Clear all trips for a user
  static Future<void> clearUserTrips(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final userKey = _getUserKey(userId);
    await prefs.remove(userKey);
  }
}