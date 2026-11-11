import 'package:ects/constant/apiconstant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ects/constant/colorcontant.dart';
import 'package:ects/generated/assets.dart';
import 'package:ects/services/remoteservice.dart';

class DeviceSwappingPage extends StatefulWidget {
  final String tripNo;
  final String device;
  final List<String> slaves;

  const DeviceSwappingPage({
    Key? key,
    required this.tripNo,
    required this.device,
    required this.slaves,
  }) : super(key: key);

  @override
  _DeviceSwappingPageState createState() => _DeviceSwappingPageState();
}

class _DeviceSwappingPageState extends State<DeviceSwappingPage> {
  List<Map<String, dynamic>> masterDevices = [];
  List<Map<String, dynamic>> slaveDevices = [];
  String? selectedMasterDevice;
  List<String> selectedSlaveDevices = [];
  bool isLoading = true;
  bool masterDevicesLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  Future<void> _loadDevices() async {
    try {
      await _loadMasterDevices();
      await _loadSlaveDevices();

      // Only prefill once
      setState(() {
        if (selectedMasterDevice == null) selectedMasterDevice = widget.device;
        if (selectedSlaveDevices.isEmpty) selectedSlaveDevices = List.from(widget.slaves);
        isLoading = false;
      });
    } catch (e) {
      print("Error loading devices: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> _loadMasterDevices() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt("userId") ?? 0;
      final response = await RemoteServices.master(userId.toString());
      if (response != null) {
        final data = jsonDecode(response);
        setState(() {
          masterDevices = (data['devices'] as List)
              .map<Map<String, dynamic>>((item) => {
            "id": item['id'],
            "serial_no": item['serial_no'],
          })
              .toList();
          masterDevicesLoaded = true;
        });
      }
    } catch (e) {
      print("Error fetching master devices: $e");
    }
  }

  Future<void> _loadSlaveDevices() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt("userId") ?? 0;
      final response = await RemoteServices.slave(userId.toString());
      if (response != null) {
        final data = jsonDecode(response);
        setState(() {
          slaveDevices = (data['devices'] as List)
              .map<Map<String, dynamic>>((item) => {
            "id": item['id'].toString(),
            "serial_no": item['serial_no'],
          })
              .toList();
        });
      }
    } catch (e) {
      print("Error fetching slave devices: $e");
    }
  }

  Future<void> _confirmAndSubmit() async {
    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.help_outline, color: Colors.orange, size: 60),
              const SizedBox(height: 16),
              const Text(
                "Confirm Device Swapping",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                "Are you sure you want to swap these devices?",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text("No", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text("Yes", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );

    if (confirm != true) return;

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("Device Swapping in progress...", style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );

    // Submit request
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt("userId") ?? 0;

      final payload = {
        "userId": userId,
        "tripNo": widget.tripNo,
        "masterSerialNo": selectedMasterDevice,
        "slaveSerialNo": selectedSlaveDevices.join(","),
      };

      print("Submitting device swapping: $payload");

      final uri = Uri.parse(Apindpoint.BASE_URL).replace(
        queryParameters: {"r": "gateway/post-records"},
      );

      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "message-type": "CREATE_DEVICE_SWAPPING",
        },
        body: jsonEncode(payload),
      );

      // Close loading
      Navigator.of(context).pop();

      // Show result
      if (response.statusCode == 200) {
        await showDialog(context: context, builder: (_) => _resultDialog(
          title: "Success",
          message: "Device swapping confirmed!",
          icon: Icons.check_circle,
          color: Colors.green,
        ));
        Navigator.pop(context);
      } else {
        final error = jsonDecode(response.body)['details'] ?? response.reasonPhrase;
        await showDialog(context: context, builder: (_) => _resultDialog(
          title: "Error",
          message: error.toString(),
          icon: Icons.error,
          color: Colors.red,
        ));
      }
    } catch (e) {
      Navigator.of(context).pop();
      await showDialog(context: context, builder: (_) => _resultDialog(
        title: "Error",
        message: e.toString(),
        icon: Icons.error,
        color: Colors.red,
      ));
    }
  }

  Widget _resultDialog({required String title, required String message, required IconData icon, required Color color}) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 60),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text("OK", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            // Top header
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
                        "Device Swapping",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Icon(Icons.swap_horiz, color: Colors.white, size: 80),
                ],
              ),
            ),

            // Main content
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
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
                ),
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Device Swapping for Trip No: ${widget.tripNo}",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    if (masterDevicesLoaded && masterDevices.isNotEmpty) ...[
                      const Text("Master Device:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
                        child: DropdownButton<String>(
                          value: masterDevices.any((d) => d['serial_no'] == selectedMasterDevice) ? selectedMasterDevice : null,
                          isExpanded: true,
                          underline: const SizedBox(),
                          items: masterDevices.map((device) {
                            return DropdownMenuItem<String>(
                              value: device['serial_no'],
                              child: Text(device['serial_no']),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedMasterDevice = newValue;
                            });
                          },
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    const Text("Slave Devices:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Expanded(
                      child: slaveDevices.isNotEmpty
                          ? ListView.builder(
                        itemCount: slaveDevices.length,
                        itemBuilder: (context, index) {
                          final device = slaveDevices[index]['serial_no'];
                          final isSelected = selectedSlaveDevices.contains(device);
                          return CheckboxListTile(
                            title: Text(device),
                            value: isSelected,
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) selectedSlaveDevices.add(device);
                                else selectedSlaveDevices.remove(device);
                              });
                            },
                          );
                        },
                      )
                          : const Center(child: Text("No slave devices available")),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: primarycolor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: _confirmAndSubmit,
                        child: const Text(
                          "Confirm Swapping",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
