import 'package:b2s_parent/src/app/app.dart';
import 'package:b2s_parent/src/app/app_localizations.dart';
import 'package:b2s_parent/src/app/app_route.dart';
import 'package:b2s_parent/src/app/core/app_setting.dart';
import 'package:b2s_parent/src/app/service/onesingal-service.dart';
import 'package:flutter/material.dart';

Future main() async {
  //from fluter version v.1.12.3 higher
  WidgetsFlutterBinding.ensureInitialized();
  OneSignalService.setup(oneSignal_myAppId,
      successCallBack: handlerPushNotification.init);
  await translation.init('vi');
  await Routes.navigateDefaultPage();

  runApp(MyApp());
}
