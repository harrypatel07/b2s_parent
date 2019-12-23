import 'package:b2s_parent/src/app/core/app_setting.dart';
import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/models/children.dart';
import 'package:b2s_parent/src/app/models/sale-order-line.dart';
import 'package:b2s_parent/src/app/pages/user/tickets_detail/student_card/student_card_viewmodel.dart';
import 'package:b2s_parent/src/app/theme/theme_primary.dart';
import 'package:b2s_parent/src/app/widgets/index.dart';
import 'package:b2s_parent/src/app/widgets/ts24_scaffold_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class StudentCardPage extends StatefulWidget {
  static const String routeName = '/studentCard';
  final StudentCardPageArgs args;
  const StudentCardPage({Key key, this.args}) : super(key: key);
  @override
  _StudentCardPageState createState() => _StudentCardPageState();
}

class _StudentCardPageState extends State<StudentCardPage> {
  StudentCardViewModel viewModel = StudentCardViewModel();
  double studentCardHeight = 400;
  @override
  Widget build(BuildContext context) {
    Widget _itemCard(Children children, SaleOrderLine order) {
      return (!viewModel.isCardVertical)
          ? Container(
              alignment: Alignment.center,
              child: RepaintBoundary(
                key: viewModel.studentCardHorizontalKey,
                child: Container(
                  height: studentCardHeight,
                  width: studentCardHeight * 0.6,
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                      border: Border.all(color: Colors.grey[300])
                  ),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: EdgeInsets.only(
                              left: studentCardHeight * 0.033,
                              right: studentCardHeight * 0.033),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(12),
                                  topLeft: Radius.circular(12)),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0x20000000),
                                    blurRadius: 5,
                                    offset: Offset(0, 3))
                              ]),
                          child: Center(
                            child: Container(
//                                color: Colors.grey,
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
//                                      color: Colors.red,
                                    alignment: Alignment.centerRight,
                                    width: studentCardHeight * 0.12,
                                    height: studentCardHeight * 0.12,
                                    child: CachedNetworkImage(
                                      imageUrl: api.getImageByIdPartner(
                                          order.companyId[0].toString()),
                                      fit: BoxFit.scaleDown,
                                    ),
                                  ),
                                  SizedBox(width: studentCardHeight * 0.012),
                                  Flexible(
                                    child: Text(
                                      children.schoolName.toString(),
                                      maxLines: 3,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: studentCardHeight * 0.033,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                          fontFamily: 'Aachenb'),
                                    ),
                                  ),
                                  SizedBox(
                                    height: studentCardHeight * 0.012,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: studentCardHeight * 0.02,
                      ),
                      Expanded(
                        flex: 9,
                        child: Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1.0, color: Colors.grey)),
                          width: studentCardHeight * 0.38,
                          height: studentCardHeight * 0.38,
                          child: CachedNetworkImage(
                            imageUrl: children.photo,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(
                              right: studentCardHeight * 0.02,
                              left: studentCardHeight * 0.02),
                          child: Text(
                            children.name.toString(),
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: studentCardHeight * 0.038,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: studentCardHeight * 0.012,
                      ),
                      Expanded(
                        flex: 6,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topCenter,
                              child: QrImage(
                                backgroundColor: Colors.white,
                                data: 'ts24corp',
                                version: QrVersions.auto,
                                size: studentCardHeight * 0.33,
                              ),
                            ),
                            Container(
                              width: studentCardHeight * 0.15,
                              height: studentCardHeight * 0.15,
//                                  decoration: BoxDecoration(
//                                      border: Border.all(width: 1.0,color: Colors.grey)
//                                  ),
                              child: Image.asset("assets/images/logo_b2s.png"),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
//                  height: 50,
//                  width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: ThemePrimary.primaryColor,
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(12),
                                  bottomLeft: Radius.circular(12))),

                          child: Center(
                            child: Text(
                              '©Bus2School.vn',
                              style: TextStyle(
                                  fontSize: studentCardHeight * 0.0267,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : RepaintBoundary(
              key: viewModel.studentCardVerticalKey,
              child: Container(
                width: studentCardHeight,
                height: studentCardHeight *0.6,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  border: Border.all(color: Colors.grey[300])
                ),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(12),
                                topLeft: Radius.circular(12)),
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0x20000000),
                                  blurRadius: 5,
                                  offset: Offset(0, 3))
                            ]),
                        child: Center(
                          child: Container(
//                                color: Colors.grey,
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
//                                      color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  width: 50,
                                  height: 50,
                                  child: CachedNetworkImage(
                                    imageUrl: api.getImageByIdPartner(
                                        order.companyId[0].toString()),
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  child: Text(
                                    children.schoolName.toString(),
                                    maxLines: 3,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                        fontFamily: 'Aachenb'),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Container(
                        decoration: BoxDecoration(
//                        color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12)),
                        ),
//                    color: Colors.red,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Expanded(
                                      flex: 7,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1.0,
                                                color: Colors.grey)),
                                        width: 130,
                                        height: 130,
                                        child: CachedNetworkImage(
                                          imageUrl: children.photo,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding:
                                            EdgeInsets.only(right: 5, left: 5),
                                        child: Text(
                                          children.name.toString(),
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue),
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 4,
                                      child: Container(
                                        child: Row(
                                          children: <Widget>[
                                            QrImage(
                                              backgroundColor: Colors.white,
                                              data: 'ts24corp',
                                              version: QrVersions.auto,
                                              size: 100,
                                            ),
                                            Container(
                                              width: 55,
                                              height: 55,
//                                  decoration: BoxDecoration(
//                                      border: Border.all(width: 1.0,color: Colors.grey)
//                                  ),
                                              child: Image.asset(
                                                  "assets/images/logo_b2s.png"),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                          decoration: BoxDecoration(
                                            color: ThemePrimary.primaryColor,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(25),
                                                bottomRight:
                                                    Radius.circular(12)),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '©Bus2School.vn',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          )),
                                    )
                                  ],
                                ),
//                            color: Colors.red,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
    }

    return ViewModelProvider(
      viewmodel: viewModel,
      child: StreamBuilder<Object>(
        stream: viewModel.stream,
        builder: (context, snapshot) {
          return TS24Scaffold(
            backgroundColor: Colors.grey[300],
            appBar: TS24AppBar(
              title: Text("Thông tin thẻ học sinh"),
              actions: <Widget>[
                IconButton(
                  onPressed: () {
                    viewModel.printScreen();
                  },
                  icon: Icon(
                    Icons.print,
                    color: Colors.white,
                  ),
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10,),
                    _itemCard(widget.args.children, widget.args.orderLine),
                  ],
                )
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: ThemePrimary.primaryColor,
              onPressed: () {
                viewModel.onSwitchCardVerticalAndHorizontal();
              },
              child: Icon(Icons.screen_rotation),
            ),
          );
        },
      ),
    );
  }
}

class StudentCardPageArgs {
  final Children children;
  final SaleOrderLine orderLine;
  StudentCardPageArgs({this.children, this.orderLine});
}
