import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/models/children.dart';
import 'package:b2s_parent/src/app/pages/busAttendance/bus_attendance_page_viewmodel.dart';
import 'package:b2s_parent/src/app/service/index.dart';
import 'package:b2s_parent/src/app/theme/theme_primary.dart';
import 'package:b2s_parent/src/app/widgets/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BusAttendancePage extends StatefulWidget {
  static const String routeName = "/busAttendance";
  @override
  _BusAttendancePageState createState() => _BusAttendancePageState();
}

class _BusAttendancePageState extends State<BusAttendancePage> {
  BusAttendancePageViewModel viewModel = BusAttendancePageViewModel();

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
                Common.convertToWeekDayAndHHMM()["week"].toString(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black54),
              ),
              Text(
                Common.convertToWeekDayAndHHMM()["time"]
                    .toString()
                    .toLowerCase(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // letterSpacing: 3,
                    fontSize: 20),
              )
            ],
          ),
        );

    Widget __listChildren() {
      Widget ___card(int index) {
        Widget ____left() {
          return Container(
            width: 10,
            decoration: BoxDecoration(
              color: Colors.yellow,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  topLeft: Radius.circular(12)),
            ),
          );
        }

        Widget ____right() {
          Widget _____userImage() {
            return Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: viewModel.listChildren[index].photo,
                    imageBuilder: (context, imageProvider) => CircleAvatar(
                      radius: 35.0,
                      backgroundImage: imageProvider,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          viewModel.listChildren[index].name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          Widget _____status() {
            return Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 12, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text(
                        "Viet My School",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black38),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text(
                        "Xe sắp đến đón trong 10 phút",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text("Đang đợi",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              ),
            );
          }

          Widget _____driverPhone() {
            return Container(
              width: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        print("call tap");
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(right: 12),
                            alignment: Alignment.centerLeft,
                            child: Icon(
                              Icons.call,
                              color: ThemePrimary.primaryColor,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Text(
                                "Gọi\ndriver",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.black38,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Icon(
                            FontAwesomeIcons.busAlt,
                            color: ThemePrimary.primaryColor,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Text(
                              "123 tran hung dao q 5 dsadsa",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.black38,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }

          return Expanded(
            child: Container(
                child: Row(
              children: <Widget>[
                _____userImage(),
                _____status(),
                _____driverPhone()
              ],
            )),
          );
        }

        return new InkWell(
          borderRadius: BorderRadius.circular(12.0),
          onTap: () {
            print("list tap");
            viewModel.listOnTap();
          },
          child: Card(
            margin: EdgeInsets.only(top: 15),
            // elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Container(
                height: 120,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: <Widget>[
                    ____left(),
                    ____right(),
                  ],
                )),
          ),
        );
      }

      return ListView.builder(
        itemCount: viewModel.listChildren.length,
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
        itemBuilder: (context, index) {
          if (index == 0)
            return Column(
              children: <Widget>[
                SizedBox(
                  height: 70,
                ),
                ___card(index)
              ],
            );
          else
            return ___card(index);
        },
      );
      // )
    }

    return Container(
      child: Stack(
        children: <Widget>[__background(), __listChildren()],
      ),
    );
  }

  Widget _appBar() => new TS24AppBar(
        title: new Text("My students"),
        elevation: 0,
      );

  @override
  Widget build(BuildContext context) {
    viewModel.context = context;
    return ViewModelProvider(
      child: StreamBuilder<Object>(
          stream: viewModel.stream,
          builder: (context, snapshot) {
            return Scaffold(
              appBar: _appBar(),
              body: _buildBody(),
            );
          }),
    );
  }
}
