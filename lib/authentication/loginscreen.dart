

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:ects/widget/widgetconstant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';



import '../HomePage.dart';
import '../constant/colorcontant.dart';
import '../controller/controllerconstant.dart';
import '../generated/assets.dart';


class Loginform extends StatefulWidget {
  Loginform({Key? key}) : super(key: key);

  @override
  State<Loginform> createState() => _LoginformState();
}

class _LoginformState extends State<Loginform> {
  final _formKey = GlobalKey<FormState>();

  final requiredValidator = RequiredValidator(errorText: 'this field is required');



  PackageInfo? packageInfo;

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    get();
  }


  get() async {

    packageInfo = await PackageInfo.fromPlatform();
    setState(() {

    });




  }

  @override
  Widget build(BuildContext context) {
    // changeLocale(context, statevalueContr.languagecode.value);
    return  PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: mainbg,
        body: Center(
          child: SafeArea(


            child:  SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    height: 95,

                    child: Image.asset(
                      Assets.iconsLogoweb,
                      fit: BoxFit.fill,
                    ),
                  ),

                  // Container(
                  //   alignment: Alignment.center,
                  //   child: Image.asset(Assets.logosLogo),
                  //
                  // ),
                  Container(
                    padding: EdgeInsets.only(left: 8, right: 8,top: 15,bottom: 20),
                    child: NeumorphicText("ECTS Sales Portal",style: const NeumorphicStyle(
                      depth: 5,
                      surfaceIntensity: 0.23,//customize depth here
                      color: Colors.black,),
                      textStyle: NeumorphicTextStyle(
                          fontSize: 22,
                          // fontWeight: FontWeight.w400

                        //customize size here
                        // AND others usual text style properties (fontFamily, fontWeight, ...)
                      ),
                    ),
                  ),




                  Container(

                    child: Form(
                      key: _formKey,
                      child: Container(
                        alignment: Alignment.center,


                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [


                            // Container(
                            //   alignment: Alignment.center
                            //   ,
                            //
                            //   padding: const EdgeInsets.only(top: 10),
                            //   child: const Text('LOGIN',
                            //     style: TextStyle(fontSize:20,fontWeight: FontWeight.w700,color:Colors.black ),
                            //     textAlign: TextAlign.center,
                            //
                            //   ),
                            // ),

                            // Container(
                            //   alignment: Alignment.centerLeft
                            //   ,
                            //
                            //   padding: const EdgeInsets.only(top: 25,left: 20,right: 20),
                            //   child: Text('Email',
                            //     style: TextStyle(fontSize:14,fontWeight: FontWeight.normal,color:colortxtb1 ),
                            //     textAlign: TextAlign.center,
                            //
                            //   ),
                            // ),

                            Container(
                                alignment: Alignment.centerLeft
                                ,

                                padding: const EdgeInsets.only(top: 35,left: 20,right: 20),

                                child: Container(

                                  height: 60,
                                  child: TextFormField(
                                    onChanged: (username){
                                      apiController.username.value =username.trim();
                                    },
                                    validator: requiredValidator,
                                    // validator: (value) {
                                    //   if(value == null || value.isEmpty || !value.contains('@') || !value.contains('.')){
                                    //     return 'Invalid Email Address';
                                    //   }
                                    //   return null;
                                    // },

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
                                      label: Text('Username'),
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


                            ),

                            // Container(
                            //   alignment: Alignment.centerLeft
                            //   ,
                            //
                            //   padding: const EdgeInsets.only(top: 25,left: 20,),
                            //   child: Text('password',
                            //     style: TextStyle(fontSize:14,fontWeight: FontWeight.normal,color:colortxtb1 ),
                            //     textAlign: TextAlign.center,
                            //
                            //   ),
                            // ),

                            Container(
                                alignment: Alignment.centerLeft
                                ,

                                padding: const EdgeInsets.only(top: 35,left: 20,right: 20),

                                child: Container(

                                  height: 60,
                                  child: Obx(() {
                                    return TextFormField(
                                      onChanged: (pas){
                                        apiController.password.value = pas.trim();

                                      },
                                      validator: requiredValidator,
                                      obscureText: apiController.ishiden.value,

                                      expands: false,
                                      style: TextStyle(fontSize: 20.0, color: Colors.black54),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(12.0),
                                        filled: true,
                                        fillColor: Colors.white,
                                        prefixIcon: Icon(
                                          Icons.lock_outline_rounded,
                                          color: colortxtgrey,
                                        ),
                                        suffixIcon: InkWell(

                                            onTap: (){
                                              if (apiController.ishiden.value) {
                                                apiController.ishiden.value = false;
                                              } else {
                                                apiController.ishiden.value = true;
                                              }


                                            },
                                            child: apiController.ishiden.value?Icon(
                                              Icons.remove_red_eye_outlined,
                                              color: colortxtgrey,
                                            ):Icon(
                                              Icons.remove_red_eye_rounded,
                                              color: colortxtgrey,
                                            )
                                        ) ,

                                        label: Text('password'),
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
                                    );
                                  }),
                                )


                            ),

                            button('LOGIN', () {



                              if (_formKey.currentState!.validate()) {

                                // If the form is valid, display a snackbar. In the real world,
                                // you'd often call a server or save the information in a database.
                                print('Submitted ttt');
                                apiController.loginuser(apiController.username.value, apiController.password.value);

                                // Get.to(()=>Home());




                                // RemoteServices.login(authController.username.value, authController.password.value);


                              }

                            })
                            ,


                            Container(
                              alignment: Alignment.center
                              ,

                              padding: const EdgeInsets.only(top: 25,left: 20,),
                              child: InkWell(
                                onTap: (){
                                  openBottomSheet();
                                },
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Cant connect? ',
                                    style: TextStyle(fontSize:14,fontWeight: FontWeight.w300,color: textgrey ),
                                    children:  <TextSpan>[
                                      TextSpan(text: 'Change Server', style:  TextStyle(fontSize:14,fontWeight: FontWeight.bold,color:primarycolor )),

                                    ],
                                  ),
                                ),
                              ),
                            ),




                            Container(
                              alignment: Alignment.bottomCenter
                              ,

                              padding: const EdgeInsets.only(top: 25,left: 20,),
                              child: Text('v${packageInfo?.version} +${packageInfo?.buildNumber}'
                                  '',
                                style: TextStyle(fontSize:14,fontWeight: FontWeight.normal,color:primarycolor ),
                                textAlign: TextAlign.center,

                              ),
                            ),







                          ],
                        ),
                      ),

                    ),
                  ),



                ],
              ),
            ),



          ),
        ),

      ),
    );
  }


  void openBottomSheet() {
    Get.bottomSheet(
      Column(
        children: [
          const SizedBox(height: 15),
       Container(
         margin: EdgeInsets.only(left: 35,right: 35),
         child: Row(
           crossAxisAlignment: CrossAxisAlignment.center,
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             Container(
                  child: Text(
                    'Change Server',
                    style: TextStyle(fontSize: 18,color: textgrey),
                  ),
                ),


             IconButton(
                 onPressed: (){
                   Get.back();
                 }, icon: Icon(Icons.close)
             ),

           ],
         ),
       ),

          Container(
            margin: EdgeInsets.only(left: 15,right: 15),
            child: Column(
              children: [
                Divider(),



                SizedBox(height: 50,),



              Container(
                margin: EdgeInsets.only(left: 20,right: 20),
                child: DropdownButtonFormField(

                  icon:  Icon(Icons.keyboard_arrow_down_outlined),

                  decoration: InputDecoration(
                    label: Text('Select Server',style: TextStyle(color: textgrey),),
                      contentPadding: EdgeInsets.all(12),
                  filled: true,
                  fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primarycolor),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    enabledBorder: OutlineInputBorder(
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
                  onChanged: (value) {
                   apiController.dropdownvalue.value = value??'';
                  },
                  onSaved: (value) {
                  apiController.dropdownvalue.value =value??'';
                  },
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "can't empty please choose one";
                    } else {
                      return null;
                    }
                  },
                  items: apiController.serverlist
                      .map((String val) {
                    return DropdownMenuItem(
                      value: val,
                      child: Text(
                        val,
                      ),
                    );
                  }).toList(),
                ),
              ),





                SizedBox(height: 15,),


                button('SAVE', () {

                })
              ],
            ),
          ),






        ],
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}