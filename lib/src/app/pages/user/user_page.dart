import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  static const String routeName = "/user";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("User"),
      ),
      body: Container(),
    );
  }
}
