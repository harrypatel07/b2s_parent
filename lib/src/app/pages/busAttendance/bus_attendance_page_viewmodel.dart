import 'dart:async';
import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/models/childrenBusSession.dart';
import 'package:b2s_parent/src/app/pages/busAttendance/bus_attendance_page.dart';
import 'package:flutter/material.dart';
import '../../app_route.dart';

class BusAttendancePageViewModel extends ViewModelBase {
  List<ChildrenBusSession> listChildren = ChildrenBusSession.list;
  StreamSubscription streamCloud;
  BusAttendancePageViewModel();

  listenData() {
    if (streamCloud != null) streamCloud.cancel();
    streamCloud =
        cloudService.busSession.listenAllChildrenBusSession().listen((onData) {
      onData.documentChanges.forEach((item) {
        var childrenUpdate = listChildren.singleWhere((_item) =>
            _item.sessionID == item.document.data["sessionID"].toString());
        if (childrenUpdate != null) childrenUpdate.fromJson(item.document.data);
      });
      this.updateState();
    });
  }

  listOnTap(ChildrenBusSession data) {
    Navigator.pop(context, RoutePopArgument(BusAttendancePage.routeName, data));
  }

  @override
  void dispose() {
    streamCloud.cancel();
    super.dispose();
  }
}
