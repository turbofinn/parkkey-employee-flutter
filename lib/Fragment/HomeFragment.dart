import 'dart:convert';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:parkey_employee/models/parking_space_stats_response.dart';
import 'package:parkey_employee/screens/home_screen.dart';
import 'package:parkey_employee/screens/scan_qr.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Clippers/login_screen_clipper1.dart';
import '../Clippers/login_screen_clipper2.dart';
import '../colors/CustomColors.dart';
import '../services/api_service.dart';
import '../utils/Constants.dart';
import '../utils/auth_interceptor.dart';
import '../utils/common_util.dart';

class HomeFragment extends StatefulWidget {
  final PageController controller;

  HomeFragment({required this.controller});

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  List<Vehicle> entryVehicleList = [];
  List<Vehicle> exitVehicleList = [];
  String parkingStatus = "";
  int totalParkedVehicle = 0;
  int capacity = 0;
  int todayRevenue = 0;
  int vehicleParkedToday = 0;
  int onlinePayment = 0,cashPayment = 0;
  bool isLoading = true;
  bool showEntryList = true;
  bool showExitList = false;
  bool isError = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getParkingSpaceStats();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double parentHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Material(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: ClipPath(
                    clipper: LoginScreenClipper1(),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(CustomColors.PURPLE_LIGHT),
                          Color(CustomColors.PURPLE_DARK).withOpacity(0.5)
                        ],
                      )),
                    ),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: ClipPath(
                    clipper: LoginScreenClipper2(),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(CustomColors.PURPLE_LIGHT).withOpacity(0.1),
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
            isError
                ? Center(
                    child: Container(
                      child: Text('Some Error Occured'),
                    ),
                  )
                : Container(
                    margin: EdgeInsets.only(bottom: 70),
                    child: ListView(
                      children: [
                        Column(
                          children: [
                            isLoading
                                ? Center(
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          top: parentHeight * 0.2),
                                      height: 300,
                                      width: 300,
                                      child: SizedBox(
                                        child: Transform.scale(
                                          scale: 0.2,
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Color(CustomColors
                                                        .GREEN_BUTTON)),
                                            strokeWidth: 25,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Color(CustomColors
                                                      .GREEN_BUTTON),
                                                  width: 2),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 10),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    'History \nLast 3-4 vehicles',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        color: Color(
                                                            CustomColors
                                                                .PURPLE_DARK),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          showEntryList = true;
                                                          showExitList = false;
                                                        });
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color: showEntryList
                                                                ? Color(CustomColors
                                                                    .GREEN_BUTTON)
                                                                : Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            border: Border.all(
                                                                color: Color(
                                                                    CustomColors
                                                                        .GREEN_BUTTON),
                                                                width: 2)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 16,
                                                                  right: 16,
                                                                  top: 4,
                                                                  bottom: 4),
                                                          child: Text(
                                                            'Entry',
                                                            style: TextStyle(
                                                                color: showEntryList
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          showExitList = true;
                                                          showEntryList = false;
                                                        });
                                                      },
                                                      child: Container(
                                                        margin: EdgeInsets.only(
                                                            left: 10),
                                                        decoration: BoxDecoration(
                                                            color: showExitList
                                                                ? Color(CustomColors
                                                                    .GREEN_BUTTON)
                                                                : Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            border: Border.all(
                                                                color: Color(
                                                                    CustomColors
                                                                        .GREEN_BUTTON),
                                                                width: 2)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 18,
                                                                  right: 18,
                                                                  top: 4,
                                                                  bottom: 4),
                                                          child: Text(
                                                            'Exit',
                                                            style: TextStyle(
                                                                color: showExitList
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                showEntryList
                                                    ? Column(
                                                        children: [
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 10),
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: Color(
                                                                        CustomColors
                                                                            .GREEN_BUTTON),
                                                                    width: 2),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Column(
                                                                    children: [
                                                                      Container(
                                                                        child:
                                                                            Text(
                                                                          'Parking Time',
                                                                          style: TextStyle(
                                                                              color: Color(CustomColors.PURPLE_DARK),
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.w600),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        child:
                                                                            Text(
                                                                          entryVehicleList.length > 0
                                                                              ? entryVehicleList.elementAt(0).parkingDuration!
                                                                              : "0 hr",
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 10,
                                                                              fontWeight: FontWeight.w600),
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
                                                                        child:
                                                                            Text(
                                                                          entryVehicleList.length > 0
                                                                              ? entryVehicleList.elementAt(0).vehicleNo!
                                                                              : "XX XX XX XXXX",
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.w600),
                                                                        ),
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Container(
                                                                            child:
                                                                                Text(
                                                                              entryVehicleList.length > 0 ? CommonUtil().maskNumber(entryVehicleList.elementAt(0).customerNo!) : "XXXXXXXXXX",
                                                                              style: TextStyle(fontSize: 10),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            margin:
                                                                                EdgeInsets.only(left: 20),
                                                                            child:
                                                                                Text(
                                                                              entryVehicleList.length > 0 ? '₹ ' + entryVehicleList.elementAt(0).parkingCharge.toString() : 'Paid Up : ₹ 0' + '/-',
                                                                              style: TextStyle(fontSize: 12),
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
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 10),
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: Color(
                                                                        CustomColors
                                                                            .GREEN_BUTTON),
                                                                    width: 2),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Column(
                                                                    children: [
                                                                      Container(
                                                                        child:
                                                                            Text(
                                                                          'Parking Time',
                                                                          style: TextStyle(
                                                                              color: Color(CustomColors.PURPLE_DARK),
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.w600),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        child:
                                                                            Text(
                                                                          entryVehicleList.length > 1
                                                                              ? entryVehicleList.elementAt(1).parkingDuration!
                                                                              : "0 hr",
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 10,
                                                                              fontWeight: FontWeight.w600),
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
                                                                        child:
                                                                            Text(
                                                                          entryVehicleList.length > 1
                                                                              ? entryVehicleList.elementAt(1).vehicleNo!
                                                                              : "XX XX XX XXXX",
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.w600),
                                                                        ),
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Container(
                                                                            child:
                                                                                Text(
                                                                              entryVehicleList.length > 1 ? CommonUtil().maskNumber(entryVehicleList.elementAt(1).customerNo!) : "XXXXXXXXXX",
                                                                              style: TextStyle(fontSize: 10),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            margin:
                                                                                EdgeInsets.only(left: 20),
                                                                            child:
                                                                                Text(
                                                                              entryVehicleList.length > 1 ? '₹ ' + entryVehicleList.elementAt(1).parkingCharge! + '/-' : 'Paid Up : ₹ 0/-',
                                                                              style: TextStyle(fontSize: 12),
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
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 10),
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: Color(
                                                                        CustomColors
                                                                            .GREEN_BUTTON),
                                                                    width: 2),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Column(
                                                                    children: [
                                                                      Container(
                                                                        child:
                                                                            Text(
                                                                          'Parking Time',
                                                                          style: TextStyle(
                                                                              color: Color(CustomColors.PURPLE_DARK),
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.w600),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        child:
                                                                            Text(
                                                                          entryVehicleList.length > 2
                                                                              ? entryVehicleList.elementAt(2).parkingDuration!
                                                                              : "0 hr",
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 10,
                                                                              fontWeight: FontWeight.w600),
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
                                                                        child:
                                                                            Text(
                                                                          entryVehicleList.length > 2
                                                                              ? entryVehicleList.elementAt(2).vehicleNo!
                                                                              : "XX XX XX XXXX",
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.w600),
                                                                        ),
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Container(
                                                                            child:
                                                                                Text(
                                                                              entryVehicleList.length > 2 ? CommonUtil().maskNumber(entryVehicleList.elementAt(2).customerNo!) : "XXXXXXXXXX",
                                                                              style: TextStyle(fontSize: 10),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            margin:
                                                                                EdgeInsets.only(left: 20),
                                                                            child:
                                                                                Text(
                                                                              entryVehicleList.length > 2 ? '₹ ' + entryVehicleList.elementAt(2).parkingCharge! + '/-' : 'Paid Up : ₹ 0/-',
                                                                              style: TextStyle(fontSize: 12),
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
                                                      )
                                                    : Column(
                                                        children: [
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 10),
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: Color(
                                                                        CustomColors
                                                                            .GREEN_BUTTON),
                                                                    width: 2),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Column(
                                                                    children: [
                                                                      Container(
                                                                        child:
                                                                            Text(
                                                                          'Parking Time',
                                                                          style: TextStyle(
                                                                              color: Color(CustomColors.PURPLE_DARK),
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.w600),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        child:
                                                                            Text(
                                                                          exitVehicleList.length > 0
                                                                              ? exitVehicleList.elementAt(0).parkingDuration!
                                                                              : "0 hr",
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 10,
                                                                              fontWeight: FontWeight.w600),
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
                                                                        child:
                                                                            Text(
                                                                          exitVehicleList.length > 0
                                                                              ? exitVehicleList.elementAt(0).vehicleNo!
                                                                              : "XX XX XX XXXX",
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.w600),
                                                                        ),
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Container(
                                                                            child:
                                                                                Text(
                                                                              exitVehicleList.length > 0 ? CommonUtil().maskNumber(exitVehicleList.elementAt(0).customerNo!) : "XXXXXXXXXX",
                                                                              style: TextStyle(fontSize: 10),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            margin:
                                                                                EdgeInsets.only(left: 20),
                                                                            child:
                                                                                Text(
                                                                              exitVehicleList.length > 0 ? '₹ ' + exitVehicleList.elementAt(0).parkingCharge! + '/-' : 'Paid Up : ₹ 0/-',
                                                                              style: TextStyle(fontSize: 12),
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
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 10),
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: Color(
                                                                        CustomColors
                                                                            .GREEN_BUTTON),
                                                                    width: 2),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Column(
                                                                    children: [
                                                                      Container(
                                                                        child:
                                                                            Text(
                                                                          'Parking Time',
                                                                          style: TextStyle(
                                                                              color: Color(CustomColors.PURPLE_DARK),
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.w600),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        child:
                                                                            Text(
                                                                          exitVehicleList.length > 1
                                                                              ? exitVehicleList.elementAt(1).parkingDuration!
                                                                              : "0 hr",
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 10,
                                                                              fontWeight: FontWeight.w600),
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
                                                                        child:
                                                                            Text(
                                                                          exitVehicleList.length > 1
                                                                              ? exitVehicleList.elementAt(1).vehicleNo!
                                                                              : "XX XX XX XXXX",
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.w600),
                                                                        ),
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Container(
                                                                            child:
                                                                                Text(
                                                                              exitVehicleList.length > 1 ? CommonUtil().maskNumber(exitVehicleList.elementAt(1).customerNo!) : "XXXXXXXXXX",
                                                                              style: TextStyle(fontSize: 10),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            margin:
                                                                                EdgeInsets.only(left: 20),
                                                                            child:
                                                                                Text(
                                                                              exitVehicleList.length > 1 ? '₹ ' + exitVehicleList.elementAt(1).parkingCharge! + '/-' : 'Paid Up : ₹ 0/-',
                                                                              style: TextStyle(fontSize: 12),
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
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 10),
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: Color(
                                                                        CustomColors
                                                                            .GREEN_BUTTON),
                                                                    width: 2),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Column(
                                                                    children: [
                                                                      Container(
                                                                        child:
                                                                            Text(
                                                                          'Parking Time',
                                                                          style: TextStyle(
                                                                              color: Color(CustomColors.PURPLE_DARK),
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.w600),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        child:
                                                                            Text(
                                                                          exitVehicleList.length > 2
                                                                              ? exitVehicleList.elementAt(2).parkingDuration!
                                                                              : "0 hr",
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 10,
                                                                              fontWeight: FontWeight.w600),
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
                                                                        child:
                                                                            Text(
                                                                          exitVehicleList.length > 2
                                                                              ? exitVehicleList.elementAt(2).vehicleNo!
                                                                              : "XX XX XX XXXX",
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.w600),
                                                                        ),
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Container(
                                                                            child:
                                                                                Text(
                                                                              exitVehicleList.length > 2 ? CommonUtil().maskNumber(exitVehicleList.elementAt(2).customerNo!) : "XXXXXXXXXX",
                                                                              style: TextStyle(fontSize: 10),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            margin:
                                                                                EdgeInsets.only(left: 20),
                                                                            child:
                                                                                Text(
                                                                              exitVehicleList.length > 2 ? '₹ ' + exitVehicleList.elementAt(2).parkingCharge! + '/-' : 'Paid Up : ₹ 0/-',
                                                                              style: TextStyle(fontSize: 12),
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
                                                      )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: Color(CustomColors
                                                      .GREEN_BUTTON),
                                                  width: 2)),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 18,
                                                bottom: 18,
                                                left: 8,
                                                right: 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(left: 12),
                                                  child: Text(
                                                    'Parking Status: ',
                                                    style: TextStyle(
                                                        color: Color(
                                                            CustomColors
                                                                .PURPLE_DARK),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                                Container(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 16,
                                                            bottom: 16,
                                                            left: 8,
                                                            right: 8),
                                                    child: Text(
                                                      '           $parkingStatus ',
                                                      style: TextStyle(
                                                          color: Color(
                                                              CustomColors
                                                                  .GREEN_BUTTON),
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: Color(CustomColors
                                                      .GREEN_BUTTON),
                                                  width: 2)),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 18,
                                                bottom: 18,
                                                left: 8,
                                                right: 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Column(
                                                  children: [
                                                    Container(
                                                      child: Text(
                                                        'No. Of Parked Vehicle',
                                                        style: TextStyle(
                                                            fontSize: 10),
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        totalParkedVehicle
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 28,
                                                            color: Color(
                                                                CustomColors
                                                                    .PURPLE_DARK)),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Container(
                                                      child: Text(
                                                        'No. Of Vacant Area',
                                                        style: TextStyle(
                                                            fontSize: 10),
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        (capacity -
                                                                totalParkedVehicle)
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 28,
                                                            color: Color(
                                                                CustomColors
                                                                    .PURPLE_DARK)),
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: Color(CustomColors
                                                      .GREEN_BUTTON),
                                                  width: 2)),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 18,
                                                bottom: 18,
                                                left: 8,
                                                right: 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Column(
                                                  children: [
                                                    Container(
                                                      child: Text(
                                                        'Revenue Till Now :',
                                                        style: TextStyle(
                                                            fontSize: 10),
                                                      ),
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            todayRevenue
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 28,
                                                                color: Color(
                                                                    CustomColors
                                                                        .PURPLE_DARK)),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  bottom: 5),
                                                          child: Text(
                                                            'Whole Day',
                                                            style: TextStyle(
                                                                fontSize: 14),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Container(
                                                      child: Text(
                                                        'Vehicle Parked Today :',
                                                        style: TextStyle(
                                                            fontSize: 10),
                                                      ),
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            vehicleParkedToday
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 28,
                                                                color: Color(
                                                                    CustomColors
                                                                        .PURPLE_DARK)),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  bottom: 5),
                                                          child: Text(
                                                            'Till Now',
                                                            style: TextStyle(
                                                                fontSize: 14),
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
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: Color(CustomColors
                                                      .GREEN_BUTTON),
                                                  width: 2)),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 18,
                                                bottom: 18,
                                                left: 8,
                                                right: 8),
                                            child: Column(
                                              children: [
                                                Container(
                                                  child: Text(
                                                    ' Today’s Amount In',
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            'Cash :',
                                                            style: TextStyle(
                                                                fontSize: 10),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            'Inr. $cashPayment',
                                                            style: TextStyle(
                                                                fontSize: 28,
                                                                color: Color(
                                                                    CustomColors
                                                                        .PURPLE_DARK)),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Container(
                                                      width: 2,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                          color: Colors.black),
                                                    ),
                                                    Column(
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            'Online Payment :',
                                                            style: TextStyle(
                                                                fontSize: 10),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            onlinePayment.toString(),
                                                            style: TextStyle(
                                                                fontSize: 28,
                                                                color: Color(
                                                                    CustomColors
                                                                        .PURPLE_DARK)),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: Color(CustomColors
                                                      .GREEN_BUTTON),
                                                  width: 2)),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 18,
                                                bottom: 18,
                                                left: 8,
                                                right: 8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      left: 20, bottom: 10),
                                                  child: Text(
                                                    'No. Of Vehicle Parked ',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Container(
                                                            child: Image(
                                                                image: AssetImage(
                                                                    'assets/images/bike.png'))),
                                                        Container(
                                                          child: Text(
                                                            'Bike',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 50,
                                                          height: 2,
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.3)),
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            '100',
                                                            style: TextStyle(
                                                                color: Color(
                                                                    CustomColors
                                                                        .PURPLE_DARK),
                                                                fontSize: 12),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        Container(
                                                            child: Image(
                                                                image: AssetImage(
                                                                    'assets/images/car.png'))),
                                                        Container(
                                                          child: Text(
                                                            'Bike',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 50,
                                                          height: 2,
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.3)),
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            '100',
                                                            style: TextStyle(
                                                                color: Color(
                                                                    CustomColors
                                                                        .PURPLE_DARK),
                                                                fontSize: 12),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        Container(
                                                            child: Image(
                                                                image: AssetImage(
                                                                    'assets/images/truck.png'))),
                                                        Container(
                                                          child: Text(
                                                            'Bike',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 50,
                                                          height: 2,
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.3)),
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            '100',
                                                            style: TextStyle(
                                                                color: Color(
                                                                    CustomColors
                                                                        .PURPLE_DARK),
                                                                fontSize: 12),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        Container(
                                                            child: Image(
                                                                image: AssetImage(
                                                                    'assets/images/cycle.png'))),
                                                        Container(
                                                          child: Text(
                                                            'Bike',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 50,
                                                          height: 2,
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.3)),
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            '100',
                                                            style: TextStyle(
                                                                color: Color(
                                                                    CustomColors
                                                                        .PURPLE_DARK),
                                                                fontSize: 12),
                                                          ),
                                                        )
                                                      ],
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
                          ],
                        )
                      ],
                    ),
                  ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        widget.controller.jumpToPage(2);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 15, bottom: 15, left: 15, right: 15),
                        child: Container(
                          child: Text(
                            'Enter Car',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(CustomColors.PURPLE_DARK),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          // Set border radius
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Color(CustomColors.PURPLE_DARK), width: 2),
                        borderRadius: BorderRadius.circular(20.0)),
                    child: ElevatedButton(
                      onPressed: () {
                        widget.controller.jumpToPage(4);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 15, bottom: 15, left: 15, right: 15),
                        child: Container(
                          child: Text(
                            'Exit Car',
                            style: TextStyle(color: Colors.black, fontSize: 18),
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
            )
          ],
        ),
      ),
    );
  }

  void getParkingSpaceStats() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? accessToken = sharedPreferences.getString(Constants.ACCESS_TOKEN);
      String? employeeID = sharedPreferences.getString(Constants.EMPLOYEE_ID);


      final dio = Dio(BaseOptions(contentType: "application/json"));
      dio.interceptors.add(AuthInterceptor(accessToken!));

      final ApiService apiService = ApiService(dio);

      final response = await apiService.getParkingSpaceStats(employeeID!);

      print('bject---' + response.toString());

      sharedPreferences.setInt(Constants.INITIAL_CHARGES, response.initialCharge ?? 0);
      sharedPreferences.setString(Constants.PAYMENT_MODE, response.paymentMode ?? "Cash");

      try {
        setState(() {
          entryVehicleList = response.entryVehicleList;
          exitVehicleList = response.exitVehicleList;
          parkingStatus = response.parkingStatus;
          totalParkedVehicle = response.totalParkedVehicle;
          capacity = response.capacity;
          todayRevenue = response.todayRevenue;
          vehicleParkedToday = response.vehicleParkedToday;
          onlinePayment = response.todayRevenueOnline;
          cashPayment = response.todayRevenueCash;
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          isError = true;
        });
        print('error123' + e.toString());
      }
    } catch (e) {
      print("Error Home");
      print(e);
      setState(() {
        isError = true;
      });
    }
  }
}
