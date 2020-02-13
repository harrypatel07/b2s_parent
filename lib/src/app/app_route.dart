import 'dart:async';

import 'package:b2s_parent/src/app/models/parent.dart';
import 'package:b2s_parent/src/app/pages/busAttendance/bus_attendance_page.dart';
import 'package:b2s_parent/src/app/pages/history/history_page.dart';
import 'package:b2s_parent/src/app/pages/historyDetail/history_detail_page.dart';
import 'package:b2s_parent/src/app/pages/home/home_page.dart';
import 'package:b2s_parent/src/app/pages/leave/leave_page.dart';
import 'package:b2s_parent/src/app/pages/locateBus/locateBus_page.dart';
import 'package:b2s_parent/src/app/pages/login/forgotPassword/inputPassword/create_new_pass.dart';
import 'package:b2s_parent/src/app/pages/login/forgotPassword/inputEmail/input_email.dart';
import 'package:b2s_parent/src/app/pages/login/login_page.dart';
import 'package:b2s_parent/src/app/pages/message/ContactsPage/contacts_page.dart';
import 'package:b2s_parent/src/app/pages/message/messageDetail/message_detail_page.dart';
import 'package:b2s_parent/src/app/pages/message/message_page.dart';
import 'package:b2s_parent/src/app/pages/message/profileMessageUser/profile_message_user_page.dart';
import 'package:b2s_parent/src/app/pages/notification/notification_page.dart';
import 'package:b2s_parent/src/app/pages/payment/editPaymentPage/edit_payment_page.dart';
import 'package:b2s_parent/src/app/pages/payment/payment_page.dart';
import 'package:b2s_parent/src/app/pages/popupChat/contentPopupChat/content_popup_chat_page.dart';
import 'package:b2s_parent/src/app/pages/popupChat/popupChat_page.dart';
import 'package:b2s_parent/src/app/pages/tabs/tabs_page.dart';
import 'package:b2s_parent/src/app/pages/user/edit_profile_children/edit_profile_children.dart';
import 'package:b2s_parent/src/app/pages/user/edit_profile_parent/edit_profile_parent.dart';
import 'package:b2s_parent/src/app/pages/user/profile_children/profile_children.dart';
import 'package:b2s_parent/src/app/pages/user/register/register_page.dart';
import 'package:b2s_parent/src/app/pages/user/settings/user_settings.dart';
import 'package:b2s_parent/src/app/pages/user/tickets/tickets_children.dart';
import 'package:b2s_parent/src/app/pages/user/tickets_detail/student_card/student_card_page.dart';
import 'package:b2s_parent/src/app/pages/user/tickets_detail/ticket_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

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
    LeavePage.routeName: (context) =>
        LeavePage(listChildren: ModalRoute.of(context).settings.arguments),
    MessagePage.routeName: (context) => MessagePage(),
    MessageDetailPage.routeName: (context) =>
        MessageDetailPage(chatting: ModalRoute.of(context).settings.arguments),
//    MessageUserPage.routeName: (context) =>
//        MessageUserPage(userId: ModalRoute.of(context).settings.arguments),
    NotificationPage.routeName: (context) => NotificationPage(),
//    PopupEditProfileChildren.routeName: (context) => PopupEditProfileChildren(ModalRoute.of(context).settings.arguments),
    EditProfileChildren.routeName: (context) =>
        EditProfileChildren(ModalRoute.of(context).settings.arguments),
    UserSettingsPage.routeName: (context) => UserSettingsPage(),
    ProfileChildrenPage.routeName: (context) => ProfileChildrenPage(
          profileChildrenPageArgs: ModalRoute.of(context).settings.arguments,
        ),
    EditProfileParent.routeName: (context) =>
        EditProfileParent(ModalRoute.of(context).settings.arguments),
    TicketsChildrenPage.routeName: (context) => TicketsChildrenPage(),
    ProfileMessageUserPage.routeName: (context) => ProfileMessageUserPage(
        userModel: ModalRoute.of(context).settings.arguments),
    ContactsPage.routeName: (context) => ContactsPage(),
    TicketsDetailPage.routeName: (context) =>
        TicketsDetailPage(args: ModalRoute.of(context).settings.arguments),
    StudentCardPage.routeName: (context) =>
        StudentCardPage(args: ModalRoute.of(context).settings.arguments),
    HistoryDetailPage.routeName: (context) => HistoryDetailPage(
          historyInfo: ModalRoute.of(context).settings.arguments,
        ),
    EditPaymentPage.routeName: (context) => EditPaymentPage(),
    PaymentPage.routeName: (context) => PaymentPage(),
    RegisterPage.routeName: (context) => RegisterPage(),
    ContentPopupChatPage.routeName: (context) =>
        ContentPopupChatPage(ModalRoute.of(context).settings.arguments),
    ForgotPasswordEmail.routeName: (context) => ForgotPasswordEmail(),
    CreateNewPass.routeName: (context) => CreateNewPass()
  };
}

void function(int index) {}

class MyRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  static String routeCurrentName = '';
  void _sendScreenView(PageRoute<dynamic> route) {
    handlerPushPageName.add(route.settings.name.toString());
    routeCurrentName = route.settings.name;
    var screenName = route.settings.name;
    switch (screenName) {
      case PopupChatPage.routeName:
        handlerPushNotification.dispose();
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
