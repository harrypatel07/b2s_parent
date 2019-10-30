import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/pages/home/home_page_viewmodel.dart';
import 'package:b2s_parent/src/app/pages/tabs/tabs_page_viewmodel.dart';
import 'package:b2s_parent/src/app/service/common-service.dart';
import 'package:b2s_parent/src/app/theme/theme_primary.dart';
import 'package:b2s_parent/src/app/widgets/bus_attentdance_card.dart';
import 'package:b2s_parent/src/app/widgets/index.dart';
import 'package:b2s_parent/src/app/models/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  static const String routeName = "/home";
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomePageViewModel viewModel;
  @override
  Widget build(BuildContext context) {
    TabsPageViewModel tabsPageViewModel = ViewModelProvider.of(context);
    viewModel = tabsPageViewModel.homePageViewModel;
    viewModel.context = context;
    return ViewModelProvider(
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

    Widget __listChildren() {
      Widget ___card(int index) => BusAttentdanceCard(
            childrenBusSession: viewModel.listChildren[index],
            onTapCard: () {
              viewModel.listOnTap(viewModel.listChildren[index]);
            },
            onTapCall: () {},
          );
      return Container(
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
        child: viewModel.listChildren.length == 0
            ? Container()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
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
                            "Chuyến đi trong ngày",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...viewModel.listChildren
                      .asMap()
                      .map((index, item) {
                        return MapEntry(
                            index,
                            index == 0
                                ? Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 20,
                                      ),
                                      ___card(index)
                                    ],
                                  )
                                : ___card(index));
                      })
                      .values
                      .toList()
                ],
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
      padding: EdgeInsets.only(left: 28, right: 28),
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

  @override
  Widget build(BuildContext context) {
    viewModel = ViewModelProvider.of(context);
    return Scaffold(
      appBar: new TS24AppBar(
        title: new Text("Bus2School"),
        leading: appBarIconSideMenu(context),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 30),
        child: Column(
          children: <Widget>[
            // Align(
            //     alignment: Alignment.topLeft,
            //     child: appBarIconSideMenu(context)),
            SizedBox(height: 30),
            _categoryList(),
            _buildListChildren(),
          ],
        ),
      ),
    );
  }
}
