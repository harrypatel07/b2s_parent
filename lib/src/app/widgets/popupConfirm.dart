import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void popupConfirm({BuildContext context,String title, String desc, String yes,String no,Function onTap}) {
  var alertStyle = AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: false,
    isOverlayTapDismiss: true,
    descStyle: TextStyle(fontWeight: FontWeight.bold),
    animationDuration: Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
      side: BorderSide(
        color: Colors.grey,
      ),
    ),
    titleStyle: TextStyle(
      color: Colors.red,
    ),
  );
  new Alert(
    context: context,
    type: AlertType.info,
    style: alertStyle,
    title: title,
    desc: desc,
    buttons: [
      DialogButton(
        child: Text(
          no,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        gradient: LinearGradient(colors: [Colors.green, Colors.teal]),
        onPressed: () => Navigator.pop(context),
        width: 120,
      ),
      DialogButton(
        child: Text(
          yes,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        gradient: LinearGradient(colors: [
          Color.fromRGBO(255, 69, 0, 1.0),
          Color.fromRGBO(255, 165, 0, 1.0),
          Color.fromRGBO(255, 215, 0, 1.0),
        ]),
        onPressed: onTap,
        width: 120,
      )
    ],
  ).show();
}