import 'dart:convert';

import 'package:b2s_parent/src/app/core/app_setting.dart';
import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/models/childrenBusSession.dart';
import 'package:b2s_parent/src/app/models/menu.dart';
import 'package:b2s_parent/src/app/models/picking-transport-info.dart';
import 'package:b2s_parent/src/app/pages/busAttendance/bus_attendance_page.dart';
import 'package:b2s_parent/src/app/pages/history/history_page.dart';
import 'package:b2s_parent/src/app/pages/locateBus/locateBus_page.dart';

import 'package:b2s_parent/src/app/pages/tabs/tabs_page_viewmodel.dart';
import 'package:b2s_parent/src/app/models/category.dart';
import 'package:flutter/material.dart';

import '../../app_route.dart';

class HomePageViewModel extends ViewModelBase {
  TabsPageViewModel tabsPageViewModel;
  BuildContext context;
  bool isDataLoading = true;
  List<ChildrenBusSession> listChildren = [];

  HomePageViewModel() {
    if (listChildren.length == 0) loadData();
  }
  void categoryOnPress(Category category) {
    tabsPageViewModel = ViewModelProvider.of(context);
    Category.categories.asMap().forEach((index, cat) async {
      if (category.routeName != null) if (category.routeName == cat.routeName) {
        if (category.routeName == LocateBusPage.routeName ||
            category.routeName == HistoryPage.routeName) {
          if (tabsPageViewModel != null) {
            Menu.tabMenu.asMap().forEach((index, menu) {
              if (category.routeName == menu.routeChildName)
                tabsPageViewModel.onSlideMenuTapped(menu.index);
            });
          }
        } else {
          final result = await Navigator.pushNamed(
            context,
            category.routeName,
          ) as RoutePopArgument;
          if (result != null) if (result.routeName.toString() ==
              BusAttendancePage.routeName)
            tabsPageViewModel.onSlideMenuTapped(2, data: result.data);
        }
      }
    });
  }

  listOnTap(ChildrenBusSession data) {
    tabsPageViewModel = ViewModelProvider.of(context);
    tabsPageViewModel.locateBusPageViewModel.childrenBus = data;
    tabsPageViewModel.locateBusPageViewModel.listenData(data.sessionID);
    Navigator.pushNamed(context, LocateBusPage.routeName,
        arguments: LocateBusArgument(data));
  }

  loadData() {
    isDataLoading = true;
    api.getListChildrenBusSession().then((data) {
      listChildren = data;
      isDataLoading = false;
      this.updateState();
    });
  }

  onTapLeave(int index) {
    listChildren[index].status = StatusBus.list[3];
    updateChildren(listChildren[index]);
    loadData();
    this.updateState();
  }

  updateChildren(ChildrenBusSession session) {
    var picking = PickingTransportInfo.fromChildrenBusSession(session);
    api.updatePickingTransportInfo(picking).then((result) {
      print('Update children ' + result.toString());
    });
  }
}
