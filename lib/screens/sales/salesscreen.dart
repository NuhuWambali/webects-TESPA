import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:ects/HomePage.dart';
import 'package:ects/screens/receipts/receipt.dart';
import 'package:ects/screens/sales/selectCustomerScreen.dart';
import 'package:ects/widget/widgetconstant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constant/colorcontant.dart';
import '../../controller/controllerconstant.dart';
import '../../generated/assets.dart';
import 'package:get/get.dart';

import '../../offlinedb/sqlite.dart';
import '../../widget/widgets.dart';
import 'newsales.dart';
import 'package:connectivity/connectivity.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});


  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  StreamSubscription<ConnectivityResult>? subscription;
  ConnectivityResult _previousResult = ConnectivityResult.none;
  int salesChannel = apiController.userdata.value.salesChannel ?? 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getoffline();
    initConnectivity();




  }


  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {

    // Initialize subscription to monitor connectivity changes
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {

        print("NO internet");
        print(result);

      } else {


        print("IPO internet");
        print(result);
        syncydata();

      }
    });


  }


  syncydata() async {
    var datastus =await hasNetwork();

    if (datastus) {

      print("sure connected ccc");








      apiController.salesdata.where((data) => data.receipt_number==null && data.prev_offline_receipt_number=="").toList().forEach((sale) {

        print("no data");
        print(sale.serialNo);
        // print(element.receipt_number);
        apiController.syncsale(sale);

      });

      apiController.salesdata.where((data) => data.prev_offline_receipt_number!="").toList().forEach((sale1) {

        print("no data edited");
        print(sale1.serialNo);
        // print(element.receipt_number);
        apiController.editsalesync(sale1);

      });


    }  else{
      print("offline");

    }
  }


  getoffline() async {
    final dbHelper = DatabaseHelper();

    var data =  await dbHelper.getSales();

    apiController.salesdata.value = data;
    log("Savedss ${jsonEncode(apiController.salesdata.value)}");


  }


  @override
  void dispose() {
    super.dispose();
    // Cancel the subscription to avoid memory leaks
    subscription?.cancel();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        body: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              SizedBox(
                height: 327,
                child: Stack(
                  children: [
                    Container(
                      height: 267,
                      width: double.infinity,
                      padding: const EdgeInsets.all(21),
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(Assets.iconsTopheader),
                              fit: BoxFit.fill)),
                    ),
                    Positioned(
                      top: 79,
                      left: 20,
                      height: 38,
                      child: Row(
                        children: [
                         InkWell(
                        onTap: (){
                          Get.offAll(() => HomePage());
                        }
                           ,
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              foregroundImage: AssetImage(Assets.iconsBack),
                              radius: 17,
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(left: 12),
                            child: Text('Sales', style: font20white
                                // TextStyle(fontWeight: FontWeight.w500,color: whitecolor,fontSize: 16),),
                                ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 21,
                      top: 162,
                      right: 21,
                      child: PhysicalModel(
                        color: Colors.white,
                        elevation: 0.1,
                        shadowColor: Colors.white.withOpacity(0.6),
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 23),
                          height: 164,
                          child: salesChannel == 1
                              ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Bill Column
                              Column(
                                children: [
                                  Text('Bill', style: font18black),
                                  SizedBox(height: 29),
                                  Text(
                                    '${apiController.salesdata.where((t) => t.saleType == '3').length}',
                                    style: font24black,
                                  ),
                                ],
                              ),
                              // Cash Column
                              Column(
                                children: [
                                  Text('Cash', style: font18black),
                                  SizedBox(height: 29),
                                  Text(
                                    '${apiController.salesdata.where((t) => t.currency == 'TZS').length + apiController.salesdata.where((t) => t.currency == 'USD').length}',
                                    style: font24black,
                                  ),
                                ],
                              ),
                              // Total Column
                              Column(
                                children: [
                                  Text('Total', style: font18black),
                                  SizedBox(height: 29),
                                  Text(
                                    '${apiController.salesdata.length}',
                                    style: font24black,
                                  ),
                                ],
                              ),
                            ],
                          )
                              : Center(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 25),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 300,
                                          child: Text(
                                            'Total Number of Sales ',
                                            style: font18black,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Text(
                                          '${apiController.salesdata.where((t) => t.currency == 'TZS' || t.currency == 'USD').length}',
                                          style: TextStyle(
                                            fontSize: 60,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        ),
                      ),
                    )

                  ],
                ),
              ),

               Container(
                 width:300,
                 margin: EdgeInsets.only(top: 0),
                   child: Stack(
                   children: [
                     tabSection(context),

                     Positioned(
                     left: 10,
                       right: 10,
                       bottom: 66,
                       child: button('NEW SALE',
                               () {
                                 apiController.step1.value= true;
                                 apiController.step2.value= false;
                                 apiController.step3.value= false;

                           Get.to(()=>NewSalesScreen());
                                 if (salesChannel == 1) {
                                   Get.to(() => SalesScreen());
                                 } else if (salesChannel == 2 || salesChannel == 3) {
                                   Get.to(() => SelectCustomerScreen());
                                 } else {
                                   showServerDownDialog(context);
                                 }

                               }),
                     )
                   ],
                 ),
               ),

            ])));
  }



  Widget tabSection(BuildContext context) {
    int salesChannel = apiController.userdata.value.salesChannel ?? 0;

    // CASE 1: salesChannel == 1 → show your 4 tabs
    if (salesChannel == 1) {
      return DefaultTabController(
        length: 4,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              child: TabBar(
                unselectedLabelColor: Colors.grey,
                indicatorColor: primarycolor,
                labelColor: primarycolor,
                tabs: const [
                  Tab(text: "All"),
                  Tab(text: "Cash Tzs"),
                  Tab(text: "Cash Usd"),
                  Tab(text: "Bill"),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.55,
              child: TabBarView(children: [
                // 🔥 your original "All" tab inline
                SingleChildScrollView(
                  child: Obx(() {
                    final salesList = apiController.salesdata;
                    if (salesList.isEmpty) {
                      return nodata("No Sales Yet");
                    }
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      reverse: true,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: salesList.length,
                      itemBuilder: (context, index) {
                        final data = salesList[index];
                        return card_allsaleto(
                          data.receipt_number ?? '',
                          data.saleDate ?? '',
                          '${data.currency == "" ? "Bill" : data.currency}',
                          "TZDL ${data.tzl}",
                              () {
                            apiController.saleedit.value = data;
                            openReceiptButtomsheet(
                                context, apiController.saleedit.value);
                          },
                              () async {
                            var datastus = await hasNetwork();
                            if (datastus) {
                              if (data.prev_offline_receipt_number != "") {
                                apiController.editsalesync(data);
                              } else {
                                apiController.adsale(data);
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    'You are offline, please connect to the internet to access this feature'),
                                backgroundColor: Colors.green.withOpacity(0.5),
                              ));
                            }
                          },
                          data.prev_offline_receipt_number,
                        );
                      },
                    );
                  }),
                ),

                // 🔥 your original "Cash Tzs" tab inline
                SingleChildScrollView(
                  child: Obx(() {
                    final tzsSales = apiController.salesdata
                        .where((t) => t.currency == 'TZS')
                        .toList();
                    if (tzsSales.isEmpty) {
                      return nodata("No Cash TZS Sales");
                    }
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      reverse: true,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: tzsSales.length,
                      itemBuilder: (context, index) {
                        final data = tzsSales[index];
                        return card_allsaleto(
                          data.receipt_number ?? '',
                          data.saleDate ?? '',
                          'TZS',
                          "TZDL ${data.tzl}",
                              () {
                            apiController.saleedit.value = data;
                            openReceiptButtomsheet(
                                context, apiController.saleedit.value);
                          },
                              () async {
                            var datastus = await hasNetwork();
                            if (datastus) {
                              if (data.prev_offline_receipt_number != "") {
                                apiController.editsalesync(data);
                              } else {
                                apiController.adsale(data);
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    'You are offline, please connect to the internet to access this feature'),
                                backgroundColor: Colors.green.withOpacity(0.5),
                              ));
                            }
                          },
                          data.prev_offline_receipt_number,
                        );
                      },
                    );
                  }),
                ),

                // 🔥 your original "Cash Usd" tab inline
                SingleChildScrollView(
                  child: Obx(() {
                    final usdSales = apiController.salesdata
                        .where((t) => t.currency == 'USD')
                        .toList();
                    if (usdSales.isEmpty) {
                      return nodata("No Cash USD Sales");
                    }
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      reverse: true,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: usdSales.length,
                      itemBuilder: (context, index) {
                        final data = usdSales[index];
                        return card_allsaleto(
                          data.receipt_number ?? '',
                          data.saleDate ?? '',
                          'USD',
                          "TZDL ${data.tzl}",
                              () {
                            apiController.saleedit.value = data;
                            openReceiptButtomsheet(
                                context, apiController.saleedit.value);
                          },
                              () async {
                            var datastus = await hasNetwork();
                            if (datastus) {
                              if (data.prev_offline_receipt_number != "") {
                                apiController.editsalesync(data);
                              } else {
                                apiController.adsale(data);
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    'You are offline, please connect to the internet to access this feature'),
                                backgroundColor: Colors.green.withOpacity(0.5),
                              ));
                            }
                          },
                          data.prev_offline_receipt_number,
                        );
                      },
                    );
                  }),
                ),

                // 🔥 your original "Bill" tab inline
                SingleChildScrollView(
                  child: Obx(() {
                    final billSales = apiController.salesdata
                        .where((t) => t.currency == "")
                        .toList();
                    if (billSales.isEmpty) {
                      return nodata("No Bill Sales");
                    }
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      reverse: true,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: billSales.length,
                      itemBuilder: (context, index) {
                        final data = billSales[index];
                        return card_allsaleto(
                          data.receipt_number ?? '',
                          data.saleDate ?? '',
                          'Bill',
                          "TZDL ${data.tzl}",
                              () {
                            apiController.saleedit.value = data;
                            openReceiptButtomsheet(
                                context, apiController.saleedit.value);
                          },
                              () async {
                            var datastus = await hasNetwork();
                            if (datastus) {
                              if (data.prev_offline_receipt_number != "") {
                                apiController.editsalesync(data);
                              } else {
                                apiController.adsale(data);
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    'You are offline, please connect to the internet to access this feature'),
                                backgroundColor: Colors.green.withOpacity(0.5),
                              ));
                            }
                          },
                          data.prev_offline_receipt_number,
                        );
                      },
                    );
                  }),
                ),
              ]),
            ),
          ],
        ),
      );
    }

    // CASE 2: salesChannel == 2 or 3 → show only cash sales in one list
    else if (salesChannel == 2 || salesChannel == 3) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.55,
        margin: EdgeInsets.only(bottom: 50),
        padding: EdgeInsets.only(bottom: 170),
        child: Center(
          child: SingleChildScrollView(
            child: Obx(() {
              final cashSales = apiController.salesdata
                  .where((t) => t.currency == 'TZS' || t.currency == 'USD')
                  .toList();
              if (cashSales.isEmpty) {
                return nodata("No Cash Sales");
              }
              return ListView.builder(
                padding: EdgeInsets.zero,
                reverse: true,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: cashSales.length,
                itemBuilder: (context, index) {
                  final data = cashSales[index];
                  return card_allsaleto(
                    data.receipt_number ?? '',
                    data.saleDate ?? '',
                    '${data.currency == "" ? "Bill" : data.currency}',
                    "TZDL ${data.tzl}",
                        () {
                      apiController.saleedit.value = data;
                      openReceiptButtomsheet(context, apiController.saleedit.value);
                    },
                        () async {
                      var datastus = await hasNetwork();
                      if (datastus) {
                        if (data.prev_offline_receipt_number != "") {
                          apiController.editsalesync(data);
                        } else {
                          apiController.adsale(data);
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'You are offline, please connect to the internet to access this feature'),
                          backgroundColor: Colors.green.withOpacity(0.5),
                        ));
                      }
                    },
                    data.prev_offline_receipt_number,
                  );
                },
              );
            }),
          ),
        ),
      );
    }

    // fallback
    else {
      return Center(child: Text("Invalid Sales Channel"));
    }
  }
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