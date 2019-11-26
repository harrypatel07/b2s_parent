import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/models/children.dart';
import 'package:b2s_parent/src/app/models/childrenBusSession.dart';
import 'package:b2s_parent/src/app/models/driver.dart';
import 'package:b2s_parent/src/app/models/historyTrip.dart';
import 'package:b2s_parent/src/app/pages/history/history_page_viewmodel.dart';
import 'package:b2s_parent/src/app/service/common-service.dart';
import 'package:b2s_parent/src/app/theme/theme_primary.dart';
import 'package:b2s_parent/src/app/widgets/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  static const String routeName = "/history";
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  HistoryPageViewModel viewModel = HistoryPageViewModel();
  @override
  Widget build(BuildContext context) {
    viewModel.context = context;
    return ViewModelProvider(
      viewmodel: viewModel,
      child: StreamBuilder<Object>(
        stream: viewModel.stream,
        builder: (context, snapshot) {
          return Scaffold(
            appBar: new TS24AppBar(
              title: new Text("Lịch sử chuyến"),
              // leading: appBarIconSideMenu(context),
            ),
            backgroundColor: ThemePrimary.history_page_backgroundcolor,
            body: _buildBody(),
            // drawer: SideMenuPage(),
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    Widget _buildLeftSection(HistoryInfo historyInfo) {
      return Padding(
        padding: const EdgeInsets.only(top: 3),
        child: Container(
          width: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                historyInfo.dayName,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                    letterSpacing: -1),
              ),
              Text(
                historyInfo.day,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                historyInfo.month,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black45,
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget _buildSeparator({Color color}) {
      if (color == null) color = Color(0XFF626368);
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final boxWidth = constraints.constrainWidth();
          final dashWidth = 3.0;
          final dashHeight = 0.5;
          final dashCount = (boxWidth / (2 * dashWidth)).floor();
          return Row(
            children: <Widget>[
              Expanded(
                child: Flex(
                  children: List.generate(dashCount, (_) {
                    return SizedBox(
                      width: dashWidth,
                      height: dashHeight,
                      child: DecoratedBox(
                        decoration: BoxDecoration(color: color),
                      ),
                    );
                  }),
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  direction: Axis.horizontal,
                ),
              ),
              Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                      color: color.withAlpha(800),
                      shape: BoxShape.circle,
                      border: Border.all(color: color, width: 1.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: DecoratedBox(
                      decoration:
                          BoxDecoration(color: color, shape: BoxShape.circle),
                    ),
                  ))
            ],
          );
        },
      );
    }

    /// type: 0 or 1.0 = đi, 1 = về
    Widget _buildRightSection(HistoryInfo historyInfo) {
      return InkWell(
        onTap: (){
          viewModel.onTapHistoryDetail(historyInfo);
        },
        child: Stack(
          children: <Widget>[
            Card(
              // decoration: BoxDecoration(
              //   color: Colors.white,
              //   borderRadius: BorderRadius.circular(4.0),
              // ),
              // padding: EdgeInsets.only(top: 0),
              elevation: 2,
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(2.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          "ĐÓN",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black12,
                          ),
                        ),
                        Expanded(flex: 6, child: Container()),
                        Text(
                          "TRẢ",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black12,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          historyInfo.timePickup,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                        Expanded(flex: 6, child: Container()),
                        Text(
                          historyInfo.timeDrop,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(historyInfo.type == 0 ? "Nhà" : "Trường",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.black87,
                            )),
                        Expanded(
                            flex: 6,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              child: _buildSeparator(
                                  color:historyInfo!=null? historyInfo.status.statusID == 3
                                      ? Colors.grey
                                      : Color(historyInfo.status.statusColor):Color(historyInfo.status.statusColor)),
                            )),
                        Text(historyInfo.type == 0 ? "Trường" : "Nhà",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.black87,
                            ))
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        CachedNetworkImage(
                          imageUrl: historyInfo.children.photo,
                          imageBuilder: (context, imageProvider) => CircleAvatar(
                            radius: 15.0,
                            backgroundImage: imageProvider,
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(historyInfo.children.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.grey[500],
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              width: MediaQuery.of(context).size.width*0.3,
              top: 40,
              left: 50,
              child: Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
//                  Expanded(flex: 1, child: Container()),
                    Text(
                      historyInfo.status.statusName,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(historyInfo.status.statusColor),
                      ),
                      overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    ///type: 0 or 1.0 = đi, 1 = về
    Widget _listItem(HistoryTrip historyTrip,List<HistoryInfo> listHistoryInfo) {
      return Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildLeftSection(listHistoryInfo[0]),
            Expanded(
                flex: 8,
                child: Column(
                  children: <Widget>[
                    ...listHistoryInfo
                        .map((historyInfo) => _buildRightSection(historyInfo))
                        .toList(),
                  ],
                ))
          ],
        ),
      );
    }

    Widget _listTrip(HistoryTrip historyTrip) {
      var __date = DateTime.parse(historyTrip.date);
      var __listHistoryInfo = historyTrip.trip
          .map((trip) => HistoryInfo(
                type: trip.type,
                status: trip.status,
                timePickup: Common.removeMiliSecond(
                    trip.realStartTime.toString() == ''
                        ? trip.startTime.toString()
                        : trip.realStartTime.toString()),
                timeDrop: Common.removeMiliSecond(
                    trip.realEndTime.toString() == ''
                        ? trip.endTime.toString()
                        : trip.realStartTime.toString()),
                day: __date.day.toString(),
                dayName: Common.convertIntDayToStringDayOfWeek(__date.weekday),
                month: DateFormat('MM/yyyy').format(__date),
                driver: trip.driver,
                vehicleName: trip.vehicleName,
                children: viewModel.getChildrenFromParent(trip.children.id),
              ))
          .toList();
      return Container(
        child: _listItem(historyTrip,__listHistoryInfo),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        viewModel.onLoad();
      },
      child: ListView(
        reverse: true,
        children: <Widget>[
          SizedBox(height: 40,),
          ...viewModel.listHistoryTrip
              .map((historyTrip) => _listTrip(historyTrip)),
        ],
      ),
    );
  }
}

class HistoryInfo {
  /// type: 0 or 1.0 = đi, 1 = về
  int type = 0;
  StatusBus status;
  String timePickup;
  String timeDrop;
  String day;
  String month;
  String dayName;
  Color colorCircle;
  Driver driver;
  String vehicleName;
  Children children;
  HistoryInfo(
      {this.type,
      this.timePickup,
      this.timeDrop,
      this.day,
      this.month,
      this.dayName,
      this.colorCircle,
      this.status,
      this.driver,
      this.vehicleName,
      this.children});
}
