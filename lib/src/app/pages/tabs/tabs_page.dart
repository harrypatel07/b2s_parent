import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/pages/history/history_page.dart';
import 'package:b2s_parent/src/app/pages/home/home_page.dart';
import 'package:b2s_parent/src/app/pages/tabs/tabs_page_viewmodel.dart';
import 'package:b2s_parent/src/app/pages/user/user_page.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';

class TabsPage extends StatefulWidget {
  static const String routeName = "/tabs";
  final TabsArgument args;
  TabsPage(this.args);
  @override
  _TabsPageState createState() => _TabsPageState();
}

class TabsArgument {
  final String routeChildName;
  TabsArgument({this.routeChildName});
}

class _TabsPageState extends State<TabsPage> {
  int currentTabIndex = 0;

  List<Widget> tabs = [HomePage(), HistoryPage(), UserPage()];

  @override
  void initState() {
    super.initState();
    _navigateChild(widget.args);
  }

  _navigateChild(TabsArgument arg) {
    switch (arg.routeChildName) {
      case HomePage.routeName:
        currentTabIndex = 0;
        break;
      case HistoryPage.routeName:
        currentTabIndex = 1;
        break;
      case UserPage.routeName:
        currentTabIndex = 2;
        break;
    }
  }

  onTapped(int index) {
    setState(() => currentTabIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    var viewModel = new TabsPageViewModel();
    return Scaffold(
      body: ViewModelProvider(
        viewmodel: viewModel,
        child: IndexedStack(
          index: currentTabIndex,
          children: tabs,
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   onTap: onTapped,
      //   currentIndex: currentTabIndex,
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       title: Text("Home"),
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.history),
      //       title: Text("History"),
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       title: Text("User"),
      //     ),
      //   ],
      // ),
      bottomNavigationBar: FancyBottomNavigation(
        tabs: [
          TabData(iconData: Icons.home, title: "Home"),
          TabData(iconData: Icons.history, title: "History"),
          TabData(iconData: Icons.person, title: "User")
        ],
        onTabChangedListener: (index) {
          //Navigator.of(context).pop();
          onTapped(index);
        },
      ),
    );
  }
}
