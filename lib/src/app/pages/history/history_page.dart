import 'package:b2s_parent/src/app/pages/sidemenu/sidemenu_page.dart';
import 'package:b2s_parent/src/app/widgets/index.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  static const String routeName = "/history";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("History"),
        leading: appBarIconSideMenu(),
      ),
      body: Container(),
      // drawer: SideMenuPage(),
    );
  }
}
