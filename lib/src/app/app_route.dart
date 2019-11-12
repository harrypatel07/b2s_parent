import 'package:b2s_parent/src/app/models/parent.dart';
import 'package:b2s_parent/src/app/pages/busAttendance/bus_attendance_page.dart';
import 'package:b2s_parent/src/app/pages/history/history_page.dart';
import 'package:b2s_parent/src/app/pages/home/home_page.dart';
import 'package:b2s_parent/src/app/pages/leave/leave_page.dart';
import 'package:b2s_parent/src/app/pages/locateBus/locateBus_page.dart';
import 'package:b2s_parent/src/app/pages/login/login_page.dart';
import 'package:b2s_parent/src/app/pages/message/ContactsPage/contacts_page.dart';
import 'package:b2s_parent/src/app/pages/message/messageDetail/message_detail_page.dart';
import 'package:b2s_parent/src/app/pages/message/messageUser/message_user_page.dart';
import 'package:b2s_parent/src/app/pages/message/message_page.dart';
import 'package:b2s_parent/src/app/pages/message/profileMessageUser/profile_message_user_page.dart';
import 'package:b2s_parent/src/app/pages/notification/notification_page.dart';
import 'package:b2s_parent/src/app/pages/tabs/tabs_page.dart';
import 'package:b2s_parent/src/app/pages/user/edit_profile_children/edit_profile_children.dart';
import 'package:b2s_parent/src/app/pages/user/edit_profile_parent/edit_profile_parent.dart';
import 'package:b2s_parent/src/app/pages/user/profile_children/profile_children.dart';
import 'package:b2s_parent/src/app/pages/user/settings/user_settings.dart';
import 'package:b2s_parent/src/app/pages/user/tickets/tickes_children.dart';
import 'package:flutter/material.dart';

import 'core/app_setting.dart';

class Routes {
  static Widget defaultPage;
  static navigateDefaultPage() async {
    Parent parent = new Parent();
    bool result = await parent.checkParentExist();
    if (result) {
      //Lấy lại danh sách children đã mua vé
      api.getParentInfo(parent.id).then((_) {
        api.getTicketOfListChildren();
      });
      Routes.defaultPage =
          TabsPage(TabsArgument(routeChildName: HomePage.routeName));
    } else
      Routes.defaultPage = LoginPage();
  }

  static final Map<String, WidgetBuilder> route = {
    // '/': (context) => LoginPage(),
    LoginPage.routeName: (context) => LoginPage(),
    TabsPage.routeName: (context) =>
        TabsPage(ModalRoute.of(context).settings.arguments),
    HomePage.routeName: (context) => HomePage(),
    HistoryPage.routeName: (context) => HistoryPage(),
    LocateBusPage.routeName: (context) =>
        LocateBusPage(ModalRoute.of(context).settings.arguments),
    BusAttendancePage.routeName: (context) => BusAttendancePage(),
    LeavePage.routeName: (context) => LeavePage(listChildren: ModalRoute.of(context).settings.arguments),
    MessagePage.routeName: (context) => MessagePage(),
    MessageDetailPage.routeName: (context) =>
        MessageDetailPage(chatting: ModalRoute.of(context).settings.arguments),
    MessageUserPage.routeName: (context) =>
        MessageUserPage(userId: ModalRoute.of(context).settings.arguments),
    NotificationPage.routeName: (context) => NotificationPage(),
//    PopupEditProfileChildren.routeName: (context) => PopupEditProfileChildren(ModalRoute.of(context).settings.arguments),
    EditProfileChildren.routeName: (context) => EditProfileChildren(ModalRoute.of(context).settings.arguments),
    UserSettingsPage.routeName: (context) => UserSettingsPage(),
    ProfileChildrenPage.routeName: (context) => ProfileChildrenPage(
          children: ModalRoute.of(context).settings.arguments,
        ),
    EditProfileParent.routeName: (context) => EditProfileParent(ModalRoute.of(context).settings.arguments),
    TicketsChildren.routeName: (context)=> TicketsChildren(arguments: ModalRoute.of(context).settings.arguments,),
    ProfileMessageUserPage.routeName: (context) => ProfileMessageUserPage(userModel:ModalRoute.of(context).settings.arguments),
    ContactsPage.routeName:(context) => ContactsPage(),
  };
}

class MyRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  void _sendScreenView(PageRoute<dynamic> route) {
    var screenName = route.settings.name;
    switch (screenName) {
      case TabsPage.routeName:
        break;
      default:
    }
    print('screenName $screenName');

    // do something with it, ie. send it to your analytics service collector
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    super.didPush(route, previousRoute);

    if (route is PageRoute) {
      _sendScreenView(route);
    }
  }

  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);

    if (newRoute is PageRoute) {
      _sendScreenView(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    super.didPop(route, previousRoute);

    if (previousRoute is PageRoute && route is PageRoute) {
      _sendScreenView(previousRoute);
    }
  }
}

class RoutePopArgument {
  final String routeName;
  final dynamic data;

  RoutePopArgument(this.routeName, this.data);
}
