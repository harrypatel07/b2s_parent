import 'package:b2s_parent/src/app/pages/history/history_page.dart';
import 'package:b2s_parent/src/app/pages/home/home_page.dart';
import 'package:b2s_parent/src/app/pages/locateBus/locateBus_page.dart';
import 'package:b2s_parent/src/app/pages/user/user_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Menu {
  Menu(
      {@required this.title,
      @required this.iconData,
      this.index,
      this.page,
      this.routeChildName});
  int index;
  String title;
  IconData iconData;
  Widget page;
  String routeChildName;
  static List<Menu> tabMenu = <Menu>[
    Menu(
      index: 0,
      title: "Trang chủ",
      iconData: Icons.home,
      page: HomePage(),
      routeChildName: HomePage.routeName,
    ),
    Menu(
      index: 1,
      title: "Lịch sử chuyến",
      iconData: FontAwesomeIcons.child,
      page: HistoryPage(),
      routeChildName: HistoryPage.routeName,
    ),
    // Menu(
    //   index: 2,
    //   title: "Locate bus",
    //   iconData: FontAwesomeIcons.bus,
    //   page: LocateBusPage(),
    //   routeChildName: LocateBusPage.routeName,
    // ),
    Menu(
      index: 2,
      title: "Người dùng",
      iconData: Icons.person,
      page: UserPage(),
      routeChildName: UserPage.routeName,
    ),
  ];
}
