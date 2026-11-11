
import 'package:ects/HomePage.dart';
import 'package:ects/screens/sales/createSalesOrder.dart';
import 'package:ects/screens/sales/paymentVerification.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../constant/colorcontant.dart';
import '../../generated/assets.dart';
import 'newsales.dart';

class SelectCustomerScreen extends StatelessWidget {
  const SelectCustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            // Background Image (matches your existing design)
            Stack(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                  ),
                ),


                Positioned(
                  top: MediaQuery.of(context).padding.top + 20,
                  left: 20,
                  right: 20, // allow centering across available width
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center, // center horizontally
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Material(
                                    color: Colors.transparent, // allow ripple to show
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(20), // match CircleAvatar
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => HomePage()),
                                        );
                                      },
                                      child: const CircleAvatar(
                                        backgroundColor: Colors.white, // non-transparent to show feedback
                                        foregroundImage: AssetImage(Assets.iconsBack),
                                        radius: 17,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                ],
                              );

                            },
                            child: GestureDetector(
                              onTap: () {
                                // Navigate to HomeScreen
                                Get.off(() => HomePage());
                              },
                              child: const CircleAvatar(
                                backgroundColor: Colors.transparent,
                                foregroundImage: AssetImage(Assets.iconsBack),
                                radius: 17,
                              ),
                            ),


                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Choose the type of Customer',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 80,
                      ),
                    ],
                  ),
                ),

              ],
            ),



            Positioned(
              top: 200,
              left: 20,
              right: 20,
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: whitecolor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // With Reference Option
                    _buildOptionCard(
                      icon: Icons.payment,
                      title: "Customer With Payment Reference Number",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PaymentVerificationScreen()),
                        );
                      },
                      // onTap: () => Get.to(() => NewSalesScreen(withReference: true)),
                      color: primarycolor, subtitle: '',
                    ),

                    SizedBox(height: 16),

                    // Without Reference Option
                    _buildOptionCard(
                      icon: Icons.money_off,
                      title: "Customer Without Payment Reference Number",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  CreateSalesOrder()),
                        );
                      },
                      color: primarycolor, subtitle: '',
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

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Function() onTap,
    Color color = Colors.teal,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 30),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    subtitle,
                    style:TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color, size: 20),
          ],
        ),
      ),
    );
  }
}

