import 'package:b2s_parent/src/app/pages/busAttendance/bus_attendance_page.dart';
import 'package:b2s_parent/src/app/pages/leave/leave_page.dart';
import 'package:b2s_parent/src/app/pages/locateBus/locateBus_page.dart';
import 'package:b2s_parent/src/app/pages/message/message_page.dart';
import 'package:flutter/material.dart';

class Category {
  const Category({@required this.name, @required this.color, this.routeName});

  final Color color;
  final String name;
  final String routeName;

  static final List<Category> categories = [
    Category(
      name: "Bus attendance",
      color: Colors.teal,
      routeName: BusAttendancePage.routeName,
    ),
    Category(
      name: "School bus tracker",
      color: Colors.red,
      routeName: LocateBusPage.routeName,
    ),
    Category(name: "School bus route", color: Colors.blue),
    Category(name: "Notification", color: Colors.yellow),
    Category(
      name: "Leave",
      color: Colors.purple,
      routeName: LeavePage.routeName,
    ),
    Category(
      name: "Message",
      color: Colors.brown,
      routeName: MessagePage.routeName,
    ),
  ];
}
