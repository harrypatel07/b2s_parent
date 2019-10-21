import 'package:b2s_parent/src/app/app.dart';
import 'package:b2s_parent/src/app/app_localizations.dart';
import 'package:b2s_parent/src/app/app_route.dart';
import 'package:flutter/material.dart';

Future main() async {
  await translation.init('vi');
  await Routes.navigateDefaultPage();
  runApp(MyApp());
}
