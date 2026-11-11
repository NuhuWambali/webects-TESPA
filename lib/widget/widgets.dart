import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ects/generated/assets.dart';
import 'package:ects/screens/sales/salesscreen.dart';
import 'package:ects/widget/widgetconstant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constant/colorcontant.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dotted_line/dotted_line.dart';

import '../controller/controllerconstant.dart';

Widget dropdown(String hint,List<String> items, Function(String? value) onchange){
  return Container(
    margin: EdgeInsets.only(left: 20,right: 20,top: 12),
    child: DropdownButtonFormField(

      icon:  Icon(Icons.keyboard_arrow_down_outlined),

      decoration: InputDecoration(
        label: Text(hint,style: font15black,),
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
      // value: _selectedValue,
      // hint: Text(
      //   'choose one',
      // ),



      isExpanded: true,
      onChanged:onchange,
      validator: (String ?value) {
        if (value=='') {
          return "can't be empty please choose one";
        }
        else if (value==null) {
          return "can't be empty please choose one";
        } else {
          return null;
        }
      },

      items: items
          .map((String val) {
        return DropdownMenuItem(
          value: val,
          child: Text(
            val,
            style: font14black,
          ),
        );
      }).toList(),
    ),
  );
}

Widget dropdownedit(String hint,List<String> items, Function(String? value) onchange,String initialvalue){
  return Container(
    margin: EdgeInsets.only(left: 20,right: 20,top: 12),
    child: DropdownButtonFormField(

      icon:  Icon(Icons.keyboard_arrow_down_outlined),
      value: initialvalue,

      decoration: InputDecoration(
        label: Text(hint,style: font15black,),
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
      // value: _selectedValue,
      // hint: Text(
      //   'choose one',
      // ),



      isExpanded: true,
      onChanged:onchange,
      validator: (String ?value) {
        if (value=='') {
          return "can't be empty please choose one";
        }
        else if (value==null) {
          return "can't be empty please choose one";
        } else {
          return null;
        }
      },

      items: items
          .map((String val) {
        return DropdownMenuItem(
          value: val,
          child: Text(
            val,
            style: font14black,
          ),
        );
      }).toList(),
    ),
  );
}


Widget dropdownobject(String hint, items, Function(String? value) onchange){
  return Container(
    margin: EdgeInsets.only(left: 20,right: 20,top: 12),
    child: DropdownButtonFormField(

      icon:  Icon(Icons.keyboard_arrow_down_outlined),

      decoration: InputDecoration(
        label: Text(hint,style: font15black,),
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
      // value: _selectedValue,
      // hint: Text(
      //   'choose one',
      // ),



      isExpanded: true,
      onChanged:onchange,
      validator: (String? value) {
        if (value!.isEmpty) {
          return "can't empty please choose one";
        } else {
          return null;
        }
      },
      items: items
          .map((String val) {
        return DropdownMenuItem(
          value: val,
          child: Text(
            val,
            style: font14black,
          ),
        );
      }).toList(),
    ),
  );
}


Widget dropdownomult(String hint, items, Function(String? value) onchange){
  return Container(
    margin: EdgeInsets.only(left: 20,right: 20,top: 12),
    child: DropdownButtonFormField(

      icon:  Icon(Icons.keyboard_arrow_down_outlined),

      decoration: InputDecoration(
        label: Text(hint,style: font15black,),
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
      // value: _selectedValue,
      // hint: Text(
      //   'choose one',
      // ),



      isExpanded: true,
      onChanged:onchange,
      validator: (String? value) {
        if (value!.isEmpty) {
          return "can't empty please choose one";
        } else {
          return null;
        }
      },
      items: items
          .map((String val) {
        return DropdownMenuItem(
          value: val,
          child: Text(
            val,
            style: font14black,
          ),
        );
      }).toList(),
    ),
  );
}


String? validateMobile(String value) {
  String patttern = r'(^(?:[+0]9)?[0-9]{10,10}$)';
  RegExp regExp = new RegExp(patttern);
  if (value.length == 0) {
    return 'Please enter mobile number';
  }
  else if (!regExp.hasMatch(value)) {
    return 'Please enter valid mobile number';
  }
  return null;
}
Widget formfielunderline(String hint, Function(String? value) onchange){
  return Container(
    margin: EdgeInsets.only(left: 20,right: 20,top: 12),
    child: TextFormField(



      decoration: InputDecoration(
        label: Text(hint,style: font15black,),
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
      // value: _selectedValue,
      // hint: Text(
      //   'choose one',
      // ),

     style: font14black,

      onChanged:onchange,
      validator: (String? value) {
        if (value=='') {
          return "This field is mandatory";
        } else if (value==null) {
          return "This field is mandatory";
        }  {
          return null;
        }
      },

    ),
  );
}


Widget formfielunderlinephone(String hint, Function(String? value) onchange){
  return Container(
    margin: EdgeInsets.only(left: 20,right: 20,top: 12),
    child: TextFormField(



      decoration: InputDecoration(
        label: Text(hint,style: font15black,),
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
      // value: _selectedValue,
      // hint: Text(
      //   'choose one',
      // ),

      style: font14black,

      onChanged:onchange,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      validator: (value) => validateMobile(value!),

      keyboardType: TextInputType.phone,
      // validator: (String? value) {
      //   if (value=='') {
      //     return "This field is mandatory";
      //   } else if (value==null) {
      //     return "This field is mandatory";
      //   }  {
      //     return null;
      //   }
      // },

    ),
  );
}

Widget formfielunderlineamount(String hint, Function(String? value) onchange){
  return Container(
    margin: EdgeInsets.only(left: 20,right: 20,top: 12),
    child: TextFormField(




      decoration: InputDecoration(
        label: Text(hint,style: font15black,),
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
      // value: _selectedValue,
      // hint: Text(
      //   'choose one',
      // ),

      keyboardType: TextInputType.number,
      inputFormatters: [
        LengthLimitingTextInputFormatter(11,),
        FilteringTextInputFormatter.digitsOnly
      ],

      style: font14black,

      onChanged:onchange,
      validator: (String? value) {
        if (value=='') {
          return "This field is mandatory";
        } else if (value==null) {
          return "This field is mandatory";
        }  {
          return null;
        }
      },

    ),
  );
}



Widget formfielunderlineedit(String hint, Function(String? value) onchange,String value){
  return Container(
    margin: EdgeInsets.only(left: 20,right: 20,top: 12),
    child: TextFormField(

      initialValue: value,



      decoration: InputDecoration(
        label: Text(hint,style: font15black,),
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
      // value: _selectedValue,
      // hint: Text(
      //   'choose one',
      // ),

      style: font14black,

      onChanged:onchange,
      validator: (String? value) {
        if (value=='') {
          return "This field is mandatory";
        } else if (value==null) {
          return "This field is mandatory";
        }  {
          return null;
        }
      },

    ),
  );
}


Widget formfielunderlineeditamount(String hint, Function(String? value) onchange,String value){
  return Container(
    margin: EdgeInsets.only(left: 20,right: 20,top: 12),
    child: TextFormField(

      initialValue: value,

      keyboardType: TextInputType.number,
      inputFormatters: [
        LengthLimitingTextInputFormatter(11,),
        FilteringTextInputFormatter.digitsOnly
      ],



      decoration: InputDecoration(
        label: Text(hint,style: font15black,),
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
      // value: _selectedValue,
      // hint: Text(
      //   'choose one',
      // ),

      style: font14black,

      onChanged:onchange,
      validator: (String? value) {
        if (value=='') {
          return "This field is mandatory";
        } else if (value==null) {
          return "This field is mandatory";
        }  {
          return null;
        }
      },

    ),
  );
}

Widget formfielunderlinetzdl(String hint, Function(String? value) onchange){
  return Container(
    margin: EdgeInsets.only(left: 20,right: 20,top: 12),
    child: TextFormField(


      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        label: Text(hint,style: font15black,),
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
      // value: _selectedValue,
      // hint: Text(
      //   'choose one',
      // ),


      style: font14black,
        inputFormatters: [
           LengthLimitingTextInputFormatter(11,),
          FilteringTextInputFormatter.digitsOnly
        ],
      autovalidateMode: AutovalidateMode.always,

      onChanged:onchange,

      validator: (String? value)  {



        if (value=='') {
          return "This field is mandatory";
        } else if (value==null) {
          return "This field is mandatory";
        }
        else if (value.length<11) {
          return "TZDL must be 11 characters";
        }
        else if (value.length>11) {
          return "TZDL must be 11 characters";
        }
        // else if (apiController.tzlesist.value) {
        //   return "TZDL Already Exist";
        // }
        else {
          return null;
        }
      },

    ),
  );
}


Widget formfielunderlinetzdln(String hint, Function(String? value) onchange){
  return Container(
    margin: EdgeInsets.only(left: 20,right: 20,top: 12),
    child: TextFormField(


      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        label: Text(hint,style: font15black,),
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
      // value: _selectedValue,
      // hint: Text(
      //   'choose one',
      // ),


      style: font14black,
      inputFormatters: [
        LengthLimitingTextInputFormatter(11,),
        FilteringTextInputFormatter.digitsOnly
      ],
      autovalidateMode: AutovalidateMode.always,

      onChanged:onchange,

      validator: (String? value)  {



        if (value=='') {
          return "This field is mandatory";
        } else if (value==null) {
          return "This field is mandatory";
        }
        else if (value.length<11) {
          return "TZDL must be 11 characters";
        }
        else if (value.length>11) {
          return "TZDL must be 11 characters";
        }
        else if (apiController.tzlesist.value) {
          return "TZDL Already Exist";
        }
        else {
          return null;
        }
      },

    ),
  );
}

Widget formfielunderlinetzdledti(String hint, Function(String? value) onchange,String value){
  return Container(
    margin: EdgeInsets.only(left: 20,right: 20,top: 12),
    child: TextFormField(


      initialValue: value,

      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        label: Text(hint,style: font15black,),
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
      // value: _selectedValue,
      // hint: Text(
      //   'choose one',
      // ),


      style: font14black,
      inputFormatters: [
        LengthLimitingTextInputFormatter(11,),
        FilteringTextInputFormatter.digitsOnly
      ],
      autovalidateMode: AutovalidateMode.always,

      onChanged:onchange,
      validator: (String? value) {

        if (value=='') {
          return "This field is mandatory";
        } else if (value==null) {
          return "This field is mandatory";
        }
        else if (value.length<11) {
          return "TZD must be 9 characters";
        }
        else if (value.length>11) {
          return "TZD must be 9 characters";
        }
        else {
          return null;
        }
      },

    ),
  );
}


Widget formfielunderlineoption(String hint, Function(String? value) onchange){
  return Container(
    margin: EdgeInsets.only(left: 20,right: 20,top: 12),
    child: TextFormField(



      decoration: InputDecoration(
        label: Text(hint,style: font15black,),
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
      // value: _selectedValue,
      // hint: Text(
      //   'choose one',
      // ),

      style: font14black,

      onChanged:onchange,
      // validator: (String? value) {
      //   if (value=='') {
      //     return "This field is mandatory";
      //   } else if (value==null) {
      //     return "This field is mandatory";
      //   }  {
      //     return null;
      //   }
      // },

    ),
  );
}


Widget formfielunderlineoptionedit(String hint, Function(String? value) onchange,String value){
  return Container(
    margin: EdgeInsets.only(left: 20,right: 20,top: 12),
    child: TextFormField(


     initialValue: value,
      decoration: InputDecoration(
        label: Text(hint,style: font15black,),
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
      // value: _selectedValue,
      // hint: Text(
      //   'choose one',
      // ),

      style: font14black,

      onChanged:onchange,
      // validator: (String? value) {
      //   if (value=='') {
      //     return "This field is mandatory";
      //   } else if (value==null) {
      //     return "This field is mandatory";
      //   }  {
      //     return null;
      //   }
      // },

    ),
  );
}


Widget roundedstep(String title){
  return Container(

    height: 40,

    // width: 132,
    margin: EdgeInsets.all(5),

    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(121)),
        color: colorgreenp

    ),

    child:  Container(
      margin: EdgeInsets.only(left: 14,right: 14),
      // padding: EdgeInsets.all(8),
      child:    Container(
        alignment: Alignment.center
        ,
        child: Text(title,
          style: font13textfont,),
      ),
    ),
  );
}


Widget button1(String title, VoidCallback ontap){

  return  Container(

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
          borderRadius: BorderRadius.circular(5), // <-- Radius
        ),
        backgroundColor: Colors.transparent,

        minimumSize: const Size.fromHeight(47), // NEW
      ),
      onPressed:ontap,
      child:   Text(
        title,
        style: GoogleFonts.roboto(
          textStyle: TextStyle(color: whitecolor, letterSpacing: 1,fontWeight: FontWeight.w400,fontSize: 12,fontStyle: FontStyle.normal,),
        ),


      ),
    ),
  );
}

Widget buttonfaint1(String title, VoidCallback ontap){

  return  Container(

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
          borderRadius: BorderRadius.circular(5), // <-- Radius
        ),

        minimumSize: const Size.fromHeight(47), // NEW
      ),
      onPressed:ontap,
      child:   Text(
        title,
        style: GoogleFonts.roboto(
          textStyle: TextStyle(color: colorstextfont, letterSpacing: 1,fontWeight: FontWeight.w400,fontSize: 12,fontStyle: FontStyle.normal),
        ),


      ),
    ),
  );
}


void openSuccessDialog(BuildContext context, String title, VoidCallback onTap) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.success,
    animType: AnimType.scale,
    title: '',
    desc: title,
    btnOkText: 'OK',
    btnOkOnPress: onTap,
    customHeader: Container(
      height: 100,
      width: 100,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: Image.asset(
        Assets.iconsSuccess,
        height: 75,
        width: 75,
      ),
    ),
    padding: const EdgeInsets.all(20),
  ).show();
}

void openSuccessDialogAndRedirect(BuildContext context, String title) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.success,
    animType: AnimType.scale,
    title: '',
    desc: title,
    btnOkText: 'OK',
    btnOkOnPress: () {
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SalesScreen()),
      );
    },
    customHeader: Container(
      height: 100,
      width: 100,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: Image.asset(
        Assets.iconsSuccess,
        height: 75,
        width: 75,
      ),
    ),
    padding: const EdgeInsets.all(20),
  ).show();
}

Widget nodata(String titlen){
  return
    Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 60),
          alignment: Alignment.center,
          height: 108,
          width: 98,
          child: Image.asset(Assets.iconsNodevice),
        ),
        Container(
          margin: EdgeInsets.only(top: 25),
          child: Text(
            '${titlen}',
            style: GoogleFonts.roboto(
              textStyle: TextStyle(color: colorsfontgrey, letterSpacing: 1,fontWeight: FontWeight.w400,fontSize: 20,fontStyle: FontStyle.normal),
            ),


          ),
        ),
      ],
    );


}


Widget formfiledbBB(String hint, Function(String value) onchange){
  return  Container(

    height: 60,
    child: TextFormField(

      validator: requiredValidator.call,

      keyboardType: TextInputType.emailAddress,
      onChanged: onchange,


      expands: false,
      style: TextStyle(fontSize: 20.0, color: Colors.black54),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(12),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(
          Icons.search_outlined,
          color: colortxtgrey,
        ),
        label: Text(hint),
        hintStyle: TextStyle(color: colortxtgrey,fontSize: 12),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primarycolor),
          borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: greenfaint),
          borderRadius: BorderRadius.circular(8.0),
        ),

        errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(
              width: 1,
              color: Colors.red,
            )),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(
            width: 1,
            color: Colors.red,
          ),
        ),


      ),
    ),
  );
}

Widget formfiledb(String hint, Function(String value) onchange){
  return  Container(

    height: 60,
    child: TextFormField(

      validator: requiredValidator.call,

      keyboardType: TextInputType.emailAddress,
      onChanged: onchange,


      expands: false,
      style: TextStyle(fontSize: 20.0, color: Colors.black54),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(12),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(
          Icons.search_outlined,
          color: colortxtgrey,
        ),
        label: Text(hint),
        hintStyle: TextStyle(color: colortxtgrey,fontSize: 12),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primarycolor),
          borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: greenfaint),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),
  );
}

Widget formfiledbB(String hint, Function(String value) onchange){
  return  Container(


    child: TextFormField(



      inputFormatters: [
        LengthLimitingTextInputFormatter(11,),
        FilteringTextInputFormatter.digitsOnly
      ],



      validator: (String? value) {

        if (value=='') {
          return "This field is mandatory";
        } else if (value==null) {
          return "This field is mandatory";
        }
        else if (value.length<11) {
          return "TZD must be 11 characters";
        }
        else if (value.length>11) {
          return "TZD must be 11 characters";
        }
        else {
          return null;
        }
      },


      onChanged: onchange,


      expands: false,
      style: font15white,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(12),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        prefixIcon: Icon(
          Icons.search_outlined,
          color: colortxtgrey,
        ),
        label: Text(hint,
          style: font15white,
        ),
        hintStyle: TextStyle(color: colortxtgrey,fontSize: 12),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primarycolor),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: greenfaint),
          borderRadius: BorderRadius.circular(12),
        ),

        errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(
              width: 1,
              color: Colors.red,
            )),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(
            width: 1,
            color: Colors.red,
          ),
        ),
      ),
    ),
  );
}

Widget formfileddate(String hint, VoidCallback ontap,TextEditingController controller){
  return  Container(


    child: TextFormField(

      // validator: requiredValidator,
      readOnly: true,
      controller: controller,

      keyboardType: TextInputType.emailAddress,
      onTap: ontap,


      expands: false,
      style: font15white,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(12),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        // prefixIcon: Icon(
        //   Icons.search_outlined,
        //   color: colortxtgrey,
        // ),
        suffixIcon:Icon(
          Icons.calendar_month,
          color: colortxtgrey,
        ) ,
        label: Text(hint,
          style: font15white,
        ),
        hintStyle: TextStyle(color: colortxtgrey,fontSize: 12),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primarycolor),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: greenfaint),
          borderRadius: BorderRadius.circular(12),
        ),



        errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(
              width: 1,
              color: Colors.red,
            )),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(
            width: 1,
            color: Colors.red,
          ),
        ),

      ),




      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter date.';
        }
        return null;
      },
    ),
  );
}

Widget dashline(){
  return   Padding(
    padding: const EdgeInsets.all(8.0),
    child: DottedLine(
      direction: Axis.horizontal,
      alignment: WrapAlignment.center,
      lineLength: double.infinity,
      lineThickness: 1.0,
      dashLength: 12.0,
      dashColor: Colors.black,
      dashGradient: [colorsfontgrey, colorsfontgrey],
      dashRadius: 5.0,
      dashGapLength: 8.0,
      dashGapColor: Colors.transparent,

      dashGapRadius: 8.0,
    ),
  );
}


Widget formfileddateundeline(String hint, VoidCallback ontap,TextEditingController controller){
  return  Container(

    height: 50,
    child: TextFormField(

      // validator: requiredValidator,
      readOnly: true,
      controller: controller,

      keyboardType: TextInputType.emailAddress,
      onTap: ontap,


      expands: false,
      style: font14black,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(12),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        // prefixIcon: Icon(
        //   Icons.search_outlined,
        //   color: colortxtgrey,
        // ),
        suffixIcon:Icon(
          Icons.calendar_month,
          color: greencolor1,
        ) ,
        label: Text(hint,
          style: font15black,
        ),
        hintStyle: TextStyle(color: colortxtgrey,fontSize: 12),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: primarycolor),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: greenfaint),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter date.';
        }
        return null;
      },
    ),
  );
}

Widget formfileddateundelinenew(String hint, TextEditingController controller){
  return  Container(

    height: 50,
    child: TextFormField(

      // validator: requiredValidator,
      readOnly: true,
      controller: controller,

      keyboardType: TextInputType.emailAddress,



      expands: false,
      style: font14black,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(12),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        // prefixIcon: Icon(
        //   Icons.search_outlined,
        //   color: colortxtgrey,
        // ),
        suffixIcon:Icon(
          Icons.calendar_month,
          color: greencolor1,
        ) ,
        label: Text(hint,
          style: font15black,
        ),
        hintStyle: TextStyle(color: colortxtgrey,fontSize: 12),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: primarycolor),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: greenfaint),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter date.';
        }
        return null;
      },
    ),
  );
}


Widget formfileddateundelinenewedit(String hint, TextEditingController controller){
  return  Container(

    height: 50,
    child: TextFormField(

      // validator: requiredValidator,
      readOnly: true,
      controller: controller,

      keyboardType: TextInputType.emailAddress,



      expands: false,
      style: font14black,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(12),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        // prefixIcon: Icon(
        //   Icons.search_outlined,
        //   color: colortxtgrey,
        // ),
        suffixIcon:Icon(
          Icons.calendar_month,
          color: greencolor1,
        ) ,
        label: Text(hint,
          style: font15black,
        ),
        hintStyle: TextStyle(color: colortxtgrey,fontSize: 12),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: primarycolor),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: greenfaint),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter date.';
        }
        return null;
      },
    ),
  );
}




Widget formfileddateundelined(String hint, VoidCallback ontap,TextEditingController controller){
  return  Container(

    height: 50,
    child: TextFormField(

      // validator: requiredValidator,
      readOnly: true,
      controller: controller,

      keyboardType: TextInputType.emailAddress,
      onTap: ontap,


      expands: false,
      style: font14black,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(12),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        // prefixIcon: Icon(
        //   Icons.search_outlined,
        //   color: colortxtgrey,
        // ),
        suffixIcon:Icon(
          Icons.calendar_month,
          color: greencolor1,
        ) ,
        label: Text(hint,
          style: font15black,
        ),
        hintStyle: TextStyle(color: colortxtgrey,fontSize: 12),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: primarycolor),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: greenfaint),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter date.';
        }
        return null;
      },
    ),
  );
}


Future sucesscustomer(String title,String desc,IconData icon,VoidCallback ontap){

  return Get.defaultDialog(
      titlePadding: EdgeInsets.only(top: 0,bottom: 0),
      contentPadding: EdgeInsets.only(left: 10,right: 10),
      title: '',
      backgroundColor: whitecolor,


      content: Container(
        color: Colors.transparent,

        margin: EdgeInsets.only(left: 0,right: 0),

        width: double.maxFinite,
        child:
        Column(
          children: [

            Container(
              padding: const EdgeInsets.only(top: 0,left: 0,right: 0,bottom: 8),
              child: Icon(icon,size: 30,),
            ),

            Container(
              padding: const EdgeInsets.only(top: 0,left: 0,right: 0,bottom: 8),
              child: Text(
                '${title}',
                style: TextStyle(color: colortxtbld,fontSize: 16,fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
            ),

            Container(
              padding: const EdgeInsets.only(top: 0,left: 10,right: 10,bottom: 8),
              child: Text(
                desc,
                style: TextStyle(color: colortxtgrey,fontSize: 14,),
                textAlign: TextAlign.center,
              ),
            ),





            SizedBox(height: 3,),


            button('OK', ontap),







            Container(
              margin: EdgeInsets.only(top: 12,right: 12,left: 12),
              child: TextButton(onPressed: (){
                Get.back();
              }, child: Text('Cancel',style: TextStyle(color: Colors.redAccent),)),
            )

            ,

            SizedBox(height: 2,),

          ],
        ),
      )
  );
}



Future<bool> connectivityChecker() async {
  var connected = false;
  print("Checking internet...");
  try {
    final result = await InternetAddress.lookup('google.com');
    final result2 = await InternetAddress.lookup('facebook.com');
    final result3 = await InternetAddress.lookup('microsoft.com');
    if ((result.isNotEmpty && result[0].rawAddress.isNotEmpty) ||
        (result2.isNotEmpty && result2[0].rawAddress.isNotEmpty) ||
        (result3.isNotEmpty && result3[0].rawAddress.isNotEmpty)) {
      print('connected..');
      connected = true;
    } else {
      print("not connected from else..");
      connected = false;
    }
  } on SocketException catch (_) {
    print('not connected...');
    connected = false;
  }
  return connected;
}


Future<bool> hasNetwork() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    // Mobile data is available. Check if it has an active internet connection.
    try {
      var result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        apiController.online.value = true;
        return true;
      }
    } catch (_) {
      apiController.online.value = false;
      return false;
    }
  } else if (connectivityResult == ConnectivityResult.wifi) {
    // Mobile data is available. Check if it has an active internet connection.
    try {
      var result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        apiController.online.value = true;
        return true;
      }
    } catch (_) {
      apiController.online.value = false;
      return false;
    }
    // I am connected to a wifi network.
    print("WIFI Internet");
  }
  // No mobile data available.
  apiController.online.value = false;
  return false;
}

