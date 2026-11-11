import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:ects/model/SaleAddTespa.dart';
import 'package:ects/model/border.dart';
import 'package:ects/model/customer.dart';
import 'package:ects/model/ports.dart';
import 'package:ects/model/saledate.dart';
import 'package:ects/screens/sales/salesscreen.dart';
import 'package:ects/screens/sales/trip_list_screen.dart';
import 'package:ects/services/remoteservice.dart';
import 'package:ects/widget/widgetconstant.dart';
import 'package:ects/widget/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/colorcontant.dart';
import '../../controller/controllerconstant.dart';
import '../../generated/assets.dart';
import '../../model/device.dart';
import '../../offlinedb/sqlite.dart';
import '../../widget/arlet.dart';
import '../receipts/receipt.dart';
import '../../model/trip.dart';
import '../../services/trip_storage.dart';

class CreateTripScreen extends StatefulWidget {
  final Map<String, dynamic>? paymentData;

  const CreateTripScreen({super.key, this.paymentData});

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen>
    with AutomaticKeepAliveClientMixin {
  // Controllers and variables
  TextEditingController startdate = TextEditingController(
      text: DateFormat('yyyy-mm-dd, HH:MM').format(DateTime.now()).toString());
  TextEditingController enddate = TextEditingController();
  final ScrollController scroll = ScrollController();
  final _multiSelectKey = GlobalKey<FormFieldState>();
  final formKeysale = GlobalKey<FormState>();
  String? _timeString;
  String paymentRef = '';
  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false; // Added loader state

  TextEditingController agentPhoneController = TextEditingController();
  TextEditingController driverLicenseController = TextEditingController();
  TextEditingController driverNameController = TextEditingController();
  TextEditingController cargoNoController = TextEditingController();

  @override
  void dispose() {
    agentPhoneController.dispose();
    driverLicenseController.dispose();
    driverNameController.dispose();
    cargoNoController.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    _loadPaymentRef();
    apiController.slavedata.value = (widget.paymentData?['devices']?['slaves'] as List? ?? [])
        .map((slave) => slave['serial_no']?.toString() ?? '')
        .toList();
    print("Received payment data in CreateTripScreen: ${widget.paymentData}");
    apiController.masterload();
    getoff();
    apiController.step1.value = true;
    apiController.step2.value = false;
    apiController.step3.value = false;
    apiController.ispastesale.value = false;
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
  }

  Future<void> _loadPaymentRef() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      paymentRef = prefs.getString('paymentRef') ?? 'No reference';
      print("Received payment ref number: ${paymentRef}");
    });
  }

  Future<void> getoff() async {
    final dbHelper = DatabaseHelper();
    var data = await dbHelper.getSales();
    apiController.salesdata.value = data;
    var mst = await dbHelper.getmaster(0);
    apiController.masterd.value = mst;
    var slv = await dbHelper.getSlaved(0);
    apiController.slaved.value = slv;
  }

  @override
  bool get wantKeepAlive => true;

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    if (mounted) {
      setState(() {
        _timeString = formattedDateTime;
        startdate.text = formattedDateTime;
        final today = DateTime.now();
        enddate.text = _formatDate(now.add(const Duration(days: 6)));
      });
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  String _formatDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  Map<String, dynamic> generateTripJson() {
    return {
      "slaves": apiController.slavedata.map((s) => cleanSerial(s)).toList(), // cleaned
      "agent": {
        "agentName": apiController.agent.value,
        "agentPhoneNo": agentPhoneController.text
      },
      "containerNo": apiController.containerno.value,
      "endDate": enddate.text,
      "borderId": apiController.border.value,
      "trailerNo": apiController.sale.value.trailerno ?? '',
      "tripNo": apiController.tzdl.value,
      "userId": apiController.userdata.value.userId?.toString() ?? '',
      "cargoTypeId": apiController.vtype.value == 'IT'
          ? '1'
          : apiController.vtype.value == 'Dry Cargo'
          ? '2'
          : '3',
      "master": cleanSerial(widget.paymentData?['devices']?['master']?['serial_no']), // cleaned
      "chassisNo": apiController.sale.value.chasisNumber ?? '',
      "vehicleNo": apiController.vehicleno.value,
      "driver": {
        "driverLicenseNo": driverLicenseController.text,
        "passportNo": apiController.pasport.value,
        "driverPhoneNo": apiController.drivernumber.value,
        "driverName": driverNameController.text
      },
      "gateId": apiController.port.value,
      "cargoNo": cargoNoController.text,
      "vehicleType": apiController.vtype.value,
      "startDate": startdate.text,
      "customer": {
        "customerId": widget.paymentData?['customer']?['customerId']?.toString() ?? '',
        "customerName": widget.paymentData?['customer']?['customerName']?.toString() ?? ''
      },
      "merchantNo": paymentRef
    };
  }


  @override
  Widget build(BuildContext context) {
    final slaves = (widget.paymentData?['devices']?['slaves'] as List? ?? [])
        .whereType<Map<String, dynamic>>()
        .toList();

    print("slavessss: ${slaves}");
    super.build(context);

    return Stack(
      children: [
        Scaffold(
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset: true,
          extendBody: true,
          body: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header Section
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
                        right: 20,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () => Get.back(),
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                foregroundImage: AssetImage(Assets.iconsBack),
                                radius: 17,
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(left: 12),
                              child: Text('New Trip ', style: font20white),
                            ),
                            Spacer(),
                            Container(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: () => openMenusheet(context),
                                child: Icon(Icons.more_vert_rounded, color: whitecolor),
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
                              color: primarycolor.withOpacity(0.6)),
                          child: Container(
                            margin: EdgeInsets.only(left: 25, right: 25),
                            child: Obx(
                                  () => Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  apiController.step1.value
                                      ? roundedstep('Step 01')
                                      : Text('Step 01', style: font15white),
                                  apiController.step2.value
                                      ? roundedstep('Step 02')
                                      : Text('Step 02', style: font15white),
                                  apiController.step3.value
                                      ? roundedstep('Step 03')
                                      : Text('Step 03', style: font15white),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                // Information Display Cards (only shown in Step 1)
                Obx(() => apiController.step1.value ? Column(
                  children: [
                    _buildInfoCard('Customer Name',
                        widget.paymentData?['customer']?['customerName'] ?? 'No customer name'),
                    _buildInfoCard('Payment Reference', paymentRef),
                    _buildInfoCard('Master Device',
                        widget.paymentData?['devices']?['master']?['serial_no'] ?? 'No master device'),

                    // Slave Devices Display
                    Container(
                      margin: const EdgeInsets.only(left: 20, right: 20, top: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: _infoBoxDecoration(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Slave Devices',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 6),
                          for (var slave in slaves)
                            _buildSlaveDeviceItem(slave['serial_no'] ?? 'No serial'),
                        ],
                      ),
                    ),
                  ],
                ) : SizedBox.shrink()),

                // Form Steps
                Obx(() => Column(
                  children: [
                    if (!apiController.ispastesale.value)
                      SizedBox(
                        height: 560,
                        child: Form(
                          key: formKeysale,
                          child: Column(
                            children: [
                              // STEP 1: Customer and Device Information
                              if (apiController.step1.value)
                                _buildStep1Content(),

                              // STEP 2: Trip Details
                              if (apiController.step2.value)
                                _buildStep2Content(),

                              // STEP 3: Rental Information
                              if (apiController.step3.value)
                                _buildStep3Content(),
                            ],
                          ),
                        ),
                      )
                    else
                      _buildPasteSaleForm(),
                  ],
                )),
              ],
            ),
          ),
        ),

        // Loader overlay
        if (_isSubmitting)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(primarycolor),
              ),
            ),
          ),
      ],
    );
  }

  // STEP 1 Content
  Widget _buildStep1Content() {
    return SizedBox(
      height: 560,
      child: Scrollbar(
        controller: scroll,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: scroll,
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              dropdown('Vehicle Type', ['IT', 'Dry Cargo', 'Wet Cargo'], (value) {
                apiController.vtype.value = value ?? '';
              }),

              if (apiController.vtype.value == 'Dry Cargo') ...[
                formfielunderline('Vehicle Number', (value) {
                  apiController.vehicleno.value = value ?? '';
                }),
                formfielunderline('Container Number', (value) {
                  apiController.containerno.value = value ?? '';
                }),
              ],

              if (apiController.vtype.value == 'Wet Cargo') ...[

                formfielunderline('Vehicle Number', (value) {
                  apiController.vehicleno.value = value ?? '';
                }),
                formfielunderline('Trailer Number', (value) {
                  apiController.sale.value.trailerno = value ?? '';
                }),
              ],

              formfielunderline('Agent Name', (value) {
                apiController.agent.value = value ?? '';
              }),

              formfielunderline('Agent Phone', (value) {
                agentPhoneController.text = value ?? '';
              }),

              formfielunderline('Cargo Number', (value) {
                cargoNoController.text = value ?? '';
              }),
              formfielunderline('Chasis Number', (value) {
                apiController.chasis.value = value ?? '';
              }),


              _buildStepNavigationButtons(
                onNext: () {
                  if (formKeysale.currentState!.validate()) {
                    apiController.step1.value = false;
                    apiController.step2.value = true;
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // STEP 2 Content
  Widget _buildStep2Content() {
    return SizedBox(
      height: 560,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildPortDropdown(),
            _buildBorderDropdown(),

            formfielunderline('Driver Name', (value) {
              driverNameController.text = value ?? '';
            }),

            formfielunderline('Driver License', (value) {
              driverLicenseController.text = value ?? '';
            }),

            formfielunderline('Passport', (value) {
              apiController.pasport.value = value ?? '';
            }),

            formfielunderlinephone('Driver Phone', (value) {
              apiController.drivernumber.value = value ?? '';
            }),

            _buildStepNavigationButtons(
              showBack: true,
              onBack: () {
                apiController.step1.value = true;
                apiController.step2.value = false;
                apiController.step3.value = false;
              },
              onNext: () {
                apiController.canhold.value = true;
                if (formKeysale.currentState!.validate()) {
                  apiController.step1.value = false;
                  apiController.step2.value = false;
                  apiController.step3.value = true;
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // STEP 3 Content
  Widget _buildStep3Content() {
    return SizedBox(
      height: 560,
      child: Column(
        children: [
          formfileddateundelinenew('Rental Start Date', startdate),
          formfileddateundelinenew('Rental End Date', enddate),
          formfielunderlinetzdln('Trip Number', (value) {
            apiController.tzlesist.value = false;
            apiController.tzdl.value = value ?? '';
            apiController.sale.value.tripStatus = '1';
            apiController.sale.value.tagger = apiController.userdata.value.name.toString();
            apiController.sale.value.salesPerson = apiController.userdata.value.userId.toString();
            apiController.sale.value.tzl = apiController.tzdl.value;
            apiController.sale.value.saleDate = startdate.text;
            apiController.sale.value.startDateTime = startdate.text;
            apiController.sale.value.endDate = enddate.text;
          }),

          _buildStepNavigationButtons(
            showBack: true,
            onBack: () {
              apiController.step1.value = false;
              apiController.step2.value = true;
              apiController.step3.value = false;
            },
            onSubmit: () async {
              if (formKeysale.currentState!.validate()) {
                apiController.tzlesist.value = false;
                var datastus = await hasNetwork();
                final dbHelper = DatabaseHelper();

                var exist = await dbHelper.doesDataExist(apiController.tzdl.value ?? "");
                if (exist) {
                  apiController.tzlesist.value = true;
                  SnackbarService.errorSnackBar(context, 'TZDL (Trip No) Already used please and try again');
                } else {
                  // Show loader
                  setState(() {
                    _isSubmitting = true;
                  });

                  try {
                    await _handleFormSubmission(datastus, dbHelper);
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
                    }

                  } catch (e) {
                    // Handle error
                    SnackbarService.errorSnackBar(context, 'Error submitting trip: $e');
                  } finally {
                    // Hide loader
                    setState(() {
                      _isSubmitting = false;
                    });
                  }
                }
              }
            },
          ),
        ],
      ),
    );
  }

  // Helper Methods
  Widget _buildInfoCard(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 12),
      padding: const EdgeInsets.all(12),
      decoration: _infoBoxDecoration(),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '$label - $value',
              style: const TextStyle(
                fontSize: 15,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _infoBoxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: const Border(
        bottom: BorderSide(
          color: Colors.grey,
          width: 1.5,
        ),
      ),
    );
  }

  Widget _buildSlaveDeviceItem(String serialNo) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          const SizedBox(width: 12),
          const Icon(Icons.subdirectory_arrow_right, color: Colors.grey, size: 16),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              serialNo,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlaveDeviceMultiSelect() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 12),
      child: MultiSelectDialogField(
        searchable: true,
        items: apiController.slaved.value
            .map((device) => MultiSelectItem<DeviceElement>(device, device.serialNo ?? ''))
            .toList(),
        title: Text("Slave Device", style: font15black),
        selectedColor: greencolor1,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(0)),
          border: Border(
            bottom: BorderSide(width: 1.0, color: textgrey),
          ),
        ),
        buttonIcon: Icon(Icons.keyboard_arrow_down_outlined, color: colorsfontgrey),
        buttonText: Text("Slave Device", style: font15black),
        onConfirm: (results) {
          apiController.slavedata.value = [];
          List<Slave> data = [];
          for (var element in results) {
            apiController.slavedata.add(element.serialNo);
            data.add(Slave(serialNo: element.serialNo ?? ''));
          }
          apiController.sale.value.slaves = data;
        },
      ),
    );
  }

  Widget _buildPortDropdown() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 12),
      child: DropDownTextField(
        clearOption: false,
        dropDownIconProperty: IconProperty(
            icon: Icons.keyboard_arrow_down_outlined),
        textFieldFocusNode: textFieldFocusNode,
        searchFocusNode: searchFocusNode,
        validator: (value) {
          if (value == '') return "Please select a port";
          return null;
        },
        textFieldDecoration: InputDecoration(
          label: Text('From Port Point', style: font15black),
          contentPadding: EdgeInsets.all(12),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: textgrey),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        dropDownItemCount: 8,
        searchShowCursor: false,
        enableSearch: true,
        searchKeyboardType: TextInputType.text,
        dropDownList: apiController.ports.value.portPoints!
            .map((PortPoint val) {
          return DropDownValueModel(
              name: val.gateName ?? '',
              value: val.id.toString());
        }).toList(),
        onChanged: (val) {
          apiController.port.value = val.value ?? '';
          apiController.sale.value.gateNumber = apiController.port.value;
          apiController.sale.value.gateName = val.name;
        },
      ),
    );
  }

  Widget _buildBorderDropdown() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 12),
      child: DropDownTextField(
        clearOption: false,
        validator: (value) {
          if (value == '') return "Please select a border";
          return null;
        },
        dropDownIconProperty: IconProperty(
            icon: Icons.keyboard_arrow_down_outlined),
        textFieldFocusNode: textFieldFocusNode,
        searchFocusNode: searchFocusNode,
        textFieldDecoration: InputDecoration(
          label: Text('To Border', style: font15black),
          contentPadding: EdgeInsets.all(12),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: textgrey),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        dropDownItemCount: 8,
        searchShowCursor: false,
        enableSearch: true,
        searchKeyboardType: TextInputType.text,
        dropDownList: apiController.borders.value.borders!
            .map((BorderElement? val) {
          return DropDownValueModel(
              name: val?.title ?? '',
              value: val?.id.toString());
        }).toList(),
        onChanged: (val) {
          apiController.border.value = val.value ?? '';
          apiController.sale.value.borderId = apiController.border.value;
          apiController.sale.value.borderName = val.name;
        },
      ),
    );
  }

  Widget _buildStepNavigationButtons({
    bool showBack = false,
    VoidCallback? onBack,
    VoidCallback? onNext,
    VoidCallback? onSubmit,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 22, right: 7, top: 30),
            child: showBack ? buttonfaint1('BACK', onBack ?? () {}) : Container(),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 7, right: 22, top: 30),
            child: onSubmit != null
                ? button1('SUBMIT', onSubmit)
                : button1('NEXT', onNext ?? () {}),
          ),
        ),
      ],
    );
  }

  // String cleanSerial(String? serial) {
  //   if (serial == null) return '';
  //   return serial.replaceAll(RegExp(r'^SN:'), '');
  // }
  String cleanSerial(String? serial) {
    if (serial == null) return '';
    return serial.replaceAll(RegExp(r'^(SN:|S:)'), '');
  }


  Future<void> _handleFormSubmission(bool datastus, DatabaseHelper dbHelper) async {
    final tripData = generateTripJson();
    print("Trip Data: ${jsonEncode(tripData)}");

    // Prepare SaleAdd for offline storage / printing
    apiController.saleprint.value = SaleAdd(
      saleDate: startdate.text,
      startDateTime: startdate.text,
      endDate: enddate.text,
      vehicleNumber: apiController.vehicleno.value,
      chasisNumber: apiController.chasis.value,
      tzl: apiController.tzdl.value,
      driverName: driverNameController.text,
      borderId: apiController.border.value,
      tripStatus: '1',
      driverNumber: apiController.drivernumber.value,
      serialNo: cleanSerial(widget.paymentData?['devices']?['master']?['serial_no']),      amount: widget.paymentData?['amount']?.toString() ?? '',
      currency: widget.paymentData?['currency']?.toString() ?? 'TZS',
      gateNumber: apiController.port.value,
      salesPerson: apiController.userdata.value.userId?.toString() ?? '',
      passport: apiController.pasport.value,
      containerNumber: apiController.containerno.value,
      vehicleTypeId: apiController.vtype.value == 'IT'
          ? '1'
          : apiController.vtype.value == 'Dry Cargo'
          ? '2'
          : '3',
      customerTypeId: widget.paymentData?['customer']?['customerTypeId']?.toString() ?? '',
      companyName: widget.paymentData?['customer']?['customerName'] ?? '',
      customerId: widget.paymentData?['customer']?['customerId']?.toString() ?? '',
      agent: apiController.agent.value,
      saleType: 'Cash',
      borderName: apiController.sale.value.borderName ?? '',
      gateName: apiController.sale.value.gateName ?? '',
      tagger: apiController.userdata.value.name ?? '',
      saleId: '',
      prev_offline_receipt_number: '',
      offline_receipt_number: "",
      slaves: apiController.slavedata.map((serial) => Slave(serialNo: cleanSerial(serial))).toList(),    );

    // Generate offline receipt number
    var t1 = apiController.tzdl.value.substring(apiController.tzdl.value.length - 3);
    var t2 = 'RCOFF' + t1 + startdate.text;
    var t3 = t2.replaceAll(' ', '').replaceAll('-', '').replaceAll(':', '');
    apiController.saleprint.value.offline_receipt_number = t3;

    String message = '';
    String details = '';
    bool isSuccess = false;

    // Helper function to safely parse response
    Map<String, dynamic> parseResponse(dynamic response) {
      if (response == null) return {"message": "No response from server"};
      if (response is Map) return Map<String, dynamic>.from(response);
      if (response is String && response.isNotEmpty) {
        try {
          final decoded = jsonDecode(response);
          if (decoded is Map) return Map<String, dynamic>.from(decoded);
          return {"message": decoded.toString()};
        } catch (e) {
          return {"message": "Failed to parse response: $e", "raw_response": response};
        }
      }
      return {"message": response.toString()};
    }

    if (datastus) {
      // ---------- ONLINE MODE ----------
      try {
        final response = await RemoteServices.createTespaTrip(tripData);
        print("Create Trip API Response: $response");
        print("Response type: ${response.runtimeType}");

        final data = parseResponse(response);

        if (data.containsKey('receipt')) {
          isSuccess = true;
          message = 'Trip Created Successfully';

          final receipt = data['receipt'];
          final prefs = await SharedPreferences.getInstance();
          final userId = prefs.getInt("userId")?.toString() ?? '';
          print("data going to local storage is : ${apiController.saleprint.value}");

          // Save & print
          await dbHelper.insertSale(apiController.saleprint.value);
          // Save trip to local storage
          // final trip = Trip.fromApiResponse(receipt, userId);
          // await TripStorage.saveTrip(trip);
          // print("Trip saved to TripStorage: ${trip.tripNo}");

          // Print receipt
          try {
            receiptPrint(apiController.saleprint.value.tooMap());
          } catch (printError) {
            print("Printing failed: $printError");
          }
        } else {
          // Handle error response
          message = data['message'] ?? data['error'] ?? 'Failed to create trip';
          details = data['details']?.toString() ?? data['error_details']?.toString() ?? '';
        }
      } catch (e) {
        message = 'Error processing response';
        details = e.toString();
        print('Error details: $e');
      }

      // Show result dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSuccess ? Icons.check_circle : Icons.error,
                  size: 60,
                  color: isSuccess ? primarycolor : Colors.red,
                ),
                const SizedBox(height: 20),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isSuccess ? primarycolor : Colors.red,
                  ),
                ),
                if (!isSuccess && details.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    details,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (isSuccess) {
                      _resetForm();

                      // Get.offAll(() => TripListScreen());
                       Get.offAll(() => SalesScreen());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSuccess ? primarycolor : Colors.red,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("OK", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        },
      );
    } else {
      // ---------- OFFLINE MODE ----------
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt("userId")?.toString() ?? '';

      final trip = Trip(
        tripNo: apiController.tzdl.value,
        vehicleNo: apiController.vehicleno.value,
        trailerNo: apiController.sale.value.trailerno,
        containerNo: apiController.containerno.value,
        customerName: widget.paymentData?['customer']?['customerName']?.toString() ?? '',
        startDate: startdate.text,
        endDate: enddate.text,
        status: "Created",
        merchantNo: paymentRef,
        receiptNo: apiController.saleprint.value.offline_receipt_number ?? 'OFFLINE-${DateTime.now().millisecondsSinceEpoch}',
        agentName: apiController.agent.value,
        agentPhoneNo: agentPhoneController.text,
        driverName: driverNameController.text,

        driverMobile: apiController.drivernumber.value,
        driverLicense: driverLicenseController.text,
        driverPassport: apiController.pasport.value,
        cargoType: apiController.vtype.value,

        cargoNo: cargoNoController.text,
        gateName: apiController.sale.value.gateName ?? '',
        borderName: apiController.sale.value.borderName ?? '',
        master: cleanSerial(widget.paymentData?['devices']?['master']?['serial_no']),
        slaves: apiController.slavedata.map((e) => cleanSerial(e.toString())).toList(),
        userId: userId,
      );

      // await TripStorage.saveTrip(trip);
      // print("Offline trip saved to TripStorage: ${trip.tripNo}");


      _resetForm();

      openSuccessButtom('Saved Successfully', () {
        Get.back();
        Get.to(() => SalesScreen());
      });
    }
  }





// Add this helper method to reset the form
  void _resetForm() {
    apiController.step1.value = true;
    apiController.step2.value = false;
    apiController.step3.value = false;
    apiController.vtype.value = '';

    // Clear form fields
    agentPhoneController.clear();
    driverLicenseController.clear();
    driverNameController.clear();
    cargoNoController.clear();
    apiController.vehicleno.value = '';
    apiController.containerno.value = '';
    apiController.agent.value = '';
    apiController.chasis.value = '';
    apiController.pasport.value = '';
    apiController.drivernumber.value = '';
    apiController.tzdl.value = '';
    apiController.port.value = '';
    apiController.border.value = '';
  }



  // Paste Sale Form
  Widget _buildPasteSaleForm() {
    return SizedBox(
      height: 560,
      child: Form(
        key: formKeysale,
        child: Obx(
              () => Column(
            children: [
              if (apiController.step1.value)
                SizedBox(
                  height: 560,
                  child: Scrollbar(
                    controller: scroll,
                    thumbVisibility: true,
                    child: ListView(
                        controller: scroll,
                        padding: EdgeInsets.zero,
                        children: [
                          // ... (keep original paste sale form implementation)
                        ]
                    ),
                  ),
                ),
              if (apiController.step2.value)
                SizedBox(
                  height: 560,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // ... (keep original paste sale form implementation)
                      ],
                    ),
                  ),
                ),
              if (apiController.step3.value)
                SizedBox(
                  height: 560,
                  child: Column(
                    children: [
                      // ... (keep original paste sale form implementation)
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void openMenusheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: whitecolor,
      isScrollControlled: true,
      elevation: 0.1,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.60,
        minChildSize: 0.2,
        maxChildSize: 0.60,
        expand: false,
        builder: (_, controller) => Column(
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
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.close)),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(12),
                child: ListView(children: <Widget>[
                  card_menu('Paste last sale', Icons.paste_outlined, () async {
                    if (apiController.isholded.value) {
                      apiController.ispastesale.value = true;
                      setState(() {});
                      Get.back();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text("No sales available", style: font14red),
                        ),
                      );
                      Get.back();
                    }
                  }),
                  card_menu('Hold sale', Icons.lock, () async {
                    apiController.salehold.value = apiController.sale.value;
                    if (apiController.canhold.value) {
                      apiController.isholded.value = true;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text("Hold Success", style: font14green),
                        ),
                      );
                      Get.back();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text(
                            "Please fill the form first to hold data",
                            style: font14red,
                          ),
                        ),
                      );
                      Get.back();
                    }
                  }),
                  card_menu('Clear Hold sale', Icons.delete, () async {
                    apiController.isholded.value = false;
                    apiController.canhold.value = false;
                  }),
                  SizedBox(height: 50),
                ]),
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