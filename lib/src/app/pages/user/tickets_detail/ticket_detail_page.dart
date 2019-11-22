import 'package:b2s_parent/src/app/models/children.dart';
import 'package:b2s_parent/src/app/models/sale-order-line.dart';
import 'package:b2s_parent/src/app/service/common-service.dart';
import 'package:b2s_parent/src/app/theme/theme_primary.dart';
import 'package:b2s_parent/src/app/widgets/index.dart';
import 'package:b2s_parent/src/app/widgets/ticket_pass.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
class TicketsDetailPage extends StatelessWidget {
  static const String routeName = "/ticketDetail";
  final TicketsDetailPageArgs args;

  const TicketsDetailPage({Key key, this. args}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Widget _itemTickets(Children children, SaleOrderLine order) {
      int __timeUsed = DateTime.now()
          .difference(DateTime.parse(order.sLastUpdate.toString()))
          .inDays;
      int __timeRemaining = order.productId[0] * 30 - __timeUsed;
      if (__timeRemaining < 0) __timeRemaining = 0;
      final style = TextStyle(
        fontSize: 14,
        color: Colors.black54,
      );
      final styleBold = TextStyle(
          fontSize: 14,
          color: Colors.black54,
          fontWeight: FontWeight.bold
      );
      Widget _buildSeparator({Color color}) {
        if (color == null) color = Color(0XFF626368);
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final boxWidth = constraints.constrainWidth();
            final dashWidth = 3.0;
            final dashHeight = 1.0;
            final dashCount = (boxWidth / (2 * dashWidth)).floor();
            return Row(
              children: <Widget>[
                Expanded(
                  child: Flex(
                    children: List.generate(dashCount, (_) {
                      return SizedBox(
                        width: dashWidth,
                        height: dashHeight,
                        child: DecoratedBox(
                          decoration: BoxDecoration(color: Colors.black45),
                        ),
                      );
                    }),
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    direction: Axis.horizontal,
                  ),
                ),
              ],
            );
          },
        );
      }
      return ClipPath(
        clipper: TicketClipper(),
        child:Container(
          width: MediaQuery.of(context).size.width - 50,
          height: 520,
          alignment: Alignment.bottomCenter,
          child: Container(
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  color: Colors.white,
                  child: new Column(
                    children: <Widget>[
                      Container(
                        //color: Colors.blue,
                        margin: EdgeInsets.only(right: 10),
                        child: Row(
                          children: <Widget>[
                            new Expanded(
                              child: Container(
                                padding: EdgeInsets.fromLTRB(20, 7.5, 0, 7.5),
                                child: new Row(
                                  children: <Widget>[
                                    CachedNetworkImage(
                                      imageUrl: children.photo,
                                      imageBuilder: (context, imageProvider) =>
                                          CircleAvatar(
                                            radius: 20.0,
                                            backgroundImage: imageProvider,
                                            backgroundColor: Colors.transparent,
                                          ),
                                    ),
                                    new Flexible(
                                      child: new Container(
                                        margin: EdgeInsets.only(left: 10),
                                        child: new Text(
                                          children.name,
                                          style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black87),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5,bottom: 5),
                        height: 20,
                        width: MediaQuery.of(context).size.width - 20,
                        child: Center(
                          child: Text(
                            order.companyId[1],
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5,bottom: 5),
                        height: 20,
                        width: MediaQuery.of(context).size.width - 20,
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Mã :',
                              style: style,
                            ),
                            Text(
                              order.orderId[1],
                              style: styleBold,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5,bottom: 5),
                        height: 20,
                        width: MediaQuery.of(context).size.width - 20,
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Loại :',
                              style: style,
                            ),
                            Text(
                              order.name,
                              style: styleBold,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5,bottom: 5),
                        height: 20,
                        width: MediaQuery.of(context).size.width - 20,
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Đơn giá :',
                              style: style,
                            ),
                            Text(
                              Common.formatMoney(order.priceTotal) +
                                  " " +
                                  order.currencyId[1],
                              style: styleBold,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5,bottom: 5),
                        height: 20,
                        width: MediaQuery.of(context).size.width - 20,
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Thời gian kích hoạt :',
                              style: style,
                            ),
                            Text(
                              DateFormat('dd/MM/yyyy').format(DateTime.parse(order.sLastUpdate.toString())),
                              style: styleBold,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5,bottom: 5),
                        height: 20,
                        width: MediaQuery.of(context).size.width - 20,
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Thời gian còn lại :',
                              style: style,
                            ),
                            Text(
                              __timeRemaining.toString() + " Ngày",
                              style: styleBold,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 14,bottom: 5),
                        child: _buildSeparator(),
                      ),
                      SizedBox(height: 15,),
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        child:  QrImage(
                          backgroundColor: Colors.white,
                          data: children.ticketCode.toString(),
                          version: QrVersions.auto,
                          size: 200,
                        ),
                      ),
                    ],
                  ),
                ),
                if (__timeRemaining <= 0)
                  Container(
                    height: 520,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black38,
                    child: Center(
                      child: Text(
                        'HẾT HẠN',
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w900,
                            fontSize: 30),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }
    Widget _appBar(){
      return TS24AppBar(
        backgroundColorEnd: ThemePrimary.primaryColor,
        backgroundColorStart: ThemePrimary.primaryColor,
        title: Text('Thông tin vé chi tiết'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          )
      );
    }
    return TS24Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top : 15),
          alignment: Alignment.center,
          child: _itemTickets(args.children, args.orderLine),
        ),
      ),
    );
  }
}
class TicketsDetailPageArgs{
  final Children children;
  final SaleOrderLine orderLine;
  TicketsDetailPageArgs({this.children, this.orderLine});
}
