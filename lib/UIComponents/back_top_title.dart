import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/login_screen.dart';
class BackTopTitle extends StatefulWidget {
  late String title;
  late String assetImage;
  late String backIncon;
  late Color titleColor;
  BuildContext context;


  BackTopTitle(this.context, this.backIncon,this.titleColor,this.title,this.assetImage, {super.key});




  @override
  State<BackTopTitle> createState() => _BackTopTitleState();
}



class _BackTopTitleState extends State<BackTopTitle> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          widget.backIncon != '' ? GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Container(
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 2,
                    color: Colors.white
                  ),
                  borderRadius: BorderRadius.circular(2)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Image(
                      image: AssetImage(
                          widget.backIncon)),
                )),
          ) : Container(),
          Container(
            margin: EdgeInsets.only(left: 20),
            child: Text(widget.title,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
              color: widget.titleColor),
            ),
          ),
          widget.assetImage != '' ? GestureDetector(
            onTap: () async {
              if(widget.assetImage.contains('logout.png')){
                SharedPreferences sharedPrefernces = await SharedPreferences.getInstance();
                sharedPrefernces.clear();
                Navigator.pushReplacement(widget.context!, MaterialPageRoute(builder: (context) => LoginScreen()));
              }
                },
            child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image(
                      image: AssetImage(
                          widget.assetImage)),
                )),
          ) : Container(
            height: 40,
            width: 40,
          )
        ],
      ),
    );
  }
}
