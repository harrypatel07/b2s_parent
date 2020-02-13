import 'dart:ui';

import 'package:b2s_parent/src/app/app_localizations.dart';
import 'package:b2s_parent/src/app/theme/theme_primary.dart';
import 'package:b2s_parent/src/app/widgets/ts24_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:tip_dialog/tip_dialog.dart';

class NotificationWidget extends StatelessWidget {
  final String title;
  final String body;
  const NotificationWidget({Key key, this.title, this.body}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: (window.physicalSize.width / window.devicePixelRatio),
      decoration: BoxDecoration(
          color: Colors.transparent),
      margin: EdgeInsets.all(12),
      child: Column(
        children: <Widget>[
          Container(
            width: (window.physicalSize.width /
                window.devicePixelRatio *
                0.8),
            padding: EdgeInsets.all(15),
            child: Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            color: ThemePrimary.primaryColor,
          ),
          Container(
            padding: EdgeInsets.all(15.0),
            width: (window.physicalSize.width /
                window.devicePixelRatio *
                0.8),
            color: Colors.white,
            child: Center(
              child: Column(
                children: <Widget>[
                  Text(
                    body,
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TS24Button(
                    width: 85,
                    height: 40,
                    onTap: () {
                      TipDialogHelper.dismiss();
                    },
                    decoration: BoxDecoration(
                        color: ThemePrimary.primaryColor,
                        borderRadius:
                        BorderRadius.all(Radius.circular(0))),
                    child: Center(
                      child: Text(
                        translation.text("POPUP_CONFIRM.CLOSE"),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
