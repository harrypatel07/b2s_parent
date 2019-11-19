import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/models/children.dart';
import 'package:b2s_parent/src/app/models/sale-order-line.dart';
import 'package:b2s_parent/src/app/pages/user/tickets/tickets_children_viewmodel.dart';
import 'package:b2s_parent/src/app/service/common-service.dart';
import 'package:b2s_parent/src/app/widgets/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class TicketsChildrenPage extends StatefulWidget {
  static const String routeName = "/ticketsChildren";
  const TicketsChildrenPage({Key key}) : super(key: key);
  @override
  _TicketsChildrenPageState createState() => _TicketsChildrenPageState();
}

class _TicketsChildrenPageState extends State<TicketsChildrenPage> {
  TicketChildrenViewModel viewModel = TicketChildrenViewModel();
  @override
  Widget build(BuildContext context) {
    viewModel.context = context;
    Widget _itemTickets(
        BuildContext context, Children children, SaleOrderLine order) {
      int __timeUsed = DateTime.now()
          .difference(DateTime.parse(order.sLastUpdate.toString()))
          .inDays;
      int __timeRemaining = order.productId[0] * 30 - __timeUsed;
      if (__timeRemaining < 0) __timeRemaining = 0;
      final style = TextStyle(
        fontSize: 13,
        color: Colors.black54,
      );
      return Stack(
        children: <Widget>[
          Container(
            color: Colors.white,
            child: new Column(
              children: <Widget>[
                new Container(
                  //color: Colors.blue,
                  margin: EdgeInsets.only(right: 10),
                  child: Row(
                    children: <Widget>[
                      new Expanded(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(20, 7.5, 0, 7.5),
                          decoration: new BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: new BorderRadius.circular(0.0),
                          ),
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
                                    style: TextStyle(fontSize: 14),
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
                  height: 20,
                  width: MediaQuery.of(context).size.width - 20,
                  child: Center(
                    child: Text(
                      order.companyId[1],
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Colors.orange),
                    ),
                  ),
                ),
                Container(
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
                        style: style,
                      ),
                    ],
                  ),
                ),
                Container(
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
                        style: style,
                      ),
                    ],
                  ),
                ),
                Container(
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
                        style: style,
                      ),
                    ],
                  ),
                ),
                Container(
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
                        order.sLastUpdate.toString(),
                        style: style,
                      ),
                    ],
                  ),
                ),
                Container(
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
                        style: style,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                new Container(
                  height: 1,
                  color: Colors.grey.shade200,
                ),
              ],
            ),
          ),
          if (__timeRemaining <= 0)
            Container(
              height: 190,
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
      );
    }

    Widget _buildTicketsContent() {
      List<Widget> listChildrenItem = new List();
      viewModel.listChildrenTickets.forEach((children) {
        viewModel.listSaleOrderLine.forEach((sale) {
          if (children.id == sale.orderPartnerId[0])
            listChildrenItem.add(_itemTickets(context, children, sale));
        });
      });
      return Container(
        color: Colors.grey.shade300,
        child: listChildrenItem.length > 0
            ? Column(
                children: listChildrenItem,
              )
            : Center(
                child: Text('Không có thông tin hiển thị.'),
              ),
      );
    }

    return ViewModelProvider(
      viewmodel: viewModel,
      child: StreamBuilder(
        stream: viewModel.stream,
        builder: (context, snapshot) {
          return Scaffold(
              appBar: TS24AppBar(
                title: Text('Thông tin vé'),
              ),
              body: RefreshIndicator(
                  onRefresh: () async {
                    viewModel.onLoad();
                  },
                  child: SingleChildScrollView(
                    child: (viewModel.loading)
                        ? Center(
                            child: LoadingSpinner.loadingView(
                                context: viewModel.context,
                                loading: (viewModel.loading)))
                        : _buildTicketsContent(),
                  )));
        },
      ),
    );
  }
}
