
 import 'package:flutter/material.dart';
 import 'package:get/get.dart';


 class SnackbarService {

   static ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(
       Get.context!);

   static closeSnackbar(BuildContext context) {
     scaffoldMessenger.removeCurrentSnackBar();
     // scaffoldMessenger.hideCurrentSnackBar();

     // scaffoldMessenger.clearSnackBars();

     print("funga snackbar");
     // while (scaffoldMessenger.hideCurrentSnackBar()) {
     //   // Keep closing snack bars until there are no more
     // }

     // while (scaffoldMessenger.) {
     //   scaffoldMessenger.hideCurrentSnackBar();
     // }
   }


   static errorSnackBar(BuildContext context, message) {
     // return ScaffoldMessenger.of(context)
     // ..removeCurrentSnackBar()
     return scaffoldMessenger
         .showSnackBar(
       SnackBar(
         // duration: const Duration(days: 365),
         behavior: SnackBarBehavior.fixed,
         backgroundColor: Color(0xFFB00020),
         // showCloseIcon: true,
         // closeIconColor: Colors.white,
         content: Container(
           margin: const EdgeInsets.only(left: 10.0),
           child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Flexible(
                   child: Text(message.toString(),
                       textAlign: TextAlign.left,
                       style: const TextStyle(
                           color: Colors.white, fontSize: 12.0))),
               Container(
                 width: 30,
                 height: 30,
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.all(Radius.circular(30)),
                   // color: Color.fromRGBO(255, 255, 255, 1),
                   color: Colors.white.withOpacity(.4),
                 ),
                 alignment: Alignment.topRight,
                 child: IconButton(
                   padding: EdgeInsets.zero,
                   icon: const Icon(
                     Icons.close_sharp,
                     color: Colors.white,
                     size: 25, // Changing Drawer Icon Size
                   ),
                   onPressed: () {
                     // Navigator.pop(context, true);
                     closeSnackbar(context);

                     // ScaffoldMessenger.of(context).removeCurrentSnackBar();
                   },
                 ),
               ),
             ],
           ),
         ),
       ),
     );
   }
 }