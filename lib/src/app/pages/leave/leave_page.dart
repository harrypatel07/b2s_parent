import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/helper/constant.dart';
import 'package:b2s_parent/src/app/widgets/dateUtils.dart';
import 'package:b2s_parent/src/app/models/children.dart';
import 'package:b2s_parent/src/app/models/month_module.dart';
import 'package:b2s_parent/src/app/pages/leave/leave_page_viewmodel.dart';
import 'package:b2s_parent/src/app/theme/theme_primary.dart';
import 'package:b2s_parent/src/app/widgets/item_date.dart';
import 'package:b2s_parent/src/app/widgets/listview_Animator.dart';
import 'package:b2s_parent/src/app/widgets/popupConfirm.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LeavePage extends StatefulWidget {
  static const String routeName = "/leave";
  final List<Children> listChildren;
  const LeavePage({Key key, this.listChildren}) : super(key: key);
  @override
  _LeavePageState createState() => _LeavePageState();
}

class _LeavePageState extends State<LeavePage> {
  PageController controller;
  LeavePageViewModel viewModel = LeavePageViewModel();
  @override
  void initState() {
    viewModel.listChildren = widget.listChildren;
    viewModel.onLoad(widget.listChildren[0].id);
    viewModel.childPrimary = widget.listChildren[0];
    super.initState();
  }

  Widget _page(int position, int year, int month) {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
          width: double.infinity,
          height: 40,
          color: Colors.grey[200],
          child: GridView.count(
              physics: new NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              crossAxisCount: 7,
              children: <String>[
                "S",
                "M",
                "T",
                "W",
                "T",
                "F",
                "S",
              ].map((String url) {
                return new InkResponse(
                    onTap: () {},
                    child: new Container(
                        margin: EdgeInsets.only(left: 5, right: 5, top: 5),
                        child: Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: Text(
                            url,
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w700),
                          ),
                        )));
              }).toList()),
        ),
        Flexible(
          child: Container(
              child: GridView.count(
                  physics: new NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(10),
                  crossAxisCount: 7,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 17,
                  children: getDateInMonth(
                          position == 0
                              ? viewModel.listDateShowPresent
                              : viewModel.listDateShowNext,
                          viewModel.listDate,viewModel.listDateGetFromSever,
                          year,
                          month)
                      .map((MonthModule month) {
                    if (month.date == new DateTime.utc(1999, 1, 1)) {
                      return Container();
                    }
                    return new InkWell(
                      onTap: () {
                        debugPrint("OnTappp" +
                            month.date.toString() +
                            "//" +
                            month.date.weekday.toString());
                        if (month.typeDraw != RED_DAY &&
                            month.typeDraw != GREY_DAY)
                          viewModel.updateSelected(month.date);
                      },
                      child: Container(
                          //color: Colors.green,
                          child: Stack(
                        children: <Widget>[
                          CustomPaint(
                              painter: ItemDateLeave(month,
                                  MediaQuery.of(context).size.width, false),
                              child: Text("")),
                          Center(
                              child: Text(
                            month.date.day.toString(),
                            style: TextStyle(color: month.colorText),
                          ))
                        ],
                      )),
                    );
                  }).toList())),
        )
      ],
    );
  }

  Widget _buildBody() {
    controller = new PageController(initialPage: 0);
    //MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey[300],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    controller.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.linear);
                  },
                  child: Container(
                    margin: EdgeInsets.all(5),
                    child: viewModel.pagePosition == 1
                        ? Icon(Icons.arrow_back_ios)
                        : Container(
                            width: 24,
                          ),
                  ),
                ),
                Spacer(),
                Container(
                  alignment: Alignment.center,
                  width: 150,
                  child: Text(
                    viewModel.pageViewTitle,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    controller.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.linear);
                  },
                  child: Container(
                    margin: EdgeInsets.all(5),
                    child: viewModel.pagePosition == 0
                        ? Icon(Icons.arrow_forward_ios)
                        : Container(
                            width: 24,
                          ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.width *3/4,
            child: PageView(
              onPageChanged: viewModel.onPageViewChange,
              controller: controller,
              children: <Widget>[
                _page(0, viewModel.dateDefault.year,
                    viewModel.dateDefault.month),
                _page(1, viewModel.dayOfNextMonth.year,
                    viewModel.dayOfNextMonth.month),
              ],
              scrollDirection: Axis.horizontal,
            ),
          ),
//        Spacer(),
          Container(
            color: Colors.grey[200],
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 20.0,
                              height: 20.0,
                              decoration: new BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(10),
                              child: Align(
                                child: Text("Ngày nghỉ lễ",style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 20.0,
                              height: 20.0,
                              decoration: new BoxDecoration(
                                color: Colors.orange,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(10),
                              child: Align(
                                child: Text("Ngày nghỉ đã xin",style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 20.0,
                              height: 20.0,
                              decoration: new BoxDecoration(
                                color: Color(0xFF007658),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(10),
                              child: Align(
                                child: Text("Ngày đã chọn",style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 20.0,
                              height: 20.0,
                              decoration: new BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(10),
                              child: Align(
                                child: Text("Ngày đã qua",style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _appBarTitle() {
    Widget __card(Children _child) {
      return InkWell(
        onTap: () {
          print('on tap item child');
          Navigator.pop(context, _child.id);
        },
        child: Container(
          width: 200,
          height: 50,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0.0, 2.0),
                    blurRadius: 2.0),
//              BoxShadow(
//                  color: Colors.black12,
//                  offset: Offset(0.0, -2.0),
//                  blurRadius: 2.0),
              ]),
          margin: EdgeInsets.all(5.0),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            child: Container(
//            color: Colors.grey[500],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: CachedNetworkImage(
                      imageUrl: _child.photo,
                      imageBuilder: (context, imageProvider) => CircleAvatar(
                        radius: 20.0,
                        backgroundImage: imageProvider,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _child.name.toString(),
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }

    List<Widget> _listCard = viewModel.listChildren
        .asMap()
        .map((index, child) {
          return MapEntry(
            index,
            WidgetANimator(__card(child)),
          );
        })
        .values
        .toList();
    return InkWell(
      onTap: () {
        showGeneralDialog(
                transitionBuilder: (context, a1, a2, widget) {
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            top: 30,
                            right: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(0.0),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black26,
                                        offset: Offset(0.0, 5.0),
                                        blurRadius: 2.0),
//                                BoxShadow(
//                                    color: Colors.black12,
//                                    offset: Offset(0.0, -10.0),
//                                    blurRadius: 10.0),
                                  ]),
//                          color: Colors.white,
                              child: Column(
                                children: _listCard,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
                transitionDuration: Duration(milliseconds: 10),
                barrierDismissible: true,
                barrierLabel: '',
                context: context,
                pageBuilder: (context, animation1, animation2) {})
            .then((childrenId) {
          if (childrenId != null) viewModel.onChangeChildren(childrenId);
        });
      },
      child: Container(
        child: new Row(
          children: <Widget>[
            new CachedNetworkImage(
              imageUrl: viewModel.childPrimary.photo,
              imageBuilder: (context, imageProvider) => CircleAvatar(
                radius: 20.0,
                backgroundImage: imageProvider,
                backgroundColor: Colors.transparent,
              ),
            ),
            new Container(
              margin: EdgeInsets.only(left: 10),
              child: new Text(
                viewModel.childPrimary.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  var alertStyle = AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: false,
    isOverlayTapDismiss: true,
    descStyle: TextStyle(fontWeight: FontWeight.bold),
    animationDuration: Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
      side: BorderSide(
        color: Colors.grey,
      ),
    ),
    titleStyle: TextStyle(
      color: Colors.red,
    ),
  );

  Widget _appBar() {
    return new AppBar(
      title: _appBarTitle(),
      actions: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.save,
            color: Colors.black54,
          ),
          tooltip: 'Show Snackbar',
          onPressed: () {
            popupConfirm(
                context: context,
                title: 'THÔNG BÁO',
                desc: 'Xác nhận thay đổi thông tin ?',
                yes: 'Có',
                no: 'Không',
                onTap: () {
                  viewModel.onSend();
                  print("onSend list leave of primary child");
                  Navigator.pop(context);
                });
            print('open popup');
          },
        ),
      ],
    );
  }

  Widget build(BuildContext context) {
    viewModel.context = context;
    return ViewModelProvider(
      viewmodel: viewModel,
      child: StreamBuilder<Object>(
          stream: viewModel.stream,
          builder: (context, snapshot) {
            return new Scaffold(
              appBar: _appBar(),
              body: _buildBody(),
            );
          }),
    );
  }
}
