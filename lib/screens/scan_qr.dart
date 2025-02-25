import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parkey_employee/models/get_ticket_response.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Clippers/login_done_clipper1.dart';
import '../Clippers/login_screen_clipper2.dart';
import '../UIComponents/back_top_title.dart';
import '../colors/CustomColors.dart';
import '../models/confirm_ticket_request.dart';
import '../models/response.dart';
import '../services/api_service.dart';
import '../utils/Constants.dart';
import '../utils/auth_interceptor.dart';
import '../utils/common_util.dart';
import 'home_screen.dart';

class ScanQrScreen extends StatefulWidget {
  final PageController controller;

  ScanQrScreen({required this.controller,super.key});

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isLoading = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    double widthParent = MediaQuery.of(context).size.width;
    double parentHeight = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Material(
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
                      color: Color(CustomColors.PURPLE_DARK).withOpacity(0.7)),
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
          ClipPath(
            clipper: LoginDoneClipper1(),
            child: Container(
              height: 130,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Color(CustomColors.PURPLE_DARK)),
            ),
          ),
          Column(
            children: [
              BackTopTitle(
                  context,'', Colors.white, 'Scan QR', ''),
              Expanded(flex: 4, child: _buildQrView(context)),
            ],
          ),
          isLoading ? Center(
            child: Container(
              margin: EdgeInsets.only(top: parentHeight*0.2),
              height: 300,
              width: 300,
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
          ) : Positioned(
            top: 120,
            right: 30,
            child: GestureDetector(
              onTap: () async {
                await controller?.toggleFlash();
                setState(() {});
              },
              child: Container(
                child: SvgPicture.asset('assets/Icons/flash.svg'),
              ),
            ),
          )
        ],
      ),
    ));
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 300.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      print('qrdata---' + result!.code.toString());

      confirmTicketApiCall(result!.code.toString());
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void confirmTicketApiCall(String parkingTicketID) async {
    setState(() {
      isLoading = true;
    });


      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      String? accessToken = sharedPreferences.getString(Constants.ACCESS_TOKEN);
      String? employeeID = sharedPreferences.getString(Constants.EMPLOYEE_ID);

      final dio = Dio(BaseOptions(contentType: "application/json"));
      dio.interceptors.add(AuthInterceptor(accessToken!));

      final ApiService apiService = ApiService(dio);

      print('parking---' + parkingTicketID);
    try {
      final GetTicketResponse response = await apiService.getTicket(parkingTicketID, employeeID!);
      print('getticketresponse--' + response.toString());
      if (response.parkingStatus == Constants.IN_PROGRESS) {
        sharedPreferences.setBool(Constants.IS_TICKET_CONFIRMED, true);
        sharedPreferences.setString(Constants.PARKING_TICKET_ID_AUTO, parkingTicketID);
        sharedPreferences.setString(Constants.VEHICLE_NUMBER, response.vehicleNo);
        sharedPreferences.setString(Constants.MOBILE_NUMBER, response.mobileNo);
        widget.controller.jumpToPage(2);
        // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>HomeScreen(2,0)));
      }
      else if(response.parkingStatus == Constants.PARKED){
        sharedPreferences.setBool(Constants.IS_TICKET_CONFIRMED, true);
        sharedPreferences.setString(Constants.PARKING_TICKET_ID_AUTO, parkingTicketID);
        sharedPreferences.setString(Constants.VEHICLE_NUMBER, response.vehicleNo);
        widget.controller.jumpToPage(4);

        // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>HomeScreen(4,0)));
      }
      else if(response.parkingStatus == Constants.EXITED){
        sharedPreferences.setBool(Constants.IS_TICKET_CONFIRMED, true);
        sharedPreferences.setString(Constants.PARKING_TICKET_ID_AUTO, parkingTicketID);
        widget.controller.jumpToPage(2);

        // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>HomeScreen(2,0)));
      }

    } on DioException catch (e) {
      if(e.response?.statusCode == 400){
        String errorMessage = e.response?.data['message'];
        print("errorMessage---" + errorMessage.toString());
        CommonUtil().showToast(errorMessage);
      }
      else{
        CommonUtil().showToast(Constants.GENERIC_ERROR_MESSAGE);
      }
      print(e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }
}
