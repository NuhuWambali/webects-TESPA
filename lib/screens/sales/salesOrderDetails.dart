import 'dart:convert';
import 'package:ects/screens/sales/paymentLinkOrderPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant/colorcontant.dart';
import '../../generated/assets.dart';
import '../../services/remoteservice.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:get/get.dart';

class SalesOrderDetails extends StatefulWidget {
  final Map<String, dynamic> orderData;

  const SalesOrderDetails({super.key, required this.orderData});

  @override
  State<SalesOrderDetails> createState() => _SalesOrderDetailsState();
}

class _SalesOrderDetailsState extends State<SalesOrderDetails> {
  bool isLoading = false;

  Future<void> _generatePaymentLink() async {
    setState(() => isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt("userId") ?? 0;

      final payData = {
        "orderId": widget.orderData['id'],
        "userId": userId,
      };

      print("Payment request data: $payData");

      final response = await RemoteServices.payForOrder(payData);
      final decoded = jsonDecode(response ?? "{}");

      if (decoded['error'] == true) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.scale,
          title: 'Payment Failed',
          desc: decoded['details'] ?? 'Failed to generate payment link for this order',
          btnOkOnPress: () {},
        ).show();
      } else {
        final paymentUrl = decoded['url'];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentPage(paymentUrl: paymentUrl),
          ),
        );
      }
    } catch (e) {
      print("Payment error: $e");
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.scale,
        title: 'Error',
        desc: 'Something went wrong. Please try again.',
        btnOkOnPress: () {},
      ).show();
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = widget.orderData['products'] as List<dynamic>? ?? [];

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
                        "Order Details",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Icon(Icons.receipt_long, color: Colors.white, size: 80),
                ],
              ),
            ),

            // Order Details Card
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order ID: ${widget.orderData['name'] ?? ''}",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text("Customer: ${widget.orderData['customer_name'] ?? ''}"),
                    Text("Date: ${widget.orderData['date_order'] ?? ''}"),
                    Text("Total Amount: TZS ${widget.orderData['amount_total'] ?? ''}"),
                    Text("Payment Status: ${widget.orderData['payment_status_desc'] ?? ''}"),
                    const Divider(height: 30, thickness: 1),
                    const Text(
                      "Summary of selected devices and amount",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),

                    // Product list
                    Expanded(
                      child: ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              title: Text(product['product_name'] ?? ''),
                              subtitle: Text(
                                  "Quantity: ${product['quantity']}  |  Price: TZS ${product['price_unit']}"),
                              trailing: Text("Subtotal: TZS ${product['subtotal']}"),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _generatePaymentLink,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primarycolor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: isLoading
                            ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                )),
                            SizedBox(width: 12),
                            Text("Generating Payment Link...", style: TextStyle(fontSize: 16)),
                          ],
                        )
                            : const Text(
                          "Generate Payment Link",
                          style: TextStyle(fontSize: 18, color: Colors.white),
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
