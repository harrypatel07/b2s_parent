import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/pages/history/history_page.dart';
import 'package:b2s_parent/src/app/pages/historyDetail/history_detail_page_viewmodel.dart';
import 'package:b2s_parent/src/app/service/common-service.dart';
import 'package:b2s_parent/src/app/theme/theme_primary.dart';
import 'package:b2s_parent/src/app/widgets/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:validators/sanitizers.dart';

class HistoryDetailPage extends StatefulWidget {
  static const String routeName = '/historyDetail';
  final HistoryInfo historyInfo;

  const HistoryDetailPage({Key key, this.historyInfo}) : super(key: key);
  @override
  _HistoryDetailPageState createState() => _HistoryDetailPageState();
}

class _HistoryDetailPageState extends State<HistoryDetailPage> {
  HistoryDetailPageViewModel viewModel = HistoryDetailPageViewModel();
  @override
  void initState() {
    viewModel.historyInfo = widget.historyInfo;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget rowTitle(String title) {
      return Container(
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 15.0, right: 15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12)),
          color: Colors.amber,
        ),
        height: 40,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      );
    }

    final hr = Container(
      height: 1,
      color: Colors.grey.shade300,
    );

    Widget row2(String title1, String content1, String title2, String content2,
        bool type) {
      return Container(
        padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 15, bottom: 15),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 5,
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 3, right: 3, bottom: 3),
                        child: Icon(
                          type ? Icons.home : Icons.school,
                          color: type ? Colors.orange : Colors.green,
                          size: 20,
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          title1,
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      content1,
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 5,
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 3, right: 3, bottom: 3),
                        child: Icon(
                          type ? Icons.school : Icons.home,
                          color: type ? Colors.green : Colors.orange,
                          size: 20,
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          title2,
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      content2,
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      );
    }

    Widget row1(String title, String content) {
      return Container(
        padding: EdgeInsets.only(left: 5.0, right: 5.0),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: Container(
                padding: EdgeInsets.only(top: 10, bottom: 10, left: 5),
                alignment: Alignment.centerLeft,
                child: Text(
                  content,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget rowIcon(
        {String title, String content, String phoneNumber, Function onTap}) {
      return Container(
        color: Colors.transparent,
        padding: EdgeInsets.only(left: 5.0, right: 5.0),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex:
                        (phoneNumber != null && toBoolean(phoneNumber) != false)
                            ? 10
                            : 14,
                    child: Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10, left: 5),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        content,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  if (phoneNumber != null && toBoolean(phoneNumber) != false)
                    Expanded(
                      flex: 2,
                      child: InkWell(
                        onTap: () {
                          launch("tel://$phoneNumber");
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 2),
//color: Colors.amber,
                          child: Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.call,
                              color: ThemePrimary.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (phoneNumber != null && toBoolean(phoneNumber) != false)
                    Expanded(
                      flex: 2,
                      child: InkWell(
                        onTap: () {
                          launch("sms://$phoneNumber");
                        },
                        child: Container(
// color: Colors.red,
                          margin: EdgeInsets.only(left: 2),
                          child: Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.message,
                              color: ThemePrimary.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  Expanded(
                    flex: 2,
                    child: InkWell(
                      onTap: onTap,
                      child: Container(
// color: Colors.red,
                        margin: EdgeInsets.only(left: 4),
                        child: Align(
                          alignment: Alignment.center,
                          child: Icon(
                            FontAwesomeIcons.facebookMessenger,
                            color: ThemePrimary.primaryColor,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget _tablePickDrop() {
      return Container(
//          color: Colors.pink,
          padding: EdgeInsets.all(5),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 2),
                    color: Color(0x20000000),
                    blurRadius: 5),
                BoxShadow(
                    offset: Offset(2, 0),
                    color: Color(0x20000000),
                    blurRadius: 5),
              ]),
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//            border: TableBorder.all(width: 1.0, color: Colors.grey[300]),
//            border: TableBorder.symmetric(inside: BorderSide.merge(a, b)),
            border: TableBorder(
                horizontalInside:
                    BorderSide(width: 1.0, color: Colors.grey[300])),
            children: [
              TableRow(children: [
                Container(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    'Thời gian',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                  child: Text(
                    'Đón',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                  child: Text(
                    'Trả',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ]),
              TableRow(children: [
                Container(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    'Dự kiến',
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    viewModel.historyInfo.estimateTimePick != ''
                        ? Common.removeMiliSecond(
                            viewModel.historyInfo.estimateTimePick)
                        : '',
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(
                  viewModel.historyInfo.estimateTimeDrop != ''
                      ? Common.removeMiliSecond(
                          viewModel.historyInfo.estimateTimeDrop)
                      : '',
                  textAlign: TextAlign.center,
                ),
              ]),
              TableRow(children: [
                Container(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    'Thực tế',
                    textAlign: TextAlign.left,
                  ),
                ),
                Center(
                  child: Text(
                    viewModel.historyInfo.realTimePick != ''
                        ? Common.removeMiliSecond(
                            viewModel.historyInfo.realTimePick)
                        : Common.removeMiliSecond(viewModel.historyInfo.estimateTimePick),
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(
                  viewModel.historyInfo.realTimeDrop != ''
                      ? Common.removeMiliSecond(
                          viewModel.historyInfo.realTimeDrop)
                      : Common.removeMiliSecond(viewModel.historyInfo.estimateTimeDrop),
                  textAlign: TextAlign.center,
                ),
              ]),
              TableRow(children: [
                Container(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    'Chênh lệch',
                    textAlign: TextAlign.left,
                  ),
                ),
                Center(
                  child: Text(
                    viewModel.getDifferenceTime(viewModel.historyInfo.estimateTimePick,viewModel.historyInfo.realTimePick != ''?viewModel.historyInfo.realTimePick:viewModel.historyInfo.estimateTimePick),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold ,color: ThemePrimary.colorDriverApp),

                  ),
                ),
                Center(
                  child: Text(
                    viewModel.getDifferenceTime(viewModel.historyInfo.estimateTimeDrop,viewModel.historyInfo.realTimeDrop != ''?viewModel.historyInfo.realTimeDrop:viewModel.historyInfo.estimateTimeDrop),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold,color: ThemePrimary.colorDriverApp),
                  ),
                ),
              ])
            ],
          )
//        GridView.count(
//          physics: new NeverScrollableScrollPhysics(),
//          padding: EdgeInsets.zero,
//          crossAxisCount: 3,
//          children: <Widget>[
//            SizedBox(),
//            Text('Đón',textAlign: TextAlign.center,),
//            Text('Trả',textAlign: TextAlign.center,),
//            Text('Thời gian dự kiến',textAlign: TextAlign.center,),
//            Text(viewModel.historyInfo.estimateTimePick,textAlign: TextAlign.center,),
//            Text(viewModel.historyInfo.estimateTimeDrop,textAlign: TextAlign.center,),
//            Text('Thời gian thực tế',textAlign: TextAlign.center,),
//            Text(viewModel.historyInfo.realTimePick,textAlign: TextAlign.center,),
//            Text(viewModel.historyInfo.realTimeDrop,textAlign: TextAlign.center,),
//            Text('Thời gian chênh lệch',textAlign: TextAlign.center,),
//            Text('Sớm 30p',textAlign: TextAlign.center,),
//            Text('Sớm 30p',textAlign: TextAlign.center,),
//          ],
//        ),
          );
    }

    Widget _buildSeparator({HistoryInfo historyInfo, Color color}) {
      if (color == null) color = Color(0XFF626368);
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final boxWidth = constraints.constrainWidth();
          final dashWidth = 3.0;
          final dashHeight = 0.5;
          final dashCount = (boxWidth / (2 * dashWidth)).floor();
          return Stack(
            children: <Widget>[
              Row(
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
                      height: 35,
                      width: 20,
                      decoration: BoxDecoration(
                          color: color.withAlpha(800),
                          shape: BoxShape.circle,
                          border: Border.all(color: color, width: 1.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: color, shape: BoxShape.circle),
                        ),
                      ))
                ],
              ),
              Positioned(
                width: boxWidth - 20,
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
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    final busInfo = Material(
      child: Container(
        color: Colors.transparent,
        child: widget.historyInfo != null
            ? Column(
                children: <Widget>[
//              rowTitle('THÔNG TIN XE BUS'),
                  _tablePickDrop(),
//                  hr,
                  SizedBox(
                    height: 10,
                  ),
                  row1(
                      'Ngày:',
                      widget.historyInfo.day.toString() +
                          "/" +
                          widget.historyInfo.month.toString()),
                  hr,
                  row1('Biển số xe :',
                      widget.historyInfo.vehicleName.toString()),
                  hr,
                  row1('Trường :',
                      widget.historyInfo.children.schoolName.toString()),
                  hr,
                  rowIcon(
                      title: 'Tài xế :',
                      content: widget.historyInfo.driver.name,
                      phoneNumber: widget.historyInfo.driver.phone.toString(),
                      onTap: () {
                        viewModel.onTapChatDriver();
                      }),
//                if (viewModel.startDepart != null)
//                  hr,
//                rowIcon(title:
//                'QL đưa đón :',
//                    content:viewModel.childrenBusSession.attendant.name
//                        .toString(),
//                    phoneNumber:viewModel.childrenBusSession.attendant.phone
//                        .toString(),
//                    onTap: (){
//                      viewModel.onTapChatAttendant();
//                    }),
                  hr,
//                rowIcon('QL tại trường :', 'Âu Dương Phong', '0983932940'),
//                hr,
//                if (viewModel.startDepart != null)
//                  row2('Giờ đón :', viewModel.startDepart, 'Đến trường :',
//                      viewModel.endDepart, true),
//                if (viewModel.startArrive != null)
//                  hr,
//                if (viewModel.startArrive != null)
//                  row2('Giờ về :', viewModel.startArrive, 'Về nhà :',
//                      viewModel.endArrive, false),
                ],
              )
            : Container(),
      ),
    );
    viewModel.context = context;
    return ViewModelProvider(
      viewmodel: viewModel,
      child: StreamBuilder<Object>(
        stream: viewModel.stream,
        builder: (context, snapshot) {
          return Scaffold(
            appBar: TS24AppBar(
              title: Text('Lịch sử chi tiết chuyến'),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
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
                          viewModel.historyInfo.timePickup,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                        Expanded(flex: 6, child: Container()),
                        Text(
                          viewModel.historyInfo.timeDrop,
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
                        Text(viewModel.historyInfo.type == 0 ? "Nhà" : "Trường",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.black87,
                            )),
                        Expanded(
                            flex: 6,
                            child: Container(
//                          color: Colors.pinkAccent,
                              height: 35,
                              alignment: Alignment.center,
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: _buildSeparator(
                                  historyInfo: viewModel.historyInfo,
                                  color: viewModel.historyInfo != null
                                      ? viewModel.historyInfo.status.statusID ==
                                              3
                                          ? Colors.grey
                                          : Color(viewModel
                                              .historyInfo.status.statusColor)
                                      : Color(viewModel
                                          .historyInfo.status.statusColor)),
                            )),
                        Text(viewModel.historyInfo.type == 0 ? "Trường" : "Nhà",
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
                          imageUrl: viewModel.historyInfo.children.photo,
                          imageBuilder: (context, imageProvider) =>
                              CircleAvatar(
                            radius: 15.0,
                            backgroundImage: imageProvider,
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(viewModel.historyInfo.children.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.grey[500],
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    busInfo
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
