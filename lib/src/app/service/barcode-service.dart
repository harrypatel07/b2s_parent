import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

class BarCodeService {
  static ScanOptions _options = ScanOptions(
    useCamera: -1,
    autoEnableFlash: false,
    android: AndroidOptions(
      useAutoFocus: true,
    ),
  );
  static Future<String> scan() async {
    try {
      // String barcode = await BarcodeScanner.scan();
      ScanResult scanResult = await BarcodeScanner.scan(options: _options);
      return scanResult?.rawContent ?? "";
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        print("The user did not grant the camera permission!");
        return null;
      } else {
        print('Unknown error: $e');
        return null;
      }
    } on FormatException {
      print(
          'null (User returned using the "back"-button before scanning anything. Result)');
      return null;
    } catch (e) {
      print('Unknown error: $e');
      return null;
    }
  }
}
