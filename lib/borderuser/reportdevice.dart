import 'dart:developer';

import 'package:ects/model/reports.dart';
import 'package:ects/screens/receipts/receipt.dart';
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

import '../model/devicereports.dart';
import '../widget/arlet.dart';



class ReportDevicesScreen extends StatefulWidget {
  const ReportDevicesScreen({super.key});

  @override
  State<ReportDevicesScreen> createState() => _ReportDevicesScreenState();
}

class _ReportDevicesScreenState extends State<ReportDevicesScreen> {

  var groupvalue = ['1','2','3','4'];

  var value = '1';

  TextEditingController startdate = TextEditingController();

  TextEditingController enddate = TextEditingController();
  final formKeysearch = GlobalKey<FormState>();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();



    // apiController.stepd1.value= true;
    // apiController.stepd2.value= false;


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
                      height: 317,
                      child: Stack(
                        children: [
                          Container(
                            height: 317,
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
                                  child: Text('Return Device Report', style: font20white
                                    // TextStyle(fontWeight: FontWeight.w500,color: whitecolor,fontSize: 16),),
                                  ),
                                ),
                              ],
                            ),
                          ),


                          Positioned(
                            top: 150,
                            left: 21,
                            right: 21,
                            child: Container(
                              width: double.infinity,

                              // decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.all(Radius.circular(121)),
                              //     color: primarycolor.withOpacity(0.6)
                              //
                              // ),

                              child:  Container(
                                margin: EdgeInsets.only(left: 1,right: 1),
                                // padding: EdgeInsets.all(8),



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


                                },
                                 startdate

                                ),


                              ),
                            ),
                          ),
                          Positioned(
                            top: 231,
                            left: 21,
                            right: 21,
                            child: Container(
                              width: double.infinity,

                              // decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.all(Radius.circular(121)),
                              //     color: primarycolor.withOpacity(0.6)
                              //
                              // ),

                              child:  Container(
                                margin: EdgeInsets.only(left: 1,right: 1),
                                // padding: EdgeInsets.all(8),



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
                                },
                                  enddate
                                ),


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


                          // apiController.searchbytzl(apiController.tzl.value);






                          apiController.getreportdevice(apiController.reportreq.value);




                        }
                        print("sure connected ccc");

                      }  else{
                        print("sure NOt connected");
                        SnackbarService.errorSnackBar(context, 'Your offline please connect to internet to access this feuture');
                       // ScaffoldMessenger.of(context).showSnackBar(
                           // SnackBar(content: Text('Your offline please connect to internet to access this feuture'),backgroundColor: Colors.green.withOpacity(0.5),));
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


void openDeviceReportButtomsheet(BuildContext context, DeviceReportz sale) {
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
                Container(
                 child: Text(
            'Border Return Report',
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



                    Container(



                        margin: EdgeInsets.only(right: 21,left: 21,top: 12),

                        child: SizedBox(
                          // color: Colors.blueGrey,

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  title('From Date'),
                                  title('To Date'),
                                  title('Border'),
                                  title('Total No'),

                                  title('User'),



                                ],
                              ),




                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  titlevalue(apiController.reportreq.value.fromDate??''),
                                  titlevalue(apiController.reportreq.value.toDate??''),

                                  titlevalue(sale.border??''),

                                  titlevalue(sale.total.toString()),
                                  title(sale.user??'Total No'),


                                ],
                              ),




                            ],
                          ),
                        )
                    ),

                    dashline(),


                    Container(



                        margin: EdgeInsets.only(right: 21,left: 21,top: 12),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            sale.devices!.isNotEmpty?
                            ListView.builder(
                                padding: EdgeInsets.zero,
                                reverse: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount:sale.devices?.length??0,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return card_devicerep(
                                      'SN:${sale.devices![index].serialNo ?? ''}',
                                      "Master",
                                         );
                                }):
                            Center(child: nodata("No devices"),),


                          ],
                        ),
                    ),













                    SizedBox(height: 50,),




                  ]
              ),
            ),
          ),


          buttontt('Print', () async {
            log("print data ${deviceReportzToJson(sale)}");

            receiptPrintReport(sale.toJson());


            // Get.to(()=>NewSalesScreen());
          }),
          Container(
            margin: EdgeInsets.only(bottom: 50),

          )
          ,
        ],
      ),
    ),
  );
}


