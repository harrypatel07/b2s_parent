import 'package:b2s_parent/src/app/widgets/index.dart';
import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  static const String routeName = "/user";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new TS24AppBar(
        title: new Text("User"),
      ),
      body: Container(),
    );
  }
}
