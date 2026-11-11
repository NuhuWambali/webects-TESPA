import 'package:ects/model/SaleAddTespa.dart';
import 'package:ects/model/receiptdata.dart';
import 'package:ects/model/saledate.dart';
import 'package:ects/screens/device/deviceSwapping.dart';
import 'package:ects/screens/receipts/editsaleTespa.dart';
import 'package:ects/widget/widgetconstant.dart';
import 'package:ects/widget/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constant/colorcontant.dart';
import '../../controller/controllerconstant.dart';
import '../../generated/assets.dart';
import 'package:get/get.dart';
import 'dart:convert';

import '../sales/editsale.dart';
import 'editsale.dart';
import 'editsale.dart';

class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({super.key});

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  var groupvalue = ['1','2','3','4'];
  var value = '1';
  final formKeysearch = GlobalKey<FormState>();
  String? _selectedSearchType = 'tespa'; // Set default to 'tespa'
  bool _isSearchEnabled = false;
  final TextEditingController _tzlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    apiController.stepd1.value = true;
    apiController.stepd2.value = false;

    // Set default search type to tespa
    _selectedSearchType = 'tespa';

    // Listen for changes in TZL text field to enable/disable search
    _tzlController.addListener(() {
      setState(() {
        _isSearchEnabled = _selectedSearchType != null && _tzlController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _tzlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Form(
          key: formKeysearch,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 227,
                child: Stack(
                  children: [
                    Container(
                      height: 227,
                      width: double.infinity,
                      padding: const EdgeInsets.all(21),
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(Assets.iconsTopheader),
                              fit: BoxFit.fill
                          )
                      ),
                    ),
                    Positioned(
                      top: 79,
                      left: 20,
                      height: 38,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              foregroundImage: AssetImage(Assets.iconsBack),
                              radius: 17,
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(left: 12),
                            child: Text('Reprint Receipt', style: font20white),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 143,
                      left: 21,
                      right: 21,
                      child: Container(
                        width: double.infinity,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Container(
                                margin: EdgeInsets.only(right: 8),
                                child: formfiledbB('Enter TZL', (value) {
                                  apiController.tzl.value = value;
                                  _tzlController.text = value;
                                  setState(() {
                                    _isSearchEnabled = _selectedSearchType != null && value.isNotEmpty;
                                  });
                                }),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 1,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedSearchType,
                                    hint: Text(
                                      'Select Type',
                                      style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    icon: Icon(Icons.arrow_drop_down, color: primarycolor),
                                    isExpanded: true,
                                    items: [
                                      DropdownMenuItem(
                                        value: 'tespa',
                                        child: Text(
                                          'Tespa',
                                          style: GoogleFonts.roboto(
                                            fontSize: 14,
                                            color: colorstextfont,
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 'web',
                                        child: Text(
                                          'Web',
                                          style: GoogleFonts.roboto(
                                            fontSize: 14,
                                            color: colorstextfont,
                                          ),
                                        ),
                                      ),

                                    ],
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedSearchType = newValue;
                                        _isSearchEnabled = newValue != null && _tzlController.text.isNotEmpty;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),

              // Search Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: _isSearchEnabled
                    ? buttonwithicon('Search', () async {
                  var datastus = await hasNetwork();

                  if (datastus) {
                    if (formKeysearch.currentState!.validate()) {
                      if (_selectedSearchType == 'web') {
                        apiController.searchbytzl(apiController.tzl.value);
                      } else if (_selectedSearchType == 'tespa') {
                        // Implement Tespa search logic here
                        print("now for tespaaaaaaa");
                        apiController.searchTespaByTzl(apiController.tzl.value);
                      }
                    }
                    print("sure connected ccc");
                  } else {
                    print("sure NOt connected");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Your offline please connect to internet to access this feature'),
                        backgroundColor: Colors.green.withOpacity(0.5),
                      ),
                    );
                  }
                })
                    : Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Please enter TZL and select search type',
                    style: GoogleFonts.roboto(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

// All other functions remain the same

Future<void> receiptPrintcop(Map receiptdata) async {
  // deep copy so slaves list isn't reused
  final Map<String, dynamic> dataToSend = jsonDecode(jsonEncode(receiptdata));
  dataToSend['branchId'] = apiController.userdata.value.branch ?? 1;

  const platform = MethodChannel('com.webcorp.ects/ReceiptCoppy');
  print("DATA TO NATIVE ANDROID: $dataToSend");

  try {
    final int result = await platform.invokeMethod('receiptPrint', dataToSend);
    print('Printing Result: printer result $result % .');
  } on PlatformException catch (e) {
    print("Failed to print: '${e.message}'.");
  }
}


Future<void> receiptPrint(Map receiptdata) async {
  receiptdata['branchId'] = apiController.userdata.value.branch??1;

  const platform = MethodChannel('com.webcorp.ects/Receipt');
  print("DATA TO NATIVE ANDROID: ");
  String resultValue;
  int returnedValue = 0;
  try {
    final int result = await platform.invokeMethod('receiptPrint', receiptdata);
    resultValue = 'printer result $result % .';
    returnedValue = result;
    receiptdata = {};


  } on PlatformException catch (e) {
    resultValue = "Failed to print: '${e.message}'.";
  }
  print('Printing Result Issssssss: ' + resultValue.toString());
}

Future<void> printTespa(SaleAddTespa sale) async {
  const MethodChannel tespaChannel = MethodChannel('com.webcorp.ects/TespaReceipt');

  final Map<String, dynamic> receiptData = {
    'branchId': apiController.userdata.value.branch ?? 1,
    'tripDetails': {
      'tripNo': sale.tripNo,
      'vehicleNo': sale.vehicleNo,
      'trailerNo': sale.trailerNo,
      'merchantNo': sale.merchantNo,
      'receiptNo': sale.receiptNo,
      'gateName': sale.gateName,
      'borderName': sale.borderName,
      'customerName': sale.customerName,
    },
    'agentDetails': {
      'agentName': sale.agentName,
      'agentPhoneNo': sale.agentPhoneNo,
    },
    'deviceDetails': {
      'master': sale.master,
      'slaves': sale.slaves?.split(',').map((e) => e.trim()).toList() ?? [],
    },
  };

  print("TESPA DATA TO NATIVE: $receiptData");

  String resultValue;
  int returnedValue = 0;

  try {
    final int result = await tespaChannel.invokeMethod('receiptPrint', receiptData);
    resultValue = 'printer result $result %';
    returnedValue = result;
  } on PlatformException catch (e) {
    resultValue = "Failed to print: '${e.message}'.";
  }

  print('Printing Result Tespa: $resultValue');
}


Future<void> receiptPrintReport(receiptdatad) async {
  receiptdatad['branchId'] = apiController.userdata.value.branch??1;
  const platform = MethodChannel('com.webcorp.ects/Receipt');
  print("DATA TO NATIVE ANDROID: ");
  String resultValue;
  int returnedValue = 0;
  try {
    final int result = await platform.invokeMethod('reportPrint', receiptdatad);
    resultValue = 'printer result $result % .';
    returnedValue = result;
    receiptdatad = {};


  } on PlatformException catch (e) {
    resultValue = "Failed to print: '${e.message}'.";
  }
  print('Printing Result Issssssss: ' + resultValue.toString());
}

void openReceiptButtomsheet(BuildContext context, SaleAdd sale) {
  showModalBottomSheet(
    context: context,
    backgroundColor: whitecolor,
    isScrollControlled: true,
    elevation: 0.1,
    isDismissible: true,
    shape: const RoundedRectangleBorder(
        borderRadius:
        BorderRadius.vertical(top: Radius.circular(16))),
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.90,
      minChildSize: 0.2,
      maxChildSize: 0.90,
      expand: false,
      builder: (_, controller) => Column(
        children: [
          const SizedBox(height: 15),

          Container(
            margin: EdgeInsets.only(left: 35,right: 25),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),

                IconButton(
                    onPressed: (){
                      Get.back();
                    }, icon: Icon(Icons.close)
                ),

              ],
            ),
          ),

          Expanded(
            child:Container(
              margin: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  border: Border.all(color: colorsfontgrey.withOpacity(0.2)),
                  borderRadius: BorderRadius.all(Radius.circular(1))
              ),
              child: ListView(
                  children: <Widget>[

                    SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(top: 7,left: 30,right: 10,bottom: 1),
                            child: Text(
                              'TZL: ${sale.tzl}',
                              style:   GoogleFonts.roboto(
                                textStyle: TextStyle(color: colorstextfont,fontWeight: FontWeight.w400,fontSize: 14,fontStyle: FontStyle.normal),
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              Get.back();
                              int salesChannel = apiController.userdata.value.salesChannel ?? 0;

                              if (salesChannel == 2) {
                                apiController.saleedited.value = sale;
                                Get.to(() => EditSales(sale));
                              } else if (salesChannel == 3) {
                                apiController.saleedited.value = sale;
                                Get.to(() => EditSalesTespa(sale));
                                // Get.to(() => EditSales(sale));
                              }

                            },
                            child: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(top: 7,left: 10,right: 10,bottom: 1),
                              child: Card(
                                shadowColor: Colors.white.withOpacity(0.3),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 5),
                                  child: SizedBox(
                                    width: 84,
                                    child: Text(
                                      'Edit',
                                      style:   GoogleFonts.roboto(
                                        textStyle: TextStyle(color: greencolor1,fontWeight: FontWeight.w400,fontSize: 14,fontStyle: FontStyle.normal),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    dashline(),

                    Container(
                        margin: EdgeInsets.only(right: 21,left: 21,top: 12),
                        child: SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  title('Device'),
                                  title('Value Type'),

                                  if (sale.vehicleTypeId=='1')
                                    title('Chassis Number'),

                                  if (sale.vehicleTypeId=='3')
                                    title('Vehicle Number'),

                                  if (sale.vehicleTypeId=='3')
                                    title('Trailer Number'),

                                  title('Customer Type'),
                                  title('Amount')
                                ],
                              ),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  titlevalue(sale.serialNo??'23798232388'),
                                  titlevalue(sale.vehicleTypeId=='1'?'IT':
                                  sale.vehicleTypeId=='2'?'Dry Cargo':'Wet Cargo'),
                                  if (sale.vehicleTypeId=='1')
                                    titlevalue(sale.chasisNumber??''),

                                  if (sale.vehicleTypeId=='3')
                                    titlevalue(sale.vehicleNumber??''),

                                  if (sale.vehicleTypeId=='3')
                                    titlevalue(sale.trailerno??''),

                                  if (sale.saleType=='1')
                                    titlevalue('Cash Sale TZS'),
                                  if (sale.saleType=='3')
                                    titlevalue('Bill'),
                                  if (sale.saleType=='2')
                                    titlevalue('Cash Sale USD'),

                                  if (sale.saleType=='1')
                                    titlevalue(sale.amount??''),
                                  if (sale.saleType=='3')
                                    titlevalue(sale.agent??''),
                                  if (sale.saleType=='2')
                                    titlevalue(sale.amount??''),
                                ],
                              ),
                            ],
                          ),
                        )
                    ),

                    dashline(),
                    Container(
                        margin: EdgeInsets.only(right: 21,left: 21,top: 12),
                        child: SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    title('Company Name'),
                                    title('From Port Point'),
                                    title('To Border'),
                                    title('Start Date'),
                                    title('Rental End Date')
                                  ],
                                ),
                              ),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    titlevalue(sale.companyName??'WEBCORP'),
                                    titlevalue(sale.gateName??''),
                                    titlevalue(sale.borderName??''),
                                    titlevalue(sale.startDateTime??''),
                                    titlevalue(sale.endDate??'')
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                    ),

                    dashline(),
                    Container(
                        margin: EdgeInsets.only(right: 21,left: 21,top: 12),
                        child: SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  title('Driver'),
                                  title('Passport'),
                                  title('Driver Number'),
                                ],
                              ),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  titlevalue(sale.driverName??'MIKE DEV'),
                                  titlevalue(sale.passport??'0'),
                                  titlevalue(sale.driverNumber??'0'),
                                ],
                              ),
                            ],
                          ),
                        )
                    ),

                    SizedBox(height: 50),
                  ]
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 5),
            child: button('REPRINT RECEIPT', () {
              receiptPrintcop(sale.tooMap());
              Get.back();
            }),
          ),
          // Main page with the button
          Container(
            margin: EdgeInsets.only(bottom: 15,top:15),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal:109),
                backgroundColor: primarycolor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DeviceSwappingPage(
                      tripNo: sale.tzl ?? '',
                      device: sale.serialNo ?? '',
                      // If sale.slaves is already List<String>, pass directly.
                      // If it's a list of objects with `serialNo`, map to strings:
                      slaves: (sale.slaves as List<dynamic>? ?? [])
                          .map((e) => e is String ? e : (e.serialNo?.toString() ?? ''))
                          .where((s) => s.isNotEmpty)
                          .cast<String>()
                          .toList(),
                    ),
                  ),
                );
              },

              child: Text(
                'DEVICE SWAMPPING',
                style: TextStyle(fontSize: 16,color: Colors.white),
              ),
            ),
          ),

        ],
      ),
    ),
  );
}

void openReceiptButtomsheettzl(BuildContext context, ReceiptClass sale) {
  showModalBottomSheet(
    context: context,
    backgroundColor: whitecolor,
    isScrollControlled: true,
    elevation: 0.1,
    isDismissible: true,
    shape: const RoundedRectangleBorder(
        borderRadius:
        BorderRadius.vertical(top: Radius.circular(16))),
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.90,
      minChildSize: 0.2,
      maxChildSize: 0.90,
      expand: false,
      builder: (_, controller) => Column(
        children: [
          const SizedBox(height: 15),

          Container(
            margin: EdgeInsets.only(left: 35,right: 25),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                IconButton(
                    onPressed: (){
                      Get.back();
                    }, icon: Icon(Icons.close)
                ),
              ],
            ),
          ),

          Expanded(
            child:Container(
              margin: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  border: Border.all(color: colorsfontgrey.withOpacity(0.2)),
                  borderRadius: BorderRadius.all(Radius.circular(1))
              ),
              child: ListView(
                  children: <Widget>[

                    SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(top: 7,left: 30,right: 10,bottom: 1),
                            child: Text(
                              'TZL: ${sale.tzl}',
                              style:   GoogleFonts.roboto(
                                textStyle: TextStyle(color: colorstextfont,fontWeight: FontWeight.w400,fontSize: 14,fontStyle: FontStyle.normal),
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              Get.back();
                            },
                            child: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(top: 7,left: 10,right: 10,bottom: 1),
                              child: Card(
                                shadowColor: Colors.white.withOpacity(0.3),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 5),
                                  child: SizedBox(
                                    width: 84,
                                    child: Text(
                                      'Edit',
                                      style:   GoogleFonts.roboto(
                                        textStyle: TextStyle(color: greencolor1,fontWeight: FontWeight.w400,fontSize: 14,fontStyle: FontStyle.normal),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    dashline(),

                    Container(
                        margin: EdgeInsets.only(right: 21,left: 21,top: 12),
                        child: SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  title('Device'),
                                  title('Value Type'),

                                  if (sale.vehicleTypeId=='1')
                                    title('Chassis Number'),

                                  if (sale.vehicleTypeId=='3')
                                    title('Vehicle Number'),

                                  if (sale.vehicleTypeId=='3')
                                    title('Trailer Number'),

                                  title('Customer Type'),
                                  title('Amount')
                                ],
                              ),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  titlevalue(sale.device?.deviceSerial??'23798232388'),
                                  titlevalue(sale.vehicleTypeId=='1'?'IT':
                                  sale.vehicleTypeId=='2'?'Dry Cargo':'Wet Cargo'),
                                  if (sale.vehicleTypeId=='1')
                                    titlevalue(sale.chasisNumber??''),

                                  if (sale.vehicleTypeId=='3')
                                    titlevalue(sale.vehicleNumber??''),

                                  if (sale.vehicleTypeId=='3')
                                    titlevalue('sale..trailerno??'''),

                                  if (sale.saleType=='1')
                                    titlevalue('Cash Sale TZS'),
                                  if (sale.saleType=='3')
                                    titlevalue('Bill'),
                                  if (sale.saleType=='2')
                                    titlevalue('Cash Sale USD'),

                                  if (sale.customerTypeId=='1')
                                    titlevalue(sale.amount??''),
                                  if (sale.saleType=='3')
                                    titlevalue(sale.agent??''),
                                  if (sale.saleType=='2')
                                    titlevalue(sale.amount??''),
                                ],
                              ),
                            ],
                          ),
                        )
                    ),

                    dashline(),
                    Container(
                        margin: EdgeInsets.only(right: 21,left: 21,top: 12),
                        child: SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    title('Company Name'),
                                    title('From Port Point'),
                                    title('To Border'),
                                    title('Start Date'),
                                    title('Rental End Date')
                                  ],
                                ),
                              ),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    titlevalue(sale.companyName??'WEBCORP'),
                                    titlevalue(sale.port?.portPointName??''),
                                    titlevalue(sale.border?.borderName??''),
                                    titlevalue(sale.startDateTime??''),
                                    titlevalue(sale.endDate??'')
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                    ),

                    dashline(),
                    Container(
                        margin: EdgeInsets.only(right: 21,left: 21,top: 12),
                        child: SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  title('Driver'),
                                  title('Passport'),
                                  title('Driver Number'),
                                ],
                              ),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  titlevalue(sale.driverName??'MIKE DEV'),
                                  titlevalue(sale.passport??'0'),
                                  titlevalue(sale.driverNumber??'0'),
                                ],
                              ),
                            ],
                          ),
                        )
                    ),

                    SizedBox(height: 50),
                  ]
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 60),
            child: button('REPRINT RECEIPT', () {
              Get.back();
            }),
          ),
        ],
      ),
    ),
  );
}