


// import 'package:bs_flutter_alert/bs_flutter_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';

import '../constant/colorcontant.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/controllerconstant.dart';



ScaffoldFeatureController<SnackBar, SnackBarClosedReason> dangerdilog(String desc){

  return  ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(
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
                child: Text(desc.toString(),
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
                  // ScaffoldMessenger.of(Get.overlayContext!).removeCurrentSnackBar();
                  // closeSnackbar(context);

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




ScaffoldFeatureController<SnackBar, SnackBarClosedReason> dangerdiloginternet(String desc){

  return  ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(
    SnackBar(
      action: SnackBarAction(onPressed: () {  }, label: '',),

      content: SizedBox(
        height: 99,
        child: Container(
          color: Colors.redAccent.withOpacity(0.2),
          margin: EdgeInsets.only(bottom: 0.0),
          child: Text(desc,textAlign: TextAlign.center,),
        ),
      ),
      backgroundColor: Colors.transparent,
      padding: EdgeInsets.all(0),
    ),
  );
}



ScaffoldFeatureController<SnackBar, SnackBarClosedReason> dangerdilogd(String desc){

  return  ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(
    SnackBar(

      content: SizedBox(
        height: 92,
        child:   Container(
          color: Colors.redAccent.withOpacity(0.2),
          margin: EdgeInsets.only(bottom: 0.0),
          child: Text(desc,textAlign: TextAlign.center,),
        ),
      ),
      backgroundColor: Colors.transparent,
      padding: EdgeInsets.all(0),
    ),
  );
}



Future loadingdialog(){

  return Get.defaultDialog(
    titlePadding: EdgeInsets.only(top: 0,bottom: 0),
    contentPadding: EdgeInsets.only(left: 0,right: 0),
    title: '',
    backgroundColor: Colors.transparent,


    content: rowloading(),
  );
}



Widget rowloading(){

  return Neumorphic(
      margin: EdgeInsets.only(right: 2,left: 2,top: 10),
      style: NeumorphicStyle(
        border: const NeumorphicBorder(
          color: Colors.white,
          width: 0.8,
        ),
        depth: 3,
        intensity: 0.75,
        surfaceIntensity: 3,//customize depth here
        color: mainbg,//customize color here
      ),

      child: Container(

          height: 70,
          width: double.infinity,


          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20,right: 15),
                  child:   CircularProgressIndicator(color: greencolor1,strokeWidth: 2,),
                ),
                Container(width: 12,),

                // Spacer(),
                Container(
                  padding: const EdgeInsets.only(top: 0,left: 10,right: 0,bottom: 0),
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 0,left: 20,right: 10,bottom: 1),
                        child: Text(
                          'Please wait..',
                          style: TextStyle(color: colortxtgrey,fontSize: 12),
                          textAlign: TextAlign.start,
                        ),
                      ),

                    ],

                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.only(left: 20,right: 10),
                  alignment: Alignment.centerRight,

                ),
              ],
            ),)

      ));
}

Widget button(String title, VoidCallback ontap){

  return  Container(
    margin: EdgeInsets.only(right: 20,left: 20,top: 40),
    alignment: Alignment.centerLeft
    ,width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(7),),
      gradient: LinearGradient(
        colors: <Color>[buttoncolor, buttoncolor],
      ),),




    child:    ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7), // <-- Radius
        ), backgroundColor: Colors.transparent,

        minimumSize: const Size.fromHeight(50), // NEW
      ),
      onPressed:ontap,
      child:   Text(
        title,
        style: GoogleFonts.roboto(
          textStyle: TextStyle(color: whitecolor, letterSpacing: 1,fontWeight: FontWeight.w400,fontSize: 16,fontStyle: FontStyle.normal),
        ),


      ),
    ),
  );
}


Widget buttontt(String title, VoidCallback ontap){

  return  Container(
    margin: EdgeInsets.only(right: 20,left: 20,top: 20),
    alignment: Alignment.centerLeft
    ,width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(7),),
      gradient: LinearGradient(
        colors: <Color>[buttoncolor, buttoncolor],
      ),),




    child:    ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7), // <-- Radius
        ), backgroundColor: Colors.transparent,

        minimumSize: const Size.fromHeight(50), // NEW
      ),
      onPressed:ontap,
      child:   Text(
        title,
        style: GoogleFonts.roboto(
          textStyle: TextStyle(color: whitecolor, letterSpacing: 1,fontWeight: FontWeight.w400,fontSize: 16,fontStyle: FontStyle.normal),
        ),


      ),
    ),
  );
}

Widget buttonwithicon(String title, VoidCallback ontap){

  return  Container(
    margin: EdgeInsets.only(right: 20,left: 20,top: 40),
    alignment: Alignment.centerLeft
    ,width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(7),),
      gradient: LinearGradient(
        colors: <Color>[buttoncolor, buttoncolor],
      ),),




    child:    ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7), // <-- Radius
        ), backgroundColor: Colors.transparent,

        minimumSize: const Size.fromHeight(50), // NEW
      ),
      onPressed:ontap,
      child:   Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search,size: 27,color: whitecolor,),
          SizedBox(width: 8,),
          Text(
            title,
            style: GoogleFonts.roboto(
              textStyle: TextStyle(color: whitecolor, letterSpacing: 1,fontWeight: FontWeight.w400,fontSize: 16,fontStyle: FontStyle.normal),
            ),
          
          
          ),
        ],
      ),
    ),
  );
}


Widget buttonfaint(String title, VoidCallback ontap){

  return  Container(
    margin: EdgeInsets.only(right: 20,left: 20,top: 40),
    alignment: Alignment.centerLeft
    ,width: double.infinity,
    decoration: BoxDecoration(

      borderRadius: BorderRadius.all(Radius.circular(7),),
      color: faintcolor
    ),




    child:    ElevatedButton(

      style: ElevatedButton.styleFrom(
        elevation: 1, backgroundColor: Colors.transparent,
        shadowColor: Colors.white.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7), // <-- Radius
        ),

        minimumSize: const Size.fromHeight(50), // NEW
      ),
      onPressed:ontap,
      child:   Text(
        title,
        style: GoogleFonts.roboto(
          textStyle: TextStyle(color: colorstextfont, letterSpacing: 1,fontWeight: FontWeight.w400,fontSize: 16,fontStyle: FontStyle.normal),
        ),


      ),
    ),
  );
}


Widget formfield(String hint, Function(String value) onchange){
  return Container(
      alignment: Alignment.centerLeft
      ,

      padding: const EdgeInsets.only(top: 35,left: 20,right: 20),

      child: Container(

        height: 60,
        child: TextFormField(
          onChanged: onchange,
          validator: requiredValidator,

          keyboardType: TextInputType.emailAddress,


          expands: false,
          style: TextStyle(fontSize: 20.0, color: Colors.black54),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(12),
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Icon(
              Icons.person_outline_rounded,
              color: colortxtgrey,
            ),
            label: Text(hint),
            hintStyle: TextStyle(color: colortxtgrey,fontSize: 12),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primarycolor),
              borderRadius: BorderRadius.circular(8.0),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      )


  );
}


Widget formfieldf(String hint, Function(String value) onchange){
  return Container(
      alignment: Alignment.centerLeft
      ,

      padding: const EdgeInsets.only(top: 35,left: 20,right: 20),

      child: Container(

        height: 60,
        child: TextFormField(
          onChanged: onchange,
          validator: requiredValidator.call,

          keyboardType: TextInputType.emailAddress,


          expands: false,
          style: TextStyle(fontSize: 20.0, color: Colors.black54),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(12),
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Icon(
              Icons.person_outline_rounded,
              color: colortxtgrey,
            ),
            label: Text(hint),
            hintStyle: TextStyle(color: colortxtgrey,fontSize: 12),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primarycolor),
              borderRadius: BorderRadius.circular(8.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      )


  );
}

Widget card_public(String title,desc,image,VoidCallback ontap){

  return  Container(

    // decoration: BoxDecoration(
    //   color: Colors.white.withOpacity(0.5),
    //   // border: Border.all(color: primarycolor,),
    //       borderRadius: BorderRadius.all(Radius.circular(12))
    // ),
    margin: EdgeInsets.only(right: 2.5,left: 2.5),

    child: PhysicalModel(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(5)),

      child: InkWell(
        onTap:ontap,
        child: Container(
          height: 170,
          child: Stack(
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                // width: 84,
                // height:81,
                margin: EdgeInsets.only(top: 24,left: 52,right: 52,bottom: 65),
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: textgrey.withOpacity(0.1)
                      
                ),
                alignment: Alignment.center,
                child: Image.asset(image,width: 32,height: 29,),
              ),
              Positioned(
                bottom: 22,
                // top: 8,
                left: 54,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.only(top: 7,left: 10,right: 10,bottom: 1),
                      child: Text(
                        title,
                        style:   GoogleFonts.inter(
                          textStyle: TextStyle(color: colorstextfont,fontWeight: FontWeight.w600,fontSize: 16,fontStyle: FontStyle.normal),
                        ),


                        // TextStyle(color: primarycolor,fontSize: 16,fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    Container(
                      alignment: Alignment.center,
                      // padding: const EdgeInsets.only(top: 7,left: 15,right: 15,bottom: 0),
                      child: Text(
                        desc,
                        style:
                        GoogleFonts.roboto(
                          textStyle: TextStyle(color: colorsfontgrey,fontWeight: FontWeight.w400,fontSize: 10,fontStyle: FontStyle.normal),
                        ),

                        // TextStyle(color: textgrey,fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),


            ],
          ),
        ),
      ),
    ),);
}


Widget card_allsale(String sn,date,String title,String amount,VoidCallback ontap){

  return  Container(
    height: 88,


    margin: EdgeInsets.only(right: 21,left: 21,top: 8),

    child: PhysicalModel(
      color: Colors.white,
      elevation: 1,
      shadowColor: Colors.white.withOpacity(.2),
      borderRadius: BorderRadius.all(Radius.circular(8)),

      child: InkWell(
        onTap:ontap,
        child: SizedBox(
          // color: Colors.blueGrey,
          height: 88,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.only(top: 7,left: 10,right: 10,bottom: 1),
                      child: Text(
                        sn,
                        style:   GoogleFonts.roboto(
                          textStyle: TextStyle(color: colorstextfont,fontWeight: FontWeight.w400,fontSize: 14,fontStyle: FontStyle.normal),
                        ),


                        // TextStyle(color: primarycolor,fontSize: 16,fontWeight: FontWeight.w500),
                        textAlign: TextAlign.start,
                      )
                    ),

                    Container(
                      alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.only(top: 7,left: 10,right: 10,bottom: 1),
                      // padding: const EdgeInsets.only(top: 7,left: 15,right: 15,bottom: 0),
                      child: Text(
                        date,
                        style:
                        GoogleFonts.roboto(
                          textStyle: TextStyle(color: colorsfontgrey,fontWeight: FontWeight.w400,fontSize: 14,fontStyle: FontStyle.normal,),
                        ),

                        // TextStyle(color: textgrey,fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Container(

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.only(top: 7,left: 10,right: 10,bottom: 1),
                      child: Card(


                        shadowColor: Colors.white.withOpacity(0.3),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 5),
                          child: SizedBox(
                            width: 84,
                            child: Text(
                              title,
                              style:   GoogleFonts.roboto(
                                textStyle: TextStyle(color: greencolor1,fontWeight: FontWeight.w400,fontSize: 14,fontStyle: FontStyle.normal),
                              ),


                              // TextStyle(color: primarycolor,fontSize: 16,fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),

                    Container(
                      alignment: Alignment.center,
                      // padding: const EdgeInsets.only(top: 7,left: 10,right: 10,bottom: 1),
                      // padding: const EdgeInsets.only(top: 7,left: 15,right: 15,bottom: 0),
                      child: Text(
                        amount,
                        style:
                        GoogleFonts.roboto(
                          textStyle: TextStyle(color: colorsfontgrey,fontWeight: FontWeight.w400,fontSize: 16,fontStyle: FontStyle.normal),
                        ),

                        // TextStyle(color: textgrey,fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),


            ],
          ),
        ),
      ),
    ),);
}


Widget card_allsaleto(
    String sn,
    String date,
    String title,
    String amount,
    VoidCallback ontap,
    VoidCallback ontapto,
    String? prev) {
  return Container(
    height:80,
    margin: const EdgeInsets.only(right: 2, left: 1, top: 12),
    child: PhysicalModel(
      color: Colors.white,
      elevation: 1,
      shadowColor: Colors.white.withOpacity(.2),
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: InkWell(
        onTap: ontap,
        child: SizedBox(
          height: 88,
          width: double.infinity, // flexible instead of fixed 300
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// LEFT SIDE
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 1),
                      child: Text(
                        prev != "" ? 'edited' : 'original',
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            color: greencolor1.withOpacity(0.5),
                            fontWeight: FontWeight.w400,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    sn != ""
                        ? Padding(
                      padding:
                      const EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        sn,
                        overflow: TextOverflow.ellipsis, // prevent overflow
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            color: colorstextfont,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    )
                        : InkWell(
                      onTap: ontapto,
                      child: Row(
                        children: [
                          Text(
                            'Offline',
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                color: Colors.redAccent.withOpacity(0.6),
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(
                            Icons.refresh_outlined,
                            size: 15,
                            color: greencolor1,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 7, left: 10, right: 10, bottom: 1),
                      child: Text(
                        date,
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            color: colorsfontgrey,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),

              /// RIGHT SIDE
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Card(
                        shadowColor: Colors.white.withOpacity(0.3),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          child: SizedBox(
                            width: 40,
                            child: Text(
                              title,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                  color: greencolor1,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.more_vert_rounded,
                        color: greencolor1,
                        size: 18,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    amount,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        color: colorsfontgrey,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}



Widget card_device(String sn,String title,VoidCallback ontap){

  return  Container(
    // height: 60,


    margin: EdgeInsets.only(right: 21,left: 21,top:12 ),

    child: PhysicalModel(
      color: Colors.white,
      elevation: 1,
      shadowColor: Colors.white.withOpacity(.3),
      borderRadius: BorderRadius.all(Radius.circular(18)),

      child: InkWell(
        onTap:ontap,
        child: SizedBox(
          // color: Colors.blueGrey,
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(top: 7,left: 10,right: 10,bottom: 1),
                // padding: const EdgeInsets.only(top: 7,left: 15,right: 15,bottom: 0),
                child: Text(
                  sn,
                  style:
                  GoogleFonts.roboto(
                    textStyle: TextStyle(color: colorsfontgrey,fontWeight: FontWeight.w400,fontSize: 14,fontStyle: FontStyle.normal,),
                  ),

                  // TextStyle(color: textgrey,fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(top: 7,left: 10,right: 10,bottom: 1),
                child: Card(


                  shadowColor: Colors.white.withOpacity(0.3),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 5),
                    child: SizedBox(
                      width: 84,
                      child: Text(
                        title,
                        style:   GoogleFonts.roboto(
                          textStyle: TextStyle(color: greencolor1,fontWeight: FontWeight.w400,fontSize: 14,fontStyle: FontStyle.normal),
                        ),


                        // TextStyle(color: primarycolor,fontSize: 16,fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    ),);
}

Widget card_devicerep(String sn,String titledd){

  return  Container(
    // height: 60,


    margin: EdgeInsets.only(right: 21,left: 21,top:12 ),

    child: PhysicalModel(
      color: Colors.white,
      elevation: 1,
      shadowColor: Colors.white.withOpacity(.3),
      borderRadius: BorderRadius.all(Radius.circular(18)),

      child: SizedBox(
          // color: Colors.blueGrey,
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(top: 7,left: 10,right: 10,bottom: 1),
                // padding: const EdgeInsets.only(top: 7,left: 15,right: 15,bottom: 0),
                child: Text(
                  sn,
                  style:
                  GoogleFonts.roboto(
                    textStyle: TextStyle(color: colorsfontgrey,fontWeight: FontWeight.w400,fontSize: 14,fontStyle: FontStyle.normal,),
                  ),

                  // TextStyle(color: textgrey,fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(top: 7,left: 10,right: 10,bottom: 1),

              ),

            ],
          ),

      ),
    ),);
}
Widget card_deviceall(String sn,String title,VoidCallback ontap){

  return  Container(
    // height: 60,


    margin: EdgeInsets.only(right: 21,left: 21,top:12 ),

    child: PhysicalModel(
      color: Colors.white,
      elevation: 1,
      shadowColor: Colors.white.withOpacity(.3),
      borderRadius: BorderRadius.all(Radius.circular(18)),

      child: InkWell(
        onTap:ontap,
        child: SizedBox(
          // color: Colors.blueGrey,
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(top: 7,left: 10,right: 10,bottom: 1),
                // padding: const EdgeInsets.only(top: 7,left: 15,right: 15,bottom: 0),
                child: Text(
                  sn,
                  style:
                  GoogleFonts.roboto(
                    textStyle: TextStyle(color: colorsfontgrey,fontWeight: FontWeight.w400,fontSize: 14,fontStyle: FontStyle.normal,),
                  ),

                  // TextStyle(color: textgrey,fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(top: 7,left: 10,right: 10,bottom: 1),

              ),

            ],
          ),
        ),
      ),
    ),);
}


Widget card_radio(String sn, Function(dynamic val) onchange,groupvalue,value){

  return  Container(
    // height: 60,


    margin: EdgeInsets.only(right: 21,left: 21,top:12 ),

    child: PhysicalModel(
      color: Colors.white,
      elevation: 1,
      shadowColor: Colors.black.withOpacity(.5),
      borderRadius: BorderRadius.all(Radius.circular(18)),


        child: SizedBox(
          // color: Colors.blueGrey,
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(top: 7,left: 25,right: 10,bottom: 1),
                // padding: const EdgeInsets.only(top: 7,left: 15,right: 15,bottom: 0),
                child: Text(
                  sn,
                  style:
                  GoogleFonts.roboto(
                    textStyle: TextStyle(color: colorsfontgrey,fontWeight: FontWeight.w400,fontSize: 14,fontStyle: FontStyle.normal,),
                  ),

                  // TextStyle(color: textgrey,fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(top: 7,left: 10,right: 10,bottom: 1),
                child:   Container(
                    padding: EdgeInsets.only(left: 2,right: 10),
                    alignment: Alignment.centerRight,
                    child: Radio(
                      activeColor: greencolor1,
                      value: value,
                      groupValue: groupvalue,
                      onChanged: onchange,
                    )
                ),
              ),

            ],
          ),
        ),

    ),);
}
Widget card_checkbox(String sn, Function(bool? val) onchange,value){

  return  Container(
    // height: 60,


    margin: EdgeInsets.only(right: 21,left: 21,top:12 ),

    child:PhysicalModel(
      color: Colors.white,
      elevation: 1,
      shadowColor: Colors.white.withOpacity(.3),
      borderRadius: BorderRadius.all(Radius.circular(18)),


      child: SizedBox(
        // color: Colors.blueGrey,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(top: 7,left: 25,right: 10,bottom: 1),
              // padding: const EdgeInsets.only(top: 7,left: 15,right: 15,bottom: 0),
              child: Text(
                sn,
                style:
                GoogleFonts.roboto(
                  textStyle: TextStyle(color: colorsfontgrey,fontWeight: FontWeight.w400,fontSize: 14,fontStyle: FontStyle.normal,),
                ),

                // TextStyle(color: textgrey,fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(top: 7,left: 10,right: 10,bottom: 1),
              child:   Container(
                  padding: EdgeInsets.only(left: 2,right: 10),
                  alignment: Alignment.centerRight,
                  child: Checkbox(
                    activeColor: greencolor1,
                    value: value,
                    onChanged: onchange,
                  )
              ),
            ),

          ],
        ),
      ),

    ),);
}



Widget card_menu(String title, IconData icon,VoidCallback ontap){

  return  InkWell(
    onTap: ontap,
    child: Container(
      // height: 60,


      margin: EdgeInsets.only(right: 21,left: 21,top:12 ),

      child: PhysicalModel(
        color: Colors.white,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(.5),
        borderRadius: BorderRadius.all(Radius.circular(18)),


        child: SizedBox(
          // color: Colors.blueGrey,
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(top: 7,left: 25,right: 10,bottom: 1),
                // padding: const EdgeInsets.only(top: 7,left: 15,right: 15,bottom: 0),
                child: Text(
                  title,
                  style:
                  GoogleFonts.roboto(
                    textStyle: TextStyle(color: colorsfontgrey,fontWeight: FontWeight.w400,fontSize: 14,fontStyle: FontStyle.normal,),
                  ),

                  // TextStyle(color: textgrey,fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(top: 7,left: 10,right: 10,bottom: 1),
                child:   Container(
                    padding: EdgeInsets.only(left: 2,right: 10),
                    alignment: Alignment.centerRight,
                    child: Icon(
                      icon,color: colorsfontgrey,
                      size: 20,

                    )
                ),
              ),

            ],
          ),
        ),

      ),),
  );
}


Widget card_report(String title,String value){

  return  Container(



    margin: EdgeInsets.only(right: 21,left: 21,top: 12),

    child: SizedBox(
      // color: Colors.blueGrey,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 7),
            child: Text(
              title,
              style:   GoogleFonts.roboto(
                textStyle: TextStyle(color: colorstextfont,fontWeight: FontWeight.w400,fontSize: 14,fontStyle: FontStyle.normal),
              ),


              // TextStyle(color: primarycolor,fontSize: 16,fontWeight: FontWeight.w500),
              textAlign: TextAlign.start,
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(right: 7),
            // padding: const EdgeInsets.only(top: 7,left: 15,right: 15,bottom: 0),
            child: Text(
              value,
              style:
              GoogleFonts.roboto(
                textStyle: TextStyle(color: colorsfontgrey,fontWeight: FontWeight.w700,fontSize: 14,fontStyle: FontStyle.normal),
              ),

              // TextStyle(color: textgrey,fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),


        ],
      ),
    )
  );
}


Widget title(String title){
  return       Container(
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.only(left: 7,top: 9),
    child: Text(
      title,
      style:   GoogleFonts.roboto(
        textStyle: TextStyle(color: colorstextfont,fontWeight: FontWeight.w400,fontSize: 14,fontStyle: FontStyle.normal),
      ),


      // TextStyle(color: primarycolor,fontSize: 16,fontWeight: FontWeight.w500),
      textAlign: TextAlign.start,
    ),
  );
}

Widget titlevalue(String value){
  return          Container(
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.only(right: 7,top: 9),
    // padding: const EdgeInsets.only(top: 7,left: 15,right: 15,bottom: 0),
    child: Text(
      value,
      style:
      GoogleFonts.roboto(
        textStyle: TextStyle(color: colorsfontgrey,fontWeight: FontWeight.w500,fontSize: 12,fontStyle: FontStyle.normal),
      ),

      // TextStyle(color: textgrey,fontSize: 12),
      textAlign: TextAlign.start,
    ),
  );
}