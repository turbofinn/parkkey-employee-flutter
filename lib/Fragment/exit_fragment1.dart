import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:parkey_employee/UIComponents/back_top_title.dart';
import 'package:parkey_employee/models/confirm_exit_response.dart';
import 'package:parkey_employee/models/exit_otp_response.dart';
import 'package:parkey_employee/models/otp_exit_request.dart';
import 'package:parkey_employee/models/parking_charges_response.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Clippers/login_done_clipper1.dart';
import '../Clippers/login_screen_clipper2.dart';
import '../colors/CustomColors.dart';
import '../models/confirm_ticket_request.dart';
import '../models/exit_vehicle_request.dart';
import '../models/parking_space_stats_response.dart';
import '../models/response.dart';
import '../services/api_service.dart';
import '../utils/Constants.dart';
import '../utils/UpperCaseFormatter.dart';
import '../utils/auth_interceptor.dart';
import '../utils/common_util.dart';

class ExitVehicleFragment1 extends StatefulWidget {
  final PageController controller;

  ExitVehicleFragment1({required this.controller});

  @override
  State<ExitVehicleFragment1> createState() => _ExitVehicleFragment1State();
}

class _ExitVehicleFragment1State extends State<ExitVehicleFragment1> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  bool isOtpValid = true, isOtpEntered = false, isLoading = false;
  bool isConfirmedTicketFromQR = false;
  bool isConfirmedTicketFromQR1 = false;
  bool isConfirmedTicket = false;
  bool isLoadingSwipe = false;
  bool payFromWallet = false;
  late String charges = "";
  late String parkingTicketID;
  late List<Vehicle> exitVehicleList;
  bool isLoadingList = true;
  bool isError = false;
  final TextEditingController vehicleNumberInputController =
      TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialiseButton();
    populateList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    isOtpEntered = false;
    clearPrefs();
  }

  @override
  Widget build(BuildContext context) {
    double widthParent = MediaQuery.of(context).size.width;
    double heightParent = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Material(
      child: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
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
                          decoration: BoxDecoration(
                              color: Color(CustomColors.PURPLE_DARK)),
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
                    BackTopTitle(context, '', Colors.white, 'Parking Exit', ''),
                    isLoadingList
                        ? Center(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Color(CustomColors.GREEN_BUTTON),
                                      width: 2),
                                  borderRadius: BorderRadius.circular(20)),
                              height: 270,
                              width: widthParent * 0.9,
                              child: SizedBox(
                                child: Transform.scale(
                                  scale: 0.2,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(CustomColors.GREEN_BUTTON)),
                                    strokeWidth: 25,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Color(CustomColors.GREEN_BUTTON),
                                      width: 2),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color(
                                                  CustomColors.GREEN_BUTTON),
                                              width: 2),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: isError
                                          ? Center(
                                              child: Container(
                                                child:
                                                    Text('Some Error Occured'),
                                              ),
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Container(
                                                        child: Text(
                                                          'Parking Time',
                                                          style: TextStyle(
                                                              color: Color(
                                                                  CustomColors
                                                                      .PURPLE_DARK),
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                      Container(
                                                        child: Text(
                                                          exitVehicleList
                                                                      .length >
                                                                  0
                                                              ? exitVehicleList
                                                                  .elementAt(0)
                                                                  .parkingDuration!
                                                              : "0 hr",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        child: Text(
                                                          exitVehicleList
                                                                      .length >
                                                                  0
                                                              ? exitVehicleList
                                                                  .elementAt(0)
                                                                  .vehicleNo!
                                                              : "XX XX XX XXXX",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            child: Text(
                                                              exitVehicleList
                                                                          .length >
                                                                      0
                                                                  ? CommonUtil().maskNumber(exitVehicleList.elementAt(0).customerNo!)
                                                                  : "XXXXXXXXX",
                                                              style: TextStyle(
                                                                  fontSize: 10),
                                                            ),
                                                          ),
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 20),
                                                            child: Text(
                                                              exitVehicleList
                                                                          .length >
                                                                      0
                                                                  ? '₹ ' +
                                                                      exitVehicleList
                                                                          .elementAt(
                                                                              0)
                                                                          .parkingCharge! +
                                                                      '/-'
                                                                  : 'Paid Up : ₹ 0/-',
                                                              style: TextStyle(
                                                                  fontSize: 12),
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color(
                                                  CustomColors.GREEN_BUTTON),
                                              width: 2),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                Container(
                                                  child: Text(
                                                    'Parking Time',
                                                    style: TextStyle(
                                                        color: Color(
                                                            CustomColors
                                                                .PURPLE_DARK),
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                                Container(
                                                  child: Text(
                                                    exitVehicleList.length > 1
                                                        ? exitVehicleList
                                                            .elementAt(1)
                                                            .parkingDuration!
                                                        : "0 hr",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  child: Text(
                                                    exitVehicleList.length > 1
                                                        ? exitVehicleList
                                                            .elementAt(1)
                                                            .vehicleNo!
                                                        : "XX XX XX XXXX",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      child: Text(
                                                        exitVehicleList.length >
                                                                1
                                                            ? CommonUtil().maskNumber(exitVehicleList.elementAt(1).customerNo!)
                                                            : "XXXXXXXXXX",
                                                        style: TextStyle(
                                                            fontSize: 10),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 20),
                                                      child: Text(
                                                        exitVehicleList.length >
                                                                1
                                                            ? '₹ ' +
                                                                exitVehicleList
                                                                    .elementAt(
                                                                        1)
                                                                    .parkingCharge! +
                                                                '/-'
                                                            : 'Paid Up : ₹ 0/-',
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color(
                                                  CustomColors.GREEN_BUTTON),
                                              width: 2),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                Container(
                                                  child: Text(
                                                    'Parking Time',
                                                    style: TextStyle(
                                                        color: Color(
                                                            CustomColors
                                                                .PURPLE_DARK),
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                                Container(
                                                  child: Text(
                                                    exitVehicleList.length > 2
                                                        ? exitVehicleList
                                                            .elementAt(2)
                                                            .parkingDuration!
                                                        : "0 hr",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  child: Text(
                                                    exitVehicleList.length > 2
                                                        ? exitVehicleList
                                                            .elementAt(2)
                                                            .vehicleNo!
                                                        : "XX XX XX XXXX",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      child: Text(
                                                        exitVehicleList.length >
                                                                2
                                                            ? CommonUtil().maskNumber(exitVehicleList.elementAt(2).customerNo!)
                                                            : "XXXXXXXXXX",
                                                        style: TextStyle(
                                                            fontSize: 10),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 20),
                                                      child: Text(
                                                        exitVehicleList.length >
                                                                2
                                                            ? '₹ ' +
                                                                exitVehicleList
                                                                    .elementAt(
                                                                        2)
                                                                    .parkingCharge! +
                                                                '/-'
                                                            : 'Paid Up : ₹ 0/-x    x ',
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: Pinput(
                          controller: pinController,
                          focusNode: focusNode,
                          defaultPinTheme: PinTheme(
                            width: 40,
                            height: 45,
                            textStyle: const TextStyle(
                              fontSize: 22,
                              color: Color(0xff000000),
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xffffffff),
                              borderRadius: BorderRadius.circular(12),
                              border: isOtpValid
                                  ? Border.all(
                                      color: Color(CustomColors.PURPLE_DARK))
                                  : Border.all(color: Color(0xffFF0000)),
                            ),
                          ),
                          separatorBuilder: (index) =>
                              const SizedBox(width: 36),
                          // validator: (value) {
                          //   return value == '2222' ? null : '';
                          // },
                          hapticFeedbackType: HapticFeedbackType.lightImpact,
                          onCompleted: (pin) {
                            setState(() {
                              isOtpEntered = true;
                            });
                            debugPrint('onCompleted: $pin');
                          },
                          onChanged: (value) {
                            debugPrint('onChanged: $value');
                          },
                          cursor: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 9),
                                width: 22,
                                height: 1,
                                color: Color(CustomColors.GREEN_BUTTON),
                              ),
                            ],
                          ),
                        ),
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
                        : Container(
                            margin: EdgeInsets.only(top: 40),
                            child: ElevatedButton(
                              onPressed: () async {
                                final SharedPreferences sharedPreferences =
                                    await SharedPreferences.getInstance();
                                isConfirmedTicketFromQR = sharedPreferences
                                    .getBool(Constants.IS_TICKET_CONFIRMED)!;

                                if (isConfirmedTicketFromQR ||
                                    isConfirmedTicketFromQR1) {
                                  sharedPreferences.setBool(
                                      Constants.IS_TICKET_CONFIRMED, false);
                                  sharedPreferences.setString(
                                      Constants.VEHICLE_NUMBER, "");

                                  if (isConfirmedTicketFromQR) {
                                    checkIsConfirmedTicket(
                                        isConfirmedTicketFromQR);
                                  }
                                  if (isConfirmedTicketFromQR1) {
                                    checkIsConfirmedTicket(
                                        isConfirmedTicketFromQR1);
                                  }
                                  setState(() {
                                    vehicleNumberInputController.setText("");
                                  });
                                } else {
                                  verifyOtp(pinController.text);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 20, bottom: 20, left: 100, right: 100),
                                child: Container(
                                  child: isConfirmedTicketFromQR1
                                      ? Text(
                                          'Confirm',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        )
                                      : Text(
                                          'Verify Otp',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color(CustomColors.PURPLE_DARK),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20.0), // Set border radius
                                ),
                              ),
                            ),
                          ),
                    GestureDetector(
                      onTap: () {
                        widget.controller.jumpToPage(1);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Color(CustomColors.PURPLE_DARK),
                                  width: 2)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Container(
                                  child: Image(
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.contain,
                                    image:
                                        AssetImage('assets/images/scan_qr.png'),
                                  ),
                                ),
                                Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Text('Scan Customer QR')),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: Container(
                          height: 70,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
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
                                    margin: EdgeInsets.only(bottom: 7),
                                    child: TextField(
                                      keyboardType: TextInputType.text,
                                      controller: vehicleNumberInputController,
                                      inputFormatters: [
                                        UpperCaseTextFormatter()
                                      ],
                                      maxLength: 10,
                                      style: TextStyle(fontSize: 22),
                                      onChanged: (text) {
                                        if (text.length == 10) {
                                          FocusScope.of(context).unfocus();
                                        }
                                      },
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        isCollapsed: true,
                                        counterText: '',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ],
                ),
                (isConfirmedTicket || isConfirmedTicketFromQR)
                    ? showSuccessAlert(widthParent)
                    : Container()
              ],
            ),
          )
        ],
      ),
    ));
  }

  showSuccessAlert(double widthParent) {
    return Container(
      height: 650,
      width: widthParent,
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              Container(
                width: 200,
                height: 200,
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
                width: widthParent,
                margin: EdgeInsets.only(top: 150),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      //blurRadius: 7, // Adjust the blur radius of the shadow
                      offset: Offset(0, 3), // Offset of the shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          child: Padding(
                              padding: EdgeInsets.all(50),
                              child: Image(
                                image: AssetImage('assets/images/tick.png'),
                              )),
                        ),
                        Positioned(
                            top: 40,
                            left: 50,
                            child: Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  color: Color(CustomColors.GREEN_BUTTON),
                                  borderRadius: BorderRadius.circular(20)),
                            )),
                        Positioned(
                            top: 130,
                            left: 40,
                            child: Container(
                              height: 12,
                              width: 12,
                              decoration: BoxDecoration(
                                  color: Color(CustomColors.GREEN_BUTTON),
                                  borderRadius: BorderRadius.circular(20)),
                            )),
                        Positioned(
                            top: 170,
                            left: 100,
                            child: Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                  color: Color(CustomColors.GREEN_BUTTON),
                                  borderRadius: BorderRadius.circular(20)),
                            )),
                        Positioned(
                            top: 170,
                            right: 70,
                            child: Container(
                              height: 5,
                              width: 5,
                              decoration: BoxDecoration(
                                  color: Color(CustomColors.GREEN_BUTTON),
                                  borderRadius: BorderRadius.circular(20)),
                            )),
                        Positioned(
                            top: 130,
                            right: 50,
                            child: Container(
                              height: 8,
                              width: 8,
                              decoration: BoxDecoration(
                                  color: Color(CustomColors.GREEN_BUTTON),
                                  borderRadius: BorderRadius.circular(20)),
                            )),
                        Positioned(
                            top: 33,
                            right: 50,
                            child: Container(
                              height: 15,
                              width: 15,
                              decoration: BoxDecoration(
                                  color: Color(CustomColors.GREEN_BUTTON),
                                  borderRadius: BorderRadius.circular(20)),
                            )),
                      ],
                    ),
                    Container(
                      child: payFromWallet ? Text(
                        'Paid From Wallet : $charges Rs ',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(CustomColors.GREEN_BUTTON)),
                      ) : Text(
                        'Collect Cash : $charges Rs ',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(CustomColors.GREEN_BUTTON)),
                      ),
                    ),
                    isLoadingSwipe
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
                        : SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 20, bottom: 20, left: 16, right: 16),
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10),
                                  child: SwipeButton(
                                    activeThumbColor:
                                        Colors.white.withOpacity(0.8),
                                    thumbPadding: EdgeInsets.all(4),
                                    activeTrackColor:
                                        Color(CustomColors.GREEN_BUTTON),
                                    inactiveThumbColor: Colors.black,
                                    inactiveTrackColor: Colors.red,
                                    child: Text(
                                      "Swipe to Give Exit",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    onSwipe: () {
                                      if (isConfirmedTicket) {
                                        confirmExit();
                                      } else {
                                        confirmExitQR();
                                      }
                                    },
                                  )),
                            ),
                          )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void verifyOtp(String otp) async {
    try{


    if (otp.length != 4) {
      setState(() {
        isOtpValid = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
    });


      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      String? accessToken = sharedPreferences.getString(Constants.ACCESS_TOKEN);

      final dio = Dio(BaseOptions(contentType: "application/json"));
      dio.interceptors.add(AuthInterceptor(accessToken!));

    try {

      final ApiService apiService = ApiService(dio);

      final ExitOtpResponse response =
          await apiService.verifyExitOtp(OtpExitRequest(otp));
      if (response.message == null) {
        print('otp call done' + response.parkingTicketID!);
        final ParkingChargesResponse parkingChargesResponse =
            await apiService.getParkingCharges(response.parkingTicketID!);

        setState(() {
          pinController.clear();
          charges = parkingChargesResponse.parkingCharges;
          parkingTicketID = response.parkingTicketID!;
          vehicleNumberInputController.setText(response.vehicleNo!);
          isConfirmedTicketFromQR1 = true;
        });
      } else {
        isOtpValid = false;
        print('EF1--' + response.message!);
      }
      setState(() {
        isLoading = false;
      });
    } on DioException catch (e) {
      if(e.response?.statusCode == 400){
        String errorMessage = e.response?.data['message'];
        print("errorMessage---" + errorMessage.toString());
        CommonUtil().showToast(errorMessage);
      }
      else{
        CommonUtil().showToast(Constants.GENERIC_ERROR_MESSAGE);
      }
      setState(() {
        isLoading = false;
        isOtpValid = false;
      });
      print(e.toString());
    }
    }catch(e){
      setState(() {
        isLoading = false;
        isOtpValid = false;
      });
      CommonUtil().showToast(Constants.GENERIC_ERROR_MESSAGE);
    }
  }

  void checkIsConfirmedTicket(bool isConfirmedTicketFromQ) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    print('123--' + isConfirmedTicketFromQR.toString());

    try{



    if (isConfirmedTicketFromQ) {
      try {
        final SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();

        String? accessToken =
            sharedPreferences.getString(Constants.ACCESS_TOKEN);
        String? parkingTicketID =
            sharedPreferences.getString(Constants.PARKING_TICKET_ID_AUTO);

        final dio = Dio(BaseOptions(contentType: "application/json"));
        dio.interceptors.add(AuthInterceptor(accessToken!));

        final ApiService apiService = ApiService(dio);

        final ParkingChargesResponse parkingChargesResponse =
            await apiService.getParkingCharges(parkingTicketID!);

        setState(() {
          isConfirmedTicketFromQR = true;
          charges = parkingChargesResponse.parkingCharges;
          payFromWallet = parkingChargesResponse.payFromWallet;
        });
      } catch (e) {
        try{


        final SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();

        String? accessToken =
            sharedPreferences.getString(Constants.ACCESS_TOKEN);

        final dio = Dio(BaseOptions(contentType: "application/json"));
        dio.interceptors.add(AuthInterceptor(accessToken!));

        final ApiService apiService = ApiService(dio);

        final ParkingChargesResponse parkingChargesResponse =
            await apiService.getParkingCharges(parkingTicketID);

        setState(() {
          isConfirmedTicket = true;
          charges = parkingChargesResponse.parkingCharges;
          payFromWallet = parkingChargesResponse.payFromWallet;
        });
        print(e.toString());
        }on DioException catch(e){
          if(e.response?.statusCode == 400){
            String errorMessage = e.response?.data['message'];
            print("errorMessage---" + errorMessage.toString());
            CommonUtil().showToast(errorMessage);
          }
          else{
            CommonUtil().showToast(Constants.GENERIC_ERROR_MESSAGE);
          }
        }
      }
    }
    }catch(e){
      CommonUtil().showToast(Constants.GENERIC_ERROR_MESSAGE);
    }
  }

  void confirmExit() async {
    setState(() {
      isLoading = true;
      isLoadingSwipe = true;
    });

    try {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      String? accessToken = sharedPreferences.getString(Constants.ACCESS_TOKEN);
      String? employeeID = sharedPreferences.getString(Constants.EMPLOYEE_ID);

      final dio = Dio(BaseOptions(contentType: "application/json"));
      dio.interceptors.add(AuthInterceptor(accessToken!));
      try {
        final ApiService apiService = ApiService(dio);

        final ConfirmExitResponse response = await apiService
            .confirmExit(ExitVehicleRequest(parkingTicketID, employeeID!));
        print('msgotp--' + response.successMessage);
        if (response.successMessage == "Vehicle exited safely") {
          Navigator.of(context).pushNamed('/ExitVehicleFragment3');
        }
        setState(() {
          isLoading = false;
          isLoadingSwipe = true;
          isConfirmedTicket = false;
          isConfirmedTicketFromQR = false;
          sharedPreferences.setBool(Constants.IS_TICKET_CONFIRMED, false);
        });
      } on DioException catch (e) {
        if (e.response?.statusCode == 400) {
          String errorMessage = e.response?.data['message'];
          print("errorMessage---" + errorMessage.toString());
          CommonUtil().showToast(errorMessage);
        } else {
          CommonUtil().showToast(Constants.GENERIC_ERROR_MESSAGE);
        }
        setState(() {
          isLoading = false;
        });
        print(e.toString());
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      CommonUtil().showToast(Constants.GENERIC_ERROR_MESSAGE);
    }
  }

  void confirmExitQR() async {
    setState(() {
      isLoading = true;
      isConfirmedTicket = true;
    });

    try {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      sharedPreferences.setBool(Constants.IS_EXIT_CONFIRMED, true);

      String? accessToken = sharedPreferences.getString(Constants.ACCESS_TOKEN);
      String? employeeID = sharedPreferences.getString(Constants.EMPLOYEE_ID);
      String? parkingTicketIDAuto =
          sharedPreferences.getString(Constants.PARKING_TICKET_ID_AUTO);

      final dio = Dio(BaseOptions(contentType: "application/json"));
      dio.interceptors.add(AuthInterceptor(accessToken!));

      // try {
        final ApiService apiService = ApiService(dio);

        final ConfirmExitResponse response = await apiService
            .confirmExit(ExitVehicleRequest(parkingTicketIDAuto!, employeeID!));
        print("appfrag--" + response.successMessage);
        if (response.successMessage == "Vehicle exited safely") {
          sharedPreferences.setBool(Constants.IS_TICKET_CONFIRMED, false);
          sharedPreferences.setString(Constants.PARKING_TICKET_ID_AUTO, "");

          Navigator.of(context).pushNamed('/ExitVehicleFragment3');
        }
        setState(() {
          isLoading = false;
          isConfirmedTicketFromQR = false;
          isConfirmedTicket = false;
          isConfirmedTicketFromQR = false;
          sharedPreferences.setBool(Constants.IS_TICKET_CONFIRMED, false);
        });
      } on DioException catch (e) {
        if (e.response?.statusCode == 400) {
          String errorMessage = e.response?.data['message'];
          print("errorMessage---" + errorMessage.toString());
          CommonUtil().showToast(errorMessage);
        } else {
          CommonUtil().showToast(Constants.GENERIC_ERROR_MESSAGE);
        }
        setState(() {
          isLoading = false;
        });
        print(e.toString());
      }
    // } catch (e) {
    //   setState(() {
    //     isLoading = false;
    //   });
    //   CommonUtil().showToast(Constants.GENERIC_ERROR_MESSAGE);
    // }
  }

  void populateList() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? accessToken = sharedPreferences.getString(Constants.ACCESS_TOKEN);
      String? employeeID = sharedPreferences.getString(Constants.EMPLOYEE_ID);

      try {
        final dio = Dio(BaseOptions(contentType: "application/json"));
        dio.interceptors.add(AuthInterceptor(accessToken!));

        final ApiService apiService = ApiService(dio);

        final response = await apiService.getParkingSpaceStats(employeeID!);

        print('bject---' + response.toString());

        setState(() {
          exitVehicleList = response.exitVehicleList;
          isLoadingList = false;
          sharedPreferences.setString(Constants.VEHICLE_NUMBER, "");
        });
      } on DioException catch (e) {
        if (e.response?.statusCode == 400) {
          String errorMessage = e.response?.data['message'];
          print("errorMessage---" + errorMessage.toString());
          CommonUtil().showToast(errorMessage);
        } else {
          CommonUtil().showToast(Constants.GENERIC_ERROR_MESSAGE);
        }
        setState(() {
          isError = true;
        });
        print('error123' + e.toString());
      }
    } catch (e) {
      setState(() {
        isError = true;
      });
      CommonUtil().showToast(Constants.GENERIC_ERROR_MESSAGE);
    }
  }

  void initialiseButton() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    setState(() {
      isConfirmedTicketFromQR1 =
          sharedPreferences.getBool(Constants.IS_TICKET_CONFIRMED)!;
      vehicleNumberInputController
          .setText(sharedPreferences.getString(Constants.VEHICLE_NUMBER)!);
    });
  }

  void clearPrefs() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(Constants.IS_TICKET_CONFIRMED, false);
    sharedPreferences.setString(Constants.VEHICLE_NUMBER, "");
  }
}
