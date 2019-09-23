import 'package:flutter/material.dart';

class ThemePrimary {
  static theme() {
    return ThemeData(
      fontFamily: "Quicksand",
      primaryColor: Color(0xFFFFD752),
      //primaryColor: Colors.blue,
      backgroundColor: Colors.white,
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.blue,
        actionTextColor: Colors.white,
      ),
      //canvasColor: Colors.white,
    );
  }

  static TextStyle loginPageButton(BuildContext context) {
    return TextStyle(color: Theme.of(context).primaryColor, fontSize: 15);
  }

  static const history_page_backgroundcolor = Color(0XFFF3F7F6);
}
