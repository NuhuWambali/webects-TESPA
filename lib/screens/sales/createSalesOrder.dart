import 'dart:convert';
import 'package:ects/screens/sales/salesOrderDetails.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import '../../constant/colorcontant.dart';
import '../../generated/assets.dart';
import 'package:ects/services/remoteservice.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:get/get.dart';
import 'package:dropdown_search/dropdown_search.dart';

class Customer {
  final int id;
  final String name;

  Customer({required this.id, required this.name});

  @override
  String toString() => name; // Needed for dropdown_search to display properly
}

class CreateSalesOrder extends StatefulWidget {
  const CreateSalesOrder({super.key});

  @override
  State<CreateSalesOrder> createState() => _CreateSalesOrderState();
}

class _CreateSalesOrderState extends State<CreateSalesOrder> {
  final _formKey = GlobalKey<FormState>();

  final SingleValueDropDownController _customerController =
      SingleValueDropDownController();
  final SingleValueDropDownController _masterDeviceController =
      SingleValueDropDownController();
  final List<Map<String, dynamic>> _selectedSlaveDevices = [];

  List<Map<String, dynamic>> customers = [];
  List<Map<String, dynamic>> masterDevices = [];
  List<Map<String, dynamic>> slaveDevices = [];

  @override
  void initState() {
    super.initState();
    _loadCustomers();
    _loadMasterDevices();
    _loadSlaveDevices();
  }

  Future<void> _loadCustomers() async {
    try {
      final response = await RemoteServices.getEctsCustomerTespa(1);
      if (response != null) {
        final data = jsonDecode(response);
        setState(() {
          customers = (data['data'] as List)
              .map<Map<String, dynamic>>((item) => {
                    "id": item['id'],
                    "name": item['name'],
                  })
              .toList();
        });
      }
    } catch (e) {
      print("Error fetching customers: $e");
      setState(() => customers = []);
    }
  }

  Future<void> _loadMasterDevices() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt("userId") ?? 0;
      print("Fetching master devices for userId: $userId");

      final response = await RemoteServices.master(userId.toString());
      print("Raw response from master API: $response");

      if (response != null) {
        final data = jsonDecode(response);
        print("Decoded master API data: $data");

        final loadedDevices = (data['devices'] as List)
            .map<Map<String, dynamic>>((item) => {
                  "id": item['id'],
                  "serial_no": item['serial_no'],
                })
            .toList();

        print("Mapped master devices list: $loadedDevices");

        setState(() {
          masterDevices = loadedDevices;

          if (masterDevices.isNotEmpty) {
            _masterDeviceController.dropDownValue = DropDownValueModel(
              name: masterDevices[0]['serial_no'],
              value: masterDevices[0]['id'],
            );
            print(
                "Master dropdown value set to: ${_masterDeviceController.dropDownValue}");
          } else {
            print("No master devices found to set in dropdown.");
          }
        });
      } else {
        print("Master API returned null response");
        setState(() => masterDevices = []);
      }
    } catch (e) {
      print("Error fetching master devices: $e");
      setState(() => masterDevices = []);
    }
  }

  Future<void> _loadSlaveDevices() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt("userId") ?? 0;
      print("Fetching slave devices for userId: $userId");

      final response = await RemoteServices.slave(userId.toString());
      print("Raw response from slave API: $response");

      if (response != null) {
        final data = jsonDecode(response);
        print("Decoded slave API data: $data");

        final loadedDevices = (data['devices'] as List)
            .map<Map<String, dynamic>>((item) => {
                  "id": item['id'].toString(),
                  "serial_no": item['serial_no'],
                })
            .toList();

        print("Mapped slave devices list: $loadedDevices");

        setState(() {
          slaveDevices = loadedDevices;
        });
      } else {
        print("Slave API returned null response");
        setState(() => slaveDevices = []);
      }
    } catch (e) {
      print("Error fetching slave devices: $e");
      setState(() => slaveDevices = []);
    }
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      print("Form is invalid");
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt("userId") ?? 0;

    final formData = {
      "customer": {
        "customerId": _customerController.dropDownValue?.value ?? 0,
        "customerName": _customerController.dropDownValue?.name ?? "",
      },
      "devices": {
        "master": masterDevices.isEmpty
            ? {"id": '', "serial_no": 'No devices available'}
            : {
                "id": _masterDeviceController.dropDownValue?.value ?? '',
                "serial_no": _masterDeviceController.dropDownValue?.name ?? '',
              },
        "slaves": slaveDevices.isEmpty
            ? []
            : _selectedSlaveDevices
                .map((device) => {"serial_no": device['serial_no']})
                .toList(),
      },
      "userId": userId.toString(),
    };

    print("Debug: JSON being sent:");
    print(jsonEncode(formData));

    // Show loader
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Dialog(
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              "Creating order...",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );

    try {
      final response = await RemoteServices.createSalesOrder(formData);
      Navigator.of(context).pop(); // close loader

      print("Debug: API Response received:");
      print(response);

      final decoded = jsonDecode(response!);

      if (decoded['error'] == true) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.scale,
          title: 'Error',
          desc: decoded['message'] ?? 'Failed to create order',
          btnOkOnPress: () {},
        ).show();
      } else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.scale,
          title: 'Success',
          desc: decoded['message'] ?? 'Order created successfully',
          btnOkOnPress: () {
            _customerController.dropDownValue = null;
            _masterDeviceController.dropDownValue = null;
            _selectedSlaveDevices.clear();
            Get.to(() => SalesOrderDetails(orderData: decoded['data']));
          },
        ).show();
      }
    } catch (e) {
      Navigator.of(context).pop(); // close loader
      print("Debug: Error sending API request: $e");
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.scale,
        title: 'Error',
        desc: 'Something went wrong. Please try again.',
        btnOkOnPress: () {},
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
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
                        "Create Sales Order",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Icon(Icons.ad_units, color: Colors.white, size: 80),
                ],
              ),
            ),
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
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Customer
                        DropDownTextField(
                          controller: _customerController,
                          clearOption: false,
                          enableSearch: true, // this enables the search box
                          dropDownItemCount: customers.length > 5 ? 5 : customers.length, // max 5 visible items
                          dropDownList: customers.isEmpty
                              ? [
                            DropDownValueModel(name: 'No customers available', value: '')
                          ]
                              : customers
                              .map((c) => DropDownValueModel(name: c['name'], value: c['id']))
                              .toList(),
                          validator: (value) {
                            if (customers.isNotEmpty && (value == null || value == '')) {
                              return "Please select a customer";
                            }
                            return null;
                          },
                          textFieldDecoration: InputDecoration(
                            labelText: customers.isEmpty ? 'No customers available' : 'Select Customer',
                            border: const OutlineInputBorder(),
                          ),
                        ),


                        const SizedBox(height: 16),

                        // Master Device (without info button)
                        DropDownTextField(
                          controller: _masterDeviceController,
                          clearOption: false,
                          readOnly: true, // always read-only
                          enableSearch: true, // searchable dropdown
                          dropDownItemCount: 5, // max visible items
                          dropDownList: masterDevices.isEmpty
                              ? [
                            DropDownValueModel(name: 'No devices available', value: '')
                          ]
                              : masterDevices
                              .map((d) => DropDownValueModel(name: d['serial_no'], value: d['id']))
                              .toList(),
                          validator: (value) {
                            if (masterDevices.isNotEmpty && (value == null || value == '')) {
                              return "Please select a master device";
                            }
                            return null;
                          },
                          textFieldDecoration: InputDecoration(
                            labelText: masterDevices.isEmpty ? 'No master devices available' : 'Select Master Device',
                            border: const OutlineInputBorder(),
                          ),
                        ),


                        const SizedBox(height: 16),

                        // Slave Devices
                        MultiSelectDialogField(
                          items: slaveDevices.isEmpty
                              ? [
                                  MultiSelectItem(
                                      {"serial_no": "No devices available"},
                                      "No devices available")
                                ]
                              : slaveDevices
                                  .map(
                                      (d) => MultiSelectItem(d, d['serial_no']))
                                  .toList(),
                          title: const Text("Select Slave Devices"),
                          selectedColor: primarycolor,
                          searchable: true,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          buttonIcon: const Icon(Icons.arrow_drop_down),
                          buttonText: Text(
                            slaveDevices.isEmpty
                                ? "No slave devices available"
                                : "Select Slave Devices",
                            style: const TextStyle(fontSize: 16),
                          ),
                          onConfirm: (results) {
                            if (slaveDevices.isEmpty) return;
                            _selectedSlaveDevices.clear();
                            _selectedSlaveDevices
                                .addAll(results.cast<Map<String, dynamic>>());
                          },
                        ),

                        const SizedBox(height: 24),

                        // Submit
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primarycolor,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: _submitForm,
                            child: const Text(
                              "Create Order",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
