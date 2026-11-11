import 'dart:convert';
import 'dart:developer';
import 'dart:io';

// import 'package:bs_flutter_alert/bs_flutter_alert.dart';
import 'package:ects/controller/controllerconstant.dart';
import 'package:ects/model/confirmdevice.dart';
import 'package:ects/model/saledate.dart';
import 'package:ects/model/transfer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constant/apiconstant.dart';
import '../model/reportreq.dart';
import '../model/scanreq.dart';
import '../widget/arlet.dart';
import '../widget/widgetconstant.dart';

class RemoteServices {
  static var client = http.Client();

  static Future<String?> login(String username, String password) async {
    var response = await client.post(Uri.parse(Apindpoint.LOGIN),
        body: jsonEncode({'username': username, 'password': password}));

    if (response.statusCode == 200) {
      print('success login');
      var jsonString = response.body;

      print(jsonString);

      Map jsonn = jsonDecode(jsonString);

      if (jsonn['status'] == 10) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        Map json = jsonDecode(jsonString);
        // String user = jsonEncode();
        pref.setString('userData', jsonString);
        // return userFromJson(jsonString);
        return jsonString;
      } else {
        print("error login");
        dangerdilog(jsonn['message']);
        SnackbarService.errorSnackBar(Get.context!, jsonn['message']);
        return null;
      }
    } else {
      // var jsonstr = response.body;
      // return userErrorFromJson(jsonstr);
      //show error message
      print("error login");
      print(response.body);
      dangerdilog('Please try again in few minutes or check you network');
      return null;
    }
  }

  static Future<String?> saleadd(SaleAdd sale) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    log("saleData ${saleAddToJson(sale)}");

    headers['Authorization'] =
    'Bearer ${apiController.userdata.value.accessToken ?? ''}';
    var response = await client.post(Uri.parse(Apindpoint.SALE),
        headers: headers, body: saleAddToJson(sale));

    if (response.statusCode == 200) {
      print('success sale');
      var jsonString = response.body;
      print(jsonString);

      Map jsonn = jsonDecode(jsonString);

      SharedPreferences pref = await SharedPreferences.getInstance();
      Map json = jsonDecode(jsonString);
      // String user = jsonEncode();
      pref.setString('Saledata', jsonString);
      // return userFromJson(jsonString);
      return jsonString;

      print("error sale");
      dangerdilog(jsonn['message']);
      return null;
    } else {
      var jsonString = response.body;
      Map jsonn = jsonDecode(jsonString);
      // var jsonstr = response.body;
      // return userErrorFromJson(jsonstr);
      //show error message
      Get.back();
      print("error login");
      print(response.body.contains("other"));

      String jsondata = jsonn['message'];

      // Parse the JSON string
      Map<String, dynamic> data = jsonDecode(jsondata);

      // Check if the map contains the 'tzl' key
      if (data.containsKey('tzl')) {
        print('JSON contains the key "tzl"');
        apiController.tzlesist.value = true;
        dangerdilog('TZDL Already used');
        return null;
      } else {
        print('JSON does not contain the key "tzl"');
        dangerdilog(jsonn['message']);
        return null;
      }

      //
      // if (jsonn['message']) {
      //     apiController.tzlesist.value= true;
      //     dangerdilog(jsonn['message']['tzl']);
      //   }else{
      //     dangerdilog(jsonn['message']);
      //   }
      //   print(jsonn['message']);
      //   dangerdilog(jsonn['message']);

      // dangerdilog('Please try again in few minutes or check you network');
      return null;
    }
  }

  static Future<String?> salesync(SaleAdd sale) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    log("saleData ${saleAddToJson(sale)}");

    headers['Authorization'] =
    'Bearer ${apiController.userdata.value.accessToken ?? ''}';
    var response = await client.post(Uri.parse(Apindpoint.SALE),
        headers: headers, body: saleAddToJson(sale));

    if (response.statusCode == 200) {
      print('success sale');
      var jsonString = response.body;
      print(jsonString);

      Map jsonn = jsonDecode(jsonString);

      SharedPreferences pref = await SharedPreferences.getInstance();
      Map json = jsonDecode(jsonString);
      // String user = jsonEncode();
      pref.setString('Saledata', jsonString);
      // return userFromJson(jsonString);
      return jsonString;
    } else {
      var jsonString = response.body;
      Map jsonn = jsonDecode(jsonString);
      // var jsonstr = response.body;
      // return userErrorFromJson(jsonstr);
      //show error message
      // Get.back();
      print("error login");
      print(response.body);
      // dangerdilog(jsonn['message']);
      // dangerdilog('Please try again in few minutes or check you network');
      return null;
    }
  }

  static Future<String?> editSale(SaleAdd sale) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    log("saleData ${saleAddToJson(sale)}");

    headers['Authorization'] =
    'Bearer ${apiController.userdata.value.accessToken ?? ''}';
    var response = await client.post(Uri.parse(Apindpoint.EDIT_SALE),
        headers: headers, body: saleAddToJson(sale));

    if (response.statusCode == 200) {
      print('EDIT SALE');
      var jsonString = response.body;
      print(jsonString);

      Map jsonn = jsonDecode(jsonString);

      SharedPreferences pref = await SharedPreferences.getInstance();
      Map json = jsonDecode(jsonString);
      // String user = jsonEncode();
      pref.setString('SaledataEdit', jsonString);
      // return userFromJson(jsonString);
      return jsonString;

      print("error sale");
      dangerdilog(jsonn['message']);
      return null;
    } else {
      var jsonString = response.body;
      Map jsonn = jsonDecode(jsonString);
      // var jsonstr = response.body;
      // return userErrorFromJson(jsonstr);
      //show error message
      Get.back();
      print("error edit sale");
      print(response.body);
      dangerdilog(jsonn['message']);
      // dangerdilog('Please try again in few minutes or check you network');
      return null;
    }
  }

  static Future<String?> editSalesync(SaleAdd sale) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    log("saleData ${saleAddToJson(sale)}");

    headers['Authorization'] =
    'Bearer ${apiController.userdata.value.accessToken ?? ''}';
    var response = await client.post(Uri.parse(Apindpoint.EDIT_SALE),
        headers: headers, body: saleAddToJson(sale));

    if (response.statusCode == 200) {
      print('EDIT SALE');
      var jsonString = response.body;
      print(jsonString);

      Map jsonn = jsonDecode(jsonString);

      SharedPreferences pref = await SharedPreferences.getInstance();
      Map json = jsonDecode(jsonString);
      // String user = jsonEncode();
      pref.setString('SaledataEdit', jsonString);
      // return userFromJson(jsonString);
      return jsonString;
    } else {
      var jsonString = response.body;
      Map jsonn = jsonDecode(jsonString);
      // var jsonstr = response.body;
      // return userErrorFromJson(jsonstr);
      //show error message
      // Get.back();
      print("error edit sale");
      print(response.body);
      // dangerdilog(jsonn['message']);
      // dangerdilog('Please try again in few minutes or check you network');
      return null;
    }
  }

  // static Future<String?> report(ReportReq sale) async {
  //   Map<String, String> headers = {
  //     'Accept': 'application/json',
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer ${apiController.userdata.value.accessToken ?? ''}',
  //   };
  //
  //   final uri = Uri.parse(Apindpoint.RERPOT);
  //   final body = reportReqToJson(sale);
  //
  //   log("REPORT URI => $uri");
  //   log("REPORT HEADERS => $headers");
  //   log("REPORT BODY => $body");
  //
  //   var response = await client.post(uri, headers: headers, body: body);
  //
  //   if (response.statusCode == 200) {
  //     print('REPORT SUCCESS');
  //     print('Response: ${response.body}');
  //     return response.body;
  //   } else {
  //     print('REPORT FAILED');
  //     print('Response: ${response.body}');
  //     Get.back();
  //
  //     try {
  //       Map jsonn = jsonDecode(response.body);
  //       dangerdilog(jsonn['message'] ?? 'Unknown error');
  //     } catch (e) {
  //       dangerdilog('Invalid response format');
  //     }
  //
  //     return null;
  //   }
  // }
  static Future<String?> report(ReportReq sale) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${apiController.userdata.value.accessToken ?? ''}',
    };

    // Convert ReportReq to Map to add sales_channel
    Map<String, dynamic> bodyMap = jsonDecode(reportReqToJson(sale));
    bodyMap['sales_channel'] = 1; // add sales_channel

    final uri = Uri.parse(Apindpoint.RERPOT);
    final body = jsonEncode(bodyMap); // convert back to JSON string

    log("REPORT URI => $uri");
    log("REPORT HEADERS => $headers");
    log("REPORT BODY => $body");

    var response = await client.post(uri, headers: headers, body: body);

    if (response.statusCode == 200) {
      print('REPORT SUCCESS WEEEEB');
      print('Response: ${response.body}');
      return response.body;
    } else {
      print('REPORT FAILED');
      print('Response: ${response.body}');
      Get.back();

      try {
        Map jsonn = jsonDecode(response.body);
        dangerdilog(jsonn['message'] ?? 'Unknown error');
      } catch (e) {
        dangerdilog('Invalid response format');
      }

      return null;
    }
  }

  static Future<String?> reportTespa(ReportReq sale) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${apiController.userdata.value.accessToken ?? ''}',
    };

    // Convert ReportReq to Map to add sales_channel
    Map<String, dynamic> bodyMap = jsonDecode(reportReqToJson(sale));
    bodyMap['sales_channel'] = 2; // add sales_channel

    final uri = Uri.parse(Apindpoint.RERPOT);
    final body = jsonEncode(bodyMap); // convert back to JSON string

    log("REPORT URI => $uri");
    log("REPORT HEADERS => $headers");
    log("REPORT BODY => $body");

    var response = await client.post(uri, headers: headers, body: body);

    if (response.statusCode == 200) {
      print('REPORT SUCCESS TESPAAAAAAAA');
      print('Response: ${response.body}');
      return response.body;
    } else {
      print('REPORT FAILED');
      print('Response: ${response.body}');
      Get.back();

      try {
        Map jsonn = jsonDecode(response.body);
        dangerdilog(jsonn['message'] ?? 'Unknown error');
      } catch (e) {
        dangerdilog('Invalid response format');
      }

      return null;
    }
  }


  static Future<String?> reportDevice(ReportReq sale) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    log("transfer ${reportReqToJson(sale)}");

    headers['Authorization'] =
    'Bearer ${apiController.userdata.value.accessToken ?? ''}';
    var response = await client.get(
      Uri.parse(Apindpoint.DEVICERERPOT +
          "${sale.userId}&date_from=${sale.fromDate}&date_to=${sale.toDate}"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      print('report');
      var jsonString = response.body;
      print(jsonString);

      Map jsonn = jsonDecode(jsonString);

      return jsonString;
    } else {
      var jsonString = response.body;
      Map jsonn = jsonDecode(jsonString);

      Get.back();
      print("Report");
      print(response.body);
      dangerdilog(jsonn['message']);
      // dangerdilog('Please try again in few minutes or check you network');
      return null;
    }
  }

  static Future<String?> transfer(Transfer sale) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    log("transfer ${transferToJson(sale)}");

    headers['Authorization'] =
    'Bearer ${apiController.userdata.value.accessToken ?? ''}';
    var response = await client.post(Uri.parse(Apindpoint.Transfer),
        headers: headers, body: transferToJson(sale));

    if (response.statusCode == 200) {
      print('Transfer');
      var jsonString = response.body;
      print(jsonString);

      Map jsonn = jsonDecode(jsonString);

      return jsonString;
    } else {
      var jsonString = response.body;
      Map jsonn = jsonDecode(jsonString);

      Get.back();
      print("Transfer");
      print(response.body);
      dangerdilog(jsonn['message']);
      // dangerdilog('Please try again in few minutes or check you network');
      return null;
    }
  }

  static Future<String?> returndevice(ComfirmDevice sale) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    log("comfirmdata ${comfirmDeviceToJson(sale)}");

    headers['Authorization'] =
    'Bearer ${apiController.userdata.value.accessToken ?? ''}';
    var response = await client.post(Uri.parse(Apindpoint.COMFRIMDEVICE),
        headers: headers, body: comfirmDeviceToJson(sale));

    if (response.statusCode == 200) {
      print('Comfrim');
      var jsonString = response.body;
      print(jsonString);

      Map jsonn = jsonDecode(jsonString);

      return jsonString;
    } else {
      var jsonString = response.body;
      Map jsonn = jsonDecode(jsonString);

      Get.back();
      print("comfrim");
      print(response.body);
      dangerdilog(jsonn['message']);
      // dangerdilog('Please try again in few minutes or check you network');
      return null;
    }
  }

  static Future<String?> returndevicetooffice(ComfirmDevice sale) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    log("comfirmdata ${comfirmDeviceToJson(sale)}");

    headers['Authorization'] =
    'Bearer ${apiController.userdata.value.accessToken ?? ''}';
    var response = await client.post(Uri.parse(Apindpoint.DEVICERETURN),
        headers: headers, body: comfirmDeviceToJson(sale));

    if (response.statusCode == 200) {
      print('Comfrim');
      var jsonString = response.body;
      print(jsonString);

      Map jsonn = jsonDecode(jsonString);

      return jsonString;
    } else {
      var jsonString = response.body;
      Map jsonn = jsonDecode(jsonString);

      Get.back();
      print("comfrim");
      print(response.body);
      dangerdilog(jsonn['message']);
      // dangerdilog('Please try again in few minutes or check you network');
      return null;
    }
  }

  static Future<String?> returndevicetoofficeintransit(
      ComfirmDevice sale) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    log("comfirmdata ${comfirmDeviceToJson(sale)}");

    headers['Authorization'] =
    'Bearer ${apiController.userdata.value.accessToken ?? ''}';
    var response = await client.post(Uri.parse(Apindpoint.DEVICERETURNINTRA),
        headers: headers, body: comfirmDeviceToJson(sale));

    if (response.statusCode == 200) {
      print('Comfrim');
      var jsonString = response.body;
      print(jsonString);

      Map jsonn = jsonDecode(jsonString);

      return jsonString;
    } else {
      var jsonString = response.body;
      Map jsonn = jsonDecode(jsonString);

      Get.back();
      print("comfrim");
      print(response.body);
      dangerdilog(jsonn['message']);
      // dangerdilog('Please try again in few minutes or check you network');
      return null;
    }
  }

  static Future<String?> scanreq(ScanReceiptReq sale) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    log("scan ${scanReceiptReqToJson(sale)}");

    headers['Authorization'] =
    'Bearer ${apiController.userdata.value.accessToken ?? ''}';
    var response = await client.post(Uri.parse(Apindpoint.SCANREQ),
        headers: headers, body: scanReceiptReqToJson(sale));

    if (response.statusCode == 200) {
      print('Scan');
      var jsonString = response.body;
      print(jsonString);

      Map jsonn = jsonDecode(jsonString);
      apiController.scanned.value.status = '200';
      apiController.scanned.value.message = jsonn['message'];
      apiController.verified.value = true;
      print(response.statusCode);

      return jsonString;
    } else if (response.statusCode == 406) {
      print('Scan');
      var jsonString = response.body;
      print(jsonString);

      Map jsonn = jsonDecode(jsonString);
      apiController.scanned.value.status = '406';
      apiController.scanned.value.message = jsonn['message'];
      apiController.verified.value = true;
      print(response.statusCode);

      return jsonString;
    } else if (response.statusCode == 404) {
      print('Scan');
      var jsonString = response.body;
      print(jsonString);
      apiController.verified.value = true;

      Map jsonn = jsonDecode(jsonString);
      apiController.scanned.value.status = '404';

      apiController.scanned.value.message = jsonn['message'];
      print(response.statusCode);
      return jsonString;
    } else {
      var jsonString = response.body;
      // Map jsonn = jsonDecode(jsonString);

      Get.back();
      print("Scan");
      print(response.body);
      print(response.statusCode);
      // dangerdilog(jsonn['message']);
      // dangerdilog('Please try again in few minutes or check you network');
      return null;
    }
  }

  static Future<String?> searchbytzl(String tzl) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    var saled = {"tzl": tzl};
    int salesChannel = 1;
    log("saleData ${jsonEncode(saled)}");

    headers['Authorization'] =
    'Bearer ${apiController.userdata.value.accessToken ?? ''}';
    var response = await client.get(
      Uri.parse("${Apindpoint.SEARCH_TZL}&tzl=$tzl&salesChannel=$salesChannel"),
      headers: headers,
    );

    final url = Uri.parse("${Apindpoint.SEARCH_TZL}&tzl=$tzl&salesChannel=$salesChannel");
    log("Web search GET => $url");
    // body: jsonEncode(saled)
    log("Web search GET => $response");
    if (response.statusCode == 200) {
      var jsonString = response.body;

      Map jsonn = jsonDecode(jsonString);
      print('search data');

      if (jsonn['receipt'] != null) {
        return jsonString;
      } else {
        Get.back();
        dangerdilog(jsonn['message']);
      }

      print(jsonString);
    } else {
      var jsonString = response.body;
      Map jsonn = jsonDecode(jsonString);
      Get.back();
      print("error edit sale");
      print(response.body);
      dangerdilog(jsonn['message']);
      return null;
    }
  }

  static Future<String?> searchTespaByTzl(String tzl) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    headers['Authorization'] =
    'Bearer ${apiController.userdata.value.accessToken ?? ''}';

    final url = Uri.parse(
        "${Apindpoint.BASE_URL}search-tzl&tzl=$tzl&salesChannel=2");

    log("TESPA search GET => $url");

    var response = await client.get(url, headers: headers);

    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        Get.back();
        dangerdilog("Empty response from server");
        return null;
      }

      log("TESPA raw response: ${response.body}");

      try {
        Map<String, dynamic> jsonn = jsonDecode(response.body);

        Map<String, dynamic> mapped = {
          "receipt": {
            "port": {
              "port_point_id": int.tryParse(jsonn["gateId"]?.toString() ?? ""),
              "port_point_name":  jsonn["gateName"],
            },
            "driver_name": jsonn["driverName"],
            "sale_id": int.tryParse(jsonn["salesTripId"]?.toString() ?? ""),
            "user_id": null,
            "username": jsonn["agentName"],
            "amount": "",
            "company_name": jsonn["customer"]?["customerName"] ?? "",
            "agent": jsonn["agentName"],
            "currency": "TZS",
            "vehicle_number": jsonn["vehicleNo"],
            "tzl": jsonn["tripNo"],
            "border": {
              "border_id": int.tryParse(jsonn["borderId"]?.toString() ?? ""),
              "border_name":  jsonn["borderName"],
            },
            "device": {
              "device_id": null,
              "device_serial": jsonn["master"],
            },
            "passport": jsonn["driverPassport"],
            "container_number": jsonn["containerNo"],
            "customer": {
              "customer_id": int.tryParse(
                  jsonn["customer"]?["customerId"]?.toString() ?? ""),
              "customer_name": jsonn["customer"]?["customerName"],
            },
            "driver_number": jsonn["driverMobile"],
            "offline_receipt_number": "",
            "prev_offline_receipt_number": "",
            "receipt_number": jsonn["receiptNo"],
            "chasis_number": jsonn["chassesNo"],
            "vehicle_type_id": jsonn["vehicleType"],
            "customer_type_id": null,
            "sale_type": 2,
            "trailerno": jsonn["trailerNo"],
            "start_date_time": jsonn["startDate"],
            "end_date": jsonn["endDate"],
            "slaves": (jsonn["slaves"] as List<dynamic>?)
                ?.map((s) => {
              "serial_no": s["serial_no"],
            })
                .toList() ?? [],

          }
        };

        log("TESPA mapped response => $mapped");

        return jsonEncode(mapped);
      } catch (e) {
        Get.back();
        dangerdilog("Invalid JSON response: $e");
        return null;
      }
    } else {
      log("TESPA error response: ${response.body}");
      var jsonn = response.body.isNotEmpty ? jsonDecode(response.body) : {};
      Get.back();
      dangerdilog(jsonn['message'] ?? 'Error searching Tespa sale');
      return null;
    }
  }





  static Future<String?> borders() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var response = await client.get(
      Uri.parse(Apindpoint.BORDER),
    );
    if (response.statusCode == 200) {
      print('success');
      var jsonString = response.body;
      pref.setString("borders", jsonString);

      return jsonString;
    } else {
      print("data fetched");
      // dangerdilog('No network please try again');
      return null;
    }
  }

  static Future<String?> ports() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var response = await client.get(
      Uri.parse(Apindpoint.PORT),
    );
    if (response.statusCode == 200) {
      print('success');
      var jsonString = response.body;
      pref.setString("ports", jsonString);

      return jsonString;
    } else {
      print("data fetched");
      // dangerdilog('No network please try again');
      return null;
    }
  }

  static Future<String?> customers() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var response = await client.get(
      Uri.parse(
          "${Apindpoint.BILLCUSTOMER}&user_id=${apiController.userdata.value
              .userId}"),
    );
    if (response.statusCode == 200) {
      print('success');
      var jsonString = response.body;
      pref.setString("billcustomer", jsonString);

      return jsonString;
    } else {
      print("data fetched");
      // dangerdilog('No network please try again');
      return null;
    }
  }

  static Future<String?> master(String id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var response = await client.get(
      Uri.parse(Apindpoint.MASTER + id),
    );
    if (response.statusCode == 200) {
      print('success');
      var jsonString = response.body;
      pref.setString("master", jsonString);

      return jsonString;
    } else {
      print("data fetched");
      // dangerdilog('No network please try again');
      return null;
    }
  }

  static Future<String?> deviceAtBorder(String id) async {
    var response = await client.get(
      Uri.parse(Apindpoint.DEVICEATBORDER + id),
    );
    if (response.statusCode == 200) {
      print('success');
      var jsonString = response.body;

      return jsonString;
    } else {
      print("device at border");
      // dangerdilog('No network please try again');
      return null;
    }
  }

  static Future<String?> deviceIntransist(String id) async {
    var response = await client.get(
      Uri.parse(Apindpoint.DEVICETORETURN + id),
    );
    if (response.statusCode == 200) {
      print('success');
      var jsonString = response.body;

      return jsonString;
    } else {
      print("device at border");
      // dangerdilog('No network please try again');
      return null;
    }
  }

  static Future<String?> deviceToconfirm(String id) async {
    var response = await client.get(
      Uri.parse(Apindpoint.DEVICETOCONFIRM + id),
    );
    if (response.statusCode == 200) {
      print('success');
      var jsonString = response.body;

      return jsonString;
    } else {
      print("data fetched bord feteched");
      log(response.body);
      // dangerdilog('No network please try again');
      return null;
    }
  }

  static Future<String?> alldevice(String id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var response = await client.get(
      Uri.parse(Apindpoint.ALLDEVICE + id),
    );
    if (response.statusCode == 200) {
      print('success');
      var jsonString = response.body;
      pref.setString("alldevice", jsonString);

      return jsonString;
    } else {
      print("data fetched");
      // dangerdilog('No network please try again');
      return null;
    }
  }

  static Future<String?> compnystaff(String id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var response = await client.get(
      Uri.parse(Apindpoint.COMPANY_STAFF + id),
    );
    if (response.statusCode == 200) {
      print('success');
      var jsonString = response.body;
      pref.setString("companystaff", jsonString);

      return jsonString;
    } else {
      print("data fetched");
      // dangerdilog('No network please try again');
      return null;
    }
  }

  static Future<String?> slave(String id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var response = await client.get(
      Uri.parse(Apindpoint.SLAVE + id),
    );
    if (response.statusCode == 200) {
      print('success');
      var jsonString = response.body;
      pref.setString("slave", jsonString);

      return jsonString;
    } else {
      print("data fetched");
      // dangerdilog('No network please try again');
      return null;
    }
  }

  static Future<String?> getEctsCustomers() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var response = await client.get(
      Uri.parse(
          "${Apindpoint.BILLCUSTOMER}&user_id=${apiController.userdata.value
              .userId}"),
    );
    if (response.statusCode == 200) {
      print('success');
      var jsonString = response.body;
      pref.setString("billcustomer", jsonString);

      return jsonString;
    } else {
      print("data fetched");
      // dangerdilog('No network please try again');
      return null;
    }
  }

  // Tespa integration

  static Future<String?> verifyPayment(int userId, String merchantNo) async {
    final httpClient = HttpClient();

    // Construct the full URL with r parameter
    final uri = Uri.parse(Apindpoint.BASE_URL).replace(
      queryParameters: {
        "r": "gateway/get-records", // add this
        "userId": userId.toString(),
        "merchantNo": merchantNo,
      },
    );

    print("Final URL: $uri");

    try {
      final request = await httpClient.getUrl(uri);

      request.headers.set(HttpHeaders.contentTypeHeader, "application/json");
      request.headers.set('message-type', 'GET_PAYMENT_VALIDATION');

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      print("response: $responseBody");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('Payment verification successful');
        return responseBody;
      } else {
        print('Payment verification failed: ${response.reasonPhrase}');
        return responseBody;
      }
    } catch (e) {
      print('Error in verifyPayment: $e');
      return "Error: $e";
    } finally {
      httpClient.close();
    }
  }

  static Future<String?> createTespaTrip(Map<String, dynamic> tripData) async {
    final httpClient = HttpClient();

    // Base URL is the same, but we don’t need query params here
    final uri = Uri.parse(Apindpoint.BASE_URL).replace(
      queryParameters: {
        "r": "gateway/post-records", // same r
      },
    );

    print("Final URL for create trip: $uri");
    print("Sending tripData: ${jsonEncode(tripData)}");

    try {
      final request = await httpClient.postUrl(uri);

      request.headers.set(HttpHeaders.contentTypeHeader, "application/json");
      request.headers.set('message-type', 'CREATE_SALES_TRIP_ORDER');

      // Write the tripData to the request body
      request.write(jsonEncode(tripData));

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      print("Response body: $responseBody");
      print("Status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        print('Trip creation successful');
        return responseBody;
      } else {
        print('Trip creation failed: ${response.reasonPhrase}');
        return responseBody;
      }
    } catch (e) {
      print('Error in createTespaTrip: $e');
      return "Error: $e";
    } finally {
      httpClient.close();
    }
  }

  static Future<String?> getEctsCustomerTespa(int userId) async {
    final httpClient = HttpClient();

    // Construct the full URL with r parameter
    final uri = Uri.parse(Apindpoint.BASE_URL).replace(
      queryParameters: {
        "r": "gateway/get-records",
        "userId": userId.toString(),
      },
    );

    print("Final URL: $uri");

    try {
      final request = await httpClient.getUrl(uri);

      request.headers.set(HttpHeaders.contentTypeHeader, "application/json");
      request.headers.set('message-type', 'GET_CUSTOMERS');

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      print("response: $responseBody");
      print(response.statusCode);

      if (response.statusCode == 200) {
        print('Customer fetch successful');
        return responseBody;
      } else {
        print('Customer fetch failed: ${response.reasonPhrase}');
        return responseBody;
      }
    } catch (e) {
      print('Error in get Ects Customer from Tespa: $e');
      return "Error: $e";
    } finally {
      httpClient.close();
    }
  }

  static Future<String?> createSalesOrder(
      Map<String, dynamic> orderData) async {
    final httpClient = HttpClient();

    final uri = Uri.parse(Apindpoint.BASE_URL).replace(
      queryParameters: {
        "r": "gateway/post-records", // same r param
      },
    );

    print("Final URL for create order: $uri");
    print("Sending orderData: ${jsonEncode(orderData)}");

    try {
      final request = await httpClient.postUrl(uri);

      request.headers.set(HttpHeaders.contentTypeHeader, "application/json");
      request.headers
          .set('message-type', 'CREATE_SALES_ORDER');

      request.write(jsonEncode(orderData));

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      print("Response body: $responseBody");
      print("Status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        print('Sales order creation successful');
        return responseBody;
      } else {
        print('Sales order creation failed: ${response.reasonPhrase}');
        return responseBody;
      }
    } catch (e) {
      print('Error in createSalesOrder: $e');
      return "Error: $e";
    } finally {
      httpClient.close();
    }
  }

  static Future<String?> payForOrder(Map<String, dynamic> orderData) async {
    final httpClient = HttpClient();

    final uri = Uri.parse(Apindpoint.BASE_URL).replace(
      queryParameters: {
        "r": "gateway/post-records",
      },
    );

    print("Final URL for payForOrder: $uri");
    print("Sending orderData for payment: ${jsonEncode(orderData)}");

    try {
      final request = await httpClient.postUrl(uri);

      // Set headers
      request.headers.set(HttpHeaders.contentTypeHeader, "application/json");
      request.headers.set('message-type', 'CREATE_PAYMENT_ORDER');

      // Write body
      request.write(jsonEncode(orderData));

      // Send request
      final response = await request.close();

      // Get response body
      final responseBody = await response.transform(utf8.decoder).join();

      print("Response body: $responseBody");
      print("Status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        print('Payment order link generated successful');
        return responseBody;
      } else {
        print('Payment order link failed: ${response.reasonPhrase}');
        return responseBody;
      }
    } catch (e) {
      print('Error in generating link: $e');
      return "Error: $e";
    } finally {
      httpClient.close();
    }
  }

  static Future<String?> getDevicePrices(int userId, String r) async {
    final httpClient = HttpClient();

    // Construct the full URL with r parameter
    final uri = Uri.parse(Apindpoint.BASE_URL).replace(
      queryParameters: {
        "r": "gateway/get-records",
        "userId": userId.toString(),
      },
    );

    print("Final URL for device prices: $uri");

    try {
      final request = await httpClient.getUrl(uri);

      request.headers.set(HttpHeaders.contentTypeHeader, "application/json");
      request.headers.set('message-type', 'GET_DEVICES_PRICE');

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      print("Device prices response: $responseBody");
      print("Status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        print('Device prices fetch successful');
        return responseBody;
      } else {
        print('Device prices fetch failed: ${response.reasonPhrase}');
        return responseBody;
      }
    } catch (e) {
      print('Error fetching device prices: $e');
      return "Error: $e";
    } finally {
      httpClient.close();
    }
  }


  static Future<String?> getUnpaidOrders(int userId) async {
    final httpClient = HttpClient();
    final uri = Uri.parse(Apindpoint.BASE_URL).replace(
      queryParameters: {
        "r": "gateway/get-records",
        "userId": userId.toString(),
      },
    );

    print("Final URL for unpaid orders: $uri");

    try {
      final request = await httpClient.getUrl(uri);
      request.headers.set(HttpHeaders.contentTypeHeader, "application/json");
      request.headers.set('message-type', 'GET_UNPAID_SALES_ORDER');

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      print("Unpaid orders response: $responseBody");
      print("Status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        print('Unpaid orders fetch successful');
        return responseBody;
      } else {
        print('Unpaid orders fetch failed: ${response.reasonPhrase}');
        return null; // <-- return null here on failure
      }
    } catch (e) {
      print('Error fetching unpaid orders: $e');
      return null;
    } finally {
      httpClient.close();
    }
  }

  static Future<String?> getPaidOrders(int userId) async {
    final httpClient = HttpClient();
    final uri = Uri.parse(Apindpoint.BASE_URL).replace(
      queryParameters: {
        "r": "gateway/get-records",
        "userId": userId.toString(),
      },
    );

    print("Final URL for paid orders: $uri");

    try {
      final request = await httpClient.getUrl(uri);
      request.headers.set(HttpHeaders.contentTypeHeader, "application/json");
      request.headers.set('message-type', 'GET_PAID_SALES_ORDER'); // updated header

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      print("Paid orders response: $responseBody");
      print("Status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        print('Paid orders fetch successful');
        return responseBody;
      } else {
        print('Paid orders fetch failed: ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      print('Error fetching paid orders: $e');
      return null;
    } finally {
      httpClient.close();
    }
  }




}












// static Future<Map?> getvalidationcode(String member_number,String lang,String validation_type,user_type) async {
//
//   print(statevalueContr.ispensioner.value);
//   var   body= { statevalueContr.ispensioner.value?'pension_number':'member_number': member_number, 'validation_type': validation_type,'lang':lang,'user_type':user_type.toString()};
//
//   print(body);
//
//     var response = await client.post(Uri.parse(Apindpoint.VALIDATE_MEMBER),
//         body: { statevalueContr.ispensioner.value?'pension_number':'member_number': member_number, 'validation_type': validation_type,'lang':lang,'user_type':user_type.toString()});
//     if (response.statusCode == 200) {
//
//
//       print('success');
//       var jsonString = response.body;
//
//       print(jsonString);
//
//       // SharedPreferences pref = await SharedPreferences.getInstance();
//       Map json = jsonDecode(jsonString);
//       // String user = jsonEncode();
//       // pref.setString('userData', jsonEncode(json));
//
//
//       // Map jsonn = jsonDecode(jsonString);
//
//       if(json['userData']['status']==200){
//         print("validation code sent");
//         return json;
//
//       }else
//       {
//         print("error login");
//         dangerdilogd(transmessg(statevalueContr.languageselected.value.toLowerCase(), json['userData']['message']));
//         Get.back();
//         // dangerdilog('Incorrect username & password');
//         return null;
//
//       }
//
//
//
//     } else {
//       // var jsonstr = response.body;
//       // return userErrorFromJson(jsonstr);
//       //show error message
//
//       Map json = jsonDecode(response.body);
//       print(json['userData']['message']);
//
//
//       print("error");
//       dangerdilogd(transmessg(statevalueContr.languageselected.value.toLowerCase(), json['userData']['message']));
//       // dangerdilog(json['userData']['message']);
//       Get.back();
//       return null;
//     }
//   }
//
//   static Future<Map?> changepassvalidation(String member_number,String lang,String validation_type,user_type) async {
//   var body =  {'member_number': member_number, 'validation_type': validation_type,'lang':'sw','user_type':user_type.toString()};
//
//     var response = await client.post(Uri.parse(Apindpoint.FORGET_PASS_EMAIL),
//         body: {'member_number': member_number, 'validation_type': validation_type,'lang':'sw','user_type':user_type.toString()});
//     print(body);
//     if (response.statusCode == 200) {
//       print(response.body);
//
//
//       print('success');
//       var jsonString = response.body;
//       print(jsonString);
//
//       // SharedPreferences pref = await SharedPreferences.getInstance();
//       Map json = jsonDecode(jsonString);
//       // String user = jsonEncode();
//       // pref.setString('userData', jsonEncode(json));
//
//
//       // Map jsonn = jsonDecode(jsonString);
//
//       if(json['userData']['status']==200){
//         print("validation code sent");
//         return json;
//
//       }else
//       {
//         print("error login");
//         dangerdilogd(transmessg(statevalueContr.languageselected.value.toLowerCase(), json['userData']['message']));
//         Get.back();
//         // dangerdilog('Incorrect username & password');
//         return null;
//
//       }
//
//
//
//     } else {
//       // var jsonstr = response.body;
//       // return userErrorFromJson(jsonstr);
//       //show error message
//
//       Map json = jsonDecode(response.body);
//       print(json['userData']['message']);
//
//
//       print("error");
//       dangerdilogd(transmessg(statevalueContr.languageselected.value.toLowerCase(), json['userData']['message']));
//       // dangerdilog(json['userData']['message']);
//       Get.back();
//       return null;
//     }
//   }
//   static Future<Map?> changepass(String member_number,String token,String password1,password2) async {
//     var body = {'member_number': member_number, 'token': token,'password1':password1,'password2':password2};
//     print(body);
//     var response = await client.post(Uri.parse(Apindpoint.FORGET_PASS_RESET),
//
//
//         body: {'member_number': member_number, 'token': token,'password1':password1,'password2':password2});
//     if (response.statusCode == 200) {
//
//
//       print('success');
//       var jsonString = response.body;
//       print(jsonString);
//
//       // SharedPreferences pref = await SharedPreferences.getInstance();
//       Map json = jsonDecode(jsonString);
//
//       if(json['userData']['status']==200){
//
//         return json;
//
//       }else
//       {
//         print("error login");
//         dangerdilogd(transmessg(statevalueContr.languageselected.value.toLowerCase(), json['userData']['message']));
//         Get.back();
//
//         return null;
//
//       }
//
//
//
//     } else {
//       // var jsonstr = response.body;
//       // return userErrorFromJson(jsonstr);
//       //show error message
//
//       Map json = jsonDecode(response.body);
//
//
//
//       print("error");
//       dangerdilogd(transmessg(statevalueContr.languageselected.value.toLowerCase(), json['userData']['message']));
//
//       Get.back();
//       return null;
//     }
//   }
//
//   static Future<Map?> changepassword(String token,String current_username,old_pass,String new_pass,confirm_pass) async {
//     Map<String, String> headers = {
//       'Token': authController.userdat.value.userData.token.toString(),
//       'User_ID': authController.userdat.value.userData.uid.toString(),
//     };
//
//     var response = await client.post(Uri.parse(Apindpoint.EDIT_PROFILE),
//         headers: headers,
//         body: {'token': token, 'current_username': current_username,'current_password':old_pass,'new_password':new_pass,'confirm_new_password':confirm_pass});
//     if (response.statusCode == 200) {
//
//
//       print('success');
//       var jsonString = response.body;
//       print(jsonString);
//
//       // SharedPreferences pref = await SharedPreferences.getInstance();
//       Map json = jsonDecode(jsonString);
//
//       if(json['userData']['status']==200){
//
//         return json;
//
//       }else
//       {
//         print("erroediting");
//         dangerdilogd(transmessg(statevalueContr.languageselected.value.toLowerCase(), json['userData']['message']));
//         Get.back();
//
//         return null;
//
//       }
//
//
//
//     } else {
//       // var jsonstr = response.body;
//       // return userErrorFromJson(jsonstr);
//       //show error message
//
//       Map json = jsonDecode(response.body);
//
//
//
//       print("error editing");
//       dangerdilogd(transmessg(statevalueContr.languageselected.value.toLowerCase(), json['userData']['message']));
//
//       Get.back();
//       return null;
//     }
//   }
//
//   static Future<Map?> editprofile(String token,String current_username,old_pass,String new_username,mobile,email) async {
//     Map<String, String> headers = {
//       'Token': authController.userdat.value.userData.token.toString(),
//       'User_ID': authController.userdat.value.userData.uid.toString(),
//     };
//     var response = await client.post(Uri.parse(Apindpoint.EDIT_PROFILE),
//         headers: headers,
//         body: {'token': token, 'current_username': current_username,'current_password':old_pass,'new_username':new_username,'mobile_number':mobile,'email_address':email,'device_token':apiController.fcm_token.value,'device_type':apiController.device_type.value});
//     if (response.statusCode == 200) {
//
//
//       print('success');
//       var jsonString = response.body;
//       print(jsonString);
//
//       // SharedPreferences pref = await SharedPreferences.getInstance();
//       Map json = jsonDecode(jsonString);
//
//       if(json['userData']['status']==200){
//
//         return json;
//
//       }else
//       {
//         print("erroediting");
//         dangerdilogd(transmessg(statevalueContr.languageselected.value.toLowerCase(), json['userData']['message']));
//         Get.back();
//
//         return null;
//
//       }
//
//
//
//     } else {
//       // var jsonstr = response.body;
//       // return userErrorFromJson(jsonstr);
//       //show error message
//
//       Map json = jsonDecode(response.body);
//
//
//
//       print("error editing");
//       dangerdilogd(transmessg(statevalueContr.languageselected.value.toLowerCase(), json['userData']['message']));
//
//       Get.back();
//       return null;
//     }
//
//
//   }
//
//   static Future<Map?> editVoluntaryCode(voluntary_number) async {
//     Map<String, String> headers = {
//       'Token': authController.userdat.value.userData.token.toString(),
//       'User_ID': authController.userdat.value.userData.uid.toString(),
//     };
//
//
//
//
//     var response = await client.post(Uri.parse(Apindpoint.EDIT_PROFILE),
//         headers: headers,
//         body: {'voluntary_number': voluntary_number.toString()});
//
//
//     print(headers);
//     print({'voluntary_number': voluntary_number.toString()});
//
//     if (response.statusCode == 200) {
//
//
//       print('success');
//       var jsonString = response.body;
//       print(jsonString);
//
//       // SharedPreferences pref = await SharedPreferences.getInstance();
//       Map json = jsonDecode(jsonString);
//
//       if(json['userData']['status']==200){
//
//         return json;
//
//       }else
//       {
//         print('success');
//         var jsonString = response.body;
//         print(jsonString);
//         print("add code error");
//         dangerdilogd(transmessg(statevalueContr.languageselected.value.toLowerCase(), json['userData']['message']));
//         Get.back();
//
//         return null;
//
//       }
//
//
//
//     } else {
//
//       Map json = jsonDecode(response.body);
//       print("add code error");
//       print('success');
//       var jsonString = response.body;
//       print(jsonString);
//       dangerdilogd(transmessg(statevalueContr.languageselected.value.toLowerCase(), json['userData']['message']));
//
//       Get.back();
//       return null;
//     }
//   }
//
//
//

