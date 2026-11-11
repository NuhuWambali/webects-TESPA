import 'package:ects/screens/sales/paymentVerification.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constant/colorcontant.dart';
import '../../generated/assets.dart';

class PaymentPage extends StatelessWidget {
  final String paymentUrl;

  const PaymentPage({super.key, required this.paymentUrl});

  Future<void> _openPaymentUrl(BuildContext context) async {
    final Uri uri = Uri.parse(paymentUrl);

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri); // opens the link in the browser
        Navigator.pop(context); // remove loader

        // Navigate to Payment Verification
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const PaymentVerificationScreen(),
          ),
        );
      } else {
        Navigator.pop(context);
        throw 'Could not launch $paymentUrl';
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to open link: $e")),
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
                        "Payment",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Icon(Icons.payment, color: Colors.white, size: 80),
                ],
              ),
            ),

            // Payment Button Card
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Click the button below to open the payment gateway in your browser. After completing the payment, you should verify your payment status.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _openPaymentUrl(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primarycolor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Click here to Pay",
                          style: TextStyle(fontSize: 18, color: Colors.white),
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
}
