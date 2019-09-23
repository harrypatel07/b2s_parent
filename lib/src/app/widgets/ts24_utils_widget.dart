library ts24_utils;

import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/pages/tabs/tabs_page_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

BoxDecoration boxShaDow() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
              color: Colors.black12,
              offset: Offset(0.0, 15.0),
              blurRadius: 15.0),
          BoxShadow(
              color: Colors.black12,
              offset: Offset(0.0, -10.0),
              blurRadius: 10.0),
        ]);

//Icon menu on appBar
IconButton appBarIconSideMenu(BuildContext context) {
  TabsPageViewModel tabsPageViewModel = ViewModelProvider.of(context);
  GlobalKey<ScaffoldState> scaffoldTabbar = tabsPageViewModel != null
      ? tabsPageViewModel.scaffoldTabbar
      : GlobalKey<ScaffoldState>();
  return IconButton(
    icon: new Icon(Icons.menu),
    tooltip: "Open side menu",
    onPressed: () => scaffoldTabbar.currentState.openDrawer(),
  );
}

class LoadingDialog {
  static void showLoadingDialog(BuildContext context, String msg) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => new Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          color: Color(0xffffffff),
          height: 100,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new CircularProgressIndicator(),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: new Text(
                  msg,
                  //style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop(LoadingDialog);
    //Navigator.pop(context);
  }

  static void showMsgDialog(BuildContext context, String msg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Thông báo"),
        content: Text(msg),
        actions: [
          new FlatButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop(LoadingDialog);
            },
          ),
        ],
      ),
    );
  }
}

class LoadingIndicator {
  static Widget spinner({BuildContext context, bool loading}) {
    if (loading)
      return Center(
        // child: SpinKitWave(
        //     color: Theme.of(context).primaryColor, type: SpinKitWaveType.start),
        child: SpinKitThreeBounce(
          color: Theme.of(context).primaryColor,
          size: 40,
        ),
      );

    return Container();
  }

  static Widget progress(
      {BuildContext context,
      bool loading,
      AlignmentGeometry position = Alignment.topCenter}) {
    if (loading)
      return Align(
        alignment: position,
        // child: SpinKitWave(
        //     color: Theme.of(context).primaryColor, type: SpinKitWaveType.start),
        child: LinearProgressIndicator(
          valueColor:
              AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
        ),
      );

    return Container();
  }
}
