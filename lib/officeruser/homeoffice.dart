
import 'package:ects/constant/colorcontant.dart';
import 'package:ects/controller/controllerconstant.dart';
import 'package:ects/generated/assets.dart';
import 'package:ects/model/confirmdevice.dart';
import 'package:ects/screens/device/device.dart';
import 'package:ects/screens/receipts/receipt.dart';
import 'package:ects/screens/report/report.dart';
import 'package:ects/screens/sales/newsales.dart';
import 'package:ects/screens/sales/salesscreen.dart';
import 'package:ects/widget/widgetconstant.dart';
import 'package:ects/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../HomePage.dart';
import '../model/alldevice.dart';
import '../model/transfer.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:package_info_plus/package_info_plus.dart';


class HomePageOffice extends StatefulWidget {
  const HomePageOffice({super.key});

  @override
  State<HomePageOffice> createState() => _HomePageOfficeState();
}

class _HomePageOfficeState extends State<HomePageOffice> {
  final formKeysale = GlobalKey<FormState>();


  final _qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();
  String? code;
  PackageInfo? packageInfo;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiController.stepd1.value = true;
    apiController.stepd2.value = false;
    apiController.borderdeviceload();

  }

  get() async {

    packageInfo = await PackageInfo.fromPlatform();
    setState(() {

    });
  }



  @override
  Widget build(BuildContext context) {
    return  PopScope(
      canPop: false,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        body: SingleChildScrollView(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Container(

                height: 250,
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage(Assets.iconsTopheader),fit: BoxFit.fill)

                ),

                child: Column(
                  children: [


                  Container(
                    margin: EdgeInsets.only(top: 70,),
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.center,

                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                        child: CircleAvatar(
                        foregroundImage: AssetImage(Assets.imagesUserp),
                        radius: 28,
                                      ),
                              ),

                        Container(
                          margin: EdgeInsets.only(left: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(apiController.userdata.value.name??'',style:
                                GoogleFonts.nunitoSans(
                                  textStyle: TextStyle(color:whitecolor,fontWeight: FontWeight.w700,fontSize: 17,fontStyle: FontStyle.normal,letterSpacing: 0.4),
                                ),
                                // TextStyle(fontWeight: FontWeight.w500,color: whitecolor,fontSize: 16),),
                              ),),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(apiController.userdata.value.role??'Position',
                                  style:
                                  GoogleFonts.nunitoSans(
                                    textStyle: TextStyle(color:whitecolor,fontWeight: FontWeight.w400,fontSize: 12,fontStyle: FontStyle.normal,letterSpacing: 0.4),
                                  ),

                                ),
                              )

                            ],
                          ),
                        ),
                        Spacer(),




                        Container(

                          alignment: Alignment.bottomLeft,
                          child: InkWell(
                            onTap: (){
                              openReceiptButtomsheetconfirm(context,packageInfo);
                            },
                              child: Icon(Icons.more_vert_rounded,color: whitecolor,)),),




                      ],
                    ),
                  )

                    ,

                    Container(
                      margin: EdgeInsets.only(top: 30),
             height: 50,
             width: double.infinity,
             decoration: BoxDecoration(
                 borderRadius:
                 BorderRadius.all(Radius.circular(121)),
                 color: primarycolor.withOpacity(0.6)),
             child: Container(
               margin: EdgeInsets.only(left: 25, right: 25),
               // padding: EdgeInsets.all(8),
               child: Container(
                   alignment: Alignment.center,
                   child: Text(
                     'RECEIPT VERIFICATION',
                     style: font15white,
                   ))
             ),
           ),






                  ],
                ),
              ),


          SizedBox(
            height:20,),

              Form(
                key: formKeysale,
                child:
                  Column(
                    children: [
                    SizedBox(

                        child: Row(
                          children: [


                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 9,left: 20),
                                child: formfiledbBB('Receipt number ...', (vad) {

                                  apiController.scanreq.value.receiptNo= vad;
                                  apiController. scanreqd.value.receiptNo= vad;


                                }),
                              ),
                            ),

                            Container(
                                width: 50,
                                margin: const EdgeInsets.only(right: 5),
                                child:  IconButton(onPressed: () async {
                                  apiController.verified.value= false;
                                  print("code scannneddd");


                                  var datastus =await hasNetwork();
                                  if (datastus) {
                                    _qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
                                        context:  Get.context,
                                        onCode: (code) {
                                          apiController. scanreqd.value.receiptNo=code;
                                          setState(() {
                                            this.code = code;
                                          });


                                          apiController.scanreq.value.receiptNo= code?.trim();
                                          apiController. scanreqd.value.receiptNo= code?.trim();
                                          apiController.scanreq.value.userId = apiController.userdata.value.userId.toString();

                                          if (code!="" ){
                                            print("code ${code}");
                                            apiController.scanreqq(apiController.scanreq.value);
                                          }











                                        });

                                    print("sure connected ccc");

                                  }  else{
                                    print("sure NOt connected");
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Your offline please connect to internet to access this feuture'),backgroundColor: Colors.green.withOpacity(0.5),));
                                  }







                                }, icon: Image.asset(Assets.iconsScanner,height: 50,width: 50,)
                                )

                            ),
                          ],
                        ),
                      )
                     ,
                      button('Verify', () async {
                        apiController.verified.value= true;
                        apiController.scanreq.value.userId = apiController.userdata.value.userId.toString();


                        var datastus =await hasNetwork();
                        if (datastus) {
                          if (formKeysale.currentState!.validate()) {
                            apiController.scanreqq(apiController.scanreq.value);

                          }
                          print("sure connected ccc");

                        }  else{
                          print("sure NOt connected");
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Your offline please connect to internet to access this feuture'),backgroundColor: Colors.green.withOpacity(0.5),));
                        }





                      })
                    ],
                  ),

              ),


        // Obx(()=>
        //   Column(
        //     children: [
        //       apiController.verified.value?
        //       Padding(
        //         padding: const EdgeInsets.all(20.0),
        //         child: PhysicalModel(
        //           color: Colors.white,
        //           shadowColor: Colors.white.withOpacity(0.2),
        //           elevation: 3,
        //           borderRadius: BorderRadius.all(Radius.circular(5)),
        //           child: SizedBox(
        //             height: 230,
        //             child: Column(
        //               children: [
        //                 const SizedBox(height: 0),
        //
        //                 Container(
        //                   margin: EdgeInsets.only(left: 35,right: 25),
        //                   child: Row(
        //                     crossAxisAlignment: CrossAxisAlignment.center,
        //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                     children: [
        //                       Container(
        //
        //                       ),
        //
        //
        //                       IconButton(
        //                           onPressed: (){
        //                             apiController.verified.value= false;
        //                           }, icon: Icon(Icons.close)
        //                       ),
        //
        //                     ],
        //                   ),
        //                 ),
        //
        //
        //
        //                 Container(
        //                   margin: EdgeInsets.only(left: 15,right: 15),
        //                   child: Column(
        //                     children: [
        //
        //
        //
        //
        //                       SizedBox(height: 10,),
        //
        //                       Center(
        //                         child: Column(
        //                           children: [
        //                             Container(
        //                               height: 40,
        //                               width: 40
        //                               ,
        //                               child: apiController.scanned.value.status=='200'? Image.asset(Assets.iconsSuccess,height: 40,width: 40,):
        //                               apiController.scanned.value.status=='404'?
        //                               Icon(Icons.warning_amber_outlined,size: 25,color:Colors.red):  Icon(Icons.warning_amber_outlined,size: 25,color:  Colors.lightGreen,),
        //                             ),
        //
        //
        //                             Container(
        //                               margin: EdgeInsets.only(top: 15),
        //                               child: Text(
        //                                 'RCPT NO: ${apiController.scanreqd.value.receiptNo}',
        //                                 style: GoogleFonts.roboto(
        //                                   textStyle: TextStyle(color: colorsfontgrey, letterSpacing: 1,fontWeight: FontWeight.w400,fontSize: 15,fontStyle: FontStyle.normal),
        //                                 ),
        //
        //
        //                               ),
        //                             ),
        //
        //
        //                             Container(
        //                               margin: EdgeInsets.only(top: 15,bottom: 20),
        //                               child: Text(
        //                                 '${apiController.scanned.value.message}',
        //                                 style: GoogleFonts.roboto(
        //                                   textStyle: TextStyle(color: apiController.scanned.value.status=='200'?greencolor1:apiController.scanned.value.status=='404'?Colors.red: Colors.lightGreen, letterSpacing: 1,fontWeight: FontWeight.w400,fontSize: 15,fontStyle: FontStyle.normal),
        //                                 ),
        //
        //
        //                               ),
        //                             ),
        //                           ],
        //                         ),
        //                       ),
        //
        //
        //
        //
        //
        //
        //
        //
        //
        //
        //                       // button('OK', () {
        //                       //   Get.back();
        //                       //
        //                       // })
        //                     ],
        //                   ),
        //                 ),
        //
        //
        //
        //
        //
        //
        //               ],
        //             ),
        //           ),
        //         ),
        //       )
        //           :Container(),
        //
        //     ],
        //   ))
        //




















            ],
          ),
        ),
      ),
    );




  }







}


void openSuccessVerify() {
  Get.bottomSheet(
    SizedBox(
      height: 400,
      child: Column(
        children: [
          const SizedBox(height: 15),

          Container(
            margin: EdgeInsets.only(left: 35,right: 25),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(

                ),


                IconButton(
                    onPressed: (){
                      Get.back();
                    }, icon: Icon(Icons.close)
                ),

              ],
            ),
          ),



          Container(
            margin: EdgeInsets.only(left: 15,right: 15),
            child: Column(
              children: [




                SizedBox(height: 5,),

                Center(
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        width: 50
                        ,
                        child: apiController.scanned.value.status=='200'? Image.asset(Assets.iconsSuccess,height: 50,width: 50,):
                        apiController.scanned.value.status=='404'?
                        Icon(Icons.warning_amber_outlined,size: 35,color:Colors.red):  Icon(Icons.warning_amber_outlined,size: 35,color:  Colors.lightGreen,),
                      ),


                      Container(
                        margin: EdgeInsets.only(top: 15),
                        child: Text(
                          'RCPT NO: ${apiController.scanreqd.value.receiptNo}',
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(color: colorsfontgrey, letterSpacing: 1,fontWeight: FontWeight.w400,fontSize: 15,fontStyle: FontStyle.normal),
                          ),


                        ),
                      ),


                      Container(
                        margin: EdgeInsets.only(top: 15,bottom: 20),
                        child: Text(
                          '${apiController.scanned.value.message}',
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(color: apiController.scanned.value.status=='200'?greencolor1:apiController.scanned.value.status=='404'?Colors.red: Colors.lightGreen, letterSpacing: 1,fontWeight: FontWeight.w400,fontSize: 15,fontStyle: FontStyle.normal),
                          ),


                        ),
                      ),
                    ],
                  ),
                ),







                SizedBox(height: 15,),


                button('OK', () {
                  Get.back();

                })
              ],
            ),
          ),






        ],
      ),
    ),
    backgroundColor: Colors.white,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );
}
