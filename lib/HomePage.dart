import 'package:ects/constant/colorcontant.dart';
import 'package:ects/controller/controllerconstant.dart';
import 'package:ects/generated/assets.dart';
import 'package:ects/screens/device/device.dart';
import 'package:ects/screens/receipts/receipt.dart';
import 'package:ects/screens/report/report.dart';
import 'package:ects/screens/sales/newsales.dart';
import 'package:ects/screens/sales/orderPage.dart';
import 'package:ects/screens/sales/salesscreen.dart';
import 'package:ects/screens/sales/selectCustomerScreen.dart';
import 'package:ects/screens/sales/trip_list_screen.dart';
import 'package:ects/widget/widgetconstant.dart';
import 'package:ects/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'authentication/loginscreen.dart';
import 'offlinedb/sqlite.dart';
import 'dart:convert';
import 'package:ects/services/remoteservice.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {
  PackageInfo? packageInfo;


  @override
  void initState() {
    super.initState();
    apiController.masterload();
    getoffline();
    getdata();


  }

  getoffline() async {
    final dbHelper = DatabaseHelper();
    var data = await dbHelper.getSales();
    apiController.salesdata.value = data;
    var mst = await dbHelper.getmaster(0);
    apiController.masterd.value = mst;
    var slv = await dbHelper.getSlaved(0);
    apiController.slaved.value = slv;
  }

  getdata() async {
    packageInfo = await PackageInfo.fromPlatform();


    setState(() {});
  }

  void showServerDownDialog(BuildContext context) {
    Get.defaultDialog(
      title: "",
      contentPadding: EdgeInsets.all(20),
      backgroundColor: Colors.white,
      radius: 16,
      content: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline,
              size: 50,
              color: Colors.red,
            ),
          ),
          SizedBox(height: 15),
          Text(
            "Server Unavailable",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "The server is currently unavailable for this sales channel. Please try again later.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: primarycolor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            ),
            child: Text(
              "OK",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // check sales channel
    int salesChannel = apiController.userdata.value.salesChannel ?? 0;


    return PopScope(
      canPop: false,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 250,
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(Assets.iconsTopheader),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 70),
                      child: Row(
                        children: [
                          CircleAvatar(
                            foregroundImage: AssetImage(Assets.imagesUserp),
                            radius: 28,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  apiController.userdata.value.name ?? '',
                                  style: GoogleFonts.nunitoSans(
                                    textStyle: TextStyle(
                                      color: whitecolor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 17,
                                      letterSpacing: 0.4,
                                    ),
                                  ),
                                ),
                                Text(
                                  apiController.userdata.value.role ??
                                      'Position',
                                  style: GoogleFonts.nunitoSans(
                                    textStyle: TextStyle(
                                      color: whitecolor,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      letterSpacing: 0.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              openReceiptButtomsheetconfirm(
                                  context, packageInfo);
                            },
                            child: Icon(Icons.more_vert_rounded,
                                color: whitecolor),
                          ),
                        ],
                      ),
                    ),
                    Obx(
                          () => Container(
                        height: 50,
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 34),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(11)),
                          color: primarycolor.withOpacity(0.6),
                        ),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 25),
                          padding: EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text:
                                  '${apiController.salesdata.length ?? 0}',
                                  style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                      color: whitecolor,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: ' Sales',
                                      style: stylesmal12,
                                    ),
                                  ],
                                ),
                              ),
                              Container(color: primarycolor, width: 2),
                              RichText(
                                text: TextSpan(
                                  text:
                                  '${apiController.masterd.length + apiController.slaved.length}',
                                  style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                      color: whitecolor,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: ' Device',
                                      style: stylesmal12,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              // First row of cards
              Container(
                margin: EdgeInsets.only(top: 30, left: 12, right: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: card_public('Sales', 'Manage Sales', Assets.iconsSale1, () {
                          if (salesChannel == 1) {
                            Get.to(() => SalesScreen());
                          } else if (salesChannel == 2 || salesChannel == 3) {
                            Get.to(() => SelectCustomerScreen());
                          } else {
                            showServerDownDialog(context);
                          }
                        }),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: card_public('Report', 'View Reports', Assets.iconsSale1, () {
                          Get.to(() => ReportScreen());
                        }),
                      ),
                    ),
                  ],
                ),
              ),

              // Second row of cards
              Container(
                margin: EdgeInsets.only(top: 5, left: 12, right: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: card_public('Device', 'Manage Device', Assets.iconsSale1, () {
                          Get.to(() => DeviceScreen());
                        }),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: card_public('Receipt', 'View Receipt', Assets.iconsSale1, () {
                          Get.to(() => ReceiptScreen());
                        }),
                      ),
                    ),
                  ],
                ),
              ),

              // Third row of cards - Added Orders card
              Container(
                margin: EdgeInsets.only(top: 5, left: 12, right: 12),
                child: Row(
                  children: [
                    if (salesChannel == 2 || salesChannel == 3)
                      Expanded(
                        child: Container(
                          child: card_public(
                            'Orders',
                            'View Orders',
                            Assets.iconsSale1,
                                () {
                              // Navigation logic
                              Get.to(() => OrderManagementPage());
                            },
                          ),
                        ),
                      ),

                    Expanded(
                      child: Container(
                        // Empty container to maintain grid layout
                        child: SizedBox(),
                      ),
                    ),
                  ],
                ),
              ),

              // New Sale button
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 60),
                child: button('NEW SALE', () {
                  if (salesChannel == 3) {
                    Get.to(() => SelectCustomerScreen());
                    // } else if (salesChannel == 2 || salesChannel == 3) {
                    //   Get.to(() => SelectCustomerScreen());
                    // } else {
                    //   showServerDownDialog(context);
                    // }
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> openReceiptButtomsheetconfirm(
    BuildContext context, PackageInfo? packageInfodd) async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  showModalBottomSheet(
    context: context,
    backgroundColor: whitecolor,
    isScrollControlled: true,
    elevation: 0.1,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.60,
      maxChildSize: 0.60,
      expand: false,
      builder: (_, controller) => Column(
        children: [
          SizedBox(height: 15),
          Container(
            margin: EdgeInsets.only(left: 35, right: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.close),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(12),
              child: ListView(
                children: <Widget>[
                  // ECTs Trips Button
                  card_menu('Sales Summary', Icons.inventory, () {
                    Get.to(() => SalesScreen());
                  }),

                  // Device Prices Button
                  card_menu('Device Prices', Icons.devices, () async {
                    // Show loading dialog
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
                              Text("Fetching device prices...", style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                    );

                    try {
                      final prefs = await SharedPreferences.getInstance();
                      final userId = prefs.getInt("userId") ?? 0;

                      final response = await RemoteServices.getDevicePrices(userId, "gateway/get-records");

                      // Close loading
                      Navigator.of(context).pop();

                      if (response != null) {
                        final data = jsonDecode(response);

                        // Hardcoded date as per your request
                        const dateText = "21 January 2025";

                        showDialog(
                          context: context,
                          builder: (_) => Dialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.devices, size: 60, color: primarycolor),
                                  const SizedBox(height: 16),
                                  const Text(
                                    "Device Prices",
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "As of $dateText",
                                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                                  ),
                                  const SizedBox(height: 16),
                                  ListTile(
                                    title: const Text('Master Device'),
                                    trailing: Text("TZS ${data['master_price'] ?? '-'}"),
                                  ),
                                  ListTile(
                                    title: const Text('Slave Device'),
                                    trailing: Text("TZS ${data['slave_price'] ?? '-'}"),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primarycolor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      child: Text("Close", style: TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Failed to fetch device prices.")),
                        );
                      }
                    } catch (e) {
                      Navigator.of(context).pop();
                      print("Error fetching device prices: $e");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error: $e")),
                      );
                    }
                  }),



                  // Orders Button in menu
                  card_menu('Orders', Icons.shopping_cart, () {
                    // Add your orders navigation logic here
                    Get.to(() => OrderManagementPage());
                    // Get.snackbar(
                    //   'Orders',
                    //   'Orders feature coming soon!',
                    //   backgroundColor: primarycolor,
                    //   colorText: whitecolor,
                    // );
                  }),

                  // Logout Button
                  card_menu('Logout', Icons.logout, () async {
                    sucesscustomer(
                      'Confirm',
                      'Are you sure you want to logout?',
                      FontAwesomeIcons.question,
                          () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setBool('isLoggedIn', false);
                        apiController.isLogin.value = false;
                        Get.offAll(() => Loginform());
                      },
                    );
                  }),

                  // App version at the bottom
                  Container(
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.only(top: 25, left: 20),
                    child: Text(
                      'v${packageInfo.version} +${packageInfo.buildNumber}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: primarycolor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}