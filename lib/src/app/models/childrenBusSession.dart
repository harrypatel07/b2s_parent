import 'package:b2s_parent/src/app/models/picking-route.dart';
import 'package:b2s_parent/src/app/models/picking-transport-info.dart';
import 'package:b2s_parent/src/app/models/route-location.dart';
import 'package:b2s_parent/src/app/service/index.dart';
import 'package:intl/intl.dart';
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
  dynamic schoolName;
  dynamic notification;
  dynamic vehicleId;
  dynamic type; // 0 là đi, 1 là về.
  ChildrenBusSession.fromPickingTransportInfo(
      {PickingTransportInfo pti,
      Children objChildren,
      Driver objDriver,
      List<RouteBus> objListRouteBus}) {
    sessionID = pti.id.toString();
    //Kiểm tra chuyến đi hay chuyền về
    var _type = 0;
    if (pti.deliveryId is List) {
      if (pti.deliveryId[1].toString().contains("IN")) _type = 1;
    }
    if (objChildren != null) {
      child = objChildren;
      schoolName = child.schoolName;
    }
    if (objDriver != null) driver = objDriver;
    notification = "";

    PickingTransportInfo_State.values.forEach((value) {
      if (Common.getValueEnum(value) == pti.state)
        switch (value) {
          case PickingTransportInfo_State.draft:
            status = StatusBus.list[0];
            break;
          case PickingTransportInfo_State.halt:
            status = StatusBus.list[1];

            break;
          case PickingTransportInfo_State.done:
            if (_type == 0)
              status = StatusBus.list[2];
            else
              status = StatusBus.list[4];
            break;
          case PickingTransportInfo_State.cancel:
            status = StatusBus.list[3];
            break;
          default:
        }
    });
    if (pti.vehicleId is List) {
      vehicleId = pti.vehicleId[1].toString().split('/').last;
    }
    listRouteBus = objListRouteBus;
  }
  fromJson(Map<dynamic, dynamic> json) {
    sessionID = json['sessionID'];
    child = Children.fromJson(json['child']);
    List list = json['listRouteBus'];
    listRouteBus = list.map((item) => RouteBus.fromJson(item)).toList();
    driver = Driver.fromJson(json['driver']);
    status = StatusBus.fromJson(json['status']);
    schoolName = json['schoolName'];
    notification = json['notification'];
  }

  Map<dynamic, dynamic> toJson() {
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
      status: StatusBus.list[0],
      schoolName: "VStar School",
      notification: "Xe sắp đến đón trong 10 phút",
    )
  ];
}

class RouteBus {
  dynamic id;
  String date;
  String time;
  String routeName;
  int type; //0: lượt đi, //1: lượt về
  dynamic status; // hoàn thành
  bool isSchool;
  double lat;
  double lng;
  RouteBus({
    this.id,
    this.date,
    this.time,
    this.routeName,
    this.type,
    this.status,
    this.lat,
    this.lng,
    this.isSchool,
  });

  RouteBus.fromRouteLocation(
      {RouteLocation routeLocation,
      PickingRoute pickingRoute,
      int type,
      PickingTransportInfo pickingTransportInfo}) {
    if (type == 0) //0-điểm bắt đầu, 1-điểm kết thúc
    {
      routeName = pickingRoute.sourceLocation is List
          ? pickingRoute.sourceLocation[1]
          : "";
      this.date = DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(pickingRoute.startTime.toString()));
      this.time = DateFormat('hh:mm')
          .format(DateTime.parse(pickingRoute.startTime.toString()));
    } else //0-điểm bắt đầu, 1-điểm kết thúc
    {
      routeName = pickingRoute.destinationLocation is List
          ? pickingRoute.destinationLocation[1]
          : "";
      this.date = DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(pickingRoute.endTime.toString()));
      this.time = DateFormat('hh:mm')
          .format(DateTime.parse(pickingRoute.endTime.toString()));
    }
    lat = double.parse(routeLocation.xPosx.toString());
    lng = double.parse(routeLocation.xPosy.toString());
    id = this.date + this.time;
    this.isSchool = routeLocation.xCheckSchool;
  }
  RouteBus.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    date = json['date'];
    time = json['time'];
    routeName = json['routeName'];
    type = json['type'];
    status = json['status'];
    lat = json['lat'];
    lng = json['lng'];
  }

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
      routeName: "200 võ thị sáu, p10, q3",
      type: 0,
      status: true,
      lat: 0,
      lng: 0,
    ),
    RouteBus(
      id: 2,
      date: "2019-09-09",
      time: "07:10 am",
      routeName: "285/94B cách mạng tháng tám, p12, q10",
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
      routeName: "285/94 cách mạng tháng 8, p12, q10",
      type: 1,
      status: false,
      lat: 0,
      lng: 0,
    ),
  ];
}

class StatusBus {
  int statusID;
  String statusName;
  int statusColor;

  StatusBus(this.statusID, this.statusName, this.statusColor);

  StatusBus.fromJson(Map<dynamic, dynamic> json) {
    statusID = json['statusID'];
    statusName = json['statusName'];
    statusColor = json['statusColor'];
  }

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
