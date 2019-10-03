import 'package:json_annotation/json_annotation.dart';
import 'package:b2s_parent/src/app/models/children.dart';

import 'driver.dart';

@JsonSerializable(nullable: false)
class ChildrenBusSession {
  String sessionID;
  Children child;
  List<RouteBus> listRouteBus;
  Driver driver;
  StatusBus status;
  String schoolName;
  String notification;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sessionID'] = this.sessionID;
    data['child'] = this.child.toJson();
    data['listRouteBus'] =
        this.listRouteBus.map((item) => item.toJson()).toList();
    data['driver'] = this.driver.toJson();
    data['status'] = this.status.toJson();
    data['schoolName'] = this.schoolName;
    data['notification'] = this.notification;
    return data;
  }

  ChildrenBusSession(
      {this.sessionID,
      this.child,
      this.listRouteBus,
      this.driver,
      this.status,
      this.schoolName,
      this.notification}); //
  static List<ChildrenBusSession> list = [
    ChildrenBusSession(
        sessionID: "S01",
        child: Children.list[0],
        listRouteBus: RouteBus.list,
        driver: Driver.list[0],
        status: StatusBus.list[0],
        schoolName: "VStar School",
        notification: "Xe sắp đến đón trong 10 phút"),
    ChildrenBusSession(
      sessionID: "S02",
      child: Children.list[1],
      listRouteBus: RouteBus.list,
      driver: Driver.list[1],
      status: StatusBus.list[1],
      schoolName: "VStar School",
      notification: "Xe sắp đến đón trong 10 phút",
    )
  ];
}

class RouteBus {
  final int id;
  final String date;
  final String time;
  final String routeName;
  final int type; //0: lượt đi, //1: lượt về
  final bool status; // hoàn thành
  final double lat;
  final double lng;
  RouteBus(
      {this.id,
      this.date,
      this.time,
      this.routeName,
      this.type,
      this.status,
      this.lat,
      this.lng});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["date"] = this.date;
    data["time"] = this.time;
    data["routeName"] = this.routeName;
    data["type"] = this.type;
    data["status"] = this.status;
    data["lat"] = this.lat;
    data["lng"] = this.lng;
    return data;
  }

  static List<RouteBus> list = [
    RouteBus(
      id: 1,
      date: "2019-09-09",
      time: "07:00 am",
      routeName: "12 cách mạng tháng tám",
      type: 0,
      status: true,
      lat: 0,
      lng: 0,
    ),
    RouteBus(
      id: 2,
      date: "2019-09-09",
      time: "07:10 am",
      routeName: "285/95 cách mạng tháng 8",
      type: 0,
      status: true,
      lat: 0,
      lng: 0,
    ),
    RouteBus(
      id: 3,
      date: "2019-09-09",
      time: "07:30 am",
      routeName: "Trường quốc tế việt úc",
      type: 0,
      status: false,
      lat: 0,
      lng: 0,
    ),
    RouteBus(
      id: 4,
      date: "2019-09-09",
      time: "04:00 pm",
      routeName: "Trường quốc tế việt úc",
      type: 1,
      status: false,
      lat: 0,
      lng: 0,
    ),
    RouteBus(
      id: 5,
      date: "2019-09-09",
      time: "04:30 pm",
      routeName: "285/95 cách mạng tháng 8",
      type: 1,
      status: false,
      lat: 0,
      lng: 0,
    ),
  ];
}

class StatusBus {
  final int statusID;
  final String statusName;
  final int statusColor;

  StatusBus(this.statusID, this.statusName, this.statusColor);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["statusID"] = this.statusID;
    data["statusName"] = this.statusName;
    data["statusColor"] = this.statusColor;
    return data;
  }

  static List<StatusBus> list = [
    StatusBus(0, "Đang chờ", 0xFFFFD752),
    StatusBus(1, "Đang trong chuyến", 0xFF8FD838),
    StatusBus(2, "Đã tới trường", 0xFF3DABEC),
    StatusBus(3, "Nghỉ học", 0xFFE80F0F),
    StatusBus(4, "Đã về nhà", 0xFF6F32A0),
  ];
}
