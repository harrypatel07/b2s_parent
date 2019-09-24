import 'package:b2s_parent/src/app/widgets/index.dart';
import 'package:flutter/material.dart';

class BusAttendancePage extends StatefulWidget {
  static const String routeName = "/busAttendance";
  @override
  _BusAttendancePageState createState() => _BusAttendancePageState();
}

class _BusAttendancePageState extends State<BusAttendancePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new TS24AppBar(
        title: new Text("BusAttendance"),
      ),
      body: Container(),
    );
  }
}
