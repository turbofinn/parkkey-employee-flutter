import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CommonUtil {
  void showToast(String msg){
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
  String maskNumber(String mobileNo) {
    // Check if mobileNo is null or empty
  if (mobileNo == null || mobileNo.isEmpty) {
    return ""; // Return empty if no mobile number is available
  }
  // Check if mobileNo has at least 10 digits (including "+91" and 6 digits to mask)
  if (mobileNo.length <= 6) {
    // If too short, return the original or partially masked version
    return "+91" + "XXXXXX" + mobileNo;
  }

  // Otherwise, apply the mask
  String lastFourDigits = mobileNo.substring(6); // Safe since length is checked
  String res = "+91" + "XXXXXX" + lastFourDigits;
  return res;
}

}