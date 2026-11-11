import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';


import 'package:ects/controller/controllerconstant.dart';
import 'package:ects/model/alldevice.dart';
import 'package:ects/model/ports.dart';
import 'package:ects/model/reportreq.dart';
import 'package:ects/model/reports.dart';
import 'package:ects/model/transfer.dart';
import 'package:ects/officeruser/homeoffice.dart';
import 'package:ects/screens/receipts/receipt.dart';
import 'package:ects/screens/sales/salesscreen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../HomePage.dart';
import '../borderuser/homeborder.dart';
import '../borderuser/reportdevice.dart';
import '../model/border.dart';
import '../model/companystaff.dart';
import '../model/confirmdevice.dart';
import '../model/customer.dart';
import '../model/device.dart';
import '../model/devicereports.dart';
import '../model/receiptdata.dart';
import '../model/saledate.dart';
import '../model/saleresults.dart';
import '../model/scanreq.dart';
import '../model/userdata.dart';
import '../offlinedb/sqlite.dart';
import '../screens/report/report.dart';
import '../screens/report/reports.dart';
import '../services/remoteservice.dart';
import '../widget/widgetconstant.dart';
import '../widget/widgets.dart';
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
import '../model/SaleAddTespa.dart';






class ApiController extends GetxController {
  static ApiController instance = Get.find();

  var tespaSalePrint = SaleAddTespa(
    tripNo: '',
    vehicleNo: '',
    trailerNo: '',
    merchantNo: '',
    receiptNo: '',
    gateName: '',
    borderName: '',
    customerName: '',
    agentName: '',
    agentPhoneNo: '',
    master: '',
    slaves: '',
  ).obs;

  var isLoading = true.obs;

  var editslave= <DeviceSlave>[].obs;

  var editslaven= <DeviceSlave>[].obs;
  var selectedMaster = ''.obs;          // ADD THIS
  var editslavend= <String>[].obs;
  var slaveed= <DeviceSlave>[].obs;
  var slaveedcombn= <DeviceSlave>[].obs;
  var slaveedonly= <DeviceSlave>[].obs;

  var tzl = ''.obs;

  var comfirm = ComfirmDevice().obs;

  var comfd = <Devicecomfirm>[].obs;

  var deviceReport = <DeviceReportz>[].obs;
  var deviceRepot = DeviceReportz().obs;

  var prevoffreceipt = ''.obs;

  var tzlesist= false.obs;

  var staff = Staff().obs;

  var staffsearched =  <StaffElement>[].obs;
  var noseearch =  <StaffElement>[].obs;

  var transder = Transfer().obs;


  var toid = ''.obs;


  var report = Report().obs;
  var reportTespa = Report().obs;
  var reportreq = ReportReq().obs;

  var scanned = ScanReceipt().obs;

  var devices = <AllnDevice>[].obs;

  var devicestrd = <AllnDevice>[].obs;


  var devicescomfirm = <AllnDevice>[].obs;
  var devicescomfirm1 = <AllnDevice>[].obs;

  var online = false.obs;

  var salehold = SaleAdd(saleDate: '', startDateTime: '', endDate: '', vehicleNumber: '', chasisNumber: '', tzl: '', driverName: '', borderId: '', tripStatus: '', driverNumber: '', serialNo: '', amount: '', currency: '', gateNumber: '', salesPerson: '', passport: '', containerNumber: '', vehicleTypeId: '', customerTypeId: '', companyName: '', customerId: '', agent: '', saleType: '',borderName: '',gateName: '', saleId: '',prev_offline_receipt_number:'',offline_receipt_number:"", slaves: []).obs;

 var ispastesale= false.obs;
  var isholded= false.obs;
  var canhold= false.obs;

  var sale = SaleAdd(
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
    offline_receipt_number: '',
    slaves: [],
  ).obs;
  var saleedit = SaleAdd(saleDate: '', startDateTime: '', endDate: '', vehicleNumber: '', chasisNumber: '', tzl: '', driverName: '', borderId: '', tripStatus: '', driverNumber: '', serialNo: '', amount: '', currency: '', gateNumber: '', salesPerson: '', passport: '', containerNumber: '', vehicleTypeId: '', customerTypeId: '', companyName: '', customerId: '', agent: '', saleType: '',borderName: '',gateName: '', saleId: '',prev_offline_receipt_number:'',offline_receipt_number:"", slaves: []).obs;
  var saleedited = SaleAdd(saleDate: '', startDateTime: '', endDate: '', vehicleNumber: '', chasisNumber: '', tzl: '', driverName: '', borderId: '', tripStatus: '', driverNumber: '', serialNo: '', amount: '', currency: '', gateNumber: '', salesPerson: '', passport: '', containerNumber: '', vehicleTypeId: '', customerTypeId: '', companyName: '', customerId: '', agent: '', saleType: '',borderName: '',gateName: '', saleId: '',prev_offline_receipt_number:'',offline_receipt_number:"", slaves: []).obs;

  var salead = SaleAdd(saleDate: '', startDateTime: '', endDate: '', vehicleNumber: '', chasisNumber: '', tzl: '', driverName: '', borderId: '', tripStatus: '', driverNumber: '', serialNo: '', amount: '', currency: '', gateNumber: '', salesPerson: '', passport: '', containerNumber: '', vehicleTypeId: '', customerTypeId: '', companyName: '', customerId: '', agent: '', saleType: '',borderName: '',gateName: '', saleId: '',prev_offline_receipt_number:'',offline_receipt_number:"", slaves: []).obs;

  var saleprint = SaleAdd(saleDate: '', startDateTime: '', endDate: '', vehicleNumber: '', chasisNumber: '', tzl: '', driverName: '', borderId: '', tripStatus: '', driverNumber: '', serialNo: '', amount: '', currency: '', gateNumber: '', salesPerson: '', passport: '', containerNumber: '', vehicleTypeId: '', customerTypeId: '', companyName: '', customerId: '', agent: '', saleType: '',borderName: '',gateName: '', saleId: '',prev_offline_receipt_number:'',offline_receipt_number:"", slaves: []).obs;

  var saleprintTespa = SaleAddTespa(
    offlineReceiptNumber: '',
    customerName: '',
    master: '',
    slaves: '',
    gateName: '',
    borderName: '',
    tripNo: '',
    vehicleNo: '',
    trailerNo: '',
    merchantNo: '',
    receiptNo: '',
    agentName: '',
    agentPhoneNo: '',
  ).obs;


  var isLogin = false.obs;

  var receipt = Receipt().obs;

  var master = Device().obs;

  var alldevice = AllDevice().obs;

  var devicetomove = AllDevice().obs;
  var devicetomoveatborder = AllDevice().obs;
  var devicetomovesearchedatborder = <AllnDevice>[].obs;
  var devicetomovesearchatborder = <AllnDevice>[].obs;
  var devicemovedatborder = AllDevice().obs;





  var devicetomoveintra= AllDevice().obs;
  var devicetomovesearchedintra = <AllnDevice>[].obs;
  var devicetomovesearchatintra = <AllnDevice>[].obs;
  var devicemovedatintra = AllDevice().obs;

  var devicetomovesearchintra = <AllnDevice>[].obs;


  var devicetomovesearched = <AllnDevice>[].obs;
  var devicetomovesearch = <AllnDevice>[].obs;
  var devicemoved = AllDevice().obs;

  var scanreq = ScanReceiptReq().obs;
  var scanreqd = ScanReceiptReq().obs;

  var verified =  false.obs;

  var scandata = ScanReceipt(status: '200',message: 'Verifieddssdsddsdsdsdsdsdsdssdsddsdsdsdsdds').obs;

  var salesdata = <SaleAdd>[].obs;
  var salesd = SaleAdd().obs;

  var saleresults = SaleResult().obs;

  var selectedmaster = ''.obs;
  var selectedslave = ''.obs;

  var vehicleno = ''.obs;
  var  containerno = ''.obs;

  var trailer = ''.obs;

var chasis = ''.obs;


  var amount = ''.obs;
  var companyname = ''.obs;
  var bill = ''.obs;
  var agent= ''.obs;
  var customertype = ''.obs;

  var selectedcustomer = ''.obs;
  var selectedcborder = ''.obs;
  var selectedport = ''.obs;

  var slave = Device().obs;

  var masterd =<DeviceElement>[].obs;
  var editmaster =<String>[].obs;
  var slaved =<DeviceElement>[].obs;
  var slavedata = [].obs;
  var slavelemnt = <DeviceElement>[].obs;

  var vtype = ''.obs;

  var tzdl = ''.obs;

  var driver = ''.obs;
  var drivernumber = ''.obs;

  var pasport = ''.obs;

  var borders = Borderd().obs;
  var ports = Port().obs;


  var border = ''.obs;
  var port = ''.obs;
  
  var userdata = Userdata().obs;

  var customer = Customer().obs;

  var step1 = false.obs;
  var step2 = false.obs;
  var step3 = false.obs;

  var stepd1 = false.obs;
  var stepd2 = false.obs;
  var stepd3 = false.obs;


  var imageurl = "".obs;
  var imgbase = "".obs;

  var username = ''.obs;

  var password = ''.obs;
  var ishiden = false.obs;


 var dropdownvalue = ''.obs;

  // List of items in our dropdown menu
  var serverlist = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ].obs;






  var maturity_amount = "00.00".obs;

  var withdraw_date = "2022-11-03".obs;

  var amountvol = "".obs;

  var descriptionvol = "".obs;


  var titlesucces = "Successfully==Umefanikiwa";



  var pensioner_number = ''.obs;

  var pensioner_numberDeath = ''.obs;

  var remarks= ''.obs;
  var validationcode = ''.obs;
  var kinMobile = ''.obs;

  var device_type = ''.obs;
  var fcm_token = ''.obs;

  var member_number = ''.obs;
  var token = ''.obs;
  var member_disable = false.obs;

  var ispemberorungaja = "no".obs;

  var lattud = "".obs;

  var langtud = 0.0.obs;




  var emploNames = ''.obs;

  var emploPhone= ''.obs;

  var emploAddress= ''.obs;
  var emploNatureofbu= ''.obs;
  var emploNoemployee= ''.obs;
  var emploEmail= ''.obs;




  var zssf_number = ''.obs;
  var subject = ''.obs;
  var message = ''.obs;
  var phone = ''.obs;
  var email = ''.obs;



  var ispensionerfirst = false.obs;
  var isPensionNOCode = false.obs;
  var isPensionerNo = false.obs;
  var ispensiondeathfirst = false.obs;

  var deathDate = "".obs;
  var deathPlace = "".obs;
  var deathLocation = "".obs;
  var deathCourse = "".obs;

  // var isPensionerNo = false.obs;

  var fileselected = false.obs;
  var fileselectedname = 'image.jpg'.obs;

  var employor_number = false.obs;
  var death_certificate= "".obs;
  var employer_number = ''.obs;
  var bussness_type = ''.obs;

  var screenname = "".obs;

  var  borderloading = false.obs;
  var  borderloadingatborder = false.obs;

  var  borderloadingintra = false.obs;

  var calculatorben = ''.obs;
  var calculatorcontr = ''.obs;

  var type = 'email'.obs;


  var calculatgross = ''.obs;
  var calculatotime = ''.obs;
  // var calculatorben = ''.obs;
  // var calculatorcontr = ''.obs;


  @override
  void onInit() {


    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();




  }

  loadlocal() async {
    SharedPreferences pref = await SharedPreferences.getInstance();



    var userdata = pref.getString('userData');

    var userdatad = userdataFromJson(userdata??'');
    // apiController.isLogin.value = true;

    apiController.userdata.value = userdatad;
    var borde = pref.getString('borders');
    var data = borderFromJson(borde??'');
    apiController.borders.value = data ;


    var port = pref.getString('ports');
    var datad= portFromJson(port??'');

    apiController.ports.value = datad ;
    var cust = pref.getString('billcustomer');
    var datac = customerFromJson(cust??'');

    apiController.customer.value = datac ;


    var mst = pref.getString('master');
    var slv = pref.getString('slave');

    var datam = deviceFromJson(mst??'');

    apiController.master.value = datam ;


    var datas = deviceFromJson(slv??'');

    apiController.slave.value = datas ;

    var slvd = pref.getString('alldevice');

    var alldevice =allDeviceFromJson(slvd??'');
        apiController.alldevice.value=alldevice;


    // var set = settingsFromJson(data??'');
    // settingsdata.value = set;

    getoff();
  }




 getoff() async {
    print("get devices");
    final dbHelper = DatabaseHelper();

    var data =  await dbHelper.getSales();
    apiController.salesdata.value = data;
    var mst =  await dbHelper.getmaster(0);
    apiController.masterd.value=mst;
    var slv =  await dbHelper.getSlaved(0);
    apiController.slaved.value=slv;

  }

  Future<void> loginuser(String username, String password) async {
    try {
      loadingdialog();
      var set = await RemoteServices.login(username, password);
      if (set != null) {
        print(set);

        SharedPreferences prefs = await SharedPreferences.getInstance();

        // Mark user as logged in
        prefs.setBool('isLoggedIn', true);

        // Parse JSON to your model
        var userdata = userdataFromJson(set);
        apiController.userdata.value = userdata;
        apiController.isLogin.value = true;

        prefs.setInt('userId', userdata.userId ?? 0);
        prefs.setString('name', userdata.name ?? "");
        prefs.setString('username', userdata.username ?? "");
        prefs.setString('email', userdata.email ?? "");
        prefs.setString('role', userdata.role ?? "");
        prefs.setString('accessToken', userdata.accessToken ?? "");


        // Navigate based on role
        if (userdata.role == "BorderUser") {
          Get.offAll(() => const HomePageborder());
        } else if (userdata.role == 'Tagger') {
          Get.offAll(() => const HomePage());
        } else {
          Get.offAll(() => const HomePageOffice());
        }
      }
    } finally {
      Get.back();
    }
  }


  Future<void> searchbytzl(String tzl) async {

    print("");
    try {

      loadingdialog();
      var set = await RemoteServices.searchbytzl(tzl);
      if (set != null) {
        Get.back();


        var datarcp =  receiptFromJson(set);
        apiController.receipt.value = datarcp;
        print("data ${set  }");
        print(datarcp.receipt?.border?.borderName??'');


        apiController.saleedited.value.gateName = datarcp.receipt?.port?.portPointName??'';
        apiController.saleedited.value.gateNumber = datarcp.receipt?.port?.portPointId.toString();
        apiController.saleedited.value.borderName = datarcp.receipt?.border?.borderName??'';
        apiController.saleedited.value.borderId=datarcp.receipt?.border?.borderId.toString();

        apiController.saleedited.value.tzl = datarcp.receipt?.tzl??'';
        apiController.saleedited.value.customerTypeId = datarcp.receipt?.customerTypeId;
        apiController.saleedited.value.saleId = datarcp.receipt?.saleId.toString();

        apiController.saleedited.value.saleType = datarcp.receipt?.saleType.toString();
        apiController.saleedited.value.salesPerson = datarcp.receipt?.userId.toString();

        apiController.saleedited.value.startDateTime = datarcp.receipt?.startDateTime;
        apiController.saleedited.value.endDate = datarcp.receipt?.endDate;

        apiController.saleedited.value.saleDate= datarcp.receipt?.startDateTime;

        // apiController.saleedited.value.customerName= datarcp.receipt?.customerName;

        apiController.saleedited.value.receipt_number = datarcp.receipt?.receiptNumber;

        apiController.saleedited.value.offline_receipt_number = datarcp.receipt?.offline_receipt_number;
        apiController.saleedited.value.companyName = datarcp.receipt?.companyName;

        apiController.saleedited.value.customerId = datarcp.receipt?.customer?.customerId.toString();

        apiController.saleedited.value.passport = datarcp.receipt?.passport??'';
        apiController.saleedited.value.driverNumber = datarcp.receipt?.driverNumber??'';
        apiController.saleedited.value.driverName = datarcp.receipt?.driverName??'';
        apiController.saleedited.value.agent= datarcp.receipt?.agent??'';
        apiController.saleedited.value.amount = datarcp.receipt?.amount??'';

        apiController.saleedited.value.chasisNumber= datarcp.receipt?.chasisNumber??'';
        apiController.saleedited.value.trailerno= datarcp.receipt?.trailerno??"";
        apiController.saleedited.value.vehicleNumber= datarcp.receipt?.vehicleNumber??'';
        apiController.saleedited.value.vehicleTypeId= datarcp.receipt?.vehicleTypeId??'';
        apiController.saleedited.value.serialNo= datarcp.receipt?.device?.deviceSerial??'';

        apiController.saleedited.value.currency= datarcp.receipt?.currency??'';
        apiController.saleedited.value.tripStatus= '';
        apiController.saleedited.value.tagger= datarcp.receipt?.username??'';
        apiController.saleedited.value.containerNumber=datarcp.receipt?.containerNumber??'';

        datarcp.receipt?.slaves?.forEach((element) {
          apiController.saleedited.value.slaves?.add(Slave(serialNo: element.serialNo,));
        });


        openReceiptButtomsheet(Get.context!, apiController.saleedited.value);









        // openReceiptButtomsheettzl(Get.context!,apiController.receipt.value.receipt!);



      }
    } finally {


      // Get.back();
    }

  }


  Future<void> searchTespaByTzl(String tzl) async {

    print("tespaaaaaaaaa");

    try {

      loadingdialog();
      var set = await RemoteServices.searchTespaByTzl(tzl);
      if (set != null) {
        Get.back();


        var datarcp =  receiptFromJson(set);
        apiController.receipt.value = datarcp;
        print("data ${set  }");
        print(datarcp.receipt?.border?.borderName??'');


        apiController.saleedited.value.gateName = datarcp.receipt?.port?.portPointName??'';
        apiController.saleedited.value.gateNumber = datarcp.receipt?.port?.portPointId.toString();
        apiController.saleedited.value.borderName = datarcp.receipt?.border?.borderName??'';
        apiController.saleedited.value.borderId=datarcp.receipt?.border?.borderId.toString();

        apiController.saleedited.value.tzl = datarcp.receipt?.tzl??'';
        apiController.saleedited.value.customerTypeId = datarcp.receipt?.customerTypeId;
        apiController.saleedited.value.saleId = datarcp.receipt?.saleId.toString();

        apiController.saleedited.value.saleType = datarcp.receipt?.saleType.toString();
        apiController.saleedited.value.salesPerson = datarcp.receipt?.userId.toString();

        apiController.saleedited.value.startDateTime = datarcp.receipt?.startDateTime;
        apiController.saleedited.value.endDate = datarcp.receipt?.endDate;

        apiController.saleedited.value.saleDate= datarcp.receipt?.startDateTime;

        apiController.saleedited.value.receipt_number = datarcp.receipt?.receiptNumber;

        apiController.saleedited.value.offline_receipt_number = datarcp.receipt?.offline_receipt_number;
        apiController.saleedited.value.companyName = datarcp.receipt?.companyName;

        apiController.saleedited.value.customerId = datarcp.receipt?.customer?.customerId.toString();

        apiController.saleedited.value.passport = datarcp.receipt?.passport??'';
        apiController.saleedited.value.driverNumber = datarcp.receipt?.driverNumber??'';
        apiController.saleedited.value.driverName = datarcp.receipt?.driverName??'';
        apiController.saleedited.value.agent= datarcp.receipt?.agent??'';
        apiController.saleedited.value.amount = datarcp.receipt?.amount??'';

        apiController.saleedited.value.chasisNumber= datarcp.receipt?.chasisNumber??'';
        apiController.saleedited.value.trailerno= datarcp.receipt?.trailerno??"";
        apiController.saleedited.value.vehicleNumber= datarcp.receipt?.vehicleNumber??'';
        apiController.saleedited.value.vehicleTypeId= datarcp.receipt?.vehicleTypeId??'';
        apiController.saleedited.value.serialNo= datarcp.receipt?.device?.deviceSerial??'';

        apiController.saleedited.value.currency= datarcp.receipt?.currency??'';
        apiController.saleedited.value.tripStatus= '';
        apiController.saleedited.value.tagger= datarcp.receipt?.username??'';
        apiController.saleedited.value.containerNumber=datarcp.receipt?.containerNumber??'';

        apiController.saleedited.value.slaves = datarcp.receipt?.slaves
            ?.map((s) => Slave(serialNo: s.serialNo))
            .toList() ?? [];


        openReceiptButtomsheet(Get.context!, apiController.saleedited.value);









        // openReceiptButtomsheettzl(Get.context!,apiController.receipt.value.receipt!);



      }
    } finally {


      // Get.back();
    }

  }





  Future<void> adsale(SaleAdd sale) async {

    print("");
    try {

      loadingdialog();
      var set = await RemoteServices.saleadd(sale);
      if (set != null) {
        Get.back();
        print(set);
        final dbHelper = DatabaseHelper();

        apiController.saleresults.value = saleResultFromJson(set??'');

        print(apiController.saleresults.value.saleId.toString());
       print( apiController.saleresults.value.receiptNumber);

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


          var data = await dbHelper.updateSales(
              apiController.saleresults.value.saleId.toString(),
              apiController.saleresults.value.receiptNumber ?? '',
              sale.tzl ?? '');
          print("data ${data}");


          var datad = await dbHelper.getSales();

          apiController.salesdata.value = datad;
          // log("Savedss ${jsonEncode(apiController.salesdata.value)}");


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


          apiController.sale.value = SaleAdd(saleDate: '', startDateTime: '', endDate: '', vehicleNumber: '', chasisNumber: '', tzl: '', driverName: '', borderId: '', tripStatus: '', driverNumber: '',  serialNo: '', amount: '', currency: '', gateNumber: '', salesPerson: '', passport: '', containerNumber: '', vehicleTypeId: '', customerTypeId: '', companyName: '', customerId: '', agent: '', saleType: '', saleId: '',prev_offline_receipt_number:'',offline_receipt_number:"", slaves: []);

          Get.back();
          Get.off(() => SalesScreen());
        }


        else {
          print(
              "DATA ZEGE");
        }



        // openSuccessButtom(apiController.saleresults.value.message??'');




      }
    } finally {


      // Get.back();
    }

  }

  Future<void> syncsale(SaleAdd sale) async {

    print("");
    try {
      apiController.sale.value = SaleAdd(saleDate: '', startDateTime: '', endDate: '', vehicleNumber: '', chasisNumber: '', tzl: '', driverName: '', borderId: '', tripStatus: '', driverNumber: '', serialNo: '', amount: '', currency: '', gateNumber: '', salesPerson: '', passport: '', containerNumber: '', vehicleTypeId: '', customerTypeId: '', companyName: '', customerId: '', agent: '', saleType: '', saleId: '',prev_offline_receipt_number:'',offline_receipt_number:"", slaves: []);

      // loadingdialog();
      var set = await RemoteServices.salesync(sale);
      if (set != null) {
        // Get.back();
        print(set);
        final dbHelper = DatabaseHelper();

        apiController.saleresults.value = saleResultFromJson(set??'');

        print(apiController.saleresults.value.saleId.toString());
        print( apiController.saleresults.value.receiptNumber);


        var data =  await dbHelper.updateSales(apiController.saleresults.value.saleId.toString(), apiController.saleresults.value.receiptNumber??'',sale.tzl??'');
        print("data ${data}");



        var datad =  await dbHelper.getSales();

        apiController.salesdata.value = datad;
        // log("Savedss ${jsonEncode(apiController.salesdata.value)}");

       /* openSuccessButtom(apiController.saleresults.value.message??'');*/




      }
    } finally {


      // Get.back();
    }

  }




  Future<void> editsale(SaleAdd sale) async {

    print("");
    try {
      apiController.saleedit.value = SaleAdd(saleDate: '', startDateTime: '', endDate: '', vehicleNumber: '', chasisNumber: '', tzl: '', driverName: '', borderId: '', tripStatus: '', driverNumber: '', serialNo: '', amount: '', currency: '', gateNumber: '', salesPerson: '', passport: '', containerNumber: '', vehicleTypeId: '', customerTypeId: '', companyName: '', customerId: '', agent: '', saleType: '', saleId: '',prev_offline_receipt_number:'',offline_receipt_number:"", slaves: []);

      loadingdialog();
      var set = await RemoteServices.editSale(sale);
      if (set != null) {
        Get.back();
        print(set);
        final dbHelper = DatabaseHelper();

        apiController.saleresults.value = saleResultFromJson(set??'');
        apiController.salead.value.receipt_number="";
        var datap = await dbHelper.insertSale(apiController.salead.value);


        if (datap!='0') {
          print("DATA ZEGEIMEGOMA");
          receiptPrintcop(apiController.saleprint.value.tooMap());


        }else{
          print("DATA ZEGE");
        }



        var data =  await dbHelper.updateSales(apiController.saleresults.value.saleId.toString(), apiController.saleresults.value.receiptNumber??'',sale.tzl??'');
        print("data ${data}");


        //
        // receiptPrintcop(apiController.saleprint.value.tooMap());
        var datad =  await dbHelper.getSales();
        apiController.salesdata.value = datad;
        // log("Savedss ${jsonEncode(apiController.salesdata.value)}");
        // openSuccessButtom(apiController.saleresults.value.message??'');
        Get.back();
        Get.off(()=>SalesScreen());


      }
    } finally {


      // Get.back();
    }

  }


  Future<void> editsalesync(SaleAdd sale) async {

    print("");
    try {
      apiController.saleedit.value = SaleAdd(saleDate: '', startDateTime: '', endDate: '', vehicleNumber: '', chasisNumber: '', tzl: '', driverName: '', borderId: '', tripStatus: '', driverNumber: '', serialNo: '', amount: '', currency: '', gateNumber: '', salesPerson: '', passport: '', containerNumber: '', vehicleTypeId: '', customerTypeId: '', companyName: '', customerId: '', agent: '', saleType: '', saleId: '',prev_offline_receipt_number:'',offline_receipt_number:"", slaves: []);

      // loadingdialog();
      var set = await RemoteServices.editSalesync(sale);
      if (set != null) {
        // Get.back();
        print(set);
        final dbHelper = DatabaseHelper();

        apiController.saleresults.value = saleResultFromJson(set??'');

        var data =  await dbHelper.updateSales(apiController.saleresults.value.saleId.toString(), apiController.saleresults.value.receiptNumber??'',sale.tzl??'');
        print("data ${data}");

        var datad =  await dbHelper.getSales();
        apiController.salesdata.value = datad;
        // log("Savedss ${jsonEncode(apiController.salesdata.value)}");
        // openSuccessButtom(apiController.saleresults.value.message??'');


      }
    } finally {


      // Get.back();
    }

  }


  Future<void> transferdat(Transfer transfer) async {


    print("");
    try {



      loadingdialog();
      var set = await RemoteServices.transfer(transfer);
      if (set != null) {
        apiController.transder.value =Transfer(fromId: '',toId: '',devices: []);
        Get.back();
        print(set);

        // openSuccessButtom(apiController.saleresults.value.message??'');

        alldeviceload();
        masterload();

        openSuccessButtom('Device Transferred',(){
          Get.back();
          // Get.off(()=>SalesScreen());
        });
      }
    } finally {


      // Get.back();
    }

  }



  Future<void> comfirmreceive(ComfirmDevice comfirm) async {

    print("");
    try {
      // apiController.borderloading.value= true;

      apiController.comfirm.value =ComfirmDevice(userId: '',devices: []);

      loadingdialog();
      var set = await RemoteServices.returndevice(comfirm);
      if (set != null) {
        Get.back();
        print(set);


        apiController.borderdeviceload();
        apiController.deviceatdeviceload();
        // apiController.borderdeviceload();
        // apiController.deviceatdeviceload();
        apiController.deviceintransistload();



        openSuccessButtom('Successfully Confirmed',(){
          Get.back();
          // Get.off(()=>SalesScreen());
        });
      }
    } finally {


      // Get.back();
    }

  }


  Future<void> comfirmreceivereturn(ComfirmDevice comfirm) async {

    print("");
    try {
      // apiController.borderloading.value= true;

      apiController.comfirm.value =ComfirmDevice(userId: '',devices: []);

      loadingdialog();
      var set = await RemoteServices.returndevicetooffice(comfirm);
      if (set != null) {
        Get.back();
        print(set);


        apiController.deviceatdeviceload();
        apiController.borderdeviceload();
        // apiController.deviceatdeviceload();
        apiController.deviceintransistload();


        openSuccessButtom('Successfully Confirmed',(){
          Get.back();
          // Get.off(()=>SalesScreen());
        });
      }
    } finally {


      // Get.back();
    }

  }


  Future<void> comfirmreceiveintransity(ComfirmDevice comfirm) async {

    print("");
    try {
      // apiController.borderloading.value= true;

      apiController.comfirm.value =ComfirmDevice(userId: '',devices: []);

      loadingdialog();
      var set = await RemoteServices.returndevicetoofficeintransit(comfirm);
      if (set != null) {
        Get.back();
        print(set);


        apiController.deviceintransistload();
        apiController.deviceatdeviceload();
        apiController.borderdeviceload();
        // apiController.deviceatdeviceload();
        // apiController.deviceintransistload();



        openSuccessButtom('Successfully Confirmed',(){
          Get.back();
          // Get.off(()=>SalesScreen());
        });
      }
    } finally {


      // Get.back();
    }

  }




  Future<void> scanreqq(ScanReceiptReq req) async {
    apiController.verified.value = false;

    print("");
    try {
      // apiController.borderloading.value= true;

      apiController.scanreq.value =ScanReceiptReq(userId: '',receiptNo: '');

      loadingdialog();
      var set = await RemoteServices.scanreq(req);
      if (set != null) {
        apiController.verified.value = true;
        Get.back();
        print(set);


        Map json = jsonDecode(set);


        openSuccessVerify();
      }
    } finally {


      // Get.back();
    }

  }





// void loginuser(){
//
// }




  void borderload() async {
    print("");
    try {

      // loadingdialog();
      var set = await RemoteServices.borders();
      if (set != null) {


        var data = borderFromJson(set);

      apiController.borders.value = data ;
      // changelangu();

        alldeviceload();



        isLoading(false);
        // Get.back();
      }
    } finally {
      isLoading(false);
      // Get.back();
    }
  }


  void portload() async {
    print("");
    try {

      // loadingdialog();
      var set = await RemoteServices.ports();
      if (set != null) {


        var data = portFromJson(set);

        apiController.ports.value = data ;
        // changelangu();
        borderload();



        isLoading(false);
        // Get.back();
      }
    } finally {
      isLoading(false);
      // Get.back();
    }
  }



  void staffload() async {
    print("");
    String id = apiController.userdata.value.userId.toString();
    try {

      // loadingdialog();
      var set = await RemoteServices.compnystaff(id);
      if (set != null) {


        var data = staffFromJson(set);

        apiController.staff.value = data ;
        // changelangu();
        // portload();



        isLoading(false);
        // Get.back();
      }
    } finally {
      isLoading(false);
      // Get.back();
    }
  }
  void customerload() async {
    print("");
    try {

      // loadingdialog();
      var set = await RemoteServices.customers();
      if (set != null) {


        var data = customerFromJson(set);

        apiController.customer.value = data ;
        // changelangu();
        portload();



        isLoading(false);
        // Get.back();
      }
    } finally {
      isLoading(false);
      // Get.back();
    }
  }


  void masterload() async {
    String id = apiController.userdata.value.userId.toString();
    print("master loading");
    try {


      var set = await RemoteServices.master(id);
      if (set != null) {
        final dbHelper = DatabaseHelper();

        dbHelper.deletemasterAllRows();


        var data = deviceFromJson(set);

        apiController.master.value = data ;


        var masters = data.devices??[];
        for (var element in masters) {
          var d = await dbHelper.insertMaster(element);
          print("MASTER SAVE ${masters.length}  $d");
        }





        // changelangu();
        salveload(id);



        isLoading(false);
        // Get.back();
      }
    } finally {
      isLoading(false);
      // Get.back();
    }
  }


  void alldeviceload() async {
    String id = apiController.userdata.value.userId.toString();
    print("master loading");
    try {


      var set = await RemoteServices.alldevice(id);
      if (set != null) {


        var data = allDeviceFromJson(set);

        apiController.alldevice.value = data ;
        apiController.devices.value = data.devices??[];
        apiController.devicestrd.value = data.devices??[];
        // changelangu();
        // salveload(id);
        staffload();



        isLoading(false);
        // Get.back();
      }
    } finally {
      isLoading(false);
      // Get.back();
    }
  }


  void borderdeviceload() async {
    String id = apiController.userdata.value.userId.toString();
    print("devicetomove");
    try {
      apiController.borderloading.value= true;

      var set = await RemoteServices.deviceToconfirm(id);
      if (set != null) {
        apiController.borderloading.value= false;

        var data = allDeviceFromJson(set);

        log("${ set}");

        apiController.devicetomove.value = data ;
        apiController.devicetomovesearch.value=data.devices??[];
        apiController.devicetomovesearched.value=data.devices??[];


        isLoading(false);
        // Get.back();
      }
    } finally {
      isLoading(false);
      // Get.back();
    }
  }

  void deviceatdeviceload() async {
    String id = apiController.userdata.value.userId.toString();
    print("devicetomove");
    try {
      apiController.borderloadingatborder.value= true;

      var set = await RemoteServices.deviceAtBorder(id);
      if (set != null) {
        apiController.borderloadingatborder.value= false;

        var data = allDeviceFromJson(set);

        log("${ set}");

        apiController.devicetomoveatborder.value = data ;
        apiController.devicetomovesearchatborder.value=data.devices??[];
        apiController.devicetomovesearchedatborder.value=data.devices??[];

        isLoading(false);
        // Get.back();
      }
    } finally {
      isLoading(false);
      // Get.back();
    }
  }


  void deviceintransistload() async {
    String id = apiController.userdata.value.userId.toString();
    print("devicetomove");
    try {
      apiController.borderloadingintra.value= true;

      var set = await RemoteServices.deviceIntransist(id);
      if (set != null) {
        apiController.borderloadingintra.value= false;

        var data = allDeviceFromJson(set);

        log("${ set}");

        apiController.devicetomoveintra.value = data ;
        apiController.devicetomovesearchatintra.value=data.devices??[];
        apiController.devicetomovesearchedintra.value=data.devices??[];

        isLoading(false);
        // Get.back();
      }
    } finally {
      isLoading(false);
      // Get.back();
    }
  }



  void salveload(String id) async {
    print("");
    try {


      var set = await RemoteServices.slave(id);
      if (set != null) {
        final dbHelper = DatabaseHelper();

        dbHelper.deleteslaveAllRows();


        var dataa = deviceFromJson(set);

        apiController.slave.value = dataa ;
        // changelangu();


        // final dbHelper = DatabaseHelper();

        var masters = dataa.devices??[];
        for (var element in masters) {
          var d = await dbHelper.insertSlave(element);
          print("Slave SAVE $d");
        }


        getoff();
        customerload();



        isLoading(false);
        // Get.back();
      }
    } finally {
      isLoading(false);
      // Get.back();
    }
  }




  void getreportdevice(ReportReq reportReq) async {
    print("");
    try {
      loadingdialog();


      var seta = await RemoteServices.reportDevice(reportReq);
      if (seta != null) {
        Get.back();

        var data = deviceReportzFromJson(seta);
        apiController.deviceRepot.value = data ;


        // Get.to(()=>ReportssScreen());


        openDeviceReportButtomsheet(Get.context!,apiController.deviceRepot.value);
        // } else{
        //   dangerdilog('No report for this date range to view');
        //
        // }





        isLoading(false);

      }
    } finally {
      isLoading(false);
      // Get.back();
    }
  }

  void getreport(ReportReq reportReq) async {
    print("");
    try {
      loadingdialog();


      var seta = await RemoteServices.report(reportReq);

      if (seta != null) {
        Get.back();

        var data = reportFromJson(seta);
        apiController.report.value = data ;


        // Get.to(()=>ReportssScreen());


          openReportButtomsheet(Get.context!,apiController.report.value);
        // } else{
        //   dangerdilog('No report for this date range to view');
        //
        // }





        isLoading(false);

      }
    } finally {
      isLoading(false);
      // Get.back();
    }
  }

   getreportTespa(ReportReq reportReq) async {
    print("");
    try {
      loadingdialog();


      var seta = await RemoteServices.reportTespa(reportReq);

      if (seta != null) {
        Get.back();

        var data = reportFromJson(seta);
        apiController.report.value = data ;


        // Get.to(()=>ReportssScreen());


        showTespaDialog(Get.context!,apiController.report.value);
        // } else{
        //   dangerdilog('No report for this date range to view');
        //
        // }

        isLoading(false);

      }
    } finally {
      isLoading(false);
      // Get.back();
    }
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