import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:ects/model/border.dart';
import 'package:ects/model/customer.dart';
import 'package:ects/model/ports.dart';
import 'package:ects/model/saledate.dart';
import 'package:ects/screens/receipts/receipt.dart';
import 'package:ects/screens/sales/salesscreen.dart';
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
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

import '../../model/device.dart';
import '../../offlinedb/sqlite.dart';



class EditSalesTespa extends StatefulWidget {
  final SaleAdd sale;
  const EditSalesTespa(this.sale, {super.key});

  @override
  State<EditSalesTespa> createState() => _EditSalesTespaState();
}

class _EditSalesTespaState extends State<EditSalesTespa> {
  TextEditingController startdate = TextEditingController(text: DateFormat('yyyy-mm-dd, HH:MM').format(DateTime.now()).toString());

  TextEditingController startdate1 = TextEditingController(text: DateFormat('yyyy-mm-dd, HH:MM').format(DateTime.now()).toString());

  TextEditingController enddate = TextEditingController();
  final ScrollController scroll = ScrollController();
  final _multiSelectKey = GlobalKey<FormFieldState>();

  final formKeysale = GlobalKey<FormState>();

  String? _timeString;
  SingleValueDropDownController? cnt;

  List<DeviceElement>  salves=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    apiController.step1.value= true;
    apiController.step2.value= false;
    apiController.step3.value= false;
    print("3");

    print("offline receipt number");
    print(widget.sale.offline_receipt_number);
    cnt =SingleValueDropDownController(data: DropDownValueModel(
        name: widget.sale.serialNo??'', value: widget.sale.serialNo));





    apiController.prevoffreceipt.value =widget.sale.offline_receipt_number??"";

    if (widget.sale.vehicleTypeId== '1') {
      print(apiController.vtype.value);

      apiController.vtype.value='IT';
    }
    if ( widget.sale.vehicleTypeId=='2') {
      print("2");

      apiController.vtype.value='Dry Cargo';
    }
    if (widget.sale.vehicleTypeId=='3') {
      print("3");

      apiController.vtype.value='Wet Cargo';
    }









    if(apiController.saleedit.value.saleType =='1'){

      apiController.customertype.value='Cash Sale(TSH)';
    }
    if(apiController.saleedit.value.saleType =='2'){

      apiController.customertype.value='Cash Sale(Dollar)';
    }
    if(apiController.saleedit.value.saleType =='3'){

      apiController.customertype.value ='Bill Customer';
    }

    startdate.text=widget.sale.startDateTime??'';

    enddate.text = widget.sale.endDate??'';





    getoff();


    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());




    apiController.tzdl.value = widget.sale.tzl??'';
    apiController.saleedit.value.tripStatus =   '1';
    apiController.saleedit.value.salesPerson = apiController.userdata.value.userId.toString();
    apiController.saleedit.value.tzl =   apiController.tzdl.value;
    apiController.saleedit.value.saleDate = startdate.text;
    apiController.saleedit.value.startDateTime = startdate.text;
    apiController.saleedit.value.endDate = enddate.text;





  }



  Future<void> getoff() async {
    final dbHelper = DatabaseHelper();

    var data =  await dbHelper.getSales();
    apiController.salesdata.value = data;
    var mst =  await dbHelper.getmaster(0);
    apiController.masterd.value=mst;
    var slv =  await dbHelper.getSlaved(0);
    apiController.slaved.value=slv;

    var  slavedatadata = <DeviceSlave>[];

    for (var element in apiController.slaved.value) {

      slavedatadata.add(DeviceSlave(serialNo: element.serialNo??''));
      apiController.slaveed.add(DeviceSlave(serialNo: element.serialNo??''));


    }


    List<String>edtmaster = [];


    apiController.masterd.value.forEach((element) {
      edtmaster.add(element.serialNo??'');

    });




    var  slavedata = <DeviceSlave>[];


    var  slavedataa = <String>[];

    if (widget.sale.slaves!.isNotEmpty) {
      // apiController.editslave.value=[];
      apiController.editslave.value=[];

      slavedata=[];
      widget.sale.slaves?.forEach((element) {
        print("Sleve5 ${element.serialNo}");
        slavedata.add(DeviceSlave(serialNo: element.serialNo??''));

        slavedataa.add(element.serialNo??'');

        setState(() {

        });

        // apiController.editslaven.add(DeviceSlave(serialNo: element.serialNo??''));
      });

    }


    edtmaster.add(widget.sale.serialNo??"");

    apiController.editmaster.value = edtmaster;





    apiController.editslavend.value = slavedataa;
    apiController.editslaven.value = slavedata;
    apiController.editslavend.value= slavedataa;
    apiController.editslave.forEach((element) {
      print("Slavedd dcontroler ${element.serialNo}");


    });


    List<DeviceSlave> combinedList = List.from(slavedata);
    Set<DeviceSlave> uniqueElements = Set<DeviceSlave>.from(slavedata);

    for (DeviceSlave element in slavedatadata) {
      if (!uniqueElements.contains(element)) {
        combinedList.add(element);
        uniqueElements.add(element);
      }
    }

    apiController.slaveedcombn.value = combinedList;









  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    if (mounted) {
      setState(() {
        _timeString = formattedDateTime;
        startdate1.text=formattedDateTime;

      });
    }


  }

  String _formatDateTime(DateTime dateTime) {
    return  DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  String _formatDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }





  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();








  @override
  Widget build(BuildContext context) {
    // DateTime currentTime =  DateTime.now();
    // startdate.text =  DateFormat('yyyy-mm-dd  hh:mm:ss').format(DateTime.now()).toString();
    //


    return Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        body: SingleChildScrollView(
          // physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
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
                                child: Text('Edit Sales', style: font20white
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
                                borderRadius: BorderRadius.all(Radius.circular(121)),
                                color: primarycolor.withOpacity(0.6)

                            ),

                            child:  Container(
                              margin: EdgeInsets.only(left: 25,right: 25),
                              // padding: EdgeInsets.all(8),
                              child: Obx(()
                              => Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [

                                  apiController.step1.value?
                                  roundedstep('Step 01'):
                                  Container(
                                      alignment: Alignment.center
                                      ,
                                      child: Text('Step 01',style: font15white,)
                                  ),
                                  // Spacer(),

                                  apiController.step2.value?
                                  roundedstep('Step 02')
                                      : Container(
                                      alignment: Alignment.center
                                      ,
                                      child: Text('Step 02',style: font15white,)
                                  ),

                                  apiController.step3.value?
                                  roundedstep('Step 03')
                                      :
                                  Container(
                                      alignment: Alignment.center
                                      ,
                                      child: Text('Step 03',style: font15white,)
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


                  SizedBox(height: 0,),

                  SizedBox(
                    height: 560,

                    child: Form(
                      key: formKeysale,

                      child: Obx(()
                      =>
                          Column(
                            children: [

                              if ( apiController.step1.value)

                                SizedBox(
                                  height: 560,
                                  child: Scrollbar(
                                    controller: scroll,
                                    thumbVisibility: true,

                                    child: ListView(
                                      controller: scroll,
                                      padding:EdgeInsets.zero,
                                      children: [
                                        Column(


                                          children: [
                                            formfielunderlineedit('Customer Name', (value) {
                                              apiController.companyname.value = value??'';
                                              apiController.saleedit.value.companyName =      apiController.companyname.value;
                                            },apiController.saleedit.value.companyName??'')
                                            ,



                                            // Container(
                                            //   margin: EdgeInsets.only(left: 20,right: 20,top: 12),
                                            //   child: DropdownButtonFormField(
                                            //     // value: apiController.saleedit.value.serialNo??'',
                                            //
                                            //    hint:Text(apiController.saleedit.value.serialNo??'',style: font14black,)
                                            //    ,
                                            //
                                            //     icon:  Icon(Icons.keyboard_arrow_down_outlined),
                                            //
                                            //     decoration: InputDecoration(
                                            //       label: Text('Device',style: font15black,),
                                            //       contentPadding: EdgeInsets.all(12),
                                            //       filled: true,
                                            //       fillColor: Colors.white,
                                            //       // focusedBorder: OutlineInputBorder(
                                            //       //   borderSide: BorderSide(color: primarycolor),
                                            //       //   borderRadius: BorderRadius.circular(8.0),
                                            //       // ),
                                            //       enabledBorder: UnderlineInputBorder(
                                            //         borderSide: BorderSide(color: textgrey),
                                            //         borderRadius: BorderRadius.circular(8.0),
                                            //       ),
                                            //
                                            //       // suffix:
                                            //     ),
                                            //
                                            //     isExpanded: true,
                                            //     onChanged:(DeviceElement ?value) {
                                            //       apiController.selectedmaster.value = value?.serialNo??'';
                                            //       apiController.saleedit.value.serialNo= apiController.selectedmaster.value;
                                            //
                                            //     },
                                            //
                                            //
                                            //     validator: (DeviceElement ?value) {
                                            //       if (value?.serialNo=='') {
                                            //         return "can't be empty please choose one";
                                            //       }
                                            //       else if (value?.serialNo==null) {
                                            //         return "can't be empty please choose one";
                                            //       } else {
                                            //         return null;
                                            //       }
                                            //     },
                                            //
                                            //
                                            //     items: apiController.masterd.value
                                            //         .map((DeviceElement val) {
                                            //       return DropdownMenuItem(
                                            //         value: val,
                                            //         child: Text(
                                            //           val.serialNo??'',
                                            //           style: font14black,
                                            //         ),
                                            //       );
                                            //     }).toList(),
                                            //   ),
                                            // ),



                                            Container(
                                              margin: EdgeInsets.only(left: 20,right: 20,top: 12),
                                              child: DropDownTextField(
                                                clearOption: false,


                                                validator: (value) {
                                                  if (value=='') {
                                                    return "can't be empty please choose one";
                                                  }
                                                  else if (value==null) {
                                                    return "can't be empty please choose one";
                                                  } else {
                                                    return null;
                                                  }

                                                },

                                                // initialValue: apiController.saleedit.value.serialNo.toString(),
                                                controller: cnt,
                                                // initialValue:DropDownValueModel(
                                                //     name: widget.sale.serialNo??'', value: widget.sale.serialNo
                                                //
                                                // ) ,
                                                // [CustomerElement(id: widget.sale.id??0,companyName: widget.sale.companyName??'WEB')],



                                                keyboardType:TextInputType.number,
                                                dropDownIconProperty: IconProperty(icon: Icons.keyboard_arrow_down_outlined),
                                                textFieldFocusNode: textFieldFocusNode,
                                                searchFocusNode: searchFocusNode,
                                                textFieldDecoration:  InputDecoration(
                                                  label: Text('Master Device',style: font15black,),
                                                  contentPadding: EdgeInsets.all(12),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  // hintStyle: font14black,

                                                  // hintText: apiController.saleedit.value.serialNo??'',
                                                  // focusedBorder: OutlineInputBorder(
                                                  //   borderSide: BorderSide(color: primarycolor),
                                                  //   borderRadius: BorderRadius.circular(8.0),
                                                  // ),
                                                  enabledBorder: UnderlineInputBorder(
                                                    borderSide: BorderSide(color: textgrey),
                                                    borderRadius: BorderRadius.circular(8.0),
                                                  ),

                                                  // suffix:
                                                ),
                                                // searchAutofocus: true,
                                                dropDownItemCount: 8,
                                                searchShowCursor: false,

                                                enableSearch: true,
                                                searchKeyboardType: TextInputType.number,
                                                dropDownList:
                                                apiController.editmaster.value.map((String val) {
                                                  return DropDownValueModel(
                                                      name: val??'', value: val

                                                  );
                                                }).toList(),


                                                // ],
                                                onChanged: (val) {
                                                  print(val);


                                                  apiController.selectedmaster.value = val.value??'';
                                                  apiController.saleedit.value.serialNo= apiController.selectedmaster.value;

                                                },
                                              ),
                                            ),



                                            Container(
                                                alignment: Alignment.centerLeft,
                                                margin: EdgeInsets.only(left: 30,right: 20,top: 12),
                                                child: Text('Slave Device',style: font15black,)),



                                            Container(
                                              margin: EdgeInsets.only(left: 20,right: 20,top: 6),
                                              child:   MultiSelectDialogField<DeviceSlave>(
                                                searchable: true,



                                                initialValue: apiController.editslaven.value,
                                                items: apiController.slaveedcombn
                                                    .map((device) => MultiSelectItem<DeviceSlave>(device, device.serialNo??''))
                                                    .toList(),
                                                title: Text("Slave Device",style:font15black),

                                                selectedColor: greencolor1,


                                                decoration: BoxDecoration(

                                                  borderRadius: BorderRadius.all(Radius.circular(0)),
                                                  border: Border(
                                                    bottom: BorderSide(width: 1.0, color:textgrey ),
                                                  ),

                                                  // border: Border.all(
                                                  //   color: Colors.blue,
                                                  //   width: 2,
                                                  // ),
                                                ),
                                                buttonIcon: Icon(
                                                  Icons.keyboard_arrow_down_outlined,
                                                  color: colorsfontgrey,
                                                ),
                                                buttonText: Text(
                                                  "Slave",style: font15blackgrey,
                                                ),
                                                onConfirm: (results) {
                                                  //_selectedAnimals = results;
                                                  apiController.slavedata.value=[];

                                                  List<Slave> data= [];

                                                  for (var element in results) {
                                                    print(element.serialNo);
                                                    apiController.slavedata.add(element.serialNo);
                                                    data.add(Slave(serialNo: element.serialNo??''));
                                                  }
                                                  apiController.saleedit.value.slaves = data;

                                                  apiController.saleedit.value.slaves?.forEach((element) {
                                                    print("slacedata ${element.serialNo}");

                                                  });






                                                },
                                              ),

                                            ),


                                            dropdownedit('Vehicle Type',
                                                ['IT','Dry Cargo','Wet Cargo'],
                                                    (value) {
                                                  print("onchange");
                                                  apiController.vtype.value=value??'';


                                                  if (apiController.vtype.value=='IT') {
                                                    apiController.saleedit.value.vehicleTypeId= '1';
                                                  }
                                                  if (apiController.vtype.value=='Dry Cargo') {
                                                    apiController.saleedit.value.vehicleTypeId='2';
                                                  }
                                                  if (apiController.vtype.value=='Wet Cargo') {
                                                    apiController.saleedit.value.vehicleTypeId='3';
                                                  }



                                                },
                                                apiController.saleedit.value.vehicleTypeId=='1'?'IT':
                                                apiController.saleedit.value.vehicleTypeId=='2'?'Dry Cargo':'Wet Cargo'

                                            ),


                                            if (apiController.vtype.value=='IT')
                                              formfielunderlineedit('Chasis Number', (value) {
                                                apiController.chasis.value = value??'';
                                                apiController.saleedit.value.chasisNumber = apiController.chasis.value;

                                              },apiController.saleedit.value.chasisNumber??''),

                                            if (apiController.vtype.value=='Dry Cargo')
                                              formfielunderlineedit('Vehicle Number', (value) {
                                                apiController.vehicleno.value = value??'';
                                                apiController.saleedit.value.vehicleNumber=  apiController.vehicleno.value;

                                              },apiController.saleedit.value.vehicleNumber??''),
                                            if (apiController.vtype.value=='Dry Cargo')
                                              formfielunderlineedit('Container Number', (value) {
                                                apiController.containerno.value = value??'';
                                                apiController.saleedit.value.containerNumber=value??'';

                                              },apiController.saleedit.value.containerNumber??''),

                                            if (apiController.vtype.value=='Wet Cargo')

                                            // MultiSelectDialogField.initialValue
                                              Column(
                                                children: [


                                                ],
                                              ),


                                            if (apiController.vtype.value=='Dry Cargo')

                                            // MultiSelectDialogField.initialValue
                                              Column(




                                                children: [

                                                  Container(
                                                      alignment: Alignment.centerLeft,
                                                      margin: EdgeInsets.only(left: 30,right: 20,top: 12),
                                                      child: Text('Slave Device',style: font15black,)),

                                                  Container(
                                                    margin: EdgeInsets.only(left: 20,right: 20,top: 6),
                                                    child:   MultiSelectDialogField<DeviceSlave>(
                                                      searchable: true,


                                                      initialValue: apiController.editslaven.value,
                                                      items: apiController.slaveedcombn
                                                          .map((device) => MultiSelectItem<DeviceSlave>(device, device.serialNo??''))
                                                          .toList(),
                                                      title: Text("Slave Device",style:font15black),

                                                      selectedColor: greencolor1,

                                                      decoration: BoxDecoration(

                                                        borderRadius: BorderRadius.all(Radius.circular(0)),
                                                        border: Border(
                                                          bottom: BorderSide(width: 1.0, color:textgrey ),
                                                        ),

                                                        // border: Border.all(
                                                        //   color: Colors.blue,
                                                        //   width: 2,
                                                        // ),
                                                      ),
                                                      buttonIcon: Icon(
                                                        Icons.keyboard_arrow_down_outlined,
                                                        color: colorsfontgrey,
                                                      ),
                                                      buttonText: Text(
                                                        "Slave",style: font15blackgrey,
                                                      ),
                                                      onConfirm: (results) {
                                                        //_selectedAnimals = results;
                                                        apiController.slavedata.value=[];

                                                        List<Slave> data= [];

                                                        for (var element in results) {
                                                          print(element.serialNo);
                                                          apiController.slavedata.add(element.serialNo);
                                                          data.add(Slave(serialNo: element.serialNo??''));
                                                        }
                                                        apiController.saleedit.value.slaves = data;

                                                        apiController.saleedit.value.slaves?.forEach((element) {
                                                          print("slacedata ${element.serialNo}");

                                                        });






                                                      },
                                                    ),

                                                  ),
                                                ],
                                              ),




                                            if (apiController.vtype.value=='Wet Cargo')
                                              formfielunderlineedit('Vehicle Number', (value) {
                                                apiController.saleedit.value.vehicleNumber=value??'';


                                              },apiController.saleedit.value.vehicleNumber??''
                                              ),
                                            if (apiController.vtype.value=='Wet Cargo')
                                              formfielunderlineoptionedit('Trailer Number', (value) {
                                                // apiController.sale.value.=apiController.containerno.value;
                                                apiController.saleedit.value.trailerno =value??'';
                                              }, apiController.saleedit.value.trailerno??''),


                                            // Expanded(
                                            //   child: SizedBox(),
                                            // ),



                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.only(left: 22,right: 7,top: 30),

                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.only(left: 7,right:22,top: 30),
                                                    child: button1('NEXT', () async {



                                                      // if (formKeysale.currentState!.validate()) {
                                                      apiController.step1.value= false;
                                                      apiController.step2.value= true;
                                                      apiController.step3.value= false;


                                                      // }


                                                    }),
                                                  ),
                                                )
                                              ],
                                            ),

                                            SizedBox(height: 70,)





                                          ],
                                        ),
                                        SizedBox(height: 100,),
                                      ],
                                    ),
                                  ),
                                ),

                              if ( apiController.step2.value)

                                SizedBox(
                                  height: 560,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [

                                        Container(
                                          margin: EdgeInsets.only(left: 20,right: 20,top: 12),
                                          child: DropDownTextField(
                                            clearOption: false,

                                            initialValue: widget.sale.gateName,
                                            keyboardType:TextInputType.text,

                                            dropDownIconProperty: IconProperty(icon: Icons.keyboard_arrow_down_outlined),
                                            textFieldFocusNode: textFieldFocusNode,
                                            searchFocusNode: searchFocusNode,
                                            validator: (value) {
                                              if (value=='') {
                                                return "can't be empty please choose one";
                                              }
                                              else if (value==null) {
                                                return "can't be empty please choose one";
                                              } else {
                                                return null;
                                              }
                                            },
                                            textFieldDecoration:  InputDecoration(
                                              label: Text('From Port Point',style: font15black,),
                                              contentPadding: EdgeInsets.all(12),
                                              filled: true,
                                              fillColor: Colors.white,

                                              enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: textgrey),
                                                borderRadius: BorderRadius.circular(8.0),
                                              ),

                                              // suffix:
                                            ),
                                            // searchAutofocus: true,
                                            dropDownItemCount: 8,
                                            searchShowCursor: false,

                                            enableSearch: true,
                                            searchKeyboardType: TextInputType.text,
                                            dropDownList:
                                            apiController.ports.value.portPoints
                                            !.map((PortPoint val) {
                                              return DropDownValueModel(
                                                  name: val.gateName??'', value: val.id.toString()

                                              );
                                            }).toList(),


                                            // ],
                                            onChanged: (val) {

                                              apiController.port.value = val.value??'';
                                              apiController.saleedit.value.gateNumber = apiController.port.value;


                                            },
                                          ),
                                        ),

                                        Container(
                                          margin: EdgeInsets.only(left: 20,right: 20,top: 12),
                                          child: DropDownTextField(
                                            initialValue: widget.sale.borderName,
                                            keyboardType:TextInputType.text,
                                            clearOption: false,
                                            validator: (value) {
                                              if (value=='') {
                                                return "can't be empty please choose one";
                                              }
                                              else if (value==null) {
                                                return "can't be empty please choose one";
                                              } else {
                                                return null;
                                              }
                                            },
                                            dropDownIconProperty: IconProperty(icon: Icons.keyboard_arrow_down_outlined),
                                            textFieldFocusNode: textFieldFocusNode,
                                            searchFocusNode: searchFocusNode,
                                            textFieldDecoration:  InputDecoration(
                                              label: Text('To Border',style: font15black,),
                                              contentPadding: EdgeInsets.all(12),
                                              filled: true,
                                              fillColor: Colors.white,
                                              // focusedBorder: OutlineInputBorder(
                                              //   borderSide: BorderSide(color: primarycolor),
                                              //   borderRadius: BorderRadius.circular(8.0),
                                              // ),
                                              enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: textgrey),
                                                borderRadius: BorderRadius.circular(8.0),
                                              ),

                                              // suffix:
                                            ),
                                            // searchAutofocus: true,
                                            dropDownItemCount: 8,
                                            searchShowCursor: false,

                                            enableSearch: true,
                                            searchKeyboardType: TextInputType.text,
                                            dropDownList:
                                            apiController.borders.value.borders
                                            !.map((BorderElement? val) {
                                              return DropDownValueModel(
                                                  name: val?.title??'', value: val?.id.toString()

                                              );
                                            }).toList(),


                                            // ],
                                            onChanged: (val) {
                                              apiController.border.value =  val.value??'';
                                              apiController.saleedit.value.borderId =  apiController.border.value;



                                            },
                                          ),
                                        ),






                                        formfielunderlineedit('Driver', (value) {
                                          apiController.driver.value = value??'';
                                          apiController.saleedit.value.driverName =      apiController.driver.value;
                                        },apiController.saleedit.value.driverName??'')
                                        ,
                                        formfielunderlineedit('Passport', (value) {
                                          apiController.pasport.value = value??'';
                                          apiController.saleedit.value.passport=apiController.pasport.value;
                                        },apiController.saleedit.value.passport??'')
                                        ,
                                        formfielunderlineedit('Driver Number', (value) {
                                          apiController.drivernumber.value = value??'';
                                          apiController.saleedit.value.driverNumber =      apiController.drivernumber.value;

                                        },apiController.saleedit.value.driverNumber??''),


                                        // Expanded(
                                        //   child: SizedBox(),
                                        // ),



                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                margin: EdgeInsets.only(left: 22,right: 7,top: 30),
                                                child: buttonfaint1('BACK', () {
                                                  apiController.step1.value= true;
                                                  apiController.step2.value= false;
                                                  apiController.step3.value= false;

                                                }),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                margin: EdgeInsets.only(left: 7,right:22,top: 30),
                                                child: button1('NEXT', () {

                                                  // if (formKeysale.currentState!.validate()) {
                                                  apiController.step1.value= false;
                                                  apiController.step2.value= false;
                                                  apiController.step3.value= true;

                                                  //
                                                  // }




                                                }),
                                              ),
                                            )
                                          ],
                                        ),

                                        SizedBox(height: 70,)




                                      ],
                                    ),
                                  ),
                                ),

                              if ( apiController.step3.value)

                                SizedBox(
                                  height: 560,
                                  child: Column(
                                    children: [


                                      Container(
                                        margin: EdgeInsets.only(left: 20,right: 20),
                                        // padding: EdgeInsets.all(8),



                                        child: formfileddateundelinenew('Rental Start Date',
                                            startdate

                                        ),


                                      ),


                                      Container(
                                        margin: EdgeInsets.only(left: 20,right: 20,top: 22),
                                        // padding: EdgeInsets.all(8),



                                        child: formfileddateundelinenew('Rental End Date',
                                            enddate

                                        ),


                                      ),




                                      // formfielunderline('Driver Number', (value) {
                                      //   apiController.driver.value = value??'';
                                      //
                                      // }),


                                      formfielunderlinetzdledti('TZDL', (value) {
                                        apiController.tzdl.value = value??'';
                                        apiController.saleedit.value.tripStatus =   '1';
                                        apiController.saleedit.value.salesPerson = apiController.userdata.value.userId.toString();
                                        apiController.saleedit.value.tzl =   apiController.tzdl.value;
                                        apiController.saleedit.value.saleDate = startdate.text;
                                        apiController.saleedit.value.startDateTime = startdate.text;
                                        apiController.saleedit.value.endDate = enddate.text;

                                      },widget.sale.tzl??''),

                                      Expanded(
                                        child: SizedBox(),
                                      ),



                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                margin: EdgeInsets.only(left: 22,right: 7,top: 30),
                                                child: buttonfaint1('BACK', () {
                                                  apiController.step1.value= false;
                                                  apiController.step2.value= true;
                                                  apiController.step3.value= false;

                                                }),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                margin: EdgeInsets.only(left: 7,right:22,top: 30),
                                                child: button1('SUBMIT', () async {
                                                  var datastus =await hasNetwork();
                                                  final dbHelper = DatabaseHelper();


                                                  if (formKeysale.currentState!.validate()) {
                                                    apiController.saleprint.value= SaleAdd(saleDate: '', startDateTime: '', endDate: '', vehicleNumber: '', chasisNumber: '', tzl: '', driverName: '', borderId: '', tripStatus: '', driverNumber: '', serialNo: '', amount: '', currency: '', gateNumber: '', salesPerson: '', passport: '', containerNumber: '', vehicleTypeId: '', customerTypeId: '', companyName: '', customerId: '', agent: '', saleType: '',borderName: '',gateName: '', saleId: '',prev_offline_receipt_number:'',offline_receipt_number:"", slaves: []);

                                                    print(apiController.saleedit.value.tzl);

                                                    var t1 =   apiController.saleedit.value.tzl?.substring(apiController.tzdl.value.length - 3);
                                                    var t2 = 'RED'+t1!+startdate1.text;

                                                    var t3 =t2.replaceAll(' ', '').replaceAll('-', '').replaceAll(':', '');

                                                    apiController.salead.value.offline_receipt_number = t3;

                                                    apiController.salead.value = apiController.saleedit.value;
                                                    apiController.saleprint.value=  apiController.salead.value;
                                                    apiController.saleprint.value.offline_receipt_number= t3;
                                                    // apiController.salead.value.prev_offline_receipt_number = t3;
                                                    apiController.salead.value.prev_offline_receipt_number = apiController.prevoffreceipt.value ;
                                                    apiController.saleprint.value.prev_offline_receipt_number =apiController.prevoffreceipt.value ;
                                                    print(t3);
                                                    print("receipt ${ apiController.prevoffreceipt.value}");
                                                    print(apiController.salead.value.offline_receipt_number);



                                                    apiController.step1.value= true;
                                                    apiController.step2.value= false;
                                                    apiController.step3.value= false;
                                                    apiController.vtype.value=='';
                                                    apiController.customertype.value= '';

                                                    // apiController.saleprint.value.prev_offline_receipt_number=apiController.prevoffreceipt.value;
                                                    // apiController.salead.value.prev_offline_receipt_number=apiController.prevoffreceipt.value;
                                                    apiController.salead.value.prev_offline_receipt_number = apiController.prevoffreceipt.value ;
                                                    apiController.saleprint.value.prev_offline_receipt_number =apiController.prevoffreceipt.value ;

                                                    print("offlineB ${apiController.saleprint.value.offline_receipt_number}");
                                                    print("prevofflineA ${apiController.saleprint.value.prev_offline_receipt_number}");
                                                    print("offline1C ${apiController.salead.value.offline_receipt_number}");
                                                    print("prevoffline1CVsale ${apiController.salead.value.prev_offline_receipt_number}");
                                                    print(apiController.saleprint.value.offline_receipt_number);






                                                    apiController.saleedit.value.prev_offline_receipt_number= apiController.prevoffreceipt.value;
                                                    print("prevoffline1CVETD  ${apiController.saleedit.value.offline_receipt_number}");
                                                    print("prevoffline1CVED ${apiController.saleedit.value.prev_offline_receipt_number}");
                                                    print("receipt ${ apiController.prevoffreceipt.value}");
                                                    print("receiptt ${ widget.sale.offline_receipt_number}");

                                                    apiController.salead.value.receipt_number="";
                                                    // var data = await dbHelper.insertSale(apiController.salead.value);



                                                    print(t3);
                                                    print(apiController.salead.value.offline_receipt_number);
                                                    print(apiController.saleprint.value.prev_offline_receipt_number);
                                                    print(apiController.saleprint.value.offline_receipt_number);


                                                    if (datastus) {
                                                      apiController.editsale(apiController.saleedit.value);
                                                      print("sure connected ccc");

                                                    }  else{
                                                      apiController.salead.value.receipt_number="";
                                                      var data = await dbHelper.insertSale(apiController.salead.value);
                                                      print("offline");
                                                      if (data!='0') {
                                                        print("DATA ZEGEIMEGOMA");
                                                        receiptPrintcop(apiController.saleprint.value.tooMap());

                                                        if (datastus) {

                                                        }  else{
                                                          // openSuccessButtomto('Saved Successfully');

                                                          Get.back();
                                                          Get.off(()=>SalesScreen());
                                                          // Get.off(()=>SalesScreen());
                                                          print("offline");

                                                        }
                                                        // receiptPrint(sale.tooMap());
                                                      }else{
                                                        print("DATA ZEGE");
                                                      }

                                                    }





                                                    // print(data);
                                                    // print("saled");


                                                    // var data =  dbHelper.getSalesWithSlaves();




                                                  }





                                                }),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),

                                      SizedBox(height: 70,)



                                    ],
                                  ),
                                )



                              // SizedBox(height: 100,)




                            ],
                          ),

                      ),
                    ),
                  ),









                ]
            )
        )
    );
  }





}
