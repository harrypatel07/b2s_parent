import 'package:b2s_parent/src/app/core/app_setting.dart';
import 'package:flutter/material.dart';

BoxDecoration boxShaDow() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
              color: Colors.black12,
              offset: Offset(0.0, 15.0),
              blurRadius: 15.0),
          BoxShadow(
              color: Colors.black12,
              offset: Offset(0.0, -10.0),
              blurRadius: 10.0),
        ]);

//Icon menu on appBar
IconButton appBarIconSideMenu() => IconButton(
      icon: new Icon(Icons.menu),
      tooltip: "Open side menu",
      onPressed: () => scaffoldTabbar.currentState.openDrawer(),
    );
