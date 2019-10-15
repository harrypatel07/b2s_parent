import 'dart:convert';
import 'package:b2s_parent/src/app/core/app_setting.dart';
import 'package:http/http.dart' as http;

import 'api_master.dart';

enum TypeImage {
  SMALL,
  MEDIUM,
  ORIGINAL,
}

class Api1 extends ApiMaster {
  Api1();

  ///Kiểm tra thông tin đăng nhập.
  ///Trả về true or false.
  Future<StatusCodeGetToken> checkLogin(
      {String username, String password}) async {
    StatusCodeGetToken result = StatusCodeGetToken.FALSE;
    this.grandType = GrandType.password;
    this.clientId = password_client_id;
    this.clienSecret = password_client_secret;
    this.username = username;
    this.password = password;
    result = await this.authorization(refresh: true);
    return result;
  }

  //Kiểm tra quyền truy cập POS
  Future<bool> checkAccessRightPOS() async {
    await this.authorization();
    return http
        .get('${this.api}/access/rights/pos.config', headers: this.headers)
        .then((http.Response response) {
      if (response.statusCode == 200) {
        bool result = response.body.toLowerCase() == 'true' ? true : false;
        return result;
      }
      return false;
    });
  }

  //Lấy thông tin user session
  Future<dynamic> getUserInfo() async {
    await this.authorization();
    body = new Map();
    body["fields"] = ['name', 'id'];
    body["domain"] = [
      [
        'email',
        '=',
        this.username,
      ]
    ];
    body["limit"] = 1;
    var params = convertSerialize(body);
    return http
        .get('${this.api}/search_read/res.users?$params', headers: this.headers)
        .then((http.Response response) {
      if (response.statusCode == 200) {
        var list = json.decode(response.body);
        return list;
      } else
        return null;
    }).catchError((error) {
      return null;
    });
  }
}
