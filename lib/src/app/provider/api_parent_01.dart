import 'dart:convert';
import 'package:b2s_parent/src/app/core/app_setting.dart';
import 'package:b2s_parent/src/app/models/children.dart';
import 'package:b2s_parent/src/app/models/childrenBusSession.dart';
import 'package:b2s_parent/src/app/models/driver.dart';
import 'package:b2s_parent/src/app/models/parent.dart';
import 'package:b2s_parent/src/app/models/picking-route.dart';
import 'package:b2s_parent/src/app/models/picking-transport-info.dart';
import 'package:b2s_parent/src/app/models/res-partner-title.dart';
import 'package:b2s_parent/src/app/models/res-partner.dart';
import 'package:b2s_parent/src/app/models/route-location.dart';
import 'package:b2s_parent/src/app/models/sale-order-line.dart';
import 'package:b2s_parent/src/app/models/sale-order.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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

  ///Lấy thông tin driver
  Future<Driver> getDriverInfo(String id) async {
    await this.authorization();
    body = new Map();
    body["domain"] = [
      ['id', '=', id],
    ];
    body["fields"] = ['id', 'name', 'image', 'title', 'phone'];
    var params = convertSerialize(body);
    List<ResPartner> listResult = new List();
    Driver driver;
    return http
        .get('${this.api}/search_read/res.partner?$params',
            headers: this.headers)
        .then((http.Response response) async {
      if (response.statusCode == 200) {
        List list = json.decode(response.body);
        if (list.length > 0) {
          listResult = list.map((item) => ResPartner.fromJson(item)).toList();
          driver = Driver.fromResPartner(listResult[0]);
        }
      }
      return driver;
    }).catchError((error) {
      return null;
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

  ///Lấy danh sách trường học
  Future<List<ResPartner>> getListSchool() async {
    await this.authorization();
    List<ResPartner> listResult = new List();
    body = new Map();
    body["domain"] = [
      ['is_company', '=', true],
    ];
    var params = convertSerialize(body);
    return http
        .get('${this.api}/search_read/res.partner?$params',
            headers: this.headers)
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

  ///Update thông tin khách hàng
  ///
  ///Success - Trả về true
  ///
  ///Fail - Trả về false
  Future<bool> updatePickingTransportInfo(PickingTransportInfo picking) async {
    await this.authorization();
    body = new Map();
    body["model"] = "picking.transport.info";
    body["ids"] = json.encode([int.parse(picking.id.toString())]);
    body["values"] = json.encode(picking.toJson());
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
        var list = json.decode(response.body);
        if (list is List) result = list[0];
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
    if (parent.listChildren.length == 0 || parent.listChildren.length == null)
      return listResult;
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

  ///Lấy session chuyến đi trong ngày của các children
  Future<List<ChildrenBusSession>> getListChildrenBusSession() async {
    await this.authorization();
    Parent parent = Parent();
    List<int> listChildrenId =
        parent.listChildren.map((item) => item.id).toList();
    var dateFrom = DateFormat('yyyy-MM-dd').format(DateTime.now());
    var dateTo =
        DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 1)));
    List<ChildrenBusSession> listResult = new List();
    body = new Map();
    body["domain"] = [
      ['saleorder_id.partner_id', 'in', listChildrenId],
      ['transport_date', '>=', dateFrom],
      ['transport_date', '<', dateTo],
      ['state', '!=', 'res']
    ];
    var params = convertSerialize(body);
    return http
        .get('${this.api}/search_read/picking.transport.info?$params',
            headers: this.headers)
        .then((http.Response response) async {
      if (response.statusCode == 200) {
        List list = json.decode(response.body);
        if (list.length > 0) {
          var listPickingTransportInfo =
              list.map((item) => PickingTransportInfo.fromJson(item)).toList();
          for (var pickingTransportInfo in listPickingTransportInfo) {
            var _saleOrder = await this
                .getSaleOrderById(pickingTransportInfo.saleorderId[0]);
            Children children;
            Driver driver;
            List<RouteBus> listRouteBus = [];
            Parent parent = Parent();
            children = parent.listChildren.firstWhere((_child) {
              if (_saleOrder.partnerId is List)
                return _child.id == _saleOrder.partnerId[0];
              return false;
            });
            if (pickingTransportInfo.vehicleDriver is List) {
              driver = await this.getDriverInfo(
                  pickingTransportInfo.vehicleDriver[0].toString());
            }
            //Tạo list Route bus
            if (pickingTransportInfo.pickingRouteIds is List) {
              var pickingRoute = await this
                  .getPickingRouteById(pickingTransportInfo.pickingRouteIds[0]);
              var startRouteLocation = await this
                  .getRouteLocationById(pickingRoute.sourceLocation[0]);
              var destinationRouteLocation = await this
                  .getRouteLocationById(pickingRoute.destinationLocation[0]);
              listRouteBus.add(RouteBus.fromRouteLocation(
                routeLocation: startRouteLocation,
                pickingRoute: pickingRoute,
                type: 0,
                pickingTransportInfo: pickingTransportInfo,
              ));
              listRouteBus.add(RouteBus.fromRouteLocation(
                routeLocation: destinationRouteLocation,
                pickingRoute: pickingRoute,
                type: 1,
                pickingTransportInfo: pickingTransportInfo,
              ));
            }
            listResult.add(ChildrenBusSession.fromPickingTransportInfo(
                pti: pickingTransportInfo,
                objChildren: children,
                objDriver: driver,
                objListRouteBus: listRouteBus));
          }
        }
      }
      return listResult;
    }).catchError((error) {
      return listResult;
    });
  }

  //Lấy thông tin sale order by id
  Future<SaleOrder> getSaleOrderById(int id) async {
    await this.authorization();
    body = new Map();
    body["domain"] = [
      ['id', '=', id],
    ];
    body['fields'] = ['partner_id'];
    var params = convertSerialize(body);
    List<SaleOrder> listResult = new List();
    return http
        .get('${this.api}/search_read/sale.order?$params',
            headers: this.headers)
        .then((http.Response response) async {
      if (response.statusCode == 200) {
        List list = json.decode(response.body);
        if (list.length > 0)
          listResult = list.map((item) => SaleOrder.fromJson(item)).toList();
      }
      return listResult[0];
    }).catchError((error) {
      return null;
    });
  }

  //Lấy thông tin Route Location by id
  Future<RouteLocation> getRouteLocationById(int id) async {
    await this.authorization();
    body = new Map();
    body["domain"] = [
      ['id', '=', id],
    ];
    body['fields'] = ['x_posx', 'x_posy', 'x_check_school'];
    var params = convertSerialize(body);
    List<RouteLocation> listResult = new List();
    return http
        .get('${this.api}/search_read/route.location?$params',
            headers: this.headers)
        .then((http.Response response) async {
      if (response.statusCode == 200) {
        List list = json.decode(response.body);
        if (list.length > 0)
          listResult =
              list.map((item) => RouteLocation.fromJson(item)).toList();
      }
      return listResult[0];
    }).catchError((error) {
      return null;
    });
  }

  //Lấy thông tin PickingRoute by id
  Future<PickingRoute> getPickingRouteById(int id) async {
    await this.authorization();
    body = new Map();
    body["domain"] = [
      ['id', '=', id],
    ];
    var params = convertSerialize(body);
    List<PickingRoute> listResult = new List();
    return http
        .get('${this.api}/search_read/picking.route?$params',
            headers: this.headers)
        .then((http.Response response) async {
      if (response.statusCode == 200) {
        List list = json.decode(response.body);
        if (list.length > 0)
          listResult = list.map((item) => PickingRoute.fromJson(item)).toList();
      }
      return listResult[0];
    }).catchError((error) {
      return null;
    });
  }
}
