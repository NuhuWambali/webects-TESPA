import 'package:ects/model/reports.dart';
import 'package:ects/screens/report/reports.dart';
import 'package:ects/widget/widgetconstant.dart';
import 'package:ects/widget/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constant/colorcontant.dart';
import '../../controller/controllerconstant.dart';
import '../../generated/assets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../sales/salesscreen.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {

  var groupvalue = ['1','2','3','4'];

  var value = '1';


  String selectedReportType = 'tespa';
  final List<Map<String, String>> reportTypes = [

    {'value': 'tespa', 'label': 'Tespa Reports'},
    {'value': 'web', 'label': 'Web Reports'},
  ];

  TextEditingController startdate = TextEditingController();

  TextEditingController enddate = TextEditingController();
  final formKeysearch = GlobalKey<FormState>();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    apiController.stepd1.value= true;
    apiController.stepd2.value= false;
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
                      height: 350, // Increased height to accommodate the new dropdown
                      child: Stack(
                        children: [
                          Container(
                            height: 350, // Increased height
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
                                    Get.back();
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
                                  child: Text('Report', style: font20white
                                    // TextStyle(fontWeight: FontWeight.w500,color: whitecolor,fontSize: 16),),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Add report type selector

                          Positioned(
                            top: 120,
                            left: 21,
                            right: 21,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              margin: EdgeInsets.only(left: 1,right: 1,top:15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedReportType,
                                  isExpanded: true,
                                  items: reportTypes.map((type) {
                                    return DropdownMenuItem<String>(
                                      value: type['value'],
                                      child: Text(type['label']!),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedReportType = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                         SizedBox(height: 30,),
                          Positioned(
                            top: 190,
                            left: 21,
                            right: 21,
                            child: Container(
                              width: double.infinity,
                              child:  Container(
                                margin: EdgeInsets.only(left: 1,right: 1,top:20),
                                child: formfileddate('Start Date', () async {
                                  await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2015),
                                    lastDate: DateTime(2030),
                                  ).then((selectedDate) {
                                    if (selectedDate != null) {
                                      startdate.text =
                                          DateFormat('yyyy-MM-dd').format(selectedDate);
                                    }
                                  });
                                }, startdate),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 251,
                            left: 21,
                            right: 21,
                            child: Container(
                              width: double.infinity,
                              child:  Container(
                                margin: EdgeInsets.only(left: 1,right: 1,top: 30),
                                child: formfileddate('End Date', () async {
                                  await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2015),
                                    lastDate: DateTime(2030),
                                  ).then((selectedDate) {
                                    if (selectedDate != null) {
                                      enddate.text =
                                          DateFormat('yyyy-MM-dd').format(selectedDate);
                                    }
                                  });
                                }, enddate),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    buttonwithicon('Check Report', () async {
                      apiController.reportreq.value.fromDate=startdate.text;
                      apiController.reportreq.value.toDate=enddate.text;
                      apiController.reportreq.value.userId=apiController.userdata.value.userId;

                      var datastus =await hasNetwork();
                      if (datastus) {
                        if (formKeysearch.currentState!.validate()) {
                          // Use the selected report type to determine which API to call
                          // if (selectedReportType == 'web') {
                          //   apiController.getreport(apiController.reportreq.value);
                          // } else if (selectedReportType == 'tespa') {
                          //   apiController.getreportTespa(apiController.reportreq.value);
                          // }

                          if (selectedReportType == 'web') {
                            apiController.getreport(apiController.reportreq.value);
                          } else if (selectedReportType == 'tespa') {

                            await apiController.getreportTespa(apiController.reportreq.value);

                            // if (apiController.reportTespa.value != null) {
                            //
                            //   Map<String, dynamic> reportMap = apiController.reportTespa.value!.report != null
                            //       ? {
                            //     'total_number': apiController.reportTespa.value!.report!.totalNumberBillSales ?? 0,
                            //     'total_amount': apiController.reportTespa.value!.report!.totalAmount ?? '0',
                            //     'remained_devices': apiController.reportTespa.value!.report!.remainedDevices ?? 0,
                            //   }
                            //       : {};
                            //
                            //   showTespaDialog(context, reportMap);
                            // }
                          }


                        }
                        print("sure connected ccc");
                      }  else{
                        print("sure Not connected");
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Your offline please connect to internet to access this feature'),backgroundColor: Colors.green.withOpacity(0.5),));
                      }
                    }),

                    SizedBox(height: 50,),
                  ]
              ),
            )
        )
    );
  }
}

void openReportButtomsheet(BuildContext context, Report sale) {
  var formatter = NumberFormat('#,##,000');
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
      initialChildSize: 0.80,
      minChildSize: 0.2,
      maxChildSize: 0.80,
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
                Container(
                  child: Text(
                    'Summary Report',
                    style:   GoogleFonts.roboto(
                      textStyle: TextStyle(color: colorstextfont,fontWeight: FontWeight.w600,fontSize: 15,fontStyle: FontStyle.normal),
                    ),
                  ),),

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
              margin: EdgeInsets.all(12,),
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
                              'Report',
                              style:   GoogleFonts.roboto(
                                textStyle: TextStyle(color: colorstextfont,fontWeight: FontWeight.w400,fontSize: 14,fontStyle: FontStyle.normal),
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          // InkWell(
                          //   onTap: (){
                          //     Get.back();
                          //     Get.off(()=>SalesScreen());
                          //   },
                          //   child: Container(
                          //     alignment: Alignment.centerRight,
                          //     padding: const EdgeInsets.only(top: 7,left: 10,right: 10,bottom: 1),
                          //     child: Card(
                          //       shadowColor: Colors.white.withOpacity(0.3),
                          //       child: Padding(
                          //         padding: const EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 5),
                          //         child: SizedBox(
                          //           width: 100,
                          //           child: Text(
                          //             'View Details',
                          //             style:   GoogleFonts.roboto(
                          //               textStyle: TextStyle(color: greencolor1,fontWeight: FontWeight.w400,fontSize: 14,fontStyle: FontStyle.normal),
                          //             ),
                          //             textAlign: TextAlign.center,
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
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
                                  title('From Date'),
                                  title('To Date'),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  titlevalue(apiController.reportreq.value.fromDate??''),
                                  titlevalue(apiController.reportreq.value.toDate??'')
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  title('Number of Bill Sales:'),
                                  title('Number of Cash Sales(USD):'),
                                  title('Number of Cash Sales(TZS):'),
                                  title('Bill Sales'),
                                  title('Cash Sales(USD)'),
                                  title('Cash Sales (TZS)'),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    titlevalue(sale.report!.totalNumberBillSales.toString()),
                                    titlevalue(sale.report!.totalNumberCashSalesUsd.toString()),
                                    titlevalue(sale.report!.totalNumberCashSalesTzs.toString()),
                                    titlevalue('${sale.report!.totalAmountBillSales??0}'),
                                    titlevalue(formatter.format(double.parse('${sale.report!.totalAmountCashSalesUsd??0}'))),
                                    titlevalue(formatter.format(double.parse('${sale.report!.totalAmountCashSalesTzs??0}'))),
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
                                  title('Remained Device'),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 50),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    titlevalue("${sale.report!.remainedDevices??0}"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                    ),

                    SizedBox(height: 50,),
                  ]
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 90),
          )
          ,
        ],
      ),
    ),
  );
}


void showTespaDialog(BuildContext context, Report sale) {
  var formatter = NumberFormat('#,##,000');

  final totalAmount = sale.report!.totalAmount.toString();
  final totalNumber = sale.report!.totalNumber??0;
  final remainedDevices = sale.report!.remainedDevices??0;
  final fromDate = apiController.reportreq.value.fromDate??'';
  final toDate = apiController.reportreq.value.toDate??'';

  showModalBottomSheet(
    context: context,
    backgroundColor: whitecolor,
    isScrollControlled: true,
    elevation: 0.1,
    isDismissible: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.2,
      maxChildSize: 0.8,
      expand: false,
      builder: (_, controller) => Column(
        children: [
          const SizedBox(height: 15),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tespa Sales Report',
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      color: colorstextfont,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.close),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: colorsfontgrey.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(1),
              ),
              child: ListView(
                controller: controller,
                children: [
                  // Date range section
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 21, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            title('From Date'),
                            title('To Date'),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            titlevalue(fromDate),
                            titlevalue(toDate),
                          ],
                        ),
                      ],
                    ),
                  ),
                  dashline(),
                  // Total numbers section
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 21, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            title('Total Number of Sales'),
                            title('Total Amount'),
                            title('Remained Devices'),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            titlevalue('$totalNumber'),
                            titlevalue(formatter.format(double.parse('$totalAmount'))),
                            titlevalue('$remainedDevices'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    ),
  );
}
