
import 'package:ects/borderuser/reportdevice.dart';
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


class HomePageborder extends StatefulWidget {
  const HomePageborder({super.key});

  @override
  State<HomePageborder> createState() => _HomePageborderState();
}

class _HomePageborderState extends State<HomePageborder> {


  final _qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();
  String? code;
  PackageInfo? packageInfo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiController.stepd1.value = true;
    apiController.stepd2.value = false;
    apiController.stepd3.value = false;
    apiController.borderdeviceload();
    apiController.deviceatdeviceload();
    apiController.deviceintransistload();

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
                          margin: EdgeInsets.only(right: 12),
                          alignment: Alignment.bottomLeft,
                          child: InkWell(
                              onTap: (){
                                // apiController.borderdeviceload();
                                Get.to(()=>ReportDevicesScreen());
                              },
                              child: Icon(Icons.print,color: whitecolor,)),),


                        Container(
                          margin: EdgeInsets.only(right: 12),
                          alignment: Alignment.bottomLeft,
                          child: InkWell(
                              onTap: (){
                                apiController.borderdeviceload();
                              },
                              child: Icon(Icons.refresh_outlined,color: whitecolor,)),),

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
               margin: EdgeInsets.only(left: 12, right: 12),
               // padding: EdgeInsets.all(8),
               child: Obx(
                     () => Row(
                   mainAxisAlignment:
                   MainAxisAlignment.spaceBetween,
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                     apiController.stepd1.value
                         ? roundedstep('Receive Item')
                         : InkWell(
                       onTap: () {
                         apiController.stepd1.value = true;
                         apiController.stepd2.value =
                         false;
                         apiController.stepd3.value = false;
                       },
                       child: Container(
                           alignment: Alignment.center,
                           child: Text(
                             'Receive Item',
                             style: font12white,
                           )),
                     ),
                     // Spacer(),

                     apiController.stepd2.value
                         ? roundedstep('Return Item')
                         : InkWell(
                       onTap: () {
                         apiController.stepd1.value =
                         false;
                         apiController.stepd2.value = true;
                         apiController.stepd3.value = false;
                       },
                       child: Container(
                           alignment: Alignment.center,
                           child: Text(
                             'Return Item',
                             style: font12white,
                           )),
                     ),



                     apiController.stepd3.value
                         ? roundedstep('Intransit')
                         : InkWell(
                       onTap: () {
                         apiController.stepd1.value =
                         false;
                         apiController.stepd2.value = false;
                         apiController.stepd3.value = true;
                       },
                       child: Container(
                           alignment: Alignment.center,
                           child: Text(
                             'Intransit',
                             style: font12white,
                           )),
                     ),


                     // S
                   ],
                 ),
               ),
             ),
           ),






                  ],
                ),
              ),

              Obx(()
               => Container(

                child:  apiController.borderloading.value? LinearProgressIndicator(
                backgroundColor: primarycolor,
                color: Colors.green,
                ):Container()),
              ),



              SizedBox(
                child: SingleChildScrollView(
                    child: Obx(
                          () => Column(
                        children: [
                          if (apiController.stepd1.value) tabSection(context),
                          if (apiController.stepd2.value)
                          // tabSectionTransfer(context),
                            Container(
                              margin: EdgeInsets.only(top: 0),
                              child: Stack(
                                children: [

                                  Container(child: tabSectionTransferat(context)),

                                  apiController.devicetomovesearchedatborder.where((elt) => elt.selected==true).isNotEmpty?
                                  Positioned(
                                    left: 10,
                                    right: 10,
                                    bottom: 25,
                                    child: button('Border Return ', () async {
                                      // openAsignButtom();



                                      var datastus =await hasNetwork();
                                      if (datastus) {
                                        apiController.comfd.value=[];

                                        apiController.devicetomovesearchedatborder.where((elt) => elt.selected==true).forEach((eldd) {
                                          apiController.comfd.value.add(Devicecomfirm(id: eldd.id,serialNo: eldd.serialNo));
                                          print("values ${eldd.id}  ${eldd.serialNo}");

                                        });



                                        apiController.comfirm.value.userId = apiController.userdata.value.userId.toString();
                                        apiController.comfirm.value.devices= apiController.comfd.value;


                                        print(comfirmDeviceToJson(apiController.comfirm.value));
                                        print("dataaa");




                                        apiController.comfirmreceivereturn( apiController.comfirm.value);




                                        print("sure connected ccc");

                                      }  else{
                                        print("sure NOt connected");
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Your offline please connect to internet to access this feuture'),backgroundColor: Colors.green.withOpacity(0.5),));
                                      }


                                      // Get.to(()=>NewSalesScreen());
                                    }),
                                  ):Container()
                                ],
                              ),
                            ),

                          if (apiController.stepd3.value)
                            tabSectionintrasity(context),
                        ],
                      ),
                    )),
              ),










            ],
          ),
        ),
      ),
    );




  }


  Widget tabSectionintrasity(BuildContext context){
    return Container(
      margin: EdgeInsets.only(top: 0),
      child: Stack(
        children: [
          Container(child: tabSectionintransist(context)),

          apiController.devicetomovesearchedintra.where((elt) => elt.selected==true).isNotEmpty?
          Positioned(
            left: 10,
            right: 10,
            bottom: 25,
            child: button('Border Return ', () async {
              // openAsignButtom();



              var datastus =await hasNetwork();
              if (datastus) {
                apiController.comfd.value=[];

                apiController.devicetomovesearchedintra.where((elt) => elt.selected==true).forEach((eldd) {
                  apiController.comfd.value.add(Devicecomfirm(id: eldd.id,serialNo: eldd.serialNo));
                  print("values ${eldd.id}  ${eldd.serialNo}");

                });



                apiController.comfirm.value.userId = apiController.userdata.value.userId.toString();
                apiController.comfirm.value.devices= apiController.comfd.value;


                print(comfirmDeviceToJson(apiController.comfirm.value));
                print("dataaa");




                apiController.comfirmreceiveintransity( apiController.comfirm.value);




                print("sure connected ccc");

              }  else{
                print("sure NOt connected");
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Your offline please connect to internet to access this feuture'),backgroundColor: Colors.green.withOpacity(0.5),));
              }


              // Get.to(()=>NewSalesScreen());
            }),
          ):Container()
        ],
      ),
    );
  }

  Widget tabSection(BuildContext context) {

    return Container(
      margin: EdgeInsets.only(top: 0),
      child: Stack(
        children: [
          Container(child: tabSectionTransfer(context)),

          apiController.devicetomovesearched.where((elt) => elt.selected==true).isNotEmpty?
          Positioned(
            left: 10,
            right: 10,
            bottom: 25,
            child: button('Border Receive', () async {
              // openAsignButtom();



              var datastus =await hasNetwork();
              if (datastus) {
                apiController.comfd.value=[];

                apiController.devicetomovesearched.where((elt) => elt.selected==true).forEach((eldd) {
                  apiController.comfd.value.add(Devicecomfirm(id: eldd.id,serialNo: eldd.serialNo));
                  print("values ${eldd.id}  ${eldd.serialNo}");

                });



                apiController.comfirm.value.userId = apiController.userdata.value.userId.toString();
                apiController.comfirm.value.devices= apiController.comfd.value;


                print(comfirmDeviceToJson(apiController.comfirm.value));
                print("dataaa");




                apiController.comfirmreceive( apiController.comfirm.value);




                print("sure connected ccc");

              }  else{
                print("sure NOt connected");
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Your offline please connect to internet to access this feuture'),backgroundColor: Colors.green.withOpacity(0.5),));
              }


              // Get.to(()=>NewSalesScreen());
            }),
          ):Container()
        ],
      ),
    );

  }

  Widget tabSectionbkp(BuildContext context) {
    var devices=  apiController.devicetomove.value.devices??[];
    apiController.devicetomovesearch.value= devices;
    return Obx(()=>
       Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child:Text("",style: font18black,)
          ),
          SizedBox(
            //Add this to give height
            height: MediaQuery.of(context).size.height * 0.55,
            child:     Container(
                margin: EdgeInsets.only(bottom: 30),
                child: SingleChildScrollView(
                  child: Column(
                    children: [


                      (apiController.devicetomove.value.devices??[]).isNotEmpty
                          ? Column(
                            children: [


                              Padding(
                                padding: const EdgeInsets.all(22.0),
                                child: formfiledb('Device ...', (vad) {

                                  if (vad=="") {
                                    apiController.devicetomovesearch.value =  devices;

                                  }else if (vad==null) {
                                    apiController.devicetomovesearch.value =  devices;

                                  }else{
                                    apiController.devicetomovesearch.value =  devices.where((el) => el.serialNo!.toLowerCase().contains(vad.toLowerCase())).toList();

                                  }

                                }),
                              ),


                              ListView.builder(
                              padding: EdgeInsets.zero,
                              reverse: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount:
                              apiController.devicetomovesearch.length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return card_deviceall(
                                    'SN:${apiController.devicetomovesearch![index].serialNo ?? ''}',
                                    "Master",
                                        () {});
                              }),



                            ],
                          )
                          : apiController.borderloading.value?Container():Center(child: nodata('No Device')),
                      SizedBox(
                        height: 50,
                      )
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Widget tabSectionTransfer(BuildContext context) {
    var devices=  apiController.devicetomove.value.devices??[];
    apiController.devicetomovesearch.value= devices;
    return SizedBox(
      //Add this to give height
      height: MediaQuery.of(context).size.height * 0.55,
      child: Container(
          margin: EdgeInsets.only(bottom: 80),
          child: SingleChildScrollView(
            child: Obx(
                  () => Column(
                children: [

                  Container(
                    margin: EdgeInsets.only(top: 20),
                  child:Text(
                  'List of Device Waiting to Receive',
                    style: font14black,
                  ),
            ),

                  (apiController.devicetomove.value.devices??[]).isNotEmpty
                      ? Column(
                        children: [
                          SizedBox(height: 22,),


                          SizedBox(
                            height:50,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 9,left: 20),
                                    child: formfiledb('Device ...', (vad) {

                                      if (vad=="") {
                                        apiController.devicetomovesearched.value =  devices;

                                      }else if (vad==null) {
                                        apiController.devicetomovesearched.value =  devices;

                                      }else{
                                        apiController.devicetomovesearched.value =  devices.where((el) => el.serialNo!.toLowerCase().contains(vad.toLowerCase())).toList();

                                      }

                                    }),
                                  ),
                                ),

                                Container(
                                  width: 50,
                                  margin: const EdgeInsets.only(right: 5),
                                  child:  IconButton(onPressed: () async {
                                    print("code scannneddd");

                                    var datastus =await hasNetwork();
                                    if (datastus) {
                                      _qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
                                          context: Get.context,
                                          onCode: (code) {
                                            setState(() {
                                              this.code = code;
                                            });
                                            var scanned =  devices.where((elf) => elf.serialNo!.toLowerCase().contains(code!.toLowerCase())).toList();

                                            if (scanned.isNotEmpty) {
                                              print(code);
                                              print("code scannned");
                                              print("Exists");
                                              print(scanned.first.serialNo);
                                              print(scanned.first.id);

                                              apiController.comfd.value=[];
                                              apiController.comfd.add(Devicecomfirm(id: scanned.first.id,serialNo: scanned.first.serialNo));
                                              apiController.comfirm.value.userId = apiController.userdata.value.userId.toString();
                                              apiController.comfirm.value.devices= apiController.comfd.value;
                                              print(comfirmDeviceToJson(apiController.comfirm.value));
                                              print("dataaa");


                                              apiController.comfirmreceive( apiController.comfirm.value);




                                            } else{
                                              print("NOT Exists");
                                              print(code);
                                              print("code scannned");
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
                          ),

                          

                          ListView.builder(
                          padding: EdgeInsets.zero,
                          reverse: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount:
                          apiController.devicetomovesearched.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            AllnDevice device =
                            apiController.devicetomovesearched[index];

                            return card_checkbox('SN: ${device.serialNo}',
                                    (value) {
                                  setState(() {});
                                  print("checked ${value}");
                                  print(device.id);
                                  print(device.serialNo);

                                  apiController.devicetomovesearched[index]
                                      .selected = value ?? false;
                                },
                                apiController.devicetomovesearched[index]
                                    .selected ??
                                    false);
                          }),
                        ],
                      )
                      : apiController.borderloading.value?Container():Center(child: nodata('No Device')),
                  SizedBox(
                    height: 60,
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget tabSectionintransist(BuildContext context) {
    var devices=  apiController.devicetomoveintra.value.devices??[];
    apiController.devicetomovesearch.value= devices;
    return SizedBox(
      //Add this to give height
      height: MediaQuery.of(context).size.height * 0.55,
      child: Container(
          margin: EdgeInsets.only(bottom: 80),
          child: SingleChildScrollView(
            child: Obx(
                  () => Column(
                children: [

                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child:Text(
                      'List of Device Intransit',
                      style: font14black,
                    ),
                  ),

                  (apiController.devicetomoveintra.value.devices??[]).isNotEmpty
                      ? Column(
                    children: [
                      SizedBox(height: 22,),


                      SizedBox(
                        height:50,
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 9,left: 20),
                                child: formfiledb('Device ...', (vad) {

                                  if (vad=="") {
                                    apiController.devicetomovesearchedintra.value =  devices;

                                  }else if (vad==null) {
                                    apiController.devicetomovesearchedintra.value =  devices;

                                  }else{
                                    apiController.devicetomovesearchedintra.value =  devices.where((el) => el.serialNo!.toLowerCase().contains(vad.toLowerCase())).toList();

                                  }

                                }),
                              ),
                            ),

                            Container(
                                width: 50,
                                margin: const EdgeInsets.only(right: 5),
                                child:  IconButton(onPressed: () async {
                                  print("code scannneddd");

                                  var datastus =await hasNetwork();
                                  if (datastus) {
                                    _qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
                                        context: Get.context,
                                        onCode: (code) {
                                          setState(() {
                                            this.code = code;
                                          });
                                          var scanned =  devices.where((elf) => elf.serialNo!.toLowerCase().contains(code!.toLowerCase())).toList();

                                          if (scanned.isNotEmpty) {
                                            print(code);
                                            print("code scannned");
                                            print("Exists");
                                            print(scanned.first.serialNo);
                                            print(scanned.first.id);

                                            apiController.comfd.value=[];
                                            apiController.comfd.add(Devicecomfirm(id: scanned.first.id,serialNo: scanned.first.serialNo));
                                            apiController.comfirm.value.userId = apiController.userdata.value.userId.toString();
                                            apiController.comfirm.value.devices= apiController.comfd.value;
                                            print(comfirmDeviceToJson(apiController.comfirm.value));
                                            print("dataaa");


                                            apiController.comfirmreceive( apiController.comfirm.value);




                                          } else{
                                            print("NOT Exists");
                                            print(code);
                                            print("code scannned");
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
                      ),



                      ListView.builder(
                          padding: EdgeInsets.zero,
                          reverse: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount:
                          apiController.devicetomovesearchedintra.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            AllnDevice device =
                            apiController.devicetomovesearchedintra[index];

                            return card_checkbox('SN: ${device.serialNo}',
                                    (value) {
                                  setState(() {});
                                  print("checked ${value}");
                                  print(device.id);
                                  print(device.serialNo);

                                  apiController.devicetomovesearchedintra[index]
                                      .selected = value ?? false;
                                },
                                apiController.devicetomovesearchedintra[index]
                                    .selected ??
                                    false);
                          }),
                    ],
                  )
                      : apiController.borderloadingintra.value?Container():Center(child: nodata('No Device')),
                  SizedBox(
                    height: 60,
                  ),
                ],
              ),
            ),
          )),
    );
  }


  Widget tabSectionTransferat(BuildContext context) {
    var devices=  apiController.devicetomoveatborder.value.devices??[];
    apiController.devicetomovesearchatborder.value= devices;
    return SizedBox(
      //Add this to give height
      height: MediaQuery.of(context).size.height * 0.55,
      child: Container(
          margin: EdgeInsets.only(bottom: 80),
          child: SingleChildScrollView(
            child: Obx(
                  () => Column(
                children: [

                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child:Text(
                      'List of Device Waiting to be Returned to Office',
                      style: font14black,
                    ),
                  ),

                  (apiController.devicetomoveatborder.value.devices??[]).isNotEmpty
                      ? Column(
                    children: [
                      SizedBox(height: 22,),


                      SizedBox(
                        height:50,
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 9,left: 20),
                                child: formfiledb('Device ...', (vad) {

                                  if (vad=="") {
                                    apiController.devicetomovesearchedatborder.value =  devices;

                                  }else if (vad==null) {
                                    apiController.devicetomovesearchedatborder.value =  devices;

                                  }else{
                                    apiController.devicetomovesearchedatborder.value =  devices.where((el) => el.serialNo!.toLowerCase().contains(vad.toLowerCase())).toList();

                                  }

                                }),
                              ),
                            ),

                            Container(
                                width: 50,
                                margin: const EdgeInsets.only(right: 5),
                                child:  IconButton(onPressed: () async {
                                  print("code scannneddd");

                                  var datastus =await hasNetwork();
                                  if (datastus) {
                                    _qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
                                        context: Get.context,
                                        onCode: (code) {
                                          setState(() {
                                            this.code = code;
                                          });
                                          var scanned =  devices.where((elf) => elf.serialNo!.toLowerCase().contains(code!.toLowerCase())).toList();

                                          if (scanned.isNotEmpty) {
                                            print(code);
                                            print("code scannned");
                                            print("Exists");
                                            print(scanned.first.serialNo);
                                            print(scanned.first.id);

                                            apiController.comfd.value=[];
                                            apiController.comfd.add(Devicecomfirm(id: scanned.first.id,serialNo: scanned.first.serialNo));
                                            apiController.comfirm.value.userId = apiController.userdata.value.userId.toString();
                                            apiController.comfirm.value.devices= apiController.comfd.value;
                                            print(comfirmDeviceToJson(apiController.comfirm.value));
                                            print("dataaa");


                                            apiController.comfirmreceive( apiController.comfirm.value);




                                          } else{
                                            print("NOT Exists");
                                            print(code);
                                            print("code scannned");
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
                      ),



                      ListView.builder(
                          padding: EdgeInsets.zero,
                          reverse: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount:
                          apiController.devicetomovesearchedatborder.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            AllnDevice device =
                            apiController.devicetomovesearchedatborder[index];

                            return card_checkbox('SN: ${device.serialNo}',
                                    (value) {
                                  setState(() {});
                                  print("checked ${value}");
                                  print(device.id);
                                  print(device.serialNo);

                                  apiController.devicetomovesearchedatborder[index]
                                      .selected = value ?? false;
                                },
                                apiController.devicetomovesearchedatborder[index]
                                    .selected ??
                                    false);
                          }),
                    ],
                  )
                      : apiController.borderloadingatborder.value?Container():Center(child: nodata('No Device')),
                  SizedBox(
                    height: 60,
                  ),
                ],
              ),
            ),
          )),
    );
  }








}
