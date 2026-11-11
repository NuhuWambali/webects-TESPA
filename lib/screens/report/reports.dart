import 'package:ects/widget/widgetconstant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constant/colorcontant.dart';
import '../../controller/controllerconstant.dart';
import '../../generated/assets.dart';
import 'package:get/get.dart';



class ReportssScreen extends StatefulWidget {
  const ReportssScreen({super.key});

  @override
  State<ReportssScreen> createState() => _ReportssScreenState();
}

class _ReportssScreenState extends State<ReportssScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        body: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 327,
                    child: Stack(
                      children: [
                        Container(
                          height: 267,
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
                                child: Text('Reports', style: font20white
                                  // TextStyle(fontWeight: FontWeight.w500,color: whitecolor,fontSize: 16),),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 21,
                          top: 162,
                          right: 21,
                          child: PhysicalModel(
                            color: Colors.white,
                            elevation: 0.1,
                            shadowColor: Colors.white.withOpacity(0.6),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            child: Container(
                              width: double.infinity,
                              padding:
                              EdgeInsets.only(top: 37, left: 23, right: 23),
                              height: 164,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text('Bill', style: font18black
                                          // TextStyle(fontWeight: FontWeight.w500,color: whitecolor,fontSize: 16),),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        margin: EdgeInsets.only(top: 29),
                                        child: Text('18', style: font24black
                                          // TextStyle(fontWeight: FontWeight.w500,color: whitecolor,fontSize: 16),),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text('Cash', style: font18black
                                          // TextStyle(fontWeight: FontWeight.w500,color: whitecolor,fontSize: 16),),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        margin: EdgeInsets.only(top: 29),
                                        child: Text('18', style: font24black
                                          // TextStyle(fontWeight: FontWeight.w500,color: whitecolor,fontSize: 16),),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text('Total', style: font18black
                                          // TextStyle(fontWeight: FontWeight.w500,color: whitecolor,fontSize: 16),),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        margin: EdgeInsets.only(top: 29),
                                        child: Text('18', style: font24black
                                          // TextStyle(fontWeight: FontWeight.w500,color: whitecolor,fontSize: 16),),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 0),
                    child:    tabSection(context),
                  ),

                ])));
  }



  Widget tabSection(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: TabBar(
                unselectedLabelColor: Colors.grey,
                indicatorColor: primarycolor,
                labelColor: primarycolor,
                tabs: const [
                  Tab(text: "All"),
                  Tab(text: "Cash Tzs"),
                  Tab(text: "Cash usd"),
                  Tab(text: "Bill"),
                ]),
          ),
          SizedBox(
            //Add this to give height
            height: MediaQuery.of(context).size.height*0.55,
            child: TabBarView(children: [
              Container(
                  margin: EdgeInsets.only(bottom: 130),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        card_allsale('284738438958485', '22/09/2021 , 12:00am', 'Cash  TZS', '400,000/=Tzs', () { }),
                        card_allsale('284738438958485', '22/09/2021 , 12:00am', 'Cash  TZS', '400,000/=Tzs', () { }),
                        card_allsale('284738438958485', '22/09/2021 , 12:00am', 'Cash  TZS', '400,000/=Tzs', () { }),
                        card_allsale('284738438958485', '22/09/2021 , 12:00am', 'Cash  TZS', '400,000/=Tzs', () { }),
                        card_allsale('284738438958485', '22/09/2021 , 12:00am', 'Cash  TZS', '400,000/=Tzs', () { }),
                        card_allsale('284738438958485', '22/09/2021 , 12:00am', 'Cash  TZS', '400,000/=Tzs', () { }),
                        card_allsale('284738438958485', '22/09/2021 , 12:00am', 'Cash  TZS', '400,000/=Tzs', () { }),
                        card_allsale('284738438958485', '22/09/2021 , 12:00am', 'Cash  TZS', '400,000/=Tzs', () { }),
                      ],
                    ),
                  )
              ),
              Container(
                  margin: EdgeInsets.only(bottom: 130),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        card_allsale('284738438958485', '22/09/2021 , 12:00am', 'Cash  TZS', '400,000/=Tzs', () { }),

                      ],
                    ),
                  )
              ),
              Container(
                  margin: EdgeInsets.only(bottom: 130),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        card_allsale('284738438958485', '22/09/2021 , 12:00am', 'Cash  usd', '400usd', () { }),

                      ],
                    ),
                  )
              ),
              Container(
                  margin: EdgeInsets.only(bottom: 130),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        card_allsale('284738438958485', '22/09/2021 , 12:00am', 'Bill', '400,000/=Tzs', () { }),

                      ],
                    ),
                  )
              ),
            ]),
          ),

        ],
      ),
    );
  }
}
