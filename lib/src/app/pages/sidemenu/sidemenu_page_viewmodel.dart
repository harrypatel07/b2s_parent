import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/models/menu.dart';
import 'package:b2s_parent/src/app/models/parent.dart';
import 'package:b2s_parent/src/app/pages/tabs/tabs_page_viewmodel.dart';
import 'package:flutter/material.dart';

import '../../models/children.dart';

class SideMenuPageViewModel extends ViewModelBase {
  String mainProfilePicture =
      "https://cdn1.iconfinder.com/data/icons/children-avatar-flat/128/children_avatar-01-512.png";
  String otherProfilePicture =
      "https://cdn1.iconfinder.com/data/icons/children-avatar-flat/128/children_avatar-11-256.png";
  Parent parent = Parent();
  List<Children> listChildren;
  Children childPrimary;
  List<Children> listChildOther;
  int currentIndex = 0;

  SideMenuPageViewModel() {
    listChildren = Children.getListChildrenPaidTicket(parent.listChildren);
    childPrimary = Children.getChildrenPrimary(listChildren);
    listChildOther = Children.getChildrenNotPrimary(listChildren);
  }

  void switchUser(Children children) {
    // String backupString = mainProfilePicture;
    // mainProfilePicture = otherProfilePicture;
    // otherProfilePicture = backupString;
    listChildren = Children.setChildrenPrimary(listChildren, children.id);
    childPrimary = Children.getChildrenPrimary(listChildren);
    listChildOther = Children.getChildrenNotPrimary(listChildren);
    tabsPageViewModel = ViewModelProvider.of(context);
    // if (tabsPageViewModel != null) {
    //   tabsPageViewModel.locateBusPageViewModel.childrenBus = ChildrenBusSession
    //       .list
    //       .singleWhere((item) => item.child.id == childPrimary.id);
    //   tabsPageViewModel.locateBusPageViewModel.updateState();
    // }
    this.updateState();
  }

  TabsPageViewModel tabsPageViewModel;

  void listContentOnTap(Menu menu) {
    currentIndex = menu.index;
    this.updateState();
    Navigator.of(context).pop();
    tabsPageViewModel = ViewModelProvider.of(context);
    if (tabsPageViewModel != null) {
      tabsPageViewModel.onSlideMenuTapped(menu.index);
    }
  }
}
