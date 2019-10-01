import 'package:b2s_parent/src/app/models/children.dart';

import 'driver.dart';

class ChildrenBusSession {
  final Children child;
  final List<RouteBus> listRouteBus;
  final Driver driver;
  final StatusBus status;

  ChildrenBusSession(
      this.child, this.listRouteBus, this.driver, this.status); //
  static List<ChildrenBusSession> list = [
    ChildrenBusSession(
        Children.list[0], RouteBus.list, Driver.list[0], StatusBus.list[0]),
    ChildrenBusSession(
        Children.list[1], RouteBus.list, Driver.list[1], StatusBus.list[1])
  ];
}

class RouteBus {
  final String date;
  final String time;
  final String routeName;
  final int type; //0: lượt đi, //1: lượt về
  final bool status; // hoàn thành
  RouteBus(this.date, this.time, this.routeName, this.type, this.status);

  static List<RouteBus> list = [
    RouteBus("2019-09-09", "07:00 am", "12 cách mạng tháng tám", 0, true),
    RouteBus("2019-09-09", "07:10 am", "285/95 cách mạng tháng 8", 0, true),
    RouteBus("2019-09-09", "07:30 am", "Trường quốc tế việt úc", 0, false),
    RouteBus("2019-09-09", "04:00 pm", "Trường quốc tế việt úc", 1, false),
    RouteBus("2019-09-09", "04:30 pm", "285/95 cách mạng tháng 8", 1, false),
  ];
}

class StatusBus {
  final int statusID;
  final String statusName;
  final int statusColor;

  StatusBus(this.statusID, this.statusName, this.statusColor);
  static List<StatusBus> list = [
    StatusBus(1, "Đang trong chuyến", 0xFF8FD838),
    StatusBus(2, "Đã tới trường", 0xFF3DABEC),
    StatusBus(3, "Nghỉ học", 0xFFE80F0F),
    StatusBus(4, "Đã về nhà", 0xFF6F32A0),
  ];
}
