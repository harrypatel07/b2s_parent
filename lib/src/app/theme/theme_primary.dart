import 'package:flutter/material.dart';

class ThemePrimary {
  static const primaryColor = Color(0xFFFFD752);
  static const gradientColor = Color(0xFFc49b29);
  static const appBar_textTheme = TextTheme(
    title: TextStyle(
        color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
  );
  static const appBar_iconTheme = IconThemeData(
    color: Colors.white,
  );
  static theme() {
    return ThemeData(
      fontFamily: "Quicksand",
      primaryColor: primaryColor,
      //primaryColor: Colors.blue,
      backgroundColor: Colors.white,
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.blue,
        actionTextColor: Colors.white,
      ),
      //canvasColor: Colors.white,
      // appBarTheme: AppBarTheme(
      //     textTheme: appBar_textTheme, iconTheme: appBar_iconTheme),
    );
  }

  static TextStyle loginPageButton(BuildContext context) {
    return TextStyle(color: Theme.of(context).primaryColor, fontSize: 15);
  }

  static const history_page_backgroundcolor = Color(0XFFF3F7F6);
}
