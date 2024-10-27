import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:parkey_employee/UIComponents/back_top_title.dart';

import '../Clippers/login_done_clipper1.dart';
import '../Clippers/login_screen_clipper2.dart';
import '../colors/CustomColors.dart';

class VehicleParkedFragment extends StatefulWidget {
  const VehicleParkedFragment({super.key});

  @override
  State<VehicleParkedFragment> createState() => _VehicleParkedFragmentState();
}

class _VehicleParkedFragmentState extends State<VehicleParkedFragment> {
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    redirect();
  }

  @override
  Widget build(BuildContext context) {
    double widthParent = MediaQuery.of(context).size.width;
    double heightParent = MediaQuery.of(context).size.height;
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
          Container(
            height: 130,
            width: widthParent,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
                color: Color(CustomColors.PURPLE_DARK).withOpacity(0.7)),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Center(
                    child: Image(
                      width: 250,
                      height: 250,
                      image: AssetImage('assets/images/tick_image.png'),
                    ),
                  ),
                  Positioned(
                      top: 30,
                      left: 110,
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            color: Color(CustomColors.GREEN_BUTTON),
                            borderRadius: BorderRadius.circular(20)
                        ),
                      )),
                  Positioned(
                      top: 150,
                      left: 100,
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            color: Color(CustomColors.GREEN_BUTTON),
                            borderRadius: BorderRadius.circular(20)
                        ),
                      )),
                  Positioned(
                      top: 210,
                      left: 130,
                      child: Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                            color: Color(CustomColors.GREEN_BUTTON),
                            borderRadius: BorderRadius.circular(20)
                        ),
                      )),
                  Positioned(
                      top: 50,
                      right: 70,
                      child: Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                            color: Color(CustomColors.GREEN_BUTTON),
                            borderRadius: BorderRadius.circular(20)
                        ),
                      )),
                  Positioned(
                      top: 150,
                      right: 100,
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            color: Color(CustomColors.GREEN_BUTTON),
                            borderRadius: BorderRadius.circular(20)
                        ),
                      )),
                  Positioned(
                      top: 210,
                      right: 160,
                      child: Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                            color: Color(CustomColors.GREEN_BUTTON),
                            borderRadius: BorderRadius.circular(20)
                        ),
                      )),
                ],
              ),
              Container(
                child: Text('Vehicle Is\nSuccessfully Parked',textAlign: TextAlign.center, style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
              ),
              Container(
                child: Text('Vehicle is now under your parking lot and\n in your responsibility',textAlign: TextAlign.center, style: TextStyle(fontSize: 14),),
              ),
            ],
          ),
          BackTopTitle(context,'assets/images/arrow_back.png', Colors.white,
              'Parking Successful', '')
        ],
      ),
    ));
  }

  void redirect() async{
    await Future.delayed(Duration(seconds: 2));
    Navigator.pop(context);
  }
}
