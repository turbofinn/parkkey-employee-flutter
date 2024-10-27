import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../UIComponents/back_top_title.dart';
import '../UIComponents/history_item.dart';
import '../colors/CustomColors.dart';
import '../models/entry_vehicle_list_response.dart';
import '../models/parking_space_stats_response.dart';
import '../services/api_service.dart';
import '../utils/Constants.dart';
import '../utils/auth_interceptor.dart';
import '../utils/common_util.dart';

class HistoryFragment extends StatefulWidget {
  BuildContext context;

  HistoryFragment({required this.context,super.key});

  @override
  State<HistoryFragment> createState() => _HistoryFragmentState();
}

class _HistoryFragmentState extends State<HistoryFragment> {
  List<EntryVehicleListResponseVehicle> vehicleList = [];
  bool isLoading = true;
  bool isError = false;
  bool isVehicleListEmpty = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('object');
    print(widget.context);
    getHistoryList();
  }

  @override
  Widget build(BuildContext context) {
    double parentHeight = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Material(
          child: Column(
            children: [
              BackTopTitle(widget.context,'', Colors.black,
                  'Parked Vehicle', 'assets/images/logout.png'),
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
              ) :
                  isError ? Center(
                    child: Container(
                      child: Text('Some Error Occured'),
                    ),
                  ) : isVehicleListEmpty ? Center(
                    child: Container(
                      child: Text('No Parked Vehicles'),
                    ),
                  ) :
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: vehicleList.length,
                  itemBuilder: (context, index) {
                    final item = vehicleList[index];
                    return GestureDetector(
                      onTap: (){
                        // print('item---' + item.parkingTicketID!);
                        // Navigator.of(context).pushNamed('/DedicatedHistoryFragment',arguments: item.parkingTicketID);

                      },
                      child: HistoryItem(
                          item.customerName == null ? "" : item.customerName!,
                          item.vehicleNo == null ? "" : item.vehicleNo!,
                          item.vehicleType == null ? "" : item.vehicleType!,
                          item.parkingLocation == null ? "" : item.parkingLocation!,
                          '',
                          item.parkDate == null ? "" : item.parkDate!,
                          item.parkedDuration == null ? "" : item.parkedDuration!),
                    );
                  },
                ),
              )
            ],
          ),
        ));
  }

  void getHistoryList() async{
    // try {
      SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
      String? accessToken = sharedPreferences.getString(Constants.ACCESS_TOKEN);
      String? employeeID = sharedPreferences.getString(Constants.EMPLOYEE_ID);

      try {
        final dio = Dio(BaseOptions(contentType: "application/json"));
        dio.interceptors.add(AuthInterceptor(accessToken!));

        final ApiService apiService = ApiService(dio);

        final response = await apiService.getHistory(employeeID!);

        print('bject---' + jsonEncode(response));

        if(response.entryVehicleList.isEmpty){
          setState(() {
            isVehicleListEmpty = true;
          });
        }

        setState(() {
          vehicleList = response.entryVehicleList;
          isLoading = false;
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
    // } catch (e) {
    //   setState(() {
    //     isError = true;
    //   });
    //   CommonUtil().showToast(Constants.GENERIC_ERROR_MESSAGE);
    // }
  }
}
