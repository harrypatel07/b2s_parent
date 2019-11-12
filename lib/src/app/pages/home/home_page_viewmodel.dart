import 'dart:convert';

import 'package:b2s_parent/src/app/core/app_setting.dart';
import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/helper/constant.dart';
import 'package:b2s_parent/src/app/models/children.dart';
import 'package:b2s_parent/src/app/models/childrenBusSession.dart';
import 'package:b2s_parent/src/app/models/menu.dart';
import 'package:b2s_parent/src/app/models/picking-transport-info.dart';
import 'package:b2s_parent/src/app/pages/busAttendance/bus_attendance_page.dart';
import 'package:b2s_parent/src/app/pages/history/history_page.dart';
import 'package:b2s_parent/src/app/pages/leave/leave_page.dart';
import 'package:b2s_parent/src/app/pages/locateBus/locateBus_page.dart';

import 'package:b2s_parent/src/app/pages/tabs/tabs_page_viewmodel.dart';
import 'package:b2s_parent/src/app/models/category.dart';
import 'package:flutter/material.dart';

import '../../app_route.dart';

class HomePageViewModel extends ViewModelBase {
  TabsPageViewModel tabsPageViewModel;
  BuildContext context;
  bool isDataLoading = true;
  List<ChildrenBusSession> listChildrenDepart = [];
  List<ChildrenBusSession> listChildrenArrive = [];

  HomePageViewModel() {
    if (listChildrenDepart.length == 0 || listChildrenArrive.length == 0) loadData();
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
          if (category.routeName == LeavePage.routeName) {
            List<Children> _list = getListChildren();
            Navigator.pushNamed(context, category.routeName, arguments: _list);
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
      }
    });
  }
  List<Children> getListChildren(){
    List<Children> _list = List();
    this.listChildrenDepart.forEach((session){
      if(!_list.contains(session.child))
        _list.add(session.child);
    });
    this.listChildrenArrive.forEach((session){
      if(!_list.contains(session.child))
        _list.add(session.child);
    });
    return _list;
  }
  listOnTap(ChildrenBusSession data) {
     tabsPageViewModel = ViewModelProvider.of(context);
     tabsPageViewModel.locateBusPageViewModel.childrenBus = data;
     tabsPageViewModel.locateBusPageViewModel.listenData(data.sessionID);
     Navigator.pushNamed(context, LocateBusPage.routeName,
         arguments: LocateBusArgument(data));
//    api.getListChildrenBusSessionV2();
  }

  loadData() {
    isDataLoading = true;
    listChildrenArrive = List();
    listChildrenDepart = List();
    api.getListChildrenBusSessionV2().then((data) {
      data.forEach((item){
        if(item.type == 0)
          listChildrenDepart.add(item);
        else listChildrenArrive.add(item);
      });
      isDataLoading = false;
      this.updateState();
    });
    this.updateState();
  }

  onTapLeave(int index,int type) {
    if(type == TYPE_DEPART) {
      listChildrenDepart[index].status = StatusBus.list[3];
      updateChildren(listChildrenDepart[index]);
    }else if(type == TYPE_ARRIVE){
      listChildrenArrive[index].status = StatusBus.list[3];
      updateChildren(listChildrenArrive[index]);
    }
//    loadData();
    this.updateState();
  }

  updateChildren(ChildrenBusSession session) {
    var picking = PickingTransportInfo.fromChildrenBusSession(session);
    api.updatePickingTransportInfo(picking).then((result) {
      print('Update children ' + result.toString());
    });
  }
}
