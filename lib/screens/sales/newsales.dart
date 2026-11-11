import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:ects/model/border.dart';
import 'package:ects/model/customer.dart';
import 'package:ects/model/ports.dart';
import 'package:ects/model/saledate.dart';
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
import '../../widget/arlet.dart';
import '../receipts/receipt.dart';




class NewSalesScreen extends StatefulWidget  {
  const NewSalesScreen({super.key});

  @override
  State<NewSalesScreen> createState() => _NewSalesScreenState();
}

class _NewSalesScreenState extends State<NewSalesScreen> with AutomaticKeepAliveClientMixin {
  TextEditingController startdate = TextEditingController(text: DateFormat('yyyy-mm-dd, HH:MM').format(DateTime.now()).toString());

  TextEditingController enddate = TextEditingController();
  final ScrollController scroll = ScrollController();
  final _multiSelectKey = GlobalKey<FormFieldState>();

  final formKeysale = GlobalKey<FormState>();
  String? _timeString;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    apiController.masterload();

    getoff();

    apiController.step1.value= true;
    apiController.step2.value= false;
    apiController.step3.value= false;
    apiController.ispastesale.value= false;
    // _timeString = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());

  }












Future<void> getoff() async {
  final dbHelper = DatabaseHelper();

  var data =  await dbHelper.getSales();
  apiController.salesdata.value = data;
  var mst =  await dbHelper.getmaster(0);
  apiController.masterd.value=mst;
  var slv =  await dbHelper.getSlaved(0);
  apiController.slaved.value=slv;

}


@override
  bool get wantKeepAlive => true;


  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    if (mounted) {
      setState(() {
        _timeString = formattedDateTime;
        startdate.text=formattedDateTime;
        final today = DateTime.now();
        enddate.text = _formatDate(now.add(const Duration(days: 6)));
      });
    }


  }

  String _formatDateTime(DateTime dateTime) {
    return  DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  String _formatDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();



  final TextEditingController form1 = TextEditingController();




  @override
  Widget build(BuildContext context) {
    super.build(context);
    // DateTime currentTime =  DateTime.now();
    // startdate.text =  DateFormat('yyyy-mm-dd  hh:mm:ss').format(DateTime.now()).toString();
    //


    return Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        extendBody: true,
        body: SingleChildScrollView(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
          // physics: NeverScrollableScrollPhysics(),
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
                          right: 20,

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
                                  child: Text('New Sales', style: font20white
                                    // TextStyle(fontWeight: FontWeight.w500,color: whitecolor,fontSize: 16),),
                                  ),
                                ),
                                Spacer(),
                                Container(

                                  alignment: Alignment.centerRight,
                                  child: InkWell(
                                      onTap: (){
                                        openMenusheet(context);
                                      },
                                      child: Icon(Icons.more_vert_rounded,color: whitecolor,)),),
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

                 Obx( ()=>Column(
                      children: [
                        !apiController.ispastesale.value?
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

                                          child: SingleChildScrollView(
                                            controller: scroll,
                                            padding:EdgeInsets.zero,

                                            child: Column(


                                              children: [
                                                dropdown('Vehicle Type',
                                                    ['IT','Dry Cargo','Wet Cargo'],
                                                        (value) {
                                                      apiController.vtype.value=value??'';


                                                      if (apiController.vtype.value=='IT') {
                                                        apiController.sale.value.vehicleTypeId= '1';
                                                      }
                                                      if (apiController.vtype.value=='Dry Cargo') {
                                                        apiController.sale.value.vehicleTypeId='2';
                                                      }
                                                      if (apiController.vtype.value=='Wet Cargo') {
                                                        apiController.sale.value.vehicleTypeId='3';
                                                      }





                                                    }),


                                                // Container(
                                                //   margin: EdgeInsets.only(left: 20,right: 20,top: 12),
                                                //   child: DropdownButtonFormField(
                                                //
                                                //
                                                //     icon:  Icon(Icons.keyboard_arrow_down_outlined),
                                                //     // value: null,
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
                                                //       apiController.sale.value.serialNo= apiController.selectedmaster.value;
                                                //
                                                //     },
                                                //     // validator: (DeviceElement ?value) {
                                                //     //   if (value?.serialNo==null) {
                                                //     //     return "can't empty please choose one";
                                                //     //   } else {
                                                //     //     return null;
                                                //     //   }
                                                //     // },
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
                                                //     items:   apiController.masterd.value
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
                                                    // initialValue: apiController.salehold.value.companyName,
                                                    // [CustomerElement(id: widget.sale.id??0,companyName: widget.sale.companyName??'WEB')],




                                                    dropDownIconProperty: IconProperty(icon: Icons.keyboard_arrow_down_outlined),
                                                    textFieldFocusNode: textFieldFocusNode,
                                                    keyboardType:TextInputType.number,
                                                    searchFocusNode: searchFocusNode,
                                                    textFieldDecoration:  InputDecoration(
                                                      label: Text('Device',style: font15black,),
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
                                                    searchKeyboardType: TextInputType.number,
                                                    dropDownList:
                                                    apiController.masterd.map((DeviceElement val) {
                                                      return DropDownValueModel(
                                                          name: val.serialNo??'', value: val.serialNo

                                                      );
                                                    }).toList(),


                                                    // ],
                                                    onChanged: (val) {
                                                      print(val);


                                                      apiController.selectedmaster.value = val.value??'';
                                                      apiController.sale.value.serialNo= apiController.selectedmaster.value;

                                                    },
                                                  ),
                                                ),

                                                apiController.masterd.value.isNotEmpty?
                                                Container()
                                                    :
                                                Container(
                                                  child: Text('No device to sale' ,style: font14red),
                                                ),

                                                if (apiController.vtype.value=='IT')
                                                  formfielunderline('Chasis Number', (value) {
                                                    apiController.chasis.value = value??'';
                                                    apiController.sale.value.chasisNumber =value??'';

                                                  }),

                                                if (apiController.vtype.value=='Dry Cargo')
                                                  formfielunderline('Vehicle Number', (value) {
                                                    apiController.vehicleno.value = value??'';
                                                    apiController.sale.value.vehicleNumber=  value??'';

                                                  }),
                                                if (apiController.vtype.value=='Dry Cargo')
                                                  formfielunderline('Container Number', (value) {
                                                    apiController.containerno.value = value??'';
                                                    apiController.sale.value.containerNumber=value??'';

                                                  }),

                                                if (apiController.vtype.value=='Wet Cargo')


                                                  Container(
                                                    margin: EdgeInsets.only(left: 20,right: 20,top: 12),
                                                    child:   MultiSelectDialogField(
                                                      searchable: true,
                                                      items:   apiController.slaved.value
                                                          .map((device) => MultiSelectItem<DeviceElement>(device, device.serialNo??''))
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
                                                        "Slave Device",style: font15black,
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
                                                        apiController.sale.value.slaves = data;

                                                        apiController.sale.value.slaves?.forEach((element) {
                                                          print("slacedata ${element.serialNo}");

                                                        });






                                                      },
                                                    ),

                                                  ),



                                                if (apiController.vtype.value=='Dry Cargo')


                                                  Container(
                                                    margin: EdgeInsets.only(left: 20,right: 20,top: 12),
                                                    child:   MultiSelectDialogField(
                                                      searchable: true,
                                                      items: apiController.slaved.value
                                                          .map((device) => MultiSelectItem<DeviceElement>(device, device.serialNo??''))
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
                                                        "Slave Device",style: font15black,
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
                                                        apiController.sale.value.slaves = data;

                                                        apiController.sale.value.slaves?.forEach((element) {
                                                          print("slacedata ${element.serialNo}");

                                                        });






                                                      },
                                                    ),

                                                  ),



                                                if (apiController.vtype.value=='Wet Cargo')
                                                  formfielunderline('Vehicle Number', (value) {
                                                    apiController.sale.value.vehicleNumber=value??'';


                                                  }),
                                                if (apiController.vtype.value=='Wet Cargo')
                                                  formfielunderlineoption('Trailer Number', (value) {
                                                    // apiController.sale.value.=apiController.containerno.value;
                                                    apiController.sale.value.trailerno =value??'';
                                                  }),



                                                dropdown('Customer Type',
                                                    ['Cash Sale(TSH)','Cash Sale(Dollar)','Bill Customer'],
                                                        (value) {
                                                      apiController.customertype.value = value??'';

                                                      // apiController.sale.value.trailerno =value??'';

                                                      if(value=='Cash Sale(TSH)'){
                                                        apiController.sale.value.saleType ='1';
                                                        apiController.sale.value.currency ='TZS';
                                                        apiController.sale.value.customerTypeId ='1';
                                                      }
                                                      if(value=='Cash Sale(Dollar)'){
                                                        apiController.sale.value.saleType ='2';
                                                        apiController.sale.value.currency ='USD';
                                                        apiController.sale.value.customerTypeId ='1';
                                                      }
                                                      if(value=='Bill Customer'){
                                                        apiController.sale.value.saleType ='3';
                                                        apiController.sale.value.currency ='';
                                                        apiController.sale.value.customerTypeId ='2';
                                                      }

                                                    }),


                                                if (apiController.customertype.value=='Cash Sale(TSH)')
                                                  formfielunderlineamount('Amount', (value) {
                                                    apiController.amount.value = value??'';
                                                    apiController.sale.value.amount= value??'';

                                                  }),
                                                if (apiController.customertype.value=='Cash Sale(TSH)')
                                                  formfielunderline('Company Name', (value) {
                                                    apiController.companyname.value = value??'';
                                                    apiController.sale.value.companyName= value??'';
                                                    apiController.sale.value.customerId="";
                                                  }),

                                                if (apiController.customertype.value=='Cash Sale(Dollar)')
                                                  formfielunderlineamount('Amount', (value) {
                                                    apiController.amount.value = value??'';
                                                    apiController.sale.value.amount= value??'';
                                                  }),
                                                if (apiController.customertype.value=='Cash Sale(Dollar)')
                                                  formfielunderline('Company Name', (value) {
                                                    apiController.companyname.value = value??'';
                                                    apiController.sale.value.companyName= value??'';
                                                    apiController.sale.value.customerId="";
                                                  }),


                                                if (apiController.customertype.value=='Bill Customer')
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
                                                      keyboardType:TextInputType.text,
                                                      dropDownIconProperty: IconProperty(icon: Icons.keyboard_arrow_down_outlined),
                                                      textFieldFocusNode: textFieldFocusNode,
                                                      searchFocusNode: searchFocusNode,
                                                      textFieldDecoration:  InputDecoration(
                                                        label: Text('Bill Customer',style: font15black,),
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
                                                      apiController.customer.value.customers
                                                      !.map((CustomerElement val) {
                                                        return DropDownValueModel(
                                                            name: val.companyName??'', value: val.id.toString()

                                                        );
                                                      }).toList(),


                                                      // ],
                                                      onChanged: (val) {
                                                        apiController.bill.value = val.value??'';
                                                        apiController.sale.value.customerId= apiController.bill.value;
                                                        apiController.sale.value.companyName= val.name??'';
                                                        // print(val.name);


                                                      },
                                                    ),
                                                  ),

                                                if (apiController.vtype.value=='Bill Customer')
                                                  formfielunderline('Agent', (value) {
                                                    apiController.agent.value = value??'';
                                                    apiController.sale.value.agent = apiController.agent.value;
                                                  }),

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



                                                          if (formKeysale.currentState!.validate()) {
                                                            apiController.step1.value= false;
                                                            apiController.step2.value= true;
                                                            apiController.step3.value= false;


                                                          }

                                                          // apiController.step2.value= true;


                                                        }),
                                                      ),
                                                    )
                                                  ],
                                                ),

                                                SizedBox(height: 150,),







                                              ],
                                            ),


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
                                                    apiController.sale.value.gateNumber = apiController.port.value;
                                                    apiController.sale.value.gateName= val.name;


                                                  },
                                                ),
                                              ),

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
                                                    apiController.sale.value.borderId =  apiController.border.value;
                                                    apiController.sale.value.borderName= val.name;



                                                  },
                                                ),
                                              ),






                                              formfielunderline('Driver', (value) {
                                                apiController.driver.value = value??'';
                                                apiController.sale.value.driverName =      apiController.driver.value;
                                              })
                                              ,
                                              formfielunderline('Passport', (value) {
                                                apiController.pasport.value = value??'';
                                                apiController.sale.value.passport=apiController.pasport.value;
                                              })
                                              ,
                                              formfielunderlinephone('Driver Phone number', (value) {
                                                apiController.drivernumber.value = value??'';
                                                apiController.sale.value.driverNumber =      apiController.drivernumber.value;

                                              }),


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
                                                        apiController.canhold.value= true;

                                                        if (formKeysale.currentState!.validate()) {
                                                          apiController.step1.value= false;
                                                          apiController.step2.value= false;
                                                          apiController.step3.value= true;


                                                        }




                                                      }),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: 60,)




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


                                            formfielunderlinetzdln('TZDL', (value) {
                                              apiController.tzlesist.value=false;
                                              apiController.tzdl.value = value??'';
                                              apiController.sale.value.tripStatus =   '1';
                                              apiController.sale.value.tagger = apiController.userdata.value.name.toString();
                                              apiController.sale.value.salesPerson = apiController.userdata.value.userId.toString();
                                              apiController.sale.value.tzl =   apiController.tzdl.value;
                                              apiController.sale.value.saleDate = startdate.text;
                                              apiController.sale.value.startDateTime = startdate.text;
                                              apiController.sale.value.endDate = enddate.text;

                                            }),

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

                                                        if (formKeysale.currentState!.validate()) {
                                                          apiController.tzlesist.value=false;

                                                          print("VALUE");


                                                                var datastus =await hasNetwork();

                                                                final dbHelper = DatabaseHelper();

                                                                var exist = await dbHelper
                                                                    .doesDataExist(
                                                                    apiController
                                                                        .tzdl.value?? "");


                                                                if (exist) {
                                                                  apiController.tzlesist.value= true;
                                                                  print("object");
                                                                  SnackbarService
                                                                      .errorSnackBar(
                                                                      context,
                                                                      'TZDL Already used please and try again');
                                                                } else {
                                                                  print("amna");
                                                                  apiController.tzlesist.value= false;



                                                                if (formKeysale.currentState!.validate()) {


                                                                    if (datastus) {
                                                                      apiController
                                                                          .saleprint.value =
                                                                          SaleAdd(
                                                                              saleDate: '',
                                                                              startDateTime: '',
                                                                              endDate: '',
                                                                              vehicleNumber: '',
                                                                              chasisNumber: '',
                                                                              tzl: '',
                                                                              driverName: '',
                                                                              borderId: '',
                                                                              tripStatus: '',
                                                                              driverNumber: '',
                                                                              serialNo: '',
                                                                              amount: '',
                                                                              currency: '',
                                                                              gateNumber: '',
                                                                              salesPerson: '',
                                                                              passport: '',
                                                                              containerNumber: '',
                                                                              vehicleTypeId: '',
                                                                              customerTypeId: '',
                                                                              companyName: '',
                                                                              customerId: '',
                                                                              agent: '',
                                                                              saleType: '',
                                                                              borderName: '',
                                                                              gateName: '',
                                                                              saleId: '',
                                                                              prev_offline_receipt_number: '',
                                                                              offline_receipt_number: "",
                                                                              slaves: []);


                                                                      // apiController.sale.value.offline_receipt_number
                                                                      var t1 = apiController
                                                                          .tzdl.value
                                                                          .substring(
                                                                          apiController.tzdl
                                                                              .value
                                                                              .length - 3);
                                                                      var t2 = 'RCOFF' +
                                                                          t1 +
                                                                          startdate.text;

                                                                      var t3 = t2
                                                                          .replaceAll(' ',
                                                                          '')
                                                                          .replaceAll(
                                                                          '-', '')
                                                                          .replaceAll(
                                                                          ':', '');

                                                                      apiController.sale
                                                                          .value
                                                                          .offline_receipt_number =
                                                                          t3;
                                                                      apiController.sale
                                                                          .value
                                                                          .prev_offline_receipt_number =
                                                                      "";

                                                                      print(t3);

                                                                      apiController.salead
                                                                          .value =
                                                                          apiController.sale
                                                                              .value;
                                                                      apiController
                                                                          .saleprint.value =
                                                                          apiController.sale
                                                                              .value;
                                                                      print(apiController
                                                                          .saleprint.value
                                                                          .offline_receipt_number);
                                                                      // print(apiController.saleprint.value.offline_receipt_number);
                                                                      // print(apiController.saleprint.value.offline_receipt_number);





                                                                      //
                                                                      // var data = await dbHelper
                                                                      //     .insertSale(
                                                                      //     apiController
                                                                      //         .salead
                                                                      //         .value);


                                                                      apiController
                                                                          .adsale(
                                                                          apiController
                                                                              .sale
                                                                              .value);
                                                                      print(
                                                                          "sure connected ccc online");
                                                                    } else {
                                                                      print(
                                                                          "sure connected ccc online ofline");
                                                                      apiController
                                                                          .saleprint.value =
                                                                          SaleAdd(
                                                                              saleDate: '',
                                                                              startDateTime: '',
                                                                              endDate: '',
                                                                              vehicleNumber: '',
                                                                              chasisNumber: '',
                                                                              tzl: '',
                                                                              driverName: '',
                                                                              borderId: '',
                                                                              tripStatus: '',
                                                                              driverNumber: '',
                                                                              serialNo: '',
                                                                              amount: '',
                                                                              currency: '',
                                                                              gateNumber: '',
                                                                              salesPerson: '',
                                                                              passport: '',
                                                                              containerNumber: '',
                                                                              vehicleTypeId: '',
                                                                              customerTypeId: '',
                                                                              companyName: '',
                                                                              customerId: '',
                                                                              agent: '',
                                                                              saleType: '',
                                                                              borderName: '',
                                                                              gateName: '',
                                                                              saleId: '',
                                                                              prev_offline_receipt_number: '',
                                                                              offline_receipt_number: "",
                                                                              slaves: []);


                                                                      // apiController.sale.value.offline_receipt_number
                                                                      var t1 = apiController
                                                                          .tzdl.value
                                                                          .substring(
                                                                          apiController.tzdl
                                                                              .value
                                                                              .length - 3);
                                                                      var t2 = 'RCOFF' +
                                                                          t1 +
                                                                          startdate.text;

                                                                      var t3 = t2
                                                                          .replaceAll(' ',
                                                                          '')
                                                                          .replaceAll(
                                                                          '-', '')
                                                                          .replaceAll(
                                                                          ':', '');

                                                                      apiController.sale
                                                                          .value
                                                                          .offline_receipt_number =
                                                                          t3;
                                                                      apiController.sale
                                                                          .value
                                                                          .prev_offline_receipt_number =
                                                                      "";

                                                                      print(t3);

                                                                      apiController.salead
                                                                          .value =
                                                                          apiController.sale
                                                                              .value;
                                                                      apiController
                                                                          .saleprint.value =
                                                                          apiController.sale
                                                                              .value;
                                                                      print(apiController
                                                                          .saleprint.value
                                                                          .offline_receipt_number);
                                                                      // print(apiController.saleprint.value.offline_receipt_number);
                                                                      // print(apiController.saleprint.value.offline_receipt_number);


                                                                      apiController.step1
                                                                          .value = true;
                                                                      apiController.step2
                                                                          .value = false;
                                                                      apiController.step3
                                                                          .value = false;
                                                                      apiController.vtype
                                                                          .value == '';
                                                                      apiController
                                                                          .customertype
                                                                          .value = '';





                                                                      var data = await dbHelper
                                                                          .insertSale(
                                                                          apiController
                                                                              .salead
                                                                              .value);


                                                                      if (data != 0) {
                                                                        apiController
                                                                            .ispastesale
                                                                            .value =
                                                                        false;
                                                                        apiController
                                                                            .canhold
                                                                            .value =
                                                                        false;

                                                                        print(
                                                                            "DATA ZEGEIMEGOMA");
                                                                        // sale.tooMap()
                                                                        log(
                                                                            "Logtunaprint ${apiController
                                                                                .saleprint
                                                                                .value
                                                                                .tooMap()}");
                                                                        getoff();

                                                                        receiptPrint(
                                                                            apiController
                                                                                .saleprint
                                                                                .value
                                                                                .tooMap());
                                                                        if (datastus) {
                                                                          print(
                                                                              "sure connected ccc");
                                                                        } else {
                                                                          openSuccessButtom(
                                                                              'Saved Successfully', () {
                                                                            Get.back();
                                                                            Get.to(() =>
                                                                                SalesScreen());
                                                                          });
                                                                          print(
                                                                              "offline");
                                                                        }
                                                                        // receiptPrint(sale.tooMap());
                                                                      } else {
                                                                        print(
                                                                            "DATA ZEGE");
                                                                      }


                                                                      print(data);
                                                                      print("saled");




                                                                      print("offline");
                                                                    }





                                                                    // var data =  dbHelper.getSalesWithSlaves();


                                                                  }
                                                                }



                                                        }








                                                      }),
                                                    ),
                                                  ),



                                                  // Expanded(
                                                  //   child: Container(
                                                  //     margin: EdgeInsets.only(left: 7,right:22,top: 30),
                                                  //     child: button1('SUBMIT', () async {
                                                  //       var datastus =await hasNetwork();
                                                  //
                                                  //       final dbHelper = DatabaseHelper();
                                                  //
                                                  //       var exist = await dbHelper
                                                  //           .doesDataExist(
                                                  //           apiController
                                                  //               .tzdl.value?? "");
                                                  //
                                                  //
                                                  //       if (exist) {
                                                  //         apiController.tzlesist.value= true;
                                                  //         print("object");
                                                  //         SnackbarService
                                                  //             .errorSnackBar(
                                                  //             context,
                                                  //             'TZDL Already used please and try again');
                                                  //       } else {
                                                  //         print("amna");
                                                  //         apiController.tzlesist.value= false;
                                                  //
                                                  //
                                                  //
                                                  //       if (formKeysale.currentState!.validate()) {
                                                  //         apiController
                                                  //             .saleprint.value =
                                                  //             SaleAdd(
                                                  //                 saleDate: '',
                                                  //                 startDateTime: '',
                                                  //                 endDate: '',
                                                  //                 vehicleNumber: '',
                                                  //                 chasisNumber: '',
                                                  //                 tzl: '',
                                                  //                 driverName: '',
                                                  //                 borderId: '',
                                                  //                 tripStatus: '',
                                                  //                 driverNumber: '',
                                                  //                 serialNo: '',
                                                  //                 amount: '',
                                                  //                 currency: '',
                                                  //                 gateNumber: '',
                                                  //                 salesPerson: '',
                                                  //                 passport: '',
                                                  //                 containerNumber: '',
                                                  //                 vehicleTypeId: '',
                                                  //                 customerTypeId: '',
                                                  //                 companyName: '',
                                                  //                 customerId: '',
                                                  //                 agent: '',
                                                  //                 saleType: '',
                                                  //                 borderName: '',
                                                  //                 gateName: '',
                                                  //                 saleId: '',
                                                  //                 prev_offline_receipt_number: '',
                                                  //                 offline_receipt_number: "",
                                                  //                 slaves: []);
                                                  //
                                                  //
                                                  //         // apiController.sale.value.offline_receipt_number
                                                  //         var t1 = apiController
                                                  //             .tzdl.value
                                                  //             .substring(
                                                  //             apiController.tzdl
                                                  //                 .value
                                                  //                 .length - 3);
                                                  //         var t2 = 'RCOFF' +
                                                  //             t1 +
                                                  //             startdate.text;
                                                  //
                                                  //         var t3 = t2
                                                  //             .replaceAll(' ',
                                                  //             '')
                                                  //             .replaceAll(
                                                  //             '-', '')
                                                  //             .replaceAll(
                                                  //             ':', '');
                                                  //
                                                  //         apiController.sale
                                                  //             .value
                                                  //             .offline_receipt_number =
                                                  //             t3;
                                                  //         apiController.sale
                                                  //             .value
                                                  //             .prev_offline_receipt_number =
                                                  //         "";
                                                  //
                                                  //         print(t3);
                                                  //
                                                  //         apiController.salead
                                                  //             .value =
                                                  //             apiController.sale
                                                  //                 .value;
                                                  //         apiController
                                                  //             .saleprint.value =
                                                  //             apiController.sale
                                                  //                 .value;
                                                  //         print(apiController
                                                  //             .saleprint.value
                                                  //             .offline_receipt_number);
                                                  //         // print(apiController.saleprint.value.offline_receipt_number);
                                                  //         // print(apiController.saleprint.value.offline_receipt_number);
                                                  //
                                                  //
                                                  //         apiController.step1
                                                  //             .value = true;
                                                  //         apiController.step2
                                                  //             .value = false;
                                                  //         apiController.step3
                                                  //             .value = false;
                                                  //         apiController.vtype
                                                  //             .value == '';
                                                  //         apiController
                                                  //             .customertype
                                                  //             .value = '';
                                                  //
                                                  //
                                                  //
                                                  //
                                                  //
                                                  //           var data = await dbHelper
                                                  //               .insertSale(
                                                  //               apiController
                                                  //                   .salead
                                                  //                   .value);
                                                  //
                                                  //           if (datastus) {
                                                  //             apiController
                                                  //                 .adsale(
                                                  //                 apiController
                                                  //                     .sale
                                                  //                     .value);
                                                  //             print(
                                                  //                 "sure connected ccc");
                                                  //           } else {
                                                  //             print("offline");
                                                  //           }
                                                  //
                                                  //
                                                  //           if (data != '0') {
                                                  //             apiController
                                                  //                 .ispastesale
                                                  //                 .value =
                                                  //             false;
                                                  //             apiController
                                                  //                 .canhold
                                                  //                 .value =
                                                  //             false;
                                                  //
                                                  //             print(
                                                  //                 "DATA ZEGEIMEGOMA");
                                                  //             // sale.tooMap()
                                                  //             log(
                                                  //                 "Logtunaprint ${apiController
                                                  //                     .saleprint
                                                  //                     .value
                                                  //                     .tooMap()}");
                                                  //             getoff();
                                                  //
                                                  //             receiptPrint(
                                                  //                 apiController
                                                  //                     .saleprint
                                                  //                     .value
                                                  //                     .tooMap());
                                                  //             if (datastus) {
                                                  //               print(
                                                  //                   "sure connected ccc");
                                                  //             } else {
                                                  //               openSuccessButtom(
                                                  //                   'Saved Successfully', () {
                                                  //                 Get.back();
                                                  //                 Get.off(() =>
                                                  //                     SalesScreen());
                                                  //               });
                                                  //               print(
                                                  //                   "offline");
                                                  //             }
                                                  //             // receiptPrint(sale.tooMap());
                                                  //           } else {
                                                  //             print(
                                                  //                 "DATA ZEGE");
                                                  //           }
                                                  //
                                                  //
                                                  //           print(data);
                                                  //           print("saled");
                                                  //
                                                  //
                                                  //           // var data =  dbHelper.getSalesWithSlaves();
                                                  //
                                                  //
                                                  //         }
                                                  //       }
                                                  //
                                                  //
                                                  //     }),
                                                  //   ),
                                                  // )
                                                ],
                                              ),
                                            ),

                                            SizedBox(height: 60,)



                                          ],
                                        ),
                                      )



                                    // SizedBox(height: 100,)




                                  ],
                                ),

                            ),
                          ),
                        ):

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
                                                  dropdownedit('Vehicle hold Type',
                                                      ['IT','Dry Cargo','Wet Cargo'],
                                                          (value) {
                                                        print("onchange");
                                                        apiController.vtype.value=value??'';


                                                        if (apiController.vtype.value=='IT') {
                                                          apiController.salehold.value.vehicleTypeId= '1';
                                                        }
                                                        if (apiController.vtype.value=='Dry Cargo') {
                                                          apiController.salehold.value.vehicleTypeId='2';
                                                        }
                                                        if (apiController.vtype.value=='Wet Cargo') {
                                                          apiController.salehold.value.vehicleTypeId='3';
                                                        }



                                                      },
                                                      apiController.salehold.value.vehicleTypeId=='1'?'IT':
                                                      apiController.salehold.value.vehicleTypeId=='2'?'Dry Cargo':'Wet Cargo'

                                                  ),


                                                  // Container(
                                                  //   margin: EdgeInsets.only(left: 20,right: 20,top: 12),
                                                  //   child: DropdownButtonFormField(
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
                                                  //       apiController.salehold.value.serialNo= apiController.selectedmaster.value;
                                                  //
                                                  //     },
                                                  //     // validator: (DeviceElement ?value) {
                                                  //     //   if (value?.serialNo==null) {
                                                  //     //     return "can't empty please choose one";
                                                  //     //   } else {
                                                  //     //     return null;
                                                  //     //   }
                                                  //     // },
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
                                                  //     items:   apiController.masterd.value
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
                                                      // initialValue: apiController.salehold.value.companyName,
                                                      // [CustomerElement(id: widget.sale.id??0,companyName: widget.sale.companyName??'WEB')],




                                                      dropDownIconProperty: IconProperty(icon: Icons.keyboard_arrow_down_outlined),
                                                      textFieldFocusNode: textFieldFocusNode,
                                                      searchFocusNode: searchFocusNode,
                                                      textFieldDecoration:  InputDecoration(
                                                        label: Text('Device',style: font15black,),
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
                                                      searchKeyboardType: TextInputType.number,
                                                      dropDownList:
                                                      apiController.masterd.value
                                                      .map((DeviceElement val) {
                                                        return DropDownValueModel(
                                                            name: val.serialNo??'', value: val.serialNo

                                                        );
                                                      }).toList(),


                                                      // ],
                                                      onChanged: (val) {
                                                        print(val);


                                                      apiController.selectedmaster.value = val.value??'';
                                                      apiController.salehold.value.serialNo= apiController.selectedmaster.value;


                                                      },
                                                    ),
                                                  ),

                                                  apiController.masterd.value.isNotEmpty?
                                                  Container()
                                                      :
                                                  Container(
                                                    child: Text('No device to sale' ,style: font14red),
                                                  ),


                                                  // Container(
                                                  //   margin: EdgeInsets.only(left: 20,right: 20,top: 12),
                                                  //   child: DropdownButtonFormField(
                                                  //     // value: apiController.saleedit.value.serialNo??'',
                                                  //
                                                  //     hint:Text(apiController.salehold.value.serialNo??'',style: font14black,)
                                                  //     ,
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
                                                  //       apiController.salehold.value.serialNo= apiController.selectedmaster.value;
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

                                                  if (apiController.vtype.value=='IT')
                                                    formfielunderlineedit('Chasis Number', (value) {
                                                      apiController.chasis.value = value??'';
                                                      apiController.salehold.value.chasisNumber = apiController.chasis.value;

                                                    },apiController.salehold.value.chasisNumber??''),

                                                  if (apiController.vtype.value=='Dry Cargo')
                                                    formfielunderlineedit('Vehicle Number', (value) {
                                                      apiController.vehicleno.value = value??'';
                                                      apiController.salehold.value.vehicleNumber=  apiController.vehicleno.value;

                                                    },apiController.salehold.value.vehicleNumber??''),
                                                  if (apiController.vtype.value=='Dry Cargo')
                                                    formfielunderlineedit('Container Number', (value) {
                                                      apiController.containerno.value = value??'';
                                                      apiController.salehold.value.containerNumber=value??'';

                                                    },apiController.salehold.value.containerNumber??''),

                                                  if (apiController.vtype.value=='Wet Cargo')


                                                    Container(
                                                      margin: EdgeInsets.only(left: 20,right: 20,top: 12),
                                                      child:   MultiSelectDialogField(
                                                        searchable: true,
                                                        items:   apiController.slaved.value
                                                            .map((device) => MultiSelectItem<DeviceElement>(device, device.serialNo??''))
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
                                                          "Slave Device",style: font15black,
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
                                                          apiController.salehold.value.slaves = data;

                                                          apiController.salehold.value.slaves?.forEach((element) {
                                                            print("slacedata ${element.serialNo}");

                                                          });






                                                        },
                                                      ),

                                                    ),



                                                  if (apiController.vtype.value=='Dry Cargo')


                                                    Container(
                                                      margin: EdgeInsets.only(left: 20,right: 20,top: 12),
                                                      child:   MultiSelectDialogField(
                                                        searchable: true,
                                                        items: apiController.slaved.value
                                                            .map((device) => MultiSelectItem<DeviceElement>(device, device.serialNo??''))
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
                                                          "Slave Device",style: font15black,
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
                                                          apiController.salehold.value.slaves = data;

                                                          apiController.salehold.value.slaves?.forEach((element) {
                                                            print("slacedata ${element.serialNo}");

                                                          });






                                                        },
                                                      ),

                                                    ),





                                                  if (apiController.vtype.value=='Wet Cargo')
                                                    formfielunderlineedit('Vehicle Number', (value) {
                                                      apiController.salehold.value.vehicleNumber=value??'';


                                                    },apiController.salehold.value.vehicleNumber??''
                                                    ),
                                                  if (apiController.vtype.value=='Wet Cargo')
                                                    formfielunderlineoptionedit('Trailer Number', (value) {
                                                      // apiController.sale.value.=apiController.containerno.value;
                                                      apiController.salehold.value.trailerno =value??'';
                                                    }, apiController.salehold.value.trailerno??''),



                                                  dropdownedit('Customer Type',
                                                      ['Cash Sale(TSH)','Cash Sale(Dollar)','Bill Customer'],
                                                          (value) {
                                                        apiController.customertype.value = value??'';

                                                        // apiController.sale.value.trailerno =value??'';

                                                        if(value=='Cash Sale(TSH)'){
                                                          apiController.salehold.value.saleType ='1';
                                                          apiController.salehold.value.currency ='TZS';
                                                          apiController.salehold.value.customerTypeId ='1';
                                                        }
                                                        if(value=='Cash Sale(Dollar)'){
                                                          apiController.salehold.value.saleType ='2';
                                                          apiController.salehold.value.currency ='USD';
                                                          apiController.salehold.value.customerTypeId ='1';
                                                        }
                                                        if(value=='Bill Customer'){
                                                          apiController.salehold.value.saleType ='3';
                                                          apiController.salehold.value.currency ='';
                                                          apiController.salehold.value.customerTypeId ='2';
                                                        }

                                                      },
                                                      apiController.salehold.value.saleType=='1'?'Cash Sale(TSH)':
                                                      apiController.salehold.value.saleType=='2'?'Cash Sale(Dollar)':'Bill Customer'
                                                  ),


                                                  if (apiController.customertype.value=='Cash Sale(TSH)')
                                                    formfielunderlineeditamount('Amount', (value) {
                                                      apiController.amount.value = value??'';
                                                      apiController.salehold.value.amount= apiController.amount.value;

                                                    },apiController.salehold.value.amount??''),

                                                  if (apiController.customertype.value=='Cash Sale(TSH)')
                                                    formfielunderlineedit('Company Name', (value) {
                                                      apiController.companyname.value = value??'';
                                                      apiController.salehold.value.companyName= apiController.companyname.value;
                                                      apiController.sale.value.customerId="";
                                                    },apiController.salehold.value.companyName??''),

                                                  if (apiController.customertype.value=='Cash Sale(Dollar)')
                                                    formfielunderlineeditamount('Amount', (value) {
                                                      apiController.amount.value = value??'';
                                                      apiController.salehold.value.amount= apiController.amount.value;
                                                    },apiController.salehold.value.amount??''),
                                                  if (apiController.customertype.value=='Cash Sale(Dollar)')
                                                    formfielunderlineedit('Company Name', (value) {
                                                      apiController.companyname.value = value??'';
                                                      apiController.sale.value.customerId="";
                                                      apiController.salehold.value.companyName= apiController.companyname.value;
                                                    },apiController.salehold.value.companyName??''),


                                                  if (apiController.customertype.value=='Bill Customer')
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
                                                        initialValue: apiController.salehold.value.companyName,
                                                        // [CustomerElement(id: widget.sale.id??0,companyName: widget.sale.companyName??'WEB')],




                                                        dropDownIconProperty: IconProperty(icon: Icons.keyboard_arrow_down_outlined),
                                                        textFieldFocusNode: textFieldFocusNode,
                                                        searchFocusNode: searchFocusNode,
                                                        textFieldDecoration:  InputDecoration(
                                                          label: Text('Bill Customer',style: font15black,),
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
                                                        apiController.customer.value.customers
                                                        !.map((CustomerElement val) {
                                                          return DropDownValueModel(
                                                              name: val.companyName??'', value: val.id.toString()

                                                          );
                                                        }).toList(),


                                                        // ],
                                                        onChanged: (val) {
                                                          print(val);
                                                          apiController.bill.value = val.value??'';
                                                          apiController.salehold.value.customerId= apiController.bill.value;
                                                          apiController.salehold.value.companyName= val.name??'';


                                                        },
                                                      ),
                                                    ),

                                                  if (apiController.vtype.value=='Bill Customer')
                                                    formfielunderlineedit('Agent', (value) {
                                                      apiController.agent.value = value??'';
                                                      apiController.salehold.value.agent = apiController.agent.value;
                                                    },apiController.salehold.value.agent??""),










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



                                                            if (formKeysale.currentState!.validate()) {
                                                            apiController.step1.value= false;
                                                            apiController.step2.value= true;
                                                            apiController.step3.value= false;


                                                            }


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

                                                  initialValue: apiController.salehold.value.gateName,

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
                                                    apiController.salehold.value.gateNumber = apiController.port.value;


                                                  },
                                                ),
                                              ),

                                              Container(
                                                margin: EdgeInsets.only(left: 20,right: 20,top: 12),
                                                child: DropDownTextField(
                                                  initialValue: apiController.salehold.value.borderName,
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
                                                    apiController.salehold.value.borderId =  apiController.border.value;



                                                  },
                                                ),
                                              ),






                                              formfielunderlineedit('Driver', (value) {
                                                apiController.driver.value = value??'';
                                                apiController.salehold.value.driverName =      apiController.driver.value;
                                              },apiController.salehold.value.driverName??'')
                                              ,
                                              formfielunderlineedit('Passport', (value) {
                                                apiController.pasport.value = value??'';
                                                apiController.salehold.value.passport=apiController.pasport.value;
                                              },apiController.salehold.value.passport??'')
                                              ,
                                              formfielunderlineedit('Driver Number', (value) {
                                                apiController.drivernumber.value = value??'';
                                                apiController.salehold.value.driverNumber =      apiController.drivernumber.value;

                                              },apiController.salehold.value.driverNumber??''),


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

                                                       apiController.canhold.value= true;

                                                        if (formKeysale.currentState!.validate()) {
                                                        apiController.step1.value= false;
                                                        apiController.step2.value= false;
                                                        apiController.step3.value= true;


                                                        }




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


                                            formfielunderlinetzdln('TZDL', (value) async {
                                              apiController.tzdl.value = value??'';
                                              apiController.tzlesist.value=false;
                                              apiController.salehold.value.tripStatus =   '1';
                                              apiController.salehold.value.tagger = apiController.userdata.value.name.toString();
                                              apiController.salehold.value.salesPerson = apiController.userdata.value.userId.toString();
                                              apiController.salehold.value.tzl =   apiController.tzdl.value;
                                              apiController.salehold.value.saleDate = startdate.text;
                                              apiController.salehold.value.startDateTime = startdate.text;
                                              apiController.salehold.value.endDate = enddate.text;

                                              // var existd = await dbHelper
                                              //     .doesDataExist(
                                              //     apiController
                                              //         .salead.value
                                              //         .tzl ?? "");

                                            }),

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

                                                        if (formKeysale.currentState!.validate()) {
                                                          apiController.tzlesist.value=false;

                                                          print("VALUE");


                                                          var datastus =await hasNetwork();

                                                          final dbHelper = DatabaseHelper();

                                                          var exist = await dbHelper
                                                              .doesDataExist(
                                                              apiController
                                                                  .tzdl.value?? "");


                                                          if (exist) {
                                                            apiController.tzlesist.value= true;
                                                            print("object");
                                                            SnackbarService
                                                                .errorSnackBar(
                                                                context,
                                                                'TZDL Already used please and try again');
                                                          } else {
                                                            print("amna");
                                                            apiController.tzlesist.value= false;



                                                            if (formKeysale.currentState!.validate()) {


                                                              if (datastus) {

                                                                apiController.saleprint.value= SaleAdd(saleDate: '', startDateTime: '', endDate: '', vehicleNumber: '', chasisNumber: '', tzl: '', driverName: '', borderId: '', tripStatus: '', driverNumber: '', serialNo: '', amount: '', currency: '', gateNumber: '', salesPerson: '', passport: '', containerNumber: '', vehicleTypeId: '', customerTypeId: '', companyName: '', customerId: '', agent: '', saleType: '',borderName: '',gateName: '', saleId: '',prev_offline_receipt_number:'',offline_receipt_number:"", slaves: []);


                                                                // apiController.sale.value.offline_receipt_number
                                                                var t1 =   apiController.tzdl.value.substring(apiController.tzdl.value.length - 3);
                                                                var t2 = 'RCOFF'+t1+startdate.text;

                                                                var t3 =t2.replaceAll(' ', '').replaceAll('-', '').replaceAll(':', '');

                                                                apiController.salehold.value.offline_receipt_number = t3;
                                                                apiController.salehold.value.prev_offline_receipt_number = "";

                                                                print(t3);

                                                                apiController.salead.value = apiController.salehold.value;
                                                                apiController.saleprint.value= apiController.salehold.value;
                                                                print(apiController.saleprint.value.offline_receipt_number);
                                                                // print(apiController.saleprint.value.offline_receipt_number);
                                                                // print(apiController.saleprint.value.offline_receipt_number);





                                                                //
                                                                // var data = await dbHelper
                                                                //     .insertSale(
                                                                //     apiController
                                                                //         .salead
                                                                //
                                                                //         .value);
                                                                apiController.adsale(apiController.salead.value);

                                                                // apiController
                                                                //     .adsale(
                                                                //     apiController
                                                                //         .sale
                                                                //         .value);
                                                                print(
                                                                    "sure connected ccc online");
                                                              } else {
                                                                print(
                                                                    "sure connected ccc online ofline");


                                                                apiController.saleprint.value= SaleAdd(saleDate: '', startDateTime: '', endDate: '', vehicleNumber: '', chasisNumber: '', tzl: '', driverName: '', borderId: '', tripStatus: '', driverNumber: '', serialNo: '', amount: '', currency: '', gateNumber: '', salesPerson: '', passport: '', containerNumber: '', vehicleTypeId: '', customerTypeId: '', companyName: '', customerId: '', agent: '', saleType: '',borderName: '',gateName: '', saleId: '',prev_offline_receipt_number:'',offline_receipt_number:"", slaves: []);


                                                                // apiController.sale.value.offline_receipt_number
                                                                var t1 =   apiController.tzdl.value.substring(apiController.tzdl.value.length - 3);
                                                                var t2 = 'RCOFF'+t1+startdate.text;

                                                                var t3 =t2.replaceAll(' ', '').replaceAll('-', '').replaceAll(':', '');

                                                                apiController.salehold.value.offline_receipt_number = t3;
                                                                apiController.salehold.value.prev_offline_receipt_number = "";

                                                                print(t3);

                                                                apiController.salead.value = apiController.salehold.value;
                                                                apiController.saleprint.value= apiController.salehold.value;
                                                                print(apiController.saleprint.value.offline_receipt_number);
                                                                // print(apiController.saleprint.value.offline_receipt_number);
                                                                // print(apiController.saleprint.value.offline_receipt_number);


                                                                apiController.step1
                                                                    .value = true;
                                                                apiController.step2
                                                                    .value = false;
                                                                apiController.step3
                                                                    .value = false;
                                                                apiController.vtype
                                                                    .value == '';
                                                                apiController
                                                                    .customertype
                                                                    .value = '';





                                                                var data = await dbHelper
                                                                    .insertSale(
                                                                    apiController
                                                                        .salead
                                                                        .value);


                                                                if (data != 0) {
                                                                  apiController
                                                                      .ispastesale
                                                                      .value =
                                                                  false;
                                                                  apiController
                                                                      .canhold
                                                                      .value =
                                                                  false;

                                                                  print(
                                                                      "DATA ZEGEIMEGOMA");
                                                                  // sale.tooMap()
                                                                  log(
                                                                      "Logtunaprint ${apiController
                                                                          .saleprint
                                                                          .value
                                                                          .tooMap()}");
                                                                  getoff();

                                                                  receiptPrint(
                                                                      apiController
                                                                          .saleprint
                                                                          .value
                                                                          .tooMap());
                                                                  if (datastus) {
                                                                    print(
                                                                        "sure connected ccc");
                                                                  } else {
                                                                    openSuccessButtom(
                                                                        'Saved Successfully', () {
                                                                      Get.back();
                                                                      Get.to(() =>
                                                                          SalesScreen());
                                                                    });
                                                                    print(
                                                                        "offline");
                                                                  }
                                                                  // receiptPrint(sale.tooMap());
                                                                } else {
                                                                  print(
                                                                      "DATA ZEGE");
                                                                }


                                                                print(data);
                                                                print("saled");




                                                                print("offline");
                                                              }





                                                              // var data =  dbHelper.getSalesWithSlaves();


                                                            }
                                                          }



                                                        }








                                                      }),
                                                    ),
                                                  ),



                                                  // Expanded(
                                                  //   child: Container(
                                                  //     margin: EdgeInsets.only(left: 7,right:22,top: 30),
                                                  //     child: button1('SUBMIT', () async {
                                                  //       var datastus =await hasNetwork();
                                                  //
                                                  //       final dbHelper = DatabaseHelper();
                                                  //
                                                  //     var existd = await dbHelper
                                                  //         .doesDataExist(
                                                  //     apiController.tzl.value?? "");
                                                  //
                                                  //
                                                  //     if (existd) {
                                                  //       apiController.tzlesist.value= true;
                                                  //     print("object");
                                                  //     SnackbarService
                                                  //         .errorSnackBar(
                                                  //     context,
                                                  //     'TZDL Already used please and try again');
                                                  //     } else {
                                                  //     print("amna");
                                                  //     apiController.tzlesist.value= false;
                                                  //
                                                  //
                                                  //
                                                  //
                                                  //       if (formKeysale.currentState!.validate()) {
                                                  //         apiController.saleprint.value= SaleAdd(saleDate: '', startDateTime: '', endDate: '', vehicleNumber: '', chasisNumber: '', tzl: '', driverName: '', borderId: '', tripStatus: '', driverNumber: '', serialNo: '', amount: '', currency: '', gateNumber: '', salesPerson: '', passport: '', containerNumber: '', vehicleTypeId: '', customerTypeId: '', companyName: '', customerId: '', agent: '', saleType: '',borderName: '',gateName: '', saleId: '',prev_offline_receipt_number:'',offline_receipt_number:"", slaves: []);
                                                  //
                                                  //
                                                  //         // apiController.sale.value.offline_receipt_number
                                                  //         var t1 =   apiController.tzdl.value.substring(apiController.tzdl.value.length - 3);
                                                  //         var t2 = 'RCOFF'+t1+startdate.text;
                                                  //
                                                  //         var t3 =t2.replaceAll(' ', '').replaceAll('-', '').replaceAll(':', '');
                                                  //
                                                  //         apiController.salehold.value.offline_receipt_number = t3;
                                                  //         apiController.salehold.value.prev_offline_receipt_number = "";
                                                  //
                                                  //         print(t3);
                                                  //
                                                  //         apiController.salead.value = apiController.salehold.value;
                                                  //         apiController.saleprint.value= apiController.salehold.value;
                                                  //         print(apiController.saleprint.value.offline_receipt_number);
                                                  //         // print(apiController.saleprint.value.offline_receipt_number);
                                                  //         // print(apiController.saleprint.value.offline_receipt_number);
                                                  //
                                                  //
                                                  //         apiController.step1.value= true;
                                                  //         apiController.step2.value= false;
                                                  //         apiController.step3.value= false;
                                                  //         apiController.vtype.value=='';
                                                  //         apiController.customertype.value= '';
                                                  //
                                                  //
                                                  //
                                                  //         var data = await dbHelper.insertSale(apiController.salead.value);
                                                  //
                                                  //         if (datastus) {
                                                  //           apiController.adsale(apiController.salehold.value);
                                                  //           print("sure connected ccc");
                                                  //
                                                  //         }  else{
                                                  //           print("offline");
                                                  //
                                                  //         }
                                                  //
                                                  //
                                                  //         if (data!='0') {
                                                  //           apiController.ispastesale.value= false;
                                                  //           apiController.canhold.value= false;
                                                  //
                                                  //           print("DATA ZEGEIMEGOMA");
                                                  //           // sale.tooMap()
                                                  //           log("Logtunaprint ${apiController.saleprint.value.tooMap()}");
                                                  //           getoff();
                                                  //
                                                  //           receiptPrint(apiController.saleprint.value.tooMap());
                                                  //           if (datastus) {
                                                  //
                                                  //             print("sure connected ccc");
                                                  //
                                                  //           }  else{
                                                  //             openSuccessButtom('Saved Successfully',(){
                                                  //               Get.back();
                                                  //               Get.off(()=>SalesScreen());
                                                  //             });
                                                  //             print("offline");
                                                  //
                                                  //           }
                                                  //           // receiptPrint(sale.tooMap());
                                                  //         }else{
                                                  //           print("DATA ZEGE");
                                                  //         }
                                                  //
                                                  //
                                                  //
                                                  //         print(data);
                                                  //         print("saled");
                                                  //
                                                  //
                                                  //
                                                  //
                                                  //         // var data =  dbHelper.getSalesWithSlaves();
                                                  //
                                                  //
                                                  //
                                                  //
                                                  //       }
                                                  //
                                                  //       }
                                                  //
                                                  //
                                                  //
                                                  //     }),
                                                  //   ),
                                                  // )
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

                      ],
                    ),
                  )









                ]
            )
        )
    );
  }


  void openMenusheet(BuildContext context,) {
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
        initialChildSize: 0.60,
        minChildSize: 0.2,
        maxChildSize: 0.60,
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

                  ),


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
                child: ListView(
                    children: <Widget>[

                      card_menu('Paste last sale', Icons.paste_outlined, () async {

                        if (apiController.isholded.value) {
                          apiController.ispastesale.value = true;
                          setState(() {
                          });

                          Get.back();
                        }  else{
                          ScaffoldMessenger.of(context).showSnackBar(

                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content: Text("No sales available",style: font14red,),
                            ),
                          );
                          Get.back();
                        }



                      }),
                      card_menu('Hold sale', Icons.lock, () async {
                        apiController.salehold.value = apiController.sale.value;


                        if (apiController.canhold.value) {
                          apiController.isholded.value= true;
                          ScaffoldMessenger.of(context).showSnackBar(

                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content: Text("Hold Success",style: font14green,),
                            ),
                          );
                          Get.back();
                        }  else{
                          ScaffoldMessenger.of(context).showSnackBar(

                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content: Text("Please fill the form first to hold data",style: font14red,),
                            ),
                          );
                          Get.back();
                        }





                      }),



                      card_menu('Clear Hold sale', Icons.delete, () async {

                        apiController.isholded.value= false;
                        apiController.canhold.value= false;

                      }),



                      // card_menu('View Hold sale', Icons.content_paste_search_sharp, () async {
                      //
                      //
                      //
                      // }),







                      SizedBox(height: 50,),




                    ]
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }


  void openSuccessButtom(String title, VoidCallback onTap) {
    Get.bottomSheet(
      SizedBox(
        height: 400,
        child: Column(
          children: [
            Text(title),
            ElevatedButton(
              onPressed: onTap,
              child: const Text("OK"),
            ),
          ],
        ),
      ),
    );
  }

}
