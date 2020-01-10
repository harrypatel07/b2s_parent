import 'dart:convert';
import 'package:b2s_parent/src/app/core/app_setting.dart';
import 'package:b2s_parent/src/app/models/attendant.dart';
import 'package:b2s_parent/src/app/models/bodyNotification.dart';
import 'package:b2s_parent/src/app/models/children.dart';
import 'package:b2s_parent/src/app/models/childrenBusSession.dart';
import 'package:b2s_parent/src/app/models/driver.dart';
import 'package:b2s_parent/src/app/models/fleet-vehicle.dart';
import 'package:b2s_parent/src/app/models/historyTrip.dart';
import 'package:b2s_parent/src/app/models/message.dart';
import 'package:b2s_parent/src/app/models/parent.dart';
import 'package:b2s_parent/src/app/models/picking-route.dart';
import 'package:b2s_parent/src/app/models/picking-transport-info.dart';
import 'package:b2s_parent/src/app/models/res-partner-category.dart';
import 'package:b2s_parent/src/app/models/res-partner-title.dart';
import 'package:b2s_parent/src/app/models/res-partner.dart';
import 'package:b2s_parent/src/app/models/route-location.dart';
import 'package:b2s_parent/src/app/models/sale-order-line.dart';
import 'package:b2s_parent/src/app/models/sale-order.dart';
import 'package:b2s_parent/src/app/service/common-service.dart';
import 'package:b2s_parent/src/app/service/onesingal-service.dart';
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
    body["fields"] = [
      "company_id",
      "company_name",
      "company_type",
      "contact_address",
      "contract_ids",
      "contracts_count",
      "country_id",
      "create_date",
      "create_uid",
      "credit",
      "credit_limit",
      "currency_id",
      "customer",
      "date",
      "debit",
      "debit_limit",
      "display_name",
      "email",
      "email_formatted",
      "employee",
      "id",
      "im_status",
      "is_company",
      "is_published",
      "is_seo_optimized",
      "journal_item_count",
      "lang",
      "mobile",
      "name",
      "parent_id",
      "parent_name",
      "partner_gid",
      "partner_share",
      "phone",
      "state_id",
      "street",
      "street2",
      "supplier",
      "team_id",
      "title",
      "total_invoiced",
      "trust",
      "type",
      "user_id",
      "user_ids",
      "vat",
      "vehicle_count",
      "vehicle_ids",
      "x_class",
      "x_company_type",
      "x_date_of_birth",
      "x_school",
      "wk_dob",
      "x_qr_code",
      "category_id"
    ];
    var params = convertSerialize(body);
    List<ResPartner> listResult = new List();
    return http
        .get('${this.api}/search_read/res.partner?$params',
            headers: this.headers)
        .then((http.Response response) async {
      this.updateCookie(response);
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
    body["fields"] = ['id', 'name', 'title', 'phone'];
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
  Future<ResPartner> getCustomerInfo(dynamic id) async {
    await this.authorization();
    body = new Map();
    body["domain"] = [
      ['id', '=', id],
    ];
    body["fields"] = [
      "company_id",
      "company_name",
      "company_type",
      "contact_address",
      "contract_ids",
      "contracts_count",
      "country_id",
      "create_date",
      "create_uid",
      "credit",
      "credit_limit",
      "currency_id",
      "customer",
      "date",
      "debit",
      "debit_limit",
      "display_name",
      "email",
      "email_formatted",
      "employee",
      "id",
      "im_status",
      "is_company",
      "is_published",
      "is_seo_optimized",
      "journal_item_count",
      "lang",
      "mobile",
      "name",
      "parent_id",
      "parent_name",
      "partner_gid",
      "partner_share",
      "phone",
      "state_id",
      "street",
      "street2",
      "supplier",
      "team_id",
      "title",
      "total_invoiced",
      "trust",
      "type",
      "user_id",
      "user_ids",
      "vat",
      "vehicle_count",
      "vehicle_ids",
      "x_class",
      "x_company_type",
      "x_date_of_birth",
      "x_school",
      "wk_dob",
      "x_qr_code",
      "category_id",
    ];
    var params = convertSerialize(body);
    List<ResPartner> listResult = new List();
    return http
        .get('${this.api}/search_read/res.partner?$params',
            headers: this.headers)
        .then((http.Response response) async {
      //this.updateCookie(response);
      if (response.statusCode == 200) {
        List list = json.decode(response.body);
        print(list);
        if (list.length > 0)
          listResult = list.map((item) => ResPartner.fromJson(item)).toList();
      }
      return listResult[0];
    }).catchError((error) {
      print("getCustomerInfoError");
      print(error);
      return null;
    });
  }

  ///Lấy thông tin title(gender) của khách hàng
  Future<List<ResPartnerTitle>> getTitleCustomer() async {
    await this.authorization();
    body = new Map();
    body["fields"] = [
      "name",
      "display_name",
      "id",
    ];
    var params = convertSerialize(body);
    List<ResPartnerTitle> listResult = new List();
    return http
        .get('${this.api}/search_read/res.partner.title?$params',
            headers: this.headers)
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
    body["fields"] = [
      "company_id",
      "company_name",
      "company_type",
      "contact_address",
      "contract_ids",
      "contracts_count",
      "country_id",
      "create_date",
      "create_uid",
      "credit",
      "credit_limit",
      "currency_id",
      "customer",
      "date",
      "debit",
      "debit_limit",
      "display_name",
      "email",
      "email_formatted",
      "employee",
      "id",
      "im_status",
      "is_company",
      "is_published",
      "is_seo_optimized",
      "journal_item_count",
      "lang",
      "mobile",
      "name",
      "parent_id",
      "parent_name",
      "partner_gid",
      "partner_share",
      "phone",
      "state_id",
      "street",
      "street2",
      "supplier",
      "team_id",
      "title",
      "total_invoiced",
      "trust",
      "type",
      "user_id",
      "user_ids",
      "vat",
      "vehicle_count",
      "vehicle_ids",
      "x_class",
      "x_company_type",
      "x_date_of_birth",
      "x_school",
      "wk_dob",
      "x_qr_code",
      "category_id"
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
    body = new Map();
    body["fields"] = [
      "additional_info",
      "bank_account_count",
      "bank_ids",
      "barcode",
      "calendar_last_notif_ack",
      "category_id",
      "channel_ids",
      "child_ids",
      "city",
      "color",
      "comment",
      "commercial_company_name",
      "commercial_partner_id",
      "company_id",
      "company_name",
      "company_type",
      "contact_address",
      "contract_ids",
      "contracts_count",
      "country_id",
      "create_date",
      "create_uid",
      "credit",
      "credit_limit",
      "currency_id",
      "customer",
      "date",
      "debit",
      "debit_limit",
      "display_name",
      "email",
      "email_formatted",
      "employee",
      "event_count",
      "function",
      "has_unreconciled_entries",
      "id",
      "im_status",
      "industry_id",
      "is_blacklisted",
      "is_company",
      "is_published",
      "is_seo_optimized",
      "journal_item_count",
      "lang",
      "last_time_entries_checked",
      "last_website_so_id",
      "meeting_count",
      "meeting_ids",
      "mobile",
      "name",
      "opportunity_count",
      "opportunity_ids",
      "parent_id",
      "parent_name",
      "partner_gid",
      "partner_share",
      "payment_token_count",
      "payment_token_ids",
      "phone",
      "state_id",
      "street",
      "street2",
      "supplier",
      "team_id",
      "title",
      "total_invoiced",
      "trust",
      "type",
      "tz",
      "tz_offset",
      "user_id",
      "user_ids",
      "vat",
      "vehicle_count",
      "vehicle_ids",
      "x_class",
      "x_company_type",
      "x_date_of_birth",
      "x_school",
      "zip",
      "wk_dob",
      "x_qr_code"
    ];
    var params = convertSerialize(body);
    List<ResPartner> listResult = List();
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

  getImageByIdPartner(String id) {
    return "$domainApi/web/image?model=res.partner&field=image&id=$id&${api.sessionId}";
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
    print(json.encode(partner.toJson()));
    if (partner.categoryId != null) if (partner.categoryId.length > 0) {
      var jsonString = json.encode(partner.toJson());
      body["values"] = jsonString.replaceAll(
          '"[(6, 0, ${partner.categoryId})]"',
          '[(6, 0, ${partner.categoryId})]');
      print(body["values"]);
    }
    return http
        .put('${this.api}/write', headers: this.headers, body: body)
        .then((http.Response response) {
      this.updateCookie(response);
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

  ///Update ngày nghỉ phép theo id Children
  ///idChildren
  ///listDate sắp xếp từ nhỏ đến lớn , định dạng yyyy-mm-dd
  Future<bool> updateLeaveByIdChildren(
      int idChildren, List<String> listDate) async {
    await this.authorization();
    var listId =
        await getListIdPickingByIdChildrenAndListDate(idChildren, listDate);
    if (listId.length == 0) return true;
    var client = await this.authorizationOdoo();
    return client.callKW(
        "picking.transport.info", "picking_cancel", [listId]).then((onValue) {
      var error = onValue.getError();
      if (error == null) return true;
      return false;
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

  ///Insert thông tin tags
  ///
  ///Success - Trả về new id
  ///
  ///Fail - Trả về null
  Future<dynamic> insertTags(ResPartnerCategory category) async {
    await this.authorization();
    body = new Map();
    body["model"] = "res.partner.category";
    body["values"] = json.encode(category.toJson());
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

  ///Tạo user portal
  Future<bool> insertUserPortal(
      {String email, String password, String name, String phone}) async {
    try {
      var client = await this.authorizationOdoo();
      body = new Map();
      body["email"] = email;
      body["password"] = password;
      body["name"] = name;
      body["phone"] = phone;
      return client
          .callController("/parent_registration", body)
          .then((onValue) {
        var result = onValue.getResult();
        if (result is String) {
          return true;
        }
        return false;
      });
    } catch (ex) {
      print("insertUserPortal: $ex");
    }
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
    domain.add(["state", "=", 'sale']);
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
              if (item.orderPartnerId[0] == children.id) {
                children.paidTicket = true;
                //children.ticketCode = item.orderId[1];
              }
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
      this.updateCookie(response);
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

  ///Lấy session chuyến đi trong ngày của các children
  Future<List<ChildrenBusSession>> getListChildrenBusSessionV2() async {
    var client = await this.authorizationOdoo();
    Parent parent = Parent();
    List<int> listChildrenId =
        parent.listChildren.map((item) => item.id).toList();
    var date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    body = new Map();
    body["partner_ids"] = listChildrenId;
    body["date"] = date;
    List<ChildrenBusSession> listResult = new List();
    return client
        .callController("/handle_customer_picking_list", body)
        .then((onValue) {
      var result = onValue.getResult();
      if (result['code'] != null) return listResult;
      List data = result["data"];
      for (var i = 0; i < data.length; i++) {
        var partner = data[i]["obj_partner"]["partner"];
        Children children = Children.fromJsonController(partner);

        var _driver = data[i]["obj_partner"]["driver"];
        Driver driver = Driver.fromJsonController(_driver);

        var _attendant = data[i]["obj_partner"]["picking_mananager"];
        Attendant attendant = Attendant.fromJsonController(_attendant);

        List<RouteBus> listRouteBus = [];

        var _picking = data[i]["obj_partner"]["picking"];
        //Tạo list Route Bus
        var _routeBusFrom =
            data[i]["obj_partner"]["picking_routes"]["source_location"];
        RouteBus routeBusFrom = RouteBus();
        routeBusFrom.id = _routeBusFrom["id"];
        routeBusFrom.routeName = _routeBusFrom["name"];
        routeBusFrom.date = date;
        routeBusFrom.time = _routeBusFrom["time"];
        routeBusFrom.lat = double.parse(_routeBusFrom["lat"].toString());
        routeBusFrom.lng = double.parse(_routeBusFrom["lng"].toString());
        routeBusFrom.isSchool = _routeBusFrom["is_school"];
        routeBusFrom.type =
            _picking["delivery_id"]["type"] == "outgoing" ? 0 : 1;
        listRouteBus.add(routeBusFrom);

        var _routeBusTo =
            data[i]["obj_partner"]["picking_routes"]["destination_location"];
        RouteBus routeBusTo = RouteBus();
        routeBusTo.id = _routeBusTo["id"];
        routeBusTo.routeName = _routeBusTo["name"];
        routeBusTo.date = date;
        routeBusTo.time = _routeBusTo["time"];
        routeBusTo.lat = double.parse(_routeBusTo["lat"].toString());
        routeBusTo.lng = double.parse(_routeBusTo["lng"].toString());
        routeBusTo.isSchool = _routeBusTo["is_school"];
        routeBusTo.type = _picking["delivery_id"]["type"] == "outgoing" ? 0 : 1;
        listRouteBus.add(routeBusTo);
        listResult.add(ChildrenBusSession.fromJsonController(
            picking: _picking,
            objChildren: children,
            objDriver: driver,
            objAttendant: attendant,
            objListRouteBus: listRouteBus));
      }

      print(listResult);
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

  ///Lấy danh sách ngày nghỉ học theo id children
  Future<List<String>> getListLeaveByIdChildren(int idChildren) async {
    await this.authorization();
    body = new Map();
    body["domain"] = [
      ['saleorder_id.partner_id', '=', idChildren],
      ['state', '=', 'cancel']
    ];
    body["fields"] = ['transport_date'];
    var params = convertSerialize(body);
    List<String> listResult = new List();
    return http
        .get('${this.api}/search_read/picking.transport.info?$params',
            headers: this.headers)
        .then((http.Response response) async {
      if (response.statusCode == 200) {
        List list = json.decode(response.body);
        if (list.length > 0)
          listResult = list.map((item) {
            String date = item['transport_date'];
            date = DateFormat('yyyy-MM-dd').format(DateTime.parse(date));
            return date;
          }).toList();
      }
      return listResult;
    }).catchError((error) {
      return listResult;
    });
  }

  ///Lấy id picking theo id children và list date
  Future<List<int>> getListIdPickingByIdChildrenAndListDate(
      int idChildren, List<String> listDate) async {
    await this.authorization();
    body = new Map();
    var domain = List<dynamic>();
    domain.add(['saleorder_id.partner_id', '=', idChildren]);
    domain.add(['state', '!=', 'res']);
    if (listDate.length != 0 && listDate.length == 1) {
      var dateFrom =
          DateFormat('yyyy-MM-dd').format(DateTime.parse(listDate[0]));
      var dateTo = DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(listDate[0]).add(Duration(days: 1)));
      domain.add(['transport_date', '>=', dateFrom]);
      domain.add(['transport_date', '<', dateTo]);
    } else {
      for (var i = 0; i < listDate.length; i++) {
        var dateFrom =
            DateFormat('yyyy-MM-dd').format(DateTime.parse(listDate[i]));
        var dateTo = DateFormat('yyyy-MM-dd')
            .format(DateTime.parse(listDate[i]).add(Duration(days: 1)));
        domain.add(['transport_date', '>=', dateFrom]);
        if (i != listDate.length - 1) {
          domain.add('|');
        }
        domain.add(['transport_date', '<', dateTo]);
      }
    }
    body["domain"] = domain;
    body["fields"] = ['transport_date'];
    var params = convertSerialize(body);
    List<int> listResult = new List();
    return http
        .get('${this.api}/search_read/picking.transport.info?$params',
            headers: this.headers)
        .then((http.Response response) async {
      if (response.statusCode == 200) {
        List list = json.decode(response.body);
        if (list.length > 0)
          listResult =
              list.map((item) => int.parse(item['id'].toString())).toList();
      }
      return listResult;
    }).catchError((error) {
      return listResult;
    });
  }

  ///Lấy tọa độ xe
  Future<FleetVehicle> getCoordinateVehicleById(int vehicleId) async {
    await this.authorization();
    body = new Map();
    body["domain"] = [
      ['id', '=', vehicleId],
    ];
    body['fields'] = ['x_posx', 'x_posy', 'x_posz'];
    var params = convertSerialize(body);
    List<FleetVehicle> listResult = new List();
    return http
        .get('${this.api}/search_read/fleet.vehicle?$params',
            headers: this.headers)
        .then((http.Response response) async {
      if (response.statusCode == 200) {
        List list = json.decode(response.body);
        if (list.length > 0)
          listResult = list.map((item) => FleetVehicle.fromJson(item)).toList();
      }
      return listResult[0];
    }).catchError((error) {
      return null;
    });
  }

  Future<List<HistoryTrip>> getHistoryTrip({int take, int skip}) async {
    var client = await this.authorizationOdoo();
    Parent parent = Parent();
    List<int> listChildrenId =
        parent.listChildren.map((item) => item.id).toList();
    body = new Map();
    body["partner_ids"] = listChildrenId;
    body["take"] = take;
    body["skip"] = skip;
    List<HistoryTrip> listResult = new List();
    return client
        .callController("/get_customer_picking_history", body)
        .then((onValue) {
      var result = onValue.getResult();
      if (result is List) if (result.length == 0) return listResult;
      for (var i = 0; i < result.length; i++) {
        HistoryTrip historyTrip = HistoryTrip();
        var data = result[i]["obj_picking"];
        var pickingIds = data["picking_ids"];
        historyTrip.date = data["transport_date"];
        historyTrip.trip = List();
        for (var j = 0; j < pickingIds.length; j++) {
          var pickingTransportInfo = pickingIds[j]["picking_transport_info"];
          var pickingRoute = pickingTransportInfo["picking_route"];
          var _trip = Trip();
          _trip.id = pickingTransportInfo["id"];
          _trip.startTime = pickingRoute["start_time"];
          _trip.endTime = pickingRoute["end_time"];
          _trip.realStartTime = pickingRoute["real_start_time"];
          _trip.realEndTime = pickingRoute["real_end_time"];
          _trip.gpsStart = pickingRoute["gps_tracking"];
          _trip.gpsEnd = pickingRoute["gps_tracking_des"];
          _trip.type = pickingTransportInfo["type"] == "outgoing" ? 0 : 1;
          PickingTransportInfo_State.values.forEach((value) {
            if (Common.getValueEnum(value) == pickingTransportInfo["state"])
              switch (value) {
                case PickingTransportInfo_State.draft:
                  _trip.status = StatusBus.list[0];
                  break;
                case PickingTransportInfo_State.halt:
                  _trip.status = StatusBus.list[1];

                  break;
                case PickingTransportInfo_State.done:
                  if (_trip.type == 0)
                    _trip.status = StatusBus.list[2];
                  else
                    _trip.status = StatusBus.list[4];
                  break;
                case PickingTransportInfo_State.cancel:
                  _trip.status = StatusBus.list[3];
                  break;
                default:
                  _trip.status = StatusBus.list[0];
              }
          });

          _trip.children =
              Children.fromJsonController(pickingIds[j]["partner_id"]);
          _trip.driver = Driver.fromJsonController(pickingIds[j]["driver"]);
          _trip.vechicleId = pickingIds[j]["vehicle"]["id"];
          _trip.vehicleName = pickingIds[j]["vehicle"]["name"] != null
              ? pickingIds[j]["vehicle"]["name"].toString().split('/').last
              : "";
          historyTrip.trip.add(_trip);
        }
        listResult.add(historyTrip);
      }
      return listResult;
    });
  }

  ///Kiểm tra children có parent hay chưa, nếu chưa update children vào parent
  Future<bool> checkChildrenHasParent(dynamic id) async {
    ResPartner partner = await getCustomerInfo(id);
    bool result = false;
    if (partner != null) {
      if (partner.parentId is List)
        result = true;
      else {
        Parent parent = Parent();
        Children children = Children.fromResPartner(partner);
        children.parentId = parent.id;
        ResPartner resPartner = ResPartner.fromChildren(children);
        await api.updateCustomer(resPartner);
        parent.listChildren.add(children);
        parent.saveLocal();
        api.checkTagsExistByName(children.schoolName);
      }
    }
    return result;
  }

  //Kiểm tra tags có tồn tại theo name, nếu chưa tạo mới tag và update vào field tag của parent
  Future<bool> checkTagsExistByName(String name) async {
    await this.authorization();
    body = new Map();
    body["domain"] = [
      ['name', '=', name.trim()],
    ];
    body["fields"] = ["name"];
    var params = convertSerialize(body);
    Parent parent = Parent();
    bool result = false;
    return http
        .get('${this.api}/search_read/res.partner.category?$params',
            headers: this.headers)
        .then((http.Response response) async {
      if (response.statusCode == 200) {
        List list = json.decode(response.body);
        var id;
        if (list.length > 0) {
          result = true;
          var listCategory =
              list.map((item) => ResPartnerCategory.fromJson(item)).toList();
          id = listCategory[0].id;
        } else {
          //Insert tag
          ResPartnerCategory category = ResPartnerCategory();
          category.name = name;
          id = await insertTags(category);
        }
        if (id != null) {
          ResPartner resPartner = ResPartner.fromParent(parent);
          if (resPartner.categoryId is List) {
            resPartner.categoryId.add(int.parse(id.toString()));
            await api.updateCustomer(resPartner);
            await api.getParentInfo(parent.id);
            await api.getTicketOfListChildren();
          }
        }
      }

      return result;
    }).catchError((error) {
      return result;
    });
  }

  /*---------------OneSignal----------------- */
  Future<dynamic> postNotificationSendMessage(Messages messages) async {
    String notification = messages.content;
    if (notification.length > 100)
      notification = notification.substring(0, 100) + "...";
    BodyNotification body = BodyNotification();
    body.headings = {"en": "Bạn có tin nhắn từ ${messages.receiverName}"};
    body.contents = {"en": notification};
    body.data = messages.toJsonPushNotification();
    body.filters = [
      {
        "field": "tag",
        "key": "id",
        "relation": "=",
        "value": int.parse(messages.receiverId)
      }
    ];
    OneSignalService.postNotification(body);
    OneSignalService.postNotificationSameApplication(body);
  }
}
