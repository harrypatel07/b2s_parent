import 'package:b2s_parent/src/app/models/children.dart';
import 'package:b2s_parent/src/app/models/childrenBusSession.dart';
import 'package:b2s_parent/src/app/models/driver.dart';

class HistoryTrip {
  dynamic date;
  List<Trip> trip;
  HistoryTrip({this.date, this.trip});
}

class Trip {
  dynamic id; //map với pickingTransportInfo
  dynamic realEndTime;
  dynamic realStartTime;
  dynamic endTime;
  dynamic startTime;
  dynamic gpsStart;
  dynamic gpsEnd;
  dynamic type = 0; // 0 : đi, 1: về
  // dynamic state;
  StatusBus status;
  dynamic vehicleName;
  dynamic vechicleId;
  Children children;
  Driver driver;
  Trip(
      {this.id,
      this.realEndTime,
      this.realStartTime,
      this.gpsStart,
      this.gpsEnd,
      this.status,
      this.children,
      this.driver,
      this.vechicleId,
      this.vehicleName,
      this.type = 0});
}
