import 'dart:convert';
import 'package:b2s_parent/src/app/core/app_setting.dart';
import 'package:b2s_parent/src/app/models/parent.dart';
import 'package:b2s_parent/src/app/models/res-partner-title.dart';
import 'package:b2s_parent/src/app/models/res-partner.dart';
import 'package:b2s_parent/src/app/models/sale-order-line.dart';
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

  ///Lấy thông tin khách hàng
  Future<ResPartner> getCustomerInfo(String id) async {
    await this.authorization();
    body = new Map();
    body["domain"] = [
      ['id', '=', id],
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
      }
      return listResult[0];
    }).catchError((error) {
      return null;
    });
  }

  ///Lấy thông tin title(gender) của khách hàng
  Future<List<ResPartnerTitle>> getTitleCustomer() async {
    await this.authorization();
    List<ResPartnerTitle> listResult = new List();
    return http
        .get('${this.api}/search_read/res.partner.title', headers: this.headers)
        .then((http.Response response) async {
      if (response.statusCode == 200) {
        List list = json.decode(response.body);
        if (list.length > 0)
          listResult =
              list.map((item) => ResPartnerTitle.fromJson(item)).toList();
      }
      return listResult;
    }).catchError((error) {
      return listResult;
    });
  }

  ///Lấy danh sách contact for user to chat
  Future<List<ResPartner>> getListContact() async {
    await this.authorization();
    List<ResPartner> listResult = List();
    return http
        .get('${this.api}/search_read/res.partner', headers: this.headers)
        .then((http.Response response) async {
      if (response.statusCode == 200) {
        List list = json.decode(response.body);
        if (list.length > 0)
          listResult = list.map((item) => ResPartner.fromJson(item)).toList();
      }
      return listResult;
    }).catchError((error) {
      return listResult;
    });
  }

  ///Update thông tin khách hàng
  ///
  ///Success - Trả về true
  ///
  ///Fail - Trả về false
  Future<bool> updateCustomer(ResPartner partner) async {
    await this.authorization();
    body = new Map();
    body["model"] = "res.partner";
    body["ids"] = json.encode([partner.id]);
    body["values"] = json.encode(partner.toJson());
    return http
        .put('${this.api}/write', headers: this.headers, body: body)
        .then((http.Response response) {
      var result = false;
      if (response.statusCode == 200) {
        print(response.body);
        result = true;
        //print(list);
      } else {
        result = false;
      }
      return result;
    });
  }

  ///Insert thông tin khách hàng
  ///
  ///Success - Trả về new id
  ///
  ///Fail - Trả về null
  Future<dynamic> insertCustomer(ResPartner partner) async {
    await this.authorization();
    body = new Map();
    body["model"] = "res.partner";
    body["values"] = json.encode(partner.toJson());
    return http
        .post('${this.api}/create', headers: this.headers, body: body)
        .then((http.Response response) {
      var result;
      if (response.statusCode == 200) {
        print(response.body);
        if (response.body is List) result = response.body[0];
        //print(list);
      } else {
        result = null;
      }
      return result;
    });
  }

  /// Lấy thông tin vé của children
  ///
  Future<List<SaleOrderLine>> getTicketOfListChildren() async {
    Parent parent = Parent();
    List<SaleOrderLine> listResult = new List();
    await this.authorization();
    body = new Map();
    if (parent.listChildren.length == 0) return listResult;
    var domain = List<dynamic>();
    if (parent.listChildren.length > 1) {
      for (var i = 0; i < parent.listChildren.length - 1; i++) {
        domain.add("|");
      }
    }
    parent.listChildren.forEach((item) {
      domain.add(["order_partner_id", "=", item.id]);
    });
    body["domain"] = domain;
    var params = convertSerialize(body);
    return http
        .get('${this.api}/search_read/sale.order.line?$params',
            headers: this.headers)
        .then((http.Response response) async {
      if (response.statusCode == 200) {
        List list = json.decode(response.body);
        if (list.length > 0) {
          listResult =
              list.map((item) => SaleOrderLine.fromJson(item)).toList();
          listResult.forEach((item) {
            parent.listChildren.forEach((children) {
              if (item.orderPartnerId[0] == children.id)
                children.paidTicket = true;
            });
          });
          parent.saveLocal();
        }
      }
      return listResult;
    }).catchError((error) {
      return listResult;
    });
  }
}
