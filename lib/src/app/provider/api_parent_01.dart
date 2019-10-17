import 'dart:convert';
import 'package:b2s_parent/src/app/core/app_setting.dart';
import 'package:b2s_parent/src/app/models/parent.dart';
import 'package:b2s_parent/src/app/models/res-partner.dart';
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

  /// Lấy thông tin Parent và children
  ///
  Future<List<ResPartner>> getParentInfo(int id) async {
    await this.authorization();
    body = new Map();
    body["domain"] = [
      '|',
      ['id', '=', id],
      ['parent_id', '=', id]
    ];
    var params = convertSerialize(body);
    List<ResPartner> listResult = new List();
    return http
        .get('${this.api}/search_read/res.partner?$params',
            headers: this.headers)
        .then((http.Response response) async {
      if (response.statusCode == 200) {
        List list = json.decode(response.body);
        if (list.length > 0)
          listResult = list.map((item) => ResPartner.fromJson(item)).toList();
        final parent = listResult.firstWhere((item) => item.id == id);
        final children = listResult.where((item) {
          if (item.parentId is List) {
            final List listParent = item.parentId;
            return listParent[0] == id;
          }
          return false;
        }).toList();
        Parent parentInfo = Parent();
        parentInfo.fromResPartner(parent, children);
        await parentInfo.saveLocal();
      }
      return listResult;
    }).catchError((error) {
      return listResult;
    });
  }
}
