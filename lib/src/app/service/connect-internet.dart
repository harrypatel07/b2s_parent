import 'dart:io';

class ConnectInternet{
  static Future<bool> check()async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      print('not connected:'+_.toString());
      return false;
    }
    return false;
  }
}