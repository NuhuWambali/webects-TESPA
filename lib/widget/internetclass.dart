
import 'dart:async';
import 'package:connectivity/connectivity.dart';

class InternetConnectionMonitor {
  static final InternetConnectionMonitor _singleton =
  InternetConnectionMonitor._internal();

  factory InternetConnectionMonitor() {
    return _singleton;
  }

  InternetConnectionMonitor._internal();

  StreamController<bool> connectionChangeController =
  StreamController<bool>.broadcast();

  final Connectivity _connectivity = Connectivity();

  void initialize() {
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      bool isConnected = result != ConnectivityResult.none;
      connectionChangeController.add(isConnected);
    });
  }

  Stream<bool> get connectionChange => connectionChangeController.stream;
}