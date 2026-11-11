import 'dart:convert';

import 'package:ects/model/transfer.dart';
import 'package:ects/widget/widgetconstant.dart';
import 'package:ects/widget/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constant/colorcontant.dart';
import '../../controller/controllerconstant.dart';
import '../../generated/assets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/alldevice.dart';

class DeviceScreen extends StatefulWidget {
  const DeviceScreen({super.key});

  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  var groupvalue = ['1', '2', '3', '4'];

  var value = '1';

  String _radioValue = "";

  void _handleRadioValueChange(String value) {
    setState(() {
      _radioValue = value;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    apiController.stepd1.value = true;
    apiController.stepd2.value = false;
    apiController.getoff();
    apiController.masterload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        body: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
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
                                  fit: BoxFit.fill)),
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
                                child: Text('Device', style: font20white
                                    // TextStyle(fontWeight: FontWeight.w500,color: whitecolor,fontSize: 16),),
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 143,
                          left: 21,
                          right: 21,
                          child: Container(
                            height: 48,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(121)),
                                color: primarycolor.withOpacity(0.6)),
                            child: Container(
                              margin: EdgeInsets.only(left: 25, right: 25),
                              // padding: EdgeInsets.all(8),
                              child: Obx(
                                () => Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    apiController.stepd1.value
                                        ? roundedstep('My Device')
                                        : InkWell(
                                            onTap: () {
                                              apiController.stepd1.value = true;
                                              apiController.stepd2.value =
                                                  false;
                                            },
                                            child: Container(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'My Device',
                                                  style: font15white,
                                                )),
                                          ),
                                    // Spacer(),

                                    apiController.stepd2.value
                                        ? roundedstep('Transfer')
                                        : InkWell(
                                            onTap: () {
                                              apiController.stepd1.value =
                                                  false;
                                              apiController.stepd2.value = true;
                                              apiController.alldeviceload();
                                            },
                                            child: Container(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'Transfer',
                                                  style: font15white,
                                                )),
                                          ),

                                    // S
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
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
                                  Container(child: tabSectionTransfer(context)),

                                  apiController.devices.where((elt) => elt.selected==true).isNotEmpty?
                                  Positioned(
                                    left: 10,
                                    right: 10,
                                    bottom: 25,
                                    child: button('Assign User', () async {
                                      // openAsignButtom();
                                      apiController.devicescomfirm1.value=[];
                                      var datastus =await hasNetwork();

                                      //
                                      // apiController.devices.

                                      apiController.devices.where((elt) => elt.selected==true).forEach((element) {
                                        apiController.devicescomfirm1.add(AllnDevice(id: element.id,serialNo: element.serialNo,selected: element.selected));
                                      });



                                      //
                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                      var data =List<dynamic>.from(apiController.devicescomfirm1.map((x) => x.toJson()));
                                      prefs.setString('assign', json.encode(data));

                                      print(json.encode(data));


                                      if (datastus) {
                                        apiController.staffsearched.value= apiController.staff.value.staffs??[];
                                        openAsignButtomsheet(context);
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
                        ],
                      ),
                    )),
                  ),
                ])));
  }

  Widget tabSection(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: TabBar(
                unselectedLabelColor: Colors.grey,
                indicatorColor: primarycolor,
                labelColor: primarycolor,
                tabs: [
                  // Tab(text: "All(200)"),
                  Tab(
                      text:
                          "Master(${apiController.masterd.length})"),
                  Tab(
                      text:
                          "Slave(${apiController.slaved.length})"),
                ]),
          ),
          SizedBox(
            //Add this to give height
            height: MediaQuery.of(context).size.height * 0.55,
            child: TabBarView(children: [
              Container(
                  margin: EdgeInsets.only(bottom: 30),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        apiController.masterd.isNotEmpty
                            ? ListView.builder(
                                padding: EdgeInsets.zero,
                                reverse: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount:
                                    apiController.masterd.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return card_device(
                                      'SN:${apiController.masterd[index].serialNo ?? ''}',
                                      "Master",
                                      () {});
                                })
                            : Center(child: nodata('No Device')),
                        SizedBox(
                          height: 50,
                        )
                      ],
                    ),
                  )),
              Container(
                  margin: EdgeInsets.only(bottom: 30),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        apiController.slaved.isNotEmpty
                            ? ListView.builder(
                                padding: EdgeInsets.zero,
                                reverse: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount:
                                    apiController.slaved.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return card_device(
                                      'SN:${apiController.slaved[index].serialNo ?? ''}',
                                      "Slave",
                                      () {});
                                })
                            : Center(child: nodata('No Device')),
                        SizedBox(
                          height: 50,
                        )
                      ],
                    ),
                  )),
              // Container(
              //     margin: EdgeInsets.only(bottom: 130),
              //     child: SingleChildScrollView(
              //       child: Column(
              //         children: [
              //           // card_device('SN:284738438958485', 'Slave', () { }),
              //           // card_device('SN: 284738438958485', 'Slave', () { }),
              //
              //
              //           nodata('No Device')
              //
              //
              //         ],
              //       ),
              //     )
              // ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget tabSectionTransfer(BuildContext context) {
    List<AllnDevice> trdevices = apiController.devicestrd.value;



    return SizedBox(
      //Add this to give height
      height: MediaQuery.of(context).size.height * 0.55,
      child: Container(
          margin: EdgeInsets.only(bottom: 80),
          child: SingleChildScrollView(
            child: Obx(
              () => Column(
                children: [
                  apiController.devicestrd.isNotEmpty
                      ? Column(
                        children: [

                          Padding(
                            padding: const EdgeInsets.all(22.0),
                            child: formfiledb('Search Device ...', (vad) {

                              if (vad=="") {
                                apiController.devices.value =  trdevices??[];

                              }else if (vad==null) {
                                apiController.devices.value =  trdevices??[];

                              }else{
                                apiController.devices.value =  trdevices.where((el) => el.serialNo!.toLowerCase().contains(vad.toLowerCase())).toList();

                              }

                            }),
                          ),


                          ListView.builder(
                              padding: EdgeInsets.zero,
                              reverse: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount:
                              apiController.devices.length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                AllnDevice device =
                                apiController.devices[index];

                                return card_checkbox('SN: ${device.serialNo}',
                                    (value) {
                                  setState(() {});
                                  print("checked ${value}");

                                  apiController.devices[index]
                                      .selected = value ?? false;
                                },
                                    apiController.devices[index]
                                            .selected ??
                                        false);
                              }),
                        ],
                      )
                      : Center(child: nodata('No Device')),
                  SizedBox(
                    height: 60,
                  ),
                ],
              ),
            ),
          )),
    );
  }

  void openAsignButtom() {
    Get.bottomSheet(
      isScrollControlled: true,
      SizedBox(
        height: 500,
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: SizedBox(
            child: Column(
              children: [
                const SizedBox(height: 15),
                Container(
                  margin: EdgeInsets.only(left: 35, right: 25),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(),
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(Icons.close)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: formfiledb('Search User ...', (value) {}),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      card_radio('Mike Dev', (val) {
                        setState(() {
                          value = val;
                        });
                      }, value, '1'),
                      card_radio('Test User', (val) {
                        setState(() {
                          value = val;
                        });
                      }, value, '2'),
                      card_radio('Mike Dev', (val) {
                        setState(() {
                          value = val;
                        });
                      }, value, '1'),
                      card_radio('Test User', (val) {
                        setState(() {
                          value = val;
                        });
                      }, value, '2'),
                      card_radio('Mike Dev', (val) {
                        setState(() {
                          value = val;
                        });
                      }, value, '1'),
                      card_radio('Test User', (val) {
                        setState(() {
                          value = val;
                        });
                      }, value, '2'),
                      card_radio('Mike Dev', (val) {
                        setState(() {
                          value = val;
                        });
                      }, value, '1'),
                      card_radio('Test User', (val) {
                        setState(() {
                          value = val;
                        });
                      }, value, '2'),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  void openAsignButtomsheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: whitecolor,
      isScrollControlled: true,
      elevation: 0.1,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.2,
          maxChildSize: 0.75,
          expand: false,
          builder: (_, controller) => StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    var stafsss=  apiController.staff.value.staffs??[];

                return Obx(()=>
                  Column(
                    children: [
                      const SizedBox(height: 15),
                      Container(
                        margin: EdgeInsets.only(left: 35, right: 25),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(),
                            IconButton(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: Icon(Icons.close)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(22.0),
                        child: formfiledb('Search User ...', (vad) {

                          if (vad=="") {
                            apiController.staffsearched.value =  apiController.staff.value.staffs??[];

                          }else if (vad==null) {
                            apiController.staffsearched.value =  apiController.staff.value.staffs??[];

                          }else{
                            apiController.staffsearched.value =  stafsss.where((el) => el.names!.toLowerCase().contains(vad.toLowerCase())).toList();

                          }

                        }),
                      ),
                      Expanded(
                        child: ListView(children: <Widget>[
                          apiController.staffsearched.isNotEmpty
                              ? ListView.builder(
                                  padding: EdgeInsets.zero,
                                  reverse: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount:
                                  apiController.staffsearched.length ??
                                          0,
                                  shrinkWrap: true,
                                  itemBuilder: (BuildContext context, int index) {
                                    return card_radio(
                                        apiController.staffsearched[index]
                                                .names ??
                                            'Mike Dev', (val) {
                                      apiController.transder.value.toId = val.toString();

                                      apiController.toid.value = val.toString();

                                      print(val.toString());



                                      setState(() =>  _radioValue = val);


                                    },
                                        _radioValue,
                                        apiController.staffsearched[index].id
                                            .toString());
                                  })
                              : Center(child: nodata('No Staff')),
                          SizedBox(
                            height: 50,
                          ),
                        ]),
                      ),
                      apiController.transder.value.toId!=null?Container(
                        margin: EdgeInsets.only(bottom: 60),
                        child: button('SUBMIT', () async {
                          Get.back();
                          apiController.devicescomfirm.value=[];




                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          // var data =List<dynamic>.from(apiController.devices.map((x) => x.toJson()));
                          var datamp =prefs.getString('assign');
                          var dataj = json.decode(datamp??"");

                          print("ectsvv $dataj");

                          apiController.devicescomfirm.value =List<AllnDevice>.from(dataj.map((x) => AllnDevice.fromJson(x)));


                          apiController.transder.value.devices=apiController.devicescomfirm.value;
                          for (var ets in apiController.devicescomfirm) {
                            print("${ets.serialNo}");
                            // apiController.transder.value.devices?.add(Devicetr(
                            //   id: ets.id,
                            //   serialNo: ets.serialNo
                            // ));
                          }
                          // apiController.transder.value.devices= apiController.devicescomfirm.value;
                          apiController.transder.value.fromId = apiController.userdata.value.userId.toString();



                          apiController.transferdat(apiController.transder.value);


                        }),
                      ):Container(),
                    ],
                  ),
                );
              })),
    );
  }
}
