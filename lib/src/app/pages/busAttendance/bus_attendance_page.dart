import 'package:b2s_parent/src/app/theme/theme_primary.dart';
import 'package:b2s_parent/src/app/widgets/index.dart';
import 'package:flutter/material.dart';

class BusAttendancePage extends StatefulWidget {
  static const String routeName = "/busAttendance";
  @override
  _BusAttendancePageState createState() => _BusAttendancePageState();
}

class _BusAttendancePageState extends State<BusAttendancePage> {
  Widget _buildBody() {
    Widget __background() => Container(
          height: 150,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(left: 20),
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            ThemePrimary.gradientColor,
            ThemePrimary.primaryColor
          ])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Thứ Năm".toUpperCase(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black54),
              ),
              Text(
                "02:00 pm",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // letterSpacing: 3,
                    fontSize: 20),
              )
            ],
          ),
        );
    return Stack(
      children: <Widget>[
        __background(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new TS24AppBar(
        title: new Text("My students"),
        elevation: 0,
      ),
      body: _buildBody(),
    );
  }
}
