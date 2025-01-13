import 'package:flutter/material.dart';
import 'package:parkey_employee/Fragment/approved_fragment.dart';
import 'package:parkey_employee/Fragment/exit_fragment_base.dart';
import 'package:parkey_employee/Fragment/exit_vehicle_fragment3.dart';
import 'package:parkey_employee/Fragment/vehicle_parked_fragment.dart';
import 'package:parkey_employee/screens/home_screen.dart';

import 'approved_fragment_screen2.dart';

class ApprovedFragmentBase extends StatefulWidget {
  final PageController controller;
  final Function(int) setScanIndex;
  ApprovedFragmentBase({required this.controller, required this.setScanIndex});

  @override
  State<ApprovedFragmentBase> createState() => _ApprovedFragmentBaseState();
}

class _ApprovedFragmentBaseState extends State<ApprovedFragmentBase> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        // Determine the screen to display based on the route name
        switch (settings.name) {
          case '/':
            builder = (BuildContext _) => ApprovedFragment(controller: widget.controller, setScanIndex: widget.setScanIndex);
            break;
          case '/ApprovedFragmentScreen2':
            builder = (BuildContext _) => ApprovedFragmentScreen2(
                  vehicleNo: settings.arguments as String,
                );
            break;
          case '/VehicleParkedFragment':
            builder = (BuildContext _) => VehicleParkedFragment();
            break;
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}
