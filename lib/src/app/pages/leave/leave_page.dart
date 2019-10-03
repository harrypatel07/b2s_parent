import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/helper/constant.dart';
import 'package:b2s_parent/src/app/helper/dateUtils.dart';
import 'package:b2s_parent/src/app/models/month_module.dart';
import 'package:b2s_parent/src/app/pages/leave/leave_page_viewmodel.dart';
import 'package:b2s_parent/src/app/pages/leave/widgets/item_date.dart';
import 'package:flutter/material.dart';

class LeavePage extends StatefulWidget {
  static const String routeName = "/leave";
  @override
  _LeavePageState createState() => _LeavePageState();
}

class _LeavePageState extends State<LeavePage> {
  PageController controller;
  Widget _page(int position, int year, int month) {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
          width: double.infinity,
          height: 40,
          color: Colors.amber.shade100,
          child: GridView.count(
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
                  padding: EdgeInsets.all(10),
                  crossAxisCount: 7,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 17,
                  children: getDateInMonth(
                          position == 0
                              ? viewModel.listDateShowPresent
                              : viewModel.listDateShowNext,
                          viewModel.listDate,
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
                              painter: Item_date(month,
                                  MediaQuery.of(context).size.width, false),
                              child: Text("")),
                          Center(
                              child: Text(
                            month.date.day.toString(),
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
    return Column(
      children: <Widget>[
        Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          color: Colors.amber,
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
          height: 300,
          child: PageView(
            onPageChanged: viewModel.onPageViewChange,
            controller: controller,
            children: <Widget>[
              _page(0, viewModel.dateDefault.year, viewModel.dateDefault.month),
              _page(1, viewModel.dayOfNextMonth.year,
                  viewModel.dayOfNextMonth.month),
            ],
            scrollDirection: Axis.horizontal,
          ),
        ),
        Spacer(),
        Container(
          color: Colors.amber,
          height: 250,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 30.0,
                      height: 30.0,
                      decoration: new BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Align(
                        child: Text("Holyday"),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 30.0,
                      height: 30.0,
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Align(
                        child: Text("Available"),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 30.0,
                      height: 30.0,
                      decoration: new BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Align(
                        child: Text("Passed"),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 30.0,
                      height: 30.0,
                      decoration: new BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Align(
                        child: Text("Selected"),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        )
      ],
    );
  }

  Widget _appBar() {
    return new AppBar(
      title: new Text("Leave"),
      actions: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.save,
            color: Colors.black54,
          ),
          tooltip: 'Show Snackbar',
          onPressed: () {
            viewModel.onSend();
          },
        ),
      ],
    );
  }

  LeavePageViewModel viewModel = LeavePageViewModel();
  @override
  Widget build(BuildContext context) {
    viewModel.context = context;
    viewModel.onCreate();
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
