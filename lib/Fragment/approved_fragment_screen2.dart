import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:parkey_employee/UIComponents/back_top_title.dart';

import '../Clippers/login_done_clipper1.dart';
import '../Clippers/login_screen_clipper2.dart';
import '../colors/CustomColors.dart';

class ApprovedFragmentScreen2 extends StatefulWidget {
  String vehicleNo;
  ApprovedFragmentScreen2({required this.vehicleNo});

  @override
  State<ApprovedFragmentScreen2> createState() => _ApprovedFragmentScreen2State();
}

class _ApprovedFragmentScreen2State extends State<ApprovedFragmentScreen2> {
  @override
  Widget build(BuildContext context) {
    double widthParent = MediaQuery.of(context).size.width;
    return SafeArea(child: Material(
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 1,
                child: ClipPath(
                  clipper: LoginDoneClipper1(),
                  child: Container(
                    height: 130,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: Color(CustomColors.PURPLE_DARK)),
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: ClipPath(
                  clipper: LoginScreenClipper2(),
                  child: Container(
                    //height: double.infinity-2,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(CustomColors.PURPLE_DARK).withOpacity(0.4),
                            Color(CustomColors.PURPLE_DARK).withOpacity(0.2)
                          ],
                        )),
                  ),
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          Column(
            children: [
              Container(
                height: 130,
                width: widthParent,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30)),
                    color: Color(CustomColors.PURPLE_DARK).withOpacity(0.7)),
              ),
              Container(
                margin: EdgeInsets.only(top: 60,left: 30),
                alignment: Alignment.topLeft,
                child: Text('Vehicle No.',style: TextStyle(fontWeight: FontWeight.w600,color: Colors.black),),
              ),
              Padding(
                padding:
                const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Container(
                    height: 70,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: Color(CustomColors.PURPLE_DARK),
                            width: 2)),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 20),
                            child: Image(
                              height: 15,
                              width: 15,
                              fit: BoxFit.contain,
                              image: AssetImage(
                                  'assets/images/approved_fragment3.png'),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(bottom: 7,left: 20),
                              child: Text(widget.vehicleNo,style: TextStyle(color: Colors.black,fontSize: 22),),
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
              Container(
                margin: EdgeInsets.only(top: 40),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/ParkingVehicleFragment');
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 10, left: 50, right: 50),
                    child: Container(
                      child: Text(
                        'Proceed',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(CustomColors.GREEN_BUTTON),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(20.0), // Set border radius
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 40),
                child: ElevatedButton(
                  onPressed: () {
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 10, left: 30, right: 30),
                    child: Container(
                      child: Text(
                        'Scan Again',
                        style: TextStyle(color: Color(CustomColors.GREEN_BUTTON), fontSize: 18),
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(20.0), // Set border radius
                    ),
                  ),
                ),
              )
            ],
          ),
          Container(
              margin: EdgeInsets.only(top: 10),
              child: BackTopTitle(context,'assets/images/arrow_back.png', Colors.white, 'Scan Number Plate', ''))
        ],
      ),
    ));
  }
}
