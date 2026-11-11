import 'package:ects/screens/sales/createTripWithRef.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'dart:convert';
import '../../constant/colorcontant.dart';
import '../../generated/assets.dart';
import '../../services/remoteservice.dart';
import 'createTrip.dart';

class PaymentVerificationScreen extends StatefulWidget {
  const PaymentVerificationScreen({super.key});

  @override
  State<PaymentVerificationScreen> createState() =>
      _PaymentVerificationScreenState();
}

class _PaymentVerificationScreenState
    extends State<PaymentVerificationScreen> {
  final TextEditingController _refController = TextEditingController();
  bool _isLoading = false;
  String paymentRef = 'No reference';

  @override
  void initState() {
    super.initState();
    _loadPaymentRef();
  }

  Future<void> _loadPaymentRef() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      paymentRef = prefs.getString('paymentRef') ?? 'No reference';
      print("Received payment ref number: $paymentRef");
    });
  }

  void _showDialog(
      String title,
      String message, {
        String? details,
        bool isSuccess = true,
        VoidCallback? onConfirm,
      }) {
    AwesomeDialog(
      context: context,
      dialogType: isSuccess ? DialogType.success : DialogType.error,
      animType: AnimType.scale,
      title: title,
      desc: details != null ? "$message\nDetails: $details" : message,
      btnCancelOnPress: () {},
      btnOkOnPress: onConfirm ?? () {},
      btnOkText: 'OK',
      btnCancelText: 'CANCEL',
    ).show();
  }

  Future<void> _verifyPayment() async {
    if (_refController.text.trim().isEmpty) {
      _showDialog("Error", "Please enter reference number", isSuccess: false);
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('paymentRef', _refController.text.trim());

    setState(() => _isLoading = true);

    try {
      final userId = prefs.getInt('userId');
      if (userId == null) {
        setState(() => _isLoading = false);
        _showDialog("Error", "User not logged in", isSuccess: false);
        return;
      }

      final jsonString = await RemoteServices.verifyPayment(
        userId,
        _refController.text.trim(),
      );

      setState(() => _isLoading = false);

      final response = jsonDecode(jsonString ?? '{}');
      final payment = response['data']?['payment'];

      // if (payment != null) {
      //   _showDialog(
      //     "Success",
      //     "Payment verified successfully!\nCustomer: ${payment['customer_name']}\nTotal: ${payment['total_balance']}",
      //     isSuccess: true,
      //     onConfirm: () {
      //       final devices = response['data']?['devices'];
      //       final masterEmpty = devices?['master'] == null || devices['master'].isEmpty;
      //       final slavesEmpty = devices?['slaves'] == null || (devices['slaves'] as List).isEmpty;
      //
      //
      //       // Case 1: devices is an empty string or null
      //       final noDevices = devices == null || devices is String || devices.isEmpty;
      //
      //       if (noDevices) {
      //         // go to CreateTripScreenWithRef
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => CreateTripScreenWithRef(
      //               paymentData: {
      //                 'payment': payment,
      //                 'customer': response['data']?['customer'],
      //                 'devices': devices,
      //               },
      //             ),
      //           ),
      //         );
      //       } else {
      //         // Case 2: devices is a map, check master/slaves inside it
      //         final masterEmpty = devices['master'] == null || devices['master'].isEmpty;
      //         final slavesEmpty = devices['slaves'] == null || (devices['slaves'] as List).isEmpty;
      //
      //         if (masterEmpty && slavesEmpty) {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (context) => CreateTripScreenWithRef(
      //                 paymentData: {
      //                   'payment': payment,
      //                   'customer': response['data']?['customer'],
      //                   'devices': devices,
      //                 },
      //               ),
      //             ),
      //           );
      //         } else {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (context) => CreateTripScreen(
      //                 paymentData: {
      //                   'payment': payment,
      //                   'customer': response['data']?['customer'],
      //                   'devices': devices,
      //                 },
      //               ),
      //             ),
      //           );
      //         }
      //       }
      //
      //     },
      //   );
      // } else {
      //   _showDialog(
      //     "Error",
      //     response['message'] ?? "Payment verification failed",
      //     details: response['details'],
      //     isSuccess: false,
      //   );
      // }
      if (payment != null) {
        _showDialog(
          "Success",
          "Payment verified successfully!\nCustomer: ${payment['customer_name']}\nTotal: ${payment['total_balance']}",
          isSuccess: true,
          onConfirm: () {
            dynamic devicesRaw = response['data']?['devices'];
            dynamic customerRaw = response['data']?['customer'];

            // Normalize devices
            final devices = (devicesRaw is Map<String, dynamic>)
                ? devicesRaw
                : {
              "master": null,
              "slaves": [],
            };

            // Normalize customer
            final customer = (customerRaw is Map<String, dynamic>)
                ? customerRaw
                : {
              "customerId": payment['customer_id'],
              "customerName": payment['customer_name'],
            };

            final masterEmpty =
                devices['master'] == null || devices['master'].toString().isEmpty;
            final slavesEmpty = devices['slaves'] == null ||
                (devices['slaves'] is List && devices['slaves'].isEmpty);

            if (masterEmpty || slavesEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateTripWithRefScreen(
                    paymentData: {
                      'payment': payment,
                      'customer': customer,
                      'devices': devices,
                    },
                  ),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateTripScreen(
                    paymentData: {
                      'payment': payment,
                      'customer': customer,
                      'devices': devices,
                    },
                  ),
                ),
              );
            }
          },
        );
      } else {
        _showDialog(
          "Error",
          response['message'] ?? "Payment verification failed",
          details: response['details'],
          isSuccess: false,
        );
      }





    } catch (e) {
      setState(() => _isLoading = false);
      _showDialog(
        "Error",
        "An unexpected error occurred",
        details: e.toString(), // show exception details
        isSuccess: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            _buildHeader(context),
            Positioned(
              top: 200,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Enter Reference Number To Verify',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    _buildInputField(
                      label: 'Payment Reference Number',
                      hint: 'Enter Reference Number',
                      icon: Icons.receipt,
                      controller: _refController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primarycolor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _isLoading ? null : _verifyPayment,
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                          'VERIFY PAYMENT',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
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
                    'Payment Verification',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Icon(Icons.verified, color: Colors.white, size: 80),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: primarycolor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: primarycolor),
            ),
          ),
          inputFormatters: inputFormatters,
        ),
      ],
    );
  }
}
