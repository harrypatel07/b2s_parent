import 'package:b2s_parent/src/app/pages/history/history_page.dart';
import 'package:b2s_parent/src/app/pages/home/home_page.dart';
import 'package:b2s_parent/src/app/pages/login/login_page.dart';
import 'package:b2s_parent/src/app/pages/tabs/tabs_page.dart';
import 'package:flutter/material.dart';

class Routes {
  static final Map<String, WidgetBuilder> route = {
    '/': (context) => LoginPage(),
    TabsPage.routeName: (context) =>
        TabsPage(ModalRoute.of(context).settings.arguments),
    HomePage.routeName: (context) => HomePage(),
    HistoryPage.routeName: (context) => HistoryPage()
  };
}
