library appsetting;

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

final LocalStorage localStorage = new LocalStorage("localStorage");
final GlobalKey<ScaffoldState> scaffoldTabbar = new GlobalKey<ScaffoldState>();
String domainApi = "http://sales24.odoo24.vn";
