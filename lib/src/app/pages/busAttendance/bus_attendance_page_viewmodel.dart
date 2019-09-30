import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/models/children.dart';
import 'package:b2s_parent/src/app/pages/busAttendance/bus_attendance_page.dart';
import 'package:flutter/material.dart';

class BusAttendancePageViewModel extends ViewModelBase {
  List<Children> listChildren = Children.listEmployee;

  listOnTap() {
    Navigator.pop(context, BusAttendancePage.routeName);
  }
}
