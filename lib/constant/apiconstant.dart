
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

final formregistercom = GlobalKey<FormState>();
final formsub = GlobalKey<FormState>();
final form3 = GlobalKey<FormState>();
final formK4 = GlobalKey<FormState>();
var formattedDate = DateFormat('yyyy-MM-dd – kk:mm');

 var monthformat =  DateFormat('MMMM');

final formsend = GlobalKey<FormState>();

final formsendst = GlobalKey<FormState>();
final formaddm = GlobalKey<FormState>();

final formreset = GlobalKey<FormState>();
final formchnage = GlobalKey<FormState>();
final formcomplete = GlobalKey<FormState>();



final CurrencyTextInputFormatter formatter = CurrencyTextInputFormatter(
    locale: 'sw_TZ',
    decimalDigits: 0,

);

final CurrencyTextInputFormatter formatterempo = CurrencyTextInputFormatter(
  locale: 'sw_TZ',
  decimalDigits: 0,

);


//String BASE_URL = "https://cargotrackafrica.com/index.php?r=api-v5/";

class Apindpoint {
  Apindpoint._();

  static const String BASE_URL_Live = "https://cargotrackafrica.com/index.php?r=api-v5/";

  static const String BASE_URL_TESTING = "http://testing.cargotrackafrica.co.tz/index.php?r=api-v5/";

  static const String BASE_URL = "http://204.13.232.252:84/index.php?r=api-v5/";

  static const String COMPLAIN = BASE_URL+"post-complaint";

  static const String LOGIN = BASE_URL+"login";

  static const String SALE = BASE_URL+"sale-add";

  static const String BORDER = BASE_URL+"borders";

  static const String PORT = BASE_URL+"port-gates";

  static const String MASTER = BASE_URL+"released&user_id=";

  static const String ALLDEVICE = BASE_URL+"all-devices&user_id=";

  static const String COMPANY_STAFF = BASE_URL+"staffs&user_id=";

  static const String Transfer = BASE_URL+"transfer";


  static const String COMFRIMDEVICE = BASE_URL+"confirm-receive";

  static const String SCANREQ = BASE_URL+"scan";

  static const String DEVICEATBORDER = BASE_URL+"devices-at-border&user_id=";
  static const String DEVICERETURN = BASE_URL+"office-return";
  static const String DEVICERETURNINTRA = BASE_URL+"return-intransit";


  static const String SLAVE = BASE_URL+"child&user_id=";


  static const String BILLCUSTOMER = BASE_URL+"customers";
  static const String EDIT_SALE = BASE_URL+"edit-sale";

  static const String SEARCH_TZL = BASE_URL+"search-tzl";


  static const String RERPOT = BASE_URL+"sales-report";

  static const String DEVICERERPOT = BASE_URL+"devices-returned&user_id=";





  static const String DEVICETOCONFIRM = BASE_URL+"device-to-confirm&user_id=";

  static const String DEVICETORETURN = BASE_URL+"intransit-devices&user_id=";






  //tespa intergration
  static const String BASE_URL_TESPA_INTERG = "http://204.13.232.252:84/index.php?r=gateway/get-records";




  static const String TESPA_SEARCH = "http://testing.cargotrackafrica.co.tz/index.php";





}

