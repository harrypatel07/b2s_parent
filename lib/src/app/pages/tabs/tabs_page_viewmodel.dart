
import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/models/childrenBusSession.dart';
import 'package:b2s_parent/src/app/pages/home/home_page_viewmodel.dart';
import 'package:b2s_parent/src/app/pages/locateBus/locateBus_page_viewmodel.dart';
import 'package:b2s_parent/src/app/pages/user/user_page_viewmodel.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';

class TabsPageViewModel extends ViewModelBase {
  int currentTabIndex = 0;

  LocateBusPageViewModel locateBusPageViewModel;
  HomePageViewModel homePageViewModel;
  UserPageViewModel userPageViewModel;
  // CloudFiresStoreService cloudService = CloudFiresStoreService();
  TabsPageViewModel() {
    locateBusPageViewModel = LocateBusPageViewModel();
    homePageViewModel = HomePageViewModel();
    userPageViewModel = UserPageViewModel();
    //cloudService.busSession.syncColectionChildrenBusSession();
    // cloudService.sendMessage();
  }
  onTapped(int index) {
    currentTabIndex = index;
    // if (currentTabIndex == 2) //LocateBus
    // {
    //   Future.delayed(const Duration(milliseconds: 300), () {
    //     locateBusPageViewModel.showGoolgeMap = true;
    //     locateBusPageViewModel.updateState();
    //   });
    // }
    this.updateState();
  }

  GlobalKey<FancyBottomNavigationState> fancyKey =
      GlobalKey<FancyBottomNavigationState>();

  GlobalKey<ScaffoldState> scaffoldTabbar = GlobalKey<ScaffoldState>();
  //Xử lý khi slide menu tap item
  onSlideMenuTapped(int index, {ChildrenBusSession data}) {
    currentTabIndex = index;
    fancyKey.currentState.setPage(index);
    // if (data != null) {
    //   locateBusPageViewModel.childrenBus = data;
    //   locateBusPageViewModel.listenData(data.sessionID);
    // }
    // locateBusPageViewModel.updateState();
  }
}
