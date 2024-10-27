import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:parkey_employee/utils/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Clippers/login_done_clipper1.dart';
import '../Clippers/login_screen_clipper2.dart';
import '../colors/CustomColors.dart';

class ExitVehicleFragment3 extends StatefulWidget {
  final PageController controller;

  ExitVehicleFragment3({required this.controller,super.key});

  @override
  State<ExitVehicleFragment3> createState() => _ExitVehicleFragment3State();
}

class _ExitVehicleFragment3State extends State<ExitVehicleFragment3> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    redirect();
  }
  @override
  Widget build(BuildContext context) {
    markExitConfirmed();
    double widthParent = MediaQuery.of(context).size.width;
    double heightParent = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Material(
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
                    decoration:
                        BoxDecoration(color: Color(CustomColors.PURPLE_DARK)),
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
            height: 100,
            width: widthParent,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
                color: Color(CustomColors.PURPLE_DARK).withOpacity(0.7)),
          ),
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  'Exit Complied',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 22),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(20.0),
              //   child: Container(
              //     margin: EdgeInsets.only(top: 100),
              //       height: 250,
              //       decoration: BoxDecoration(
              //         gradient: LinearGradient(
              //           begin: Alignment.topLeft,
              //           end: Alignment.bottomRight,
              //           colors: [
              //             Color(CustomColors.PURPLE_DARK).withOpacity(0.8),
              //             Color(CustomColors.PURPLE_DARK).withOpacity(0.5),
              //           ],
              //         ),
              //         borderRadius: BorderRadius.circular(20)
              //       )),
              // ),
              SizedBox(
                height: 200,
              ),
              Stack(
                children: [
                  Center(
                    child: Image(
                      width: 180,
                      height: 180,
                      image: AssetImage('assets/images/tick_image.png'),
                    ),
                  ),
                  Positioned(
                      top: 10,
                      left: 140,
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            color: Color(CustomColors.GREEN_BUTTON),
                            borderRadius: BorderRadius.circular(20)),
                      )),
                  Positioned(
                      top: 100,
                      left: 120,
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            color: Color(CustomColors.GREEN_BUTTON),
                            borderRadius: BorderRadius.circular(20)),
                      )),
                  Positioned(
                      top: 150,
                      left: 160,
                      child: Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                            color: Color(CustomColors.GREEN_BUTTON),
                            borderRadius: BorderRadius.circular(20)),
                      )),
                  Positioned(
                      top: 40,
                      right: 100,
                      child: Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                            color: Color(CustomColors.GREEN_BUTTON),
                            borderRadius: BorderRadius.circular(20)),
                      )),
                  Positioned(
                      top: 110,
                      right: 120,
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            color: Color(CustomColors.GREEN_BUTTON),
                            borderRadius: BorderRadius.circular(20)),
                      )),
                  Positioned(
                      top: 150,
                      right: 160,
                      child: Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                            color: Color(CustomColors.GREEN_BUTTON),
                            borderRadius: BorderRadius.circular(20)),
                      )),
                ],
              ),
              Container(
                child: Text(
                  'Vehicle EXIT Safely & \nSuccessfully',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
            ],
          )
        ],
      ),
    ));
  }

  void markExitConfirmed() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setBool(Constants.IS_EXIT_CONFIRMED, false);
  }

  void redirect() async{
    await Future.delayed(Duration(seconds: 2));
    Navigator.pop(context);
  }
}
