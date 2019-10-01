import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/models/childrenBusSession.dart';
import 'package:b2s_parent/src/app/pages/busAttendance/bus_attendance_page.dart';
import 'package:flutter/material.dart';

import '../../app_route.dart';

class BusAttendancePageViewModel extends ViewModelBase {
  List<ChildrenBusSession> listChildren = ChildrenBusSession.list;

  listOnTap(ChildrenBusSession data) {
    Navigator.pop(context, RoutePopArgument(BusAttendancePage.routeName, data));
  }
}
