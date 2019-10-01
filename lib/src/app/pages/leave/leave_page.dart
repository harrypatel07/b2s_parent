import 'package:b2s_parent/src/app/models/childrenBusSession.dart';
import 'package:b2s_parent/src/app/widgets/ts24_timeline.dart';
import 'package:flutter/material.dart';
import 'package:timeline/model/timeline_model.dart';
import 'package:timeline/timeline.dart';

class LeavePage extends StatefulWidget {
  static const String routeName = "/leave";

  @override
  _LeavePageState createState() => _LeavePageState();
}

final List<TimelineModel> list = [
  TimelineModel(id: "1", description: "Test 1", title: "Test 1"),
  TimelineModel(id: "2", description: "Test 2", title: "Test 2")
];

class _LeavePageState extends State<LeavePage> {
  @override
  Widget build(BuildContext context) {
    Widget __timeLine() {
      var listTimeLine = ChildrenBusSession.list[0].listRouteBus
          .map((item) => EventTime(item.time, item.routeName, "", item.status))
          .toList();
      return TS24TimeLine(listTimeLine: listTimeLine);
    }

    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Leave"),
        ),
        body: __timeLine());
  }
}
