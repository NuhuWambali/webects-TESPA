import 'package:ects/authentication/loginscreen.dart';
import 'package:ects/constant/colorcontant.dart';
import 'package:ects/controller/controllerconstant.dart';
import 'package:ects/officeruser/homeoffice.dart';
import 'package:ects/widget/internetclass.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomePage.dart';
import 'borderuser/homeborder.dart';
import 'controller/apicalcontroller.dart';

void main() async {

    WidgetsFlutterBinding.ensureInitialized();
    Get.put(ApiController());
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool('isLoggedIn') ?? false;
    apiController.isLogin.value= status;


    if (apiController.isLogin.value) {
     apiController.loadlocal();

    }

    // InternetConnectionMonitor().initialize();

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Web ECTS',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: primarycolor),
        useMaterial3: true,
      ),
      home: apiController.isLogin.value?
      apiController.userdata.value.role=="BorderUser"?
      const HomePageborder():apiController.userdata.value.role=='Tagger'?
      const  HomePage():const HomePageOffice():Loginform(),
    );
  }

}

