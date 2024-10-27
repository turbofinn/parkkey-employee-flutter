import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parkey_employee/screens/login_screen.dart';
import 'package:parkey_employee/utils/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Clippers/login_screen_clipper1.dart';
import '../Clippers/login_screen_clipper2.dart';
import '../Clippers/splash_screen_clipper1.dart';
import '../colors/CustomColors.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool _disposed = false;
  var _logoWidth = 170.0;
  var _logoHeight = 150.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance!.addPersistentFrameCallback((timeStamp) {
      if(!_disposed) {
        setState(() {
          _logoHeight = 250.0;
          _logoWidth = 270.0;
        });
      }
    });

    Future.delayed(Duration(seconds: 4),() async{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      print("Splash_screen");
      sharedPreferences.setBool(Constants.IS_TICKET_CONFIRMED, false);
      if(sharedPreferences.getString(Constants.ACCESS_TOKEN)!=null){
        print(sharedPreferences.getString("accessToken"));
        String? accessToken = sharedPreferences.getString(Constants.ACCESS_TOKEN);

        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>HomeScreen(0,0)));

      }
      else{
        print("splashPre");
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> LoginScreen()));

      }

    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _disposed = true;
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {

    double heightParent = MediaQuery.of(context).size.height;
    double widthParent = MediaQuery.of(context).size.width;


    return SafeArea(
        child: Material(
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipPath(
                      clipper: LoginScreenClipper1(),
                      child: Container(
                        height: 150,
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
                    ClipPath(
                      clipper: LoginScreenClipper2(),
                      child: Container(
                        height: heightParent - 200,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(CustomColors.GREEN_LIGHT).withOpacity(0.1),
                                Color(CustomColors.GREEN_LIGHT).withOpacity(0.2)
                              ],
                            )),
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
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: AnimatedContainer(
                            duration: Duration(seconds: 2),
                            width: _logoWidth,
                            height: _logoHeight,
                            curve: Curves.easeInOut,
                            child: Image(
                              height: 150,
                              width: 150,
                              fit: BoxFit.fill,
                              image: AssetImage('assets/images/app_logo.png'),
                            ),
                          )
                      ),
                      Center(
                        child: Container(
                          child: Text('Parking Junction Private Limited'),
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
        ));
  }
}
