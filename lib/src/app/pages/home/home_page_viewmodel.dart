import 'dart:convert';

import 'package:b2s_parent/src/app/core/app_setting.dart';
import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/models/childrenBusSession.dart';
import 'package:b2s_parent/src/app/models/menu.dart';
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
    // tabsPageViewModel = ViewModelProvider.of(context);
    // tabsPageViewModel.locateBusPageViewModel.childrenBus = data;
    // tabsPageViewModel.locateBusPageViewModel.listenData(data.sessionID);
    // Navigator.pushNamed(context, LocateBusPage.routeName,
    //     arguments: LocateBusArgument(data));
    var list = json.decode("""
      {\"code\": 200, \"msg\": \"Request success.\", \"data\": {\"outgoing\": {\"Tr\ư\ờng L\ê A\": {\"00:00:00\": {\"1765\": {\"number\": \"TR/1765\", \"saleorder_id\": {\"id\": 62, \"name\": \"SO049\", \"partner_id\": {\"id\": 27, \"name\": \"Nicole Ford\"}}, \"transporter_id\": {\"id\": 14, \"name\": \"Azure Interior\"}, \"vehicle_id\": {\"id\": 1, \"name\": \"Opel/Astra/1-ACK-205\"}, \"vehicle_driver\": {\"id\": 47, \"name\": \"L\ái xe A\", \"user_id\": 9}, \"transport_date\": \"22:00:00\", \"user_id\": \"Mitchell Admin\", \"school_time\": \"AM\", \"state\": \"draft\", \"picking_location\": {\"name\": \"3404  Edgewood Road, Jonesboro AR 72401, United States\", \"pos_x\": false, \"pos_y\": false}, \"destination_location\": {\"name\": \"Tr\ư\ờng L\ê A\", \"pos_x\": false, \"pos_y\": false}}}, \"00:15:00\": {\"506\": {\"number\": \"TR/0506\", \"saleorder_id\": {\"id\": 31, \"name\": \"SO030\", \"partner_id\": {\"id\": 34, \"name\": \"Lorraine Douglas\"}}, \"transporter_id\": {\"id\": 14, \"name\": \"Azure Interior\"}, \"vehicle_id\": {\"id\": 1, \"name\": \"Opel/Astra/1-ACK-205\"}, \"vehicle_driver\": {\"id\": 47, \"name\": \"L\ái xe A\", \"user_id\": 9}, \"transport_date\": \"04:00:00\", \"user_id\": \"Mitchell Admin\", \"school_time\": \"AM\", \"state\": \"draft\", \"picking_location\": {\"name\": \"3202  Hannah Street, Asheville NC 28801, United States\", \"pos_x\": false, \"pos_y\": false}, \"destination_location\": {\"name\": \"Tr\ư\ờng L\ê A\", \"pos_x\": false, \"pos_y\": false}}}, \"00:30:00\": {\"758\": {\"number\": \"TR/0758\", \"saleorder_id\": {\"id\": 32, \"name\": \"SO031\", \"partner_id\": {\"id\": 45, \"name\": \"abcd \"}}, \"transporter_id\": {\"id\": 14, \"name\": \"Azure Interior\"}, \"vehicle_id\": {\"id\": 1, \"name\": \"Opel/Astra/1-ACK-205\"}, \"vehicle_driver\": {\"id\": 47, \"name\": \"L\ái xe A\", \"user_id\": 9}, \"transport_date\": \"04:00:00\", \"user_id\": \"Mitchell Admin\", \"school_time\": \"AM\", \"state\": \"draft\", \"picking_location\": {\"name\": \"1128 Lunetta Street, caasdjkl, asd asd,   , \", \"pos_x\": false, \"pos_y\": false}, \"destination_location\": {\"name\": \"Tr\ư\ờng L\ê A\", \"pos_x\": false, \"pos_y\": false}}}, \"00:45:20\": {\"3\": {\"number\": \"TR/0003\", \"saleorder_id\": {\"id\": 30, \"name\": \"SO029\", \"partner_id\": {\"id\": 45, \"name\": \"abcd \"}}, \"transporter_id\": {\"id\": 14, \"name\": \"Azure Interior\"}, \"vehicle_id\": {\"id\": 1, \"name\": \"Opel/Astra/1-ACK-205\"}, \"vehicle_driver\": {\"id\": 47, \"name\": \"L\ái xe A\", \"user_id\": 9}, \"transport_date\": \"04:00:00\", \"user_id\": \"Mitchell Admin\", \"school_time\": \"AM\", \"state\": \"draft\", \"picking_location\": {\"name\": \"1128 Lunetta Street, caasdjkl, asd asd,   , \", \"pos_x\": false, \"pos_y\": false}, \"destination_location\": {\"name\": \"Tr\ư\ờng L\ê A\", \"pos_x\": false, \"pos_y\": false}}}}, \"1128 Lunetta Street, caasdjkl, asd asd,   , \": {\"00:10:00\": {\"4\": {\"number\": \"TR/0004\", \"saleorder_id\": {\"id\": 30, \"name\": \"SO029\", \"partner_id\": {\"id\": 45, \"name\": \"abcd \"}}, \"transporter_id\": {\"id\": 14, \"name\": \"Azure Interior\"}, \"vehicle_id\": {\"id\": 1, \"name\": \"Opel/Astra/1-ACK-205\"}, \"vehicle_driver\": {\"id\": 47, \"name\": \"L\ái xe A\", \"user_id\": 9}, \"transport_date\": \"17:00:00\", \"user_id\": \"Mitchell Admin\", \"school_time\": \"AM\", \"state\": \"draft\", \"picking_location\": {\"name\": \"Tr\ư\ờng L\ê A\", \"pos_x\": false, \"pos_y\": false}, \"destination_location\": {\"name\": \"1128 Lunetta Street, caasdjkl, asd asd,   , \", \"pos_x\": false, \"pos_y\": false}}}}}, \"incoming\": {\"3404  Edgewood Road, Jonesboro AR 72401, United States\": {\"00:00:00\": {\"1512\": {\"number\": \"TR/1512\", \"saleorder_id\": {\"id\": 62, \"name\": \"SO049\", \"partner_id\": {\"id\": 27, \"name\": \"Nicole Ford\"}}, \"transporter_id\": {\"id\": 14, \"name\": \"Azure Interior\"}, \"vehicle_id\": {\"id\": 1, \"name\": \"Opel/Astra/1-ACK-205\"}, \"vehicle_driver\": {\"id\": 47, \"name\": \"L\ái xe A\", \"user_id\": 9}, \"transport_date\": \"11:00:00\", \"user_id\": \"Mitchell Admin\", \"school_time\": \"AM\", \"state\": \"draft\", \"picking_location\": {\"name\": \"Tr\ư\ờng L\ê A\", \"pos_x\": false, \"pos_y\": false}, \"destination_location\": {\"name\": \"3404  Edgewood Road, Jonesboro AR 72401, United States\", \"pos_x\": false, \"pos_y\": false}}}}}}}
      
      """);
    print(list);
  }

  loadData() {
    api.getListChildrenBusSession().then((data) {
      listChildren = data;
      this.updateState();
    });
  }
}
