import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/helper/constant.dart';
import 'package:b2s_parent/src/app/models/childrenBusSession.dart';
import 'package:b2s_parent/src/app/pages/home/home_page_viewmodel.dart';
import 'package:b2s_parent/src/app/pages/tabs/tabs_page_viewmodel.dart';
import 'package:b2s_parent/src/app/pages/user/edit_profile_children/edit_profile_children.dart';
import 'package:b2s_parent/src/app/pages/user/profile_children/profile_children.dart';
import 'package:b2s_parent/src/app/service/common-service.dart';
import 'package:b2s_parent/src/app/theme/theme_primary.dart';
import 'package:b2s_parent/src/app/widgets/bus_attentdance_card.dart';
import 'package:b2s_parent/src/app/widgets/bus_attentdance_card_shimmer.dart';
import 'package:b2s_parent/src/app/widgets/index.dart';
import 'package:b2s_parent/src/app/models/category.dart';
import 'package:b2s_parent/src/app/widgets/popupConfirm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  static const String routeName = "/home";
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomePageViewModel viewModel;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TabsPageViewModel tabsPageViewModel = ViewModelProvider.of(context);
    viewModel = tabsPageViewModel.homePageViewModel;
    viewModel.context = context;
    return StatefulWrapper(
      onInit: () {
        // viewModel.loadData();
      },
      child: ViewModelProvider(
        viewmodel: viewModel,
        child: StreamBuilder<Object>(
            stream: viewModel.stream,
            builder: (context, snapshot) {
              return TS24Scaffold(
                backgroundColor: Colors.white,
                // appBar: AppBar(
                //   backgroundColor: Colors.white,
                //   elevation: 0,
                //   leading: appBarIconSideMenu(context),
                // ),
                body: HomeBodyWidget(),
                // drawer: SideMenuPage(),
              );
            }),
      ),
    );
  }
}

class HomeBodyWidget extends StatefulWidget {
  @override
  _HomeBodyWidgetState createState() => _HomeBodyWidgetState();
}

class _HomeBodyWidgetState extends State<HomeBodyWidget> {
  HomePageViewModel viewModel;

  Widget _buildListChildren() {
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
    Widget __itemTitle(String title) {
      return Container(
        padding: EdgeInsets.only(top: 20),
        child: Row(
          children: <Widget>[
            Icon(
              FontAwesomeIcons.busAlt,
              color: ThemePrimary.primaryColor,
            ),
            Container(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    }

    Widget __card(ChildrenBusSession childrenBusSession) {
      List<RouteBus> _listRouteBus = List();
      viewModel.listChildren.forEach((item) {
        if (item.child.id == childrenBusSession.child.id) {
          item.listRouteBus.forEach((routeBus) {
            _listRouteBus.add(routeBus);
          });
        }
      });
      return BusAttentdanceCard(
        isExten: false,
        colorText: Colors.grey[800],
        colorLeft: Colors.grey,
        colorRight: Colors.grey,
        childrenBusSession: childrenBusSession,
        onTapCard: () {
          viewModel.listOnTap(childrenBusSession);
        },
        onTapCall: () {},
        onTapProfileChildren: () {
          Navigator.pushNamed(context, ProfileChildrenPage.routeName,
              arguments: ProfileChildrenPageArgs(
                  listRouteBus: _listRouteBus,
                  childrenBusSession: childrenBusSession,
                  children: childrenBusSession.child));
        },
        onTapLeave: () {
          popupConfirm(
            context: context,
            title: 'THÔNG BÁO',
            desc: 'Xác nhận thay đổi trạng thái ?',
            yes: 'Có',
            no: 'Không',
            onTap: () {
              viewModel.onTapLeave(childrenBusSession);
              Navigator.pop(context);
              print('onTap leave');
            },
          );
        },
      );
    }

    Widget __listChildren() {
      var listDepart = List();
      var listArrive = List();
      if (!viewModel.isDataLoading && viewModel.listChildren.length > 0) {
        viewModel.listChildren.forEach((children) {
          children.type == 0
              ? listDepart.add(__card(children))
              : listArrive.add(__card(children));
        });
      }
      return Container(
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
        child: viewModel.isDataLoading
            ? Column(
                children: <Widget>[
                  __itemTitle('Chuyến đi trong ngày'),
                  SizedBox(
                    height: 20,
                  ),
                  BusAttentdanceCardShimmer(),
                  BusAttentdanceCardShimmer(),
                  __itemTitle('Chuyến về trong ngày'),
                  SizedBox(
                    height: 20,
                  ),
                  BusAttentdanceCardShimmer(),
                  BusAttentdanceCardShimmer(),
                ],
              )
            : (viewModel.listChildren.length > 0)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (listDepart.length > 0)
                        Column(
                          children: <Widget>[
                            __itemTitle('Chuyến đi trong ngày'),
                            SizedBox(
                              height: 20,
                            ),
                            ...listDepart,
                          ],
                        ),
                      if (listArrive.length > 0)
                        Column(
                          children: <Widget>[
                            __itemTitle('Chuyến về trong ngày'),
                            SizedBox(
                              height: 20,
                            ),
                            ...listArrive,
                          ],
                        )
                    ],
                  )
                : Container(
                    width: MediaQuery.of(context).size.width,
                    height: 250,
                    margin: EdgeInsets.only(top: 20),
                    child: Center(
                        child: Text(
                      "Không có chuyến đi trong ngày.",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18.0,
                        color: Colors.grey.withOpacity(0.6),
                      ),
                      textAlign: TextAlign.center,
                    )),
                  ),
      );
    }

    return Container(
      child: __listChildren(),
    );
  }

  Widget _categoryList() {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.44,
        crossAxisSpacing: 10,
        mainAxisSpacing: 12,
      ),
      padding: EdgeInsets.only(left: 28, right: 28, bottom: 20),
      itemCount: Category.categories.length,
      itemBuilder: (context, index) => BusCategoryCard(
        Category.categories[index],
        onPress: () {
          viewModel.categoryOnPress(Category.categories[index]);
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _body() {
    return RefreshIndicator(
      onRefresh: () async {
        viewModel.loadData();
      },
      child: ListView(
        children: <Widget>[
          // Align(
          //     alignment: Alignment.topLeft,
          //     child: appBarIconSideMenu(context)),
          SizedBox(height: 30),
          _categoryList(),
          _buildListChildren(),
//          _buildListChildren("Chuyến về trong ngày",
//              viewModel.listChildrenArrive, TYPE_ARRIVE),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    viewModel = ViewModelProvider.of(context);
    return Scaffold(
        appBar: new TS24AppBar(
          title: new Text("Bus2School"),
          // leading: appBarIconSideMenu(context),
        ),
        body: _body()
//      SingleChildScrollView(
//        padding: EdgeInsets.only(bottom: 30),
//        child: _body(),
//      ),
        );
  }
}
