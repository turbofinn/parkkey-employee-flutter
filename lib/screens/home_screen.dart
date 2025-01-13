import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkey_employee/Fragment/entry_fragment.dart';
import 'package:parkey_employee/Fragment/exit_fragment_base.dart';
import 'package:parkey_employee/Fragment/scan_fragment.dart';
import 'package:parkey_employee/colors/CustomColors.dart';
import 'package:parkey_employee/screens/scan_number_plate.dart';
import 'package:parkey_employee/screens/scan_qr.dart';

import '../Fragment/HomeFragment.dart';
import '../Fragment/approved_fragment.dart';
import '../Fragment/approved_fragment_base.dart';
import '../Fragment/history_fragment.dart';

class HomeScreen extends StatefulWidget {
  int currentIndex;
  int exitFragment;
  HomeScreen(this.currentIndex,this.exitFragment,{super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _currentIndex;
  List<Widget> tabs = [];
  PageController _pageController = PageController();
  late int currentExitFragment;
  double parentHeight = 0.0;
  int scanIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
    _pageController = PageController(initialPage: _currentIndex);
    currentExitFragment = widget.exitFragment;

    print('currentExitFragmentinit--' + currentExitFragment.toString());
  }

  @override
  Widget build(BuildContext context) {
    print('currentIndex---' + _currentIndex.toString());
    print('rebuild--' + currentExitFragment.toString());
    parentHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        setState(() {
          _pageController.jumpToPage(0);
        });
        return false;
      },
      child: SafeArea(
        child: Material(
          child: Scaffold(
            body: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(), // Disables horizontal swipe
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              children: [
                HomeFragment(controller: _pageController),
                ScanFragment(controller: _pageController, scanIndex: scanIndex),
                ApprovedFragmentBase(controller: _pageController, setScanIndex: (index){
                  setScanIndex(index);
                }),
                HistoryFragment(context: context),
                ExitFragmentBase(controller: _pageController),
              ],
            ),
            bottomNavigationBar: SizedBox(
              height: 0.09*parentHeight,
              child: BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                    if (_currentIndex == 4) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => HomeScreen(4, 0)));
                    }
                  });
                  _pageController.jumpToPage(index);
                },
                items: [
                  _buildBottomNavigationBarItem(
                    iconPath: 'assets/Icons/icon_home.png',
                    label: 'Home',
                    index: 0,
                  ),
                  _buildBottomNavigationBarItem(
                    iconPath: 'assets/images/qr_code.png',
                    label: 'Scan QR',
                    index: 1,
                  ),
                  _buildBottomNavigationBarItem(
                    iconPath: 'assets/Icons/icon_profile.png',
                    label: 'Entry',
                    index: 2,
                  ),
                  _buildBottomNavigationBarItem(
                    iconPath: 'assets/Icons/icon_history.png',
                    label: 'History',
                    index: 3,
                  ),
                  _buildBottomNavigationBarItem(
                    iconPath: 'assets/Icons/icon_exit.png',
                    label: 'Exit',
                    index: 4,
                  ),
                ],
                selectedItemColor: Color(CustomColors.GREEN_BUTTON),
                unselectedItemColor: Colors.black,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.white,
                showSelectedLabels: true,
                showUnselectedLabels: true,
              ),
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem({
    required String iconPath,
    required String label,
    required int index,
  }) {
    return BottomNavigationBarItem(
      icon: Container(
        decoration: BoxDecoration(
          color: _currentIndex == index
              ? Color(CustomColors.GREEN_BUTTON)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
        ),
        padding: EdgeInsets.all(8),
        child: Image(
          width: 50,
          height: 0.03 * parentHeight,
          image: AssetImage(iconPath),
        ),
      ),
      label: label,
    );
  }

  Future<Uint8List> getImages(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
  
  setScanIndex(index){
    
    setState(() {
      scanIndex = index;
    });
    
  }

  void initialiseUI() {}
}
