import 'package:flutter/material.dart';
import 'package:parkey_employee/screens/scan_number_plate.dart';

import '../screens/scan_qr.dart';

class ScanFragment extends StatefulWidget {
  final PageController controller;
  final scanIndex;

  const ScanFragment({required this.controller, required this.scanIndex,super.key});

  @override
  State<ScanFragment> createState() => _ScanFragmentState();
}

class _ScanFragmentState extends State<ScanFragment> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: DefaultTabController(
          length: 2,
          initialIndex: widget.scanIndex,
          child: Scaffold(
            body: Column(
              children: [
                TabBar(tabs: [
                  Tab(text: 'Scan QR'),
                  Tab(text: 'Scan Number Plate',)
                ]),
                Expanded(
                  child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                    ScanQrScreen(controller: widget.controller),
                    ScanNumberPlate(controller: widget.controller),
                  ]),
                )
              ],
            ),
          )),
    );
  }
}
