import 'package:b2s_parent/src/app/app_localizations.dart';
import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/models/children.dart';
import 'package:b2s_parent/src/app/models/sale-order-line.dart';
import 'package:b2s_parent/src/app/pages/user/tickets/tickets_children_viewmodel.dart';
import 'package:b2s_parent/src/app/service/common-service.dart';
import 'package:b2s_parent/src/app/widgets/empty_widget.dart';
import 'package:b2s_parent/src/app/widgets/index.dart';
import 'package:b2s_parent/src/app/widgets/ticket_pass.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TicketsChildrenPage extends StatefulWidget {
  static const String routeName = "/ticketsChildren";
  const TicketsChildrenPage({Key key}) : super(key: key);
  @override
  _TicketsChildrenPageState createState() => _TicketsChildrenPageState();
}

class _TicketsChildrenPageState extends State<TicketsChildrenPage> {
  TicketChildrenViewModel viewModel = TicketChildrenViewModel();
  final ticketHeight = 200.0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    viewModel.context = context;
    Widget _itemTickets(
        BuildContext context, Children children, SaleOrderLine saleOrderLine) {
      int __timeUsed = DateTime.now()
          .difference(DateTime.parse(saleOrderLine.sLastUpdate.toString()))
          .inDays;
      int __timeRemaining = saleOrderLine.productId[0] * 30 - __timeUsed;
      if (__timeRemaining < 0) __timeRemaining = 0;
      final style = TextStyle(
        fontSize: 14,
        color: Colors.black54,
      );
      final styleBold = TextStyle(
          fontSize: 14, color: Colors.black54, fontWeight: FontWeight.bold);
      return InkWell(
        onTap: () {
          viewModel.onTapTicket(children, saleOrderLine);
        },
        child: Container(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: TicketPass(
            width: MediaQuery.of(context).size.width - 50,
            height: ticketHeight,
            elevation: 0.0,
            titleColor: Colors.white,
            separatorColor: Colors.white,
            titleHeight: 0.0,
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width - 50,
              height: ticketHeight,
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
                                      ),
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
                              saleOrderLine.companyId[1],
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
                                saleOrderLine.orderId[1],
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
                                saleOrderLine.name,
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
                                Common.formatMoney(saleOrderLine.priceTotal) +
                                    " " +
                                    saleOrderLine.currencyId[1],
                                style: styleBold,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (__timeRemaining <= 0)
                    Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black38,
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
                ],
              ),
            ),
          ),
        ),
      );
    }

    Widget _buildTicketsContent() {
      List<Widget> listChildrenItem = new List();
      viewModel.listChildrenTickets.forEach((children) {
        viewModel.listSaleOrderLine.forEach((sale) {
          if (children.id == sale.orderPartnerId[0] && sale.state == 'sale')
            listChildrenItem.add(_itemTickets(context, children, sale));
        });
      });
      double _deviceHeight = MediaQuery.of(context).size.height;
      double _widgetHeight = listChildrenItem.length * (ticketHeight + 20);
      double _height = _widgetHeight <= _deviceHeight - 20
          ? _deviceHeight - 20
          : _widgetHeight;
      return Container(
        height: _height,
        width: MediaQuery.of(context).size.width,
        color: Colors.grey.shade300,
        child: listChildrenItem.length > 0
            ? Column(
                children: <Widget>[
                  ...listChildrenItem,
                ],
              )
            : EmptyWidget(message: translation.text("COMMON.DATA_TICKET_EMPTY"),),
      );
    }

    return ViewModelProvider(
      viewmodel: viewModel,
      child: StreamBuilder(
        stream: viewModel.stream,
        builder: (context, snapshot) {
          return TS24Scaffold(
              appBar: TS24AppBar(
                title: Text(translation.text("TICKET_PAGE.TITLE")),
              ),
              body: RefreshIndicator(
                  onRefresh: () async {
                    viewModel.onLoad();
                  },
                  child: SingleChildScrollView(
                    child: (viewModel.loading)
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.9,
                            child: Center(
                                child: LoadingSpinner.loadingView(
                                    context: viewModel.context,
                                    loading: (viewModel.loading))),
                          )
                        : _buildTicketsContent(),
                  )));
        },
      ),
    );
  }
}
