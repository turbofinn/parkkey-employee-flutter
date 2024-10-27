import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:parkey_employee/models/confirm_exit_response.dart';
import 'package:parkey_employee/models/exit_vehicle_request.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Clippers/login_done_clipper1.dart';
import '../Clippers/login_screen_clipper2.dart';
import '../colors/CustomColors.dart';
import '../models/response.dart';
import '../services/api_service.dart';
import '../utils/Constants.dart';
import '../utils/auth_interceptor.dart';

class ExitFragment2 extends StatefulWidget {
  String parkingTicketID;

  ExitFragment2({required this.parkingTicketID});

  @override
  State<ExitFragment2> createState() => _ExitFragment2State();
}

class _ExitFragment2State extends State<ExitFragment2> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
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
          Column(
            children: [
              Container(
                child: Image(
                  image: AssetImage('assets/images/parkvehiclescreen1.png'),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Text(
                  'Confirmation for Post\n Payment. ',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Text(
                  'Swipe For Allot An Parking Spot To \nCustomers',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
              ),
              isLoading
                  ? Container(
                      margin: EdgeInsets.only(top: 50),
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Color(CustomColors.GREEN_BUTTON)),
                        strokeWidth: 4,
                      ),
                    )
                  : SwipeButton(
                      width: widthParent * 0.7,
                      activeThumbColor: Colors.grey.withOpacity(0.8),
                      thumbPadding: EdgeInsets.all(4),
                      activeTrackColor: Color(CustomColors.PURPLE_DARK),
                      inactiveThumbColor: Colors.black,
                      inactiveTrackColor: Colors.red,
                      child: Text(
                        "Swipe to EXIT Car",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onSwipe: () {
                        confirmExit();
                      },
                    )
            ],
          ),
          Container(
            height: 70,
            width: widthParent,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
                color: Color(CustomColors.PURPLE_DARK).withOpacity(0.7)),
          ),
        ],
      ),
    ));
  }

  void confirmExit() async {
    setState(() {
      isLoading = true;
    });

    try {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      String? accessToken = sharedPreferences.getString(Constants.ACCESS_TOKEN);
      String? employeeID = sharedPreferences.getString(Constants.EMPLOYEE_ID);

      final dio = Dio(BaseOptions(contentType: "application/json"));
      dio.interceptors.add(AuthInterceptor(accessToken!));

      final ApiService apiService = ApiService(dio);

      final ConfirmExitResponse response = await apiService
          .confirmExit(ExitVehicleRequest(widget.parkingTicketID, employeeID!));
      print('msgotp--' + response.successMessage);
      if (response.successMessage == "Vehicle exited safely") {
        Navigator.of(context).pushNamed('/ExitVehicleFragment3');
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e.toString());
    }

  }
}
