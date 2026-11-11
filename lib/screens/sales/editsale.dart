import 'package:flutter/material.dart';

class EditSale extends StatefulWidget {
  const EditSale({super.key});

  @override
  State<EditSale> createState() => _EditSaleState();
}

class _EditSaleState extends State<EditSale> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 430,
        height: 932,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(color: Colors.white),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: 430,
                height: 157,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(),
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: 430,
                        height: 227,
                        decoration: ShapeDecoration(
                          color: Color(0xFF121315),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          shadows: [
                            BoxShadow(
                              color: Color(0x0A000000),
                              blurRadius: 18,
                              offset: Offset(0, 4),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 21,
                      top: 79,
                      child: Container(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Opacity(
                              opacity: 0.70,
                              child: Container(
                                width: 38,
                                height: 38,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 38,
                                      top: 38,
                                      child: Transform(
                                        transform: Matrix4.identity()..translate(0.0, 0.0)..rotateZ(-3.14),
                                        child: Container(
                                          width: 38,
                                          height: 38,
                                          decoration: ShapeDecoration(
                                            shape: OvalBorder(
                                              side: BorderSide(width: 0.97, color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 26.57,
                                      top: 26.57,
                                      child: Transform(
                                        transform: Matrix4.identity()..translate(0.0, 0.0)..rotateZ(-3.14),
                                        child: Container(
                                          width: 14.48,
                                          height: 14.48,
                                          child: Stack(children: [

                                              ]),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                              width: 134.11,
                              child: Text(
                                'Edit Sale',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.78,
                                  fontFamily: 'SF Compact Display',
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                  letterSpacing: -1.04,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 48.25,
                      top: 0.35,
                      child: Container(
                        width: 333.50,
                        height: 239.65,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              top: 0,
                              child: Opacity(
                                opacity: 0.50,
                                child: Container(
                                  width: 193.33,
                                  height: 188.06,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFFB7FF6F),
                                    shape: OvalBorder(),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 237.13,
                              top: 135.91,
                              child: Opacity(
                                opacity: 0.78,
                                child: Container(
                                  width: 96.37,
                                  height: 103.74,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFF21CDAF),
                                    shape: OvalBorder(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 35,
              top: 199,
              child: Text(
                'Vehicle Typle',
                style: TextStyle(
                  color: Color(0xFF8E8E8E),
                  fontSize: 15,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
            ),
            Positioned(
              left: 35,
              top: 290,
              child: Text(
                'Device',
                style: TextStyle(
                  color: Color(0xFF8E8E8E),
                  fontSize: 15,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
            ),
            Positioned(
              left: 35,
              top: 378,
              child: Text(
                'Customer Type',
                style: TextStyle(
                  color: Color(0xFF8E8E8E),
                  fontSize: 15,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
            ),
            Positioned(
              left: 35,
              top: 564,
              child: Text(
                'Star Date',
                style: TextStyle(
                  color: Color(0xFF8E8E8E),
                  fontSize: 15,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
            ),
            Positioned(
              left: 35,
              top: 472,
              child: Text(
                'To Border',
                style: TextStyle(
                  color: Color(0xFF8E8E8E),
                  fontSize: 15,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
            ),
            Positioned(
              left: 35,
              top: 658,
              child: Text(
                'Rental End Date',
                style: TextStyle(
                  color: Color(0xFF8E8E8E),
                  fontSize: 15,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
            ),
            Positioned(
              left: 37,
              top: 594,
              child: Text(
                'T342 DUX',
                style: TextStyle(
                  color: Color(0xFF253337),
                  fontSize: 14,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),
            ),
            Positioned(
              left: 37,
              top: 502,
              child: Text(
                '564632784',
                style: TextStyle(
                  color: Color(0xFF253337),
                  fontSize: 14,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),
            ),
            Positioned(
              left: 37,
              top: 688,
              child: Text(
                '564632784',
                style: TextStyle(
                  color: Color(0xFF253337),
                  fontSize: 14,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),
            ),
            Positioned(
              left: 37,
              top: 261,
              child: Container(
                width: 314,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      strokeAlign: BorderSide.strokeAlignCenter,
                      color: Color(0xFFC8C8C8),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 37,
              top: 351,
              child: Container(
                width: 367,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      strokeAlign: BorderSide.strokeAlignCenter,
                      color: Color(0xFFC8C8C8),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 37,
              top: 439,
              child: Container(
                width: 367,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      strokeAlign: BorderSide.strokeAlignCenter,
                      color: Color(0xFFC8C8C8),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 37,
              top: 625,
              child: Container(
                width: 367,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      strokeAlign: BorderSide.strokeAlignCenter,
                      color: Color(0xFFC8C8C8),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 37,
              top: 533,
              child: Container(
                width: 367,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      strokeAlign: BorderSide.strokeAlignCenter,
                      color: Color(0xFFC8C8C8),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 37,
              top: 719,
              child: Container(
                width: 367,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      strokeAlign: BorderSide.strokeAlignCenter,
                      color: Color(0xFFC8C8C8),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 222,
              top: 844,
              child: Container(
                width: 186,
                height: 48,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(),
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: 186,
                        height: 48,
                        decoration: ShapeDecoration(
                          color: Color(0xFF1A372E),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 78,
                      top: 17,
                      child: Text(
                        'NEXT',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          height: 0,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 37,
              top: 261,
              child: Container(
                width: 367,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      strokeAlign: BorderSide.strokeAlignCenter,
                      color: Color(0xFFC8C8C8),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 379,
              top: 590,
              child: Container(
                width: 20,
                height: 20,
                padding: const EdgeInsets.symmetric(horizontal: 2.50, vertical: 1.67),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 15,
                      height: 16.67,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 1.38,
                            child: Opacity(
                              opacity: 0.40,
                              child: Container(
                                width: 15,
                                height: 4.59,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage("https://via.placeholder.com/15x5"),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            top: 5.96,
                            child: Container(
                              width: 15,
                              height: 10.70,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage("https://via.placeholder.com/15x11"),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 377,
              top: 684,
              child: Container(
                width: 20,
                height: 20,
                padding: const EdgeInsets.symmetric(horizontal: 2.50, vertical: 1.67),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 15,
                      height: 16.67,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 1.38,
                            child: Opacity(
                              opacity: 0.40,
                              child: Container(
                                width: 15,
                                height: 4.59,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage("https://via.placeholder.com/15x5"),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            top: 5.96,
                            child: Container(
                              width: 15,
                              height: 10.70,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage("https://via.placeholder.com/15x11"),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
