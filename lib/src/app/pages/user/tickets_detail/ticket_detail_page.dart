import 'dart:typed_data';
import 'package:b2s_parent/src/app/app_localizations.dart';
import 'package:b2s_parent/src/app/models/children.dart';
import 'package:b2s_parent/src/app/models/sale-order-line.dart';
import 'package:b2s_parent/src/app/pages/user/tickets_detail/student_card/student_card_page.dart';
import 'package:b2s_parent/src/app/service/common-service.dart';
import 'package:b2s_parent/src/app/theme/theme_primary.dart';
import 'package:b2s_parent/src/app/widgets/index.dart';
import 'package:b2s_parent/src/app/widgets/ts24_button_widget.dart';
import 'package:flutter/rendering.dart';
import 'package:printing/printing.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'dart:ui' as ui;

class TicketsDetailPage extends StatefulWidget {
  static const String routeName = "/ticketDetail";
  final TicketsDetailPageArgs args;
  const TicketsDetailPage({Key key, this.args}) : super(key: key);
  @override
  _TicketsDetailPageState createState() => _TicketsDetailPageState();
}

class _TicketsDetailPageState extends State<TicketsDetailPage> {
  final GlobalKey<State<StatefulWidget>> previewContainer = GlobalKey();
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
          fontSize: 14, color: Colors.black54, fontWeight: FontWeight.bold);
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

      return Column(
        children: <Widget>[
          RepaintBoundary(
            key: previewContainer,
            child: Container(
              margin: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width - 50,
              height: 520,
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
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
                                        imageBuilder:
                                            (context, imageProvider) =>
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
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87),
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
                          margin: EdgeInsets.only(top: 5, bottom: 5),
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
                          margin: EdgeInsets.only(top: 5, bottom: 5),
                          height: 20,
                          width: MediaQuery.of(context).size.width - 20,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                translation.text("TICKET_PAGE.CODE"),
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
                          margin: EdgeInsets.only(top: 5, bottom: 5),
                          height: 20,
                          width: MediaQuery.of(context).size.width - 20,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                translation.text("TICKET_PAGE.TYPE"),
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
                          margin: EdgeInsets.only(top: 5, bottom: 5),
                          height: 20,
                          width: MediaQuery.of(context).size.width - 20,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                translation.text("TICKET_PAGE.PRICE"),
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
                          margin: EdgeInsets.only(top: 5, bottom: 5),
                          height: 20,
                          width: MediaQuery.of(context).size.width - 20,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                translation.text("TICKET_PAGE.ACTIVE_TIME"),
                                style: style,
                              ),
                              Text(
                                DateFormat('dd/MM/yyyy').format(DateTime.parse(
                                    order.sLastUpdate.toString())),
                                style: styleBold,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5, bottom: 5),
                          height: 20,
                          width: MediaQuery.of(context).size.width - 20,
                          padding: EdgeInsets.only(left: 20, right: 20),
//                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                        children: <Widget>[
//                          Text(
//                            'Thời gian còn lại :',
//                            style: style,
//                          ),
//                          Text(
//                            __timeRemaining.toString() + " Ngày",
//                            style: styleBold,
//                          ),
//                        ],
//                      ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 14, bottom: 5),
                          child: _buildSeparator(),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          child: QrImage(
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
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Center(
                        child: Text(
                          translation
                              .text("TICKET_PAGE.OUT_DATE")
                              .toUpperCase(),
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w900,
                              fontSize: 30),
                        ),
                      ),
                    ),
                  Positioned(
                    left: -20,
                    top: 520 * 0.5 - 20,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.grey[300], shape: BoxShape.circle),
                    ),
                  ),
                  Positioned(
                    right: -20,
                    top: 520 * 0.5 - 20,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.grey[300], shape: BoxShape.circle),
                    ),
                  )
                ],
              ),
            ),
          ),
          TS24Button(
            onTap: () {
              Navigator.pushNamed(context, StudentCardPage.routeName,
                  arguments: StudentCardPageArgs(
                      children: children, orderLine: order));
            },
            height: 50,
            decoration: BoxDecoration(
                color: ThemePrimary.primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: Center(
              child: Text(
                translation.text("TICKET_PAGE.PRINT_CARD"),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      );
    }

    Future<void> _printScreen() async {
      final RenderRepaintBoundary boundary =
          previewContainer.currentContext.findRenderObject();
      final ui.Image im = await boundary.toImage(pixelRatio: 3.0);
      final ByteData bytes =
          await im.toByteData(format: ui.ImageByteFormat.rawRgba);
      print('Print Screen ${im.width}x${im.height} ...');

      Printing.layoutPdf(onLayout: (PdfPageFormat format) {
        final pdf.Document document = pdf.Document();

        final PdfImage image = PdfImage(document.document,
            image: bytes.buffer.asUint8List(),
            width: im.width,
            height: im.height);

        document.addPage(pdf.Page(
            pageFormat: format,
            build: (pdf.Context context) {
              return pdf.Center(
                child: pdf.Expanded(
                  child: pdf.Image(image),
                ),
              ); // Center
            })); // Page

        return document.save();
      });
    }

    Widget _appBar() {
      return TS24AppBar(
        title: Text(translation.text("TICKET_PAGE.TITLE_DETAIL")),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.print),
            onPressed: _printScreen,
          )
        ],
      );
    }

    return TS24Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 15),
          alignment: Alignment.center,
          child: _itemTickets(widget.args.children, widget.args.orderLine),
        ),
      ),
    );
  }
}

class TicketsDetailPageArgs {
  final Children children;
  final SaleOrderLine orderLine;
  TicketsDetailPageArgs({this.children, this.orderLine});
}
