import 'dart:convert';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:parkey_employee/Fragment/approved_fragment_screen2.dart';
import 'package:parkey_employee/UIComponents/back_top_title.dart';
import 'package:parkey_employee/models/create_customer_request.dart';
import 'package:parkey_employee/models/exit_vehicle_request.dart';
import 'package:parkey_employee/models/response.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Clippers/login_done_clipper1.dart';
import '../Clippers/login_screen_clipper2.dart';
import '../colors/CustomColors.dart';
import '../models/confirm_ticket_request.dart';
import '../models/create_customer_response.dart';
import '../models/parking_space_stats_response.dart';
import '../services/api_service.dart';
import '../utils/Constants.dart';
import '../utils/UpperCaseFormatter.dart';
import '../utils/auth_interceptor.dart';
import '../utils/common_util.dart';

class ApprovedFragment extends StatefulWidget {
  final PageController controller;

  const ApprovedFragment({required this.controller, super.key});

  @override
  State<ApprovedFragment> createState() => _ApprovedFragmentState();
}

class _ApprovedFragmentState extends State<ApprovedFragment> {
  final TextEditingController mobileNumberInputController =
      TextEditingController();
  final TextEditingController vehicleNumberInputController =
      TextEditingController();
  bool isLoading = false;
  bool isLoadingSwipe = false;
  final apiService =
      ApiService(Dio(BaseOptions(contentType: "application/json")));
  bool isConfirmedTicketFromQR = false;
  bool isConfirmedTicket = false;
  late String parkingTicketID;
  List<Vehicle> entryVehicleList = [];
  bool isLoadingList = true;
  bool isError = false;
  String vehicleNo = "";
  String mobileNo = "";
  String unmaskedMobileNo = ""; // To store the unmasked number for API use

  bool isFetchingMNo = false;
  static String initialCharges = "";
  static String paymentMode = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     populateList();
    checkIsConfirmedTicket();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    clearInputBox();
    vehicleNumberInputController.clear();
    mobileNumberInputController.clear();
  }

  @override
  Widget build(BuildContext context) {
    double widthParent = MediaQuery.of(context).size.width;
    double heightParent = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
      body: Material(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: widthParent,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30)),
                          color:
                              Color(CustomColors.PURPLE_DARK).withOpacity(0.7)),
                    ),
                  ),
                  Expanded(
                    flex: 3,
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
              ClipPath(
                clipper: LoginDoneClipper1(),
                child: Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  decoration:
                      BoxDecoration(color: Color(CustomColors.PURPLE_DARK)),
                ),
              ),
              ListView(
                children: [
                  BackTopTitle(context, '', Colors.white, 'Parking Entry', ''),
                  Column(
                    children: [
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
                                child: isError
                                    ? Center(
                                        child: Container(
                                          child: Text('Some Error Occured'),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(top: 10),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Color(CustomColors
                                                          .GREEN_BUTTON),
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Padding(
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
                                                            entryVehicleList
                                                                        .length >
                                                                    0
                                                                ? entryVehicleList
                                                                    .elementAt(
                                                                        0)
                                                                    .parkingDuration!
                                                                : "0 hr",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
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
                                                            entryVehicleList
                                                                        .length >
                                                                    0
                                                                ? entryVehicleList
                                                                    .elementAt(
                                                                        0)
                                                                    .vehicleNo!
                                                                : "XX XX XX XXXX",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
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
                                                                entryVehicleList
                                                                            .length >
                                                                        0
                                                                    ? CommonUtil().maskNumber(entryVehicleList
                                                                        .elementAt(
                                                                            0)
                                                                        .customerNo!)
                                                                    : "XXXXXXXXXX",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        10),
                                                              ),
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 20),
                                                              child: Text(
                                                                entryVehicleList
                                                                            .length >
                                                                        0
                                                                    ? '₹ ' +
                                                                        entryVehicleList
                                                                            .elementAt(0)
                                                                            .parkingCharge! +
                                                                        '/-'
                                                                    : 'Paid Up : ₹ 0/-',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12),
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
                                                      color: Color(CustomColors
                                                          .GREEN_BUTTON),
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Padding(
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
                                                            entryVehicleList
                                                                        .length >
                                                                    1
                                                                ? entryVehicleList
                                                                    .elementAt(
                                                                        1)
                                                                    .parkingDuration!
                                                                : "0 hr",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
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
                                                            entryVehicleList
                                                                        .length >
                                                                    1
                                                                ? entryVehicleList
                                                                    .elementAt(
                                                                        1)
                                                                    .vehicleNo!
                                                                : "XX XX XX XXXX",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
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
                                                                entryVehicleList
                                                                            .length >
                                                                        1
                                                                    ? CommonUtil().maskNumber(entryVehicleList
                                                                        .elementAt(
                                                                            1)
                                                                        .customerNo!)
                                                                    : "XXXXXXXXXX",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        10),
                                                              ),
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 20),
                                                              child: Text(
                                                                entryVehicleList
                                                                            .length >
                                                                        1
                                                                    ? '₹ ' +
                                                                        entryVehicleList
                                                                            .elementAt(1)
                                                                            .parkingCharge! +
                                                                        '/-'
                                                                    : 'Paid Up : ₹ 0/-',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12),
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
                                                      color: Color(CustomColors
                                                          .GREEN_BUTTON),
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Padding(
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
                                                            entryVehicleList
                                                                        .length >
                                                                    2
                                                                ? entryVehicleList
                                                                    .elementAt(
                                                                        2)
                                                                    .parkingDuration!
                                                                : "0 hr",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
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
                                                            entryVehicleList
                                                                        .length >
                                                                    2
                                                                ? entryVehicleList
                                                                    .elementAt(
                                                                        2)
                                                                    .vehicleNo!
                                                                : "XX XX XX XXXX",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
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
                                                                entryVehicleList
                                                                            .length >
                                                                        2
                                                                    ? CommonUtil().maskNumber(entryVehicleList
                                                                        .elementAt(
                                                                            2)
                                                                        .customerNo!)
                                                                    : "XXXXXXXXXX",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        10),
                                                              ),
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 20),
                                                              child: Text(
                                                                entryVehicleList
                                                                            .length >
                                                                        2
                                                                    ? '₹ ' +
                                                                        entryVehicleList
                                                                            .elementAt(2)
                                                                            .parkingCharge! +
                                                                        '/-'
                                                                    : 'Paid Up : ₹ 0/-',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12),
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
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(top: 50, left: 20),
                        child: Text(
                          'Choose Scan Method',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.controller.jumpToPage(1);
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
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
                                          width: 30,
                                          height: 30,
                                          fit: BoxFit.contain,
                                          image: AssetImage(
                                              'assets/images/scan_qr.png'),
                                        ),
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(left: 20),
                                          child: Text('Scan\nCustomer QR')),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
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
                                          width: 30,
                                          height: 30,
                                          fit: BoxFit.contain,
                                          image: AssetImage(
                                              'assets/images/scan_number_plate.png'),
                                        ),
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(left: 20),
                                          child: Text('Scan\nNumber Plate')),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(left: 20),
                        child: Text(
                          'Manual',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
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
                                        controller:
                                            vehicleNumberInputController,
                                        inputFormatters: [
                                          UpperCaseTextFormatter()
                                        ],
                                        maxLength: 10,
                                        style: TextStyle(fontSize: 22),
                                        onChanged: (text) {
                                          if (text.length == 10) {
                                                 FocusScope.of(context).unfocus();
                                                 fetchMobileNo(vehicleNumberInputController.text);
                                           } else {
                                                // Allow manual entry by clearing `mobileNo`
                                                 mobileNo = ""; 
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
                                  isFetchingMNo
                                      ? Container(
                                          width: 30,
                                          height: 30,
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Color(CustomColors
                                                        .GREEN_BUTTON)),
                                            strokeWidth: 4,
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            )),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 10),
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
                                  Text(
                                    '+91 ',
                                    style: TextStyle(fontSize: 22),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 7),
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        controller: mobileNumberInputController,
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
                              margin: EdgeInsets.only(top: 20),
                              child: ElevatedButton(
                                onPressed: () async {
                                  final SharedPreferences sharedPreferences =
                                      await SharedPreferences.getInstance();
                                  isConfirmedTicketFromQR = sharedPreferences
                                      .getBool(Constants.IS_TICKET_CONFIRMED)!;
                                  if (isConfirmedTicketFromQR) {
                                    setState(() {
                                      sharedPreferences.setBool(
                                          Constants.IS_TICKET_CONFIRMED, false);
                                      mobileNumberInputController.setText("");
                                      vehicleNumberInputController.setText("");
                                    });
                                  } else {
                                    createCustomer(
                                        vehicleNumberInputController.text,
                                        mobileNo!);
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, left: 50, right: 50),
                                  child: Container(
                                    child: Text(
                                      'Next',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color(CustomColors.GREEN_BUTTON),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        20.0), // Set border radius
                                  ),
                                ),
                              ),
                            )
                    ],
                  ),
                ],
              ),
              (isConfirmedTicket || isConfirmedTicketFromQR)
                  ? showSuccessAlert(widthParent)
                  : Container()
            ],
          ),
        ),
      ),
    ));
  }

  void createCustomer(String vehicleNumber, String mobileNumber) async {
    setState(() {
      isLoading = true;
    });

    print('veh--' + vehicleNumber + "--" + mobileNumber);

    try {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      String? accessToken = sharedPreferences.getString(Constants.ACCESS_TOKEN);
      String? employeeID = sharedPreferences.getString(Constants.EMPLOYEE_ID);

      final dio = Dio(BaseOptions(contentType: "application/json"));
      dio.interceptors.add(AuthInterceptor(accessToken!));
      try {
        final ApiService apiService = ApiService(dio);
        
         // Prioritize unmasked `mobileNo` if available; fallback to the text in `mobileNumberInputController`
      final String enteredMobileNo = unmaskedMobileNo.isNotEmpty 
    ? unmaskedMobileNo 
    : mobileNumberInputController.text;
      
        final CreateCustomerResponse response = await apiService.createCustomer(
            CreateCustomerRequest(
                'EMPLOYEE_APP', enteredMobileNo, vehicleNumber, employeeID!));
        if (response.parkingTicketID == null) {
          CommonUtil().showToast("Vehicle Already Parked");
          setState(() {
            isLoading = false;
          });
          return;
        }
        print('userid-----' + response.parkingTicketID!);
        if (response.vehicleNo != null) {
          String userID = response.userID;
          sharedPreferences.setString(Constants.USER_ID, userID);
          sharedPreferences.setString(Constants.VEHICLE_ID, response.vehicleID);
          sharedPreferences.setString(
              Constants.VEHICLE_NUMBER, response.vehicleNo);
          // Set initial charges and payment mode in SharedPreferences
        sharedPreferences.setString(Constants.INITIAL_CHARGES, response.initialCharge);
        sharedPreferences.setString(Constants.PAYMENT_MODE, response.paymentMode);

        // Set the variables for display
        setState(() {
          initialCharges = response.initialCharge;
          paymentMode = response.paymentMode;
        });
        
        print('Initial Charges createCustomer: ${response.initialCharge}');
        print('Payment Mode createCustome: ${response.paymentMode}');
        }
        
        setState(() {
          isLoading = false;
          parkingTicketID = response.parkingTicketID!;
          isConfirmedTicket = true;
        });
        
     //  populateList();

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

  void checkIsConfirmedTicket() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    setState(() {
      vehicleNumberInputController
          .setText(sharedPreferences.getString(Constants.VEHICLE_NUMBER)!);
      
       // Retrieve unmasked number and mask it for display
        unmaskedMobileNo = sharedPreferences.getString(Constants.MOBILE_NUMBER)!;
        mobileNumberInputController.setText(CommonUtil().maskNumber(unmaskedMobileNo).substring(3));
        
      sharedPreferences.setString(Constants.VEHICLE_NUMBER, "");
      sharedPreferences.setString(Constants.MOBILE_NUMBER, "");
    });
  }

  showSuccessAlert(double widthParent) {
    return Container(
      height: 650,
      width: widthParent,
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Container(
          width: widthParent,
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
                      child: Text(
                        'Collect $paymentMode : $initialCharges Rs ',
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
                              child: ElevatedButton(
                                onPressed: () {},
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
                                        "Swipe to Give Parking Spot",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      onSwipe: () {
                                        if (isConfirmedTicketFromQR) {
                                          entrySucess();
                                        } else {
                                          confirmEntry(parkingTicketID);
                                        }
                                      },
                                    )),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color(CustomColors.GREEN_BUTTON),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10.0), // Set border radius
                                  ),
                                ),
                              ),
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

  void entrySucess() async {
    setState(() {
      isLoadingSwipe = true;
    });
    try {
      print('inside entry success');

      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      String? accessToken = sharedPreferences.getString(Constants.ACCESS_TOKEN);
      String? employeeID = sharedPreferences.getString(Constants.EMPLOYEE_ID);
      String? parkingTicketID =
          sharedPreferences.getString(Constants.PARKING_TICKET_ID_AUTO);

      final dio = Dio(BaseOptions(contentType: "application/json"));
      dio.interceptors.add(AuthInterceptor(accessToken!));
      try {
        final ApiService apiService = ApiService(dio);

        final MyResponse response1 = await apiService.confirmTicket(
            ConfirmTicketRequest(
                parkingTicketID!, "CONFIRM_TICKET", employeeID!));

        print('response1---' + jsonEncode(response1));

        if (response1.message == "Parking successful") {
          sharedPreferences.setString(Constants.PARKING_TICKET_ID_AUTO, "");
          sharedPreferences.setBool(Constants.IS_TICKET_CONFIRMED, false);
          sharedPreferences.setString(Constants.VEHICLE_NUMBER, "");
          Navigator.of(context).pushNamed('/VehicleParkedFragment');
        }
        setState(() {
          isLoadingSwipe = false;
          isConfirmedTicket = false;
          isConfirmedTicketFromQR = false;
          mobileNumberInputController.clear();
          vehicleNumberInputController.clear();
        });
      } on DioException catch (e) {
        if (e.response?.statusCode == 400) {
          String errorMessage = e.response?.data['message'];
          print("errorMessage---" + errorMessage.toString());
          CommonUtil().showToast(errorMessage);
        } else {
          CommonUtil().showToast(Constants.GENERIC_ERROR_MESSAGE);
        }
        print(e.toString());
      }
    } catch (e) {
      CommonUtil().showToast(Constants.GENERIC_ERROR_MESSAGE);
    }
  }

  void confirmEntry(String parkingTicketID) async {
    setState(() {
      isLoadingSwipe = true;
    });

    try {
      print('inside confirm entry');

      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      String? accessToken = sharedPreferences.getString(Constants.ACCESS_TOKEN);
      String? employeeID = sharedPreferences.getString(Constants.EMPLOYEE_ID);

      final dio = Dio(BaseOptions(contentType: "application/json"));
      dio.interceptors.add(AuthInterceptor(accessToken!));

      try {
        final ApiService apiService = ApiService(dio);

        final MyResponse response1 = await apiService.confirmTicket(
            ConfirmTicketRequest(
                parkingTicketID, "CONFIRM_TICKET", employeeID!));
        if (response1.message == "Parking successful") {
          Navigator.of(context).pushNamed('/VehicleParkedFragment');
        }
        setState(() {
          isLoadingSwipe = false;
          isConfirmedTicket = false;
          mobileNumberInputController.clear();
          vehicleNumberInputController.clear();
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
          isLoadingSwipe = false;
        });
        print(e.toString());
      }
    } catch (e) {
      setState(() {
        isLoadingSwipe = false;
      });
      CommonUtil().showToast(Constants.GENERIC_ERROR_MESSAGE);
    }
  }

  void populateList() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? accessToken = sharedPreferences.getString(Constants.ACCESS_TOKEN);
      String? employeeID = sharedPreferences.getString(Constants.EMPLOYEE_ID);

      initialCharges =
          sharedPreferences.getInt(Constants.INITIAL_CHARGES).toString();
      paymentMode =
          sharedPreferences.getString(Constants.PAYMENT_MODE)?? "Cash";
      print('Initial Charges (from populateList): $initialCharges');
      print('Payment Mode (from populateList): $paymentMode');

      try {
        final dio = Dio(BaseOptions(contentType: "application/json"));
        dio.interceptors.add(AuthInterceptor(accessToken!));

        final ApiService apiService = ApiService(dio);

        final response = await apiService.getParkingSpaceStats(employeeID!);

        print('bject---' + response.toString());

        setState(() {
          entryVehicleList = response.entryVehicleList;
          isLoadingList = false;
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

  void clearInputBox() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(Constants.VEHICLE_NUMBER, "");
    sharedPreferences.setString(Constants.MOBILE_NUMBER, "");
  }

  void fetchMobileNo(String vehicleNumber) async {
    print('Inside Fetch');
    setState(() {
      isFetchingMNo = true;
    });
    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String? accessToken = sharedPreferences.getString(Constants.ACCESS_TOKEN);

      final dio = Dio(BaseOptions(contentType: "application/json"));
      dio.interceptors.add(AuthInterceptor(accessToken!));

      final ApiService apiService = ApiService(dio);

      try {
        final response = await apiService.getVehicleDetails(vehicleNumber);
        if (response.mobileNo != null) {
          // Store the unmasked mobile number for API usage
          unmaskedMobileNo = response.mobileNo!;
          
          // Display only the masked version in the TextField
          mobileNumberInputController.text = CommonUtil().maskNumber(unmaskedMobileNo).substring(3);
        } else {
          // Clear the mobile number to allow manual entry
          mobileNumberInputController.clear();
          unmaskedMobileNo = "";  // Reset if not found
          CommonUtil().showToast("Vehicle not present in the system. Please enter manually.");
        }
      } catch (e) {
        // Display a message for the manual entry case
        CommonUtil().showToast("Vehicle not present in the system. Please enter manually.");
        mobileNumberInputController.clear(); // Clear field to allow typing
        unmaskedMobileNo = ""; // Reset in case of error
      }
    } catch (e) {
      print('Inside catch block');
      CommonUtil().showToast(Constants.GENERIC_ERROR_MESSAGE);
    } finally {
      setState(() {
        isFetchingMNo = false;
      });
    }
  }


}
