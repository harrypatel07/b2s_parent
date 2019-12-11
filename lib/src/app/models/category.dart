import 'package:b2s_parent/src/app/app_localizations.dart';
import 'package:b2s_parent/src/app/pages/history/history_page.dart';
import 'package:b2s_parent/src/app/pages/leave/leave_page.dart';
import 'package:b2s_parent/src/app/pages/message/message_page.dart';
import 'package:b2s_parent/src/app/pages/user/tickets/tickets_children.dart';
import 'package:flutter/material.dart';

class Category {
  const Category({@required this.name, @required this.color, this.routeName});

  final Color color;
  final String name;
  final String routeName;

  static final List<Category> categories = [
    // Category(
    //   name: "My students",
    //   color: Colors.teal,
    //   routeName: BusAttendancePage.routeName,
    // ),
    // Category(
    //   name: "Locale bus map",
    //   color: Colors.red,
    //   routeName: LocateBusPage.routeName,
    // ),
    Category(
      name: translation.text("HOME_PAGE.CATEGORY.LEAVE"),
      color: Color(0xFFdea118),
      routeName: LeavePage.routeName,
    ),
    Category(
      name: translation.text("HOME_PAGE.CATEGORY.MESSAGE"),
      color: Color(0xFFdea118),
      routeName: MessagePage.routeName,
    ),
    Category(
      name: translation.text("HOME_PAGE.CATEGORY.HISTORY_TRIP"),
      color: Color(0xFFdea118),
      routeName: HistoryPage.routeName,
    ),
    Category(
        name: translation.text("HOME_PAGE.CATEGORY.TICKET_MANAGER"),
        color: Color(0xFFdea118),
        routeName: TicketsChildrenPage.routeName),
  ];
}
