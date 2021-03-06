import 'dart:async';

import 'package:b2s_parent/src/app/app_localizations.dart';
import 'package:b2s_parent/src/app/core/app_setting.dart';
import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/models/children.dart';
import 'package:b2s_parent/src/app/models/childrenBusSession.dart';
import 'package:b2s_parent/src/app/models/menu.dart';
import 'package:b2s_parent/src/app/models/parent.dart';
import 'package:b2s_parent/src/app/models/picking-transport-info.dart';
import 'package:b2s_parent/src/app/pages/busAttendance/bus_attendance_page.dart';
import 'package:b2s_parent/src/app/pages/history/history_page.dart';
import 'package:b2s_parent/src/app/pages/leave/leave_page.dart';
import 'package:b2s_parent/src/app/pages/locateBus/locateBus_page.dart';

import 'package:b2s_parent/src/app/pages/tabs/tabs_page_viewmodel.dart';
import 'package:b2s_parent/src/app/models/category.dart';
import 'package:b2s_parent/src/app/widgets/index.dart';
import 'package:b2s_parent/src/app/widgets/popupConfirm.dart';
import 'package:flutter/material.dart';

import '../../app_route.dart';

class HomePageViewModel extends ViewModelBase {
  TabsPageViewModel tabsPageViewModel;
  BuildContext context;
  bool isDataLoading = true;
  List<RouteBus> listRouteBus = List();
  List<ChildrenBusSession> listChildren = [];
  StreamSubscription streamCloud;
  HomePageViewModel() {
    if (listChildren.length == 0) loadData();
  }
  @override
  dispose() {
    if (streamCloud != null) streamCloud.cancel();
    super.dispose();
  }

  Children getChildrenFromParent(int childrenId) {
    return Parent()
        .listChildren
        .firstWhere((children) => children.id == childrenId);
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
            List<Children> listChildrenPaidTicket =
                Children.getListChildrenPaidTicket(Parent().listChildren);
            if (listChildrenPaidTicket.length > 0)
              Navigator.pushNamed(context, category.routeName,
                  arguments: listChildrenPaidTicket);
            else {
              LoadingDialog.showMsgDialog(context,
                  'Hãy đăng ký thông tin cho trẻ trước, sau đó có thể sử dụng chức năng này.');
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
      }
    });
  }

  listOnTap(ChildrenBusSession data) {
    //  tabsPageViewModel = ViewModelProvider.of(context);
    //  tabsPageViewModel.locateBusPageViewModel.childrenBus = data;
    //  tabsPageViewModel.locateBusPageViewModel.listenData(data.sessionID);
    if (data.status.statusID == 3) return;
    if (data.status.statusID == 2 || data.status.statusID == 4)
      LoadingDialog.showMsgDialog(context, 'Chuyến đi đã hoàn thành.');
    else
      Navigator.pushNamed(context, LocateBusPage.routeName,
          arguments: LocateBusArgument(data));
//    api.getListChildrenBusSessionV2();
    // api.getHistoryTrip(take: 20, skip: 0);
  }

  loadData() {
    isDataLoading = true;
    this.updateState();
    api.getListChildrenBusSessionV2().then((data) {
      listChildren = data;
      isDataLoading = false;
      //tạo busSession trên firestore
      if (data.length > 0)
        cloudService.busSession
            .createListBusSessionFromChildrenBusSession(data)
            .then((_) {
          listenData();
        });
      this.updateState();
    });
  }

  onTapLeave(ChildrenBusSession childrenBusSession) {
    popupConfirm(
      context: context,
      title: translation.text("POPUP_CONFIRM.TITLE"),
      desc: translation.text("POPUP_CONFIRM.DESC_STATUS"),
      yes: translation.text("POPUP_CONFIRM.YES"),
      no: translation.text("POPUP_CONFIRM.NO"),
      onTap: () {
        childrenBusSession.status = StatusBus.list[3];
        updateChildren(childrenBusSession);
        //update bus session treen firestore
        cloudService.busSession
            .updateBusSessionFromChildrenBusSession(childrenBusSession);
        this.updateState();
        Navigator.pop(context);
        print('onTap leave');
      },
    );
  }

  updateChildren(ChildrenBusSession session) {
    var picking = PickingTransportInfo.fromChildrenBusSession(session);
    api.updatePickingTransportInfo(picking).then((result) {
      print('Update children ' + result.toString());
    });
  }

  listenData() async {
    if (streamCloud != null) streamCloud.cancel();
    streamCloud = await cloudService.busSession
        .listenBusSessionForChildren(listChildren, () {
      this.updateState();
    });
  }
}
