import 'package:flutter/material.dart';
import 'package:parkey_employee/Fragment/exit_fragment1.dart';

import 'exit_fragment2.dart';
import 'exit_vehicle_fragment3.dart';

class ExitFragmentBase extends StatefulWidget {
  final PageController controller;

  ExitFragmentBase({required this.controller, super.key});

  @override
  State<ExitFragmentBase> createState() => _ExitFragmentBaseState();
}

class _ExitFragmentBaseState extends State<ExitFragmentBase> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        // Determine the screen to display based on the route name
        switch (settings.name) {
          case '/':
            builder = (BuildContext _) => ExitVehicleFragment1(controller: widget.controller,);
            break;
          case '/ExitFragment2':
            builder = (BuildContext _) => ExitFragment2(
                  parkingTicketID: settings.arguments as String,
                );
            break;
          case '/ExitVehicleFragment3':
            builder = (BuildContext _) => ExitVehicleFragment3(controller: widget.controller);
            break;
          // case '/VehicleParkedFragment':
          //   builder = (BuildContext _) => VehicleParkedFragment();
          //   break;
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}
