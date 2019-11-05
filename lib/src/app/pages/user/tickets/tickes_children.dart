import 'package:b2s_parent/src/app/models/children.dart';
import 'package:b2s_parent/src/app/models/sale-order-line.dart';
import 'package:b2s_parent/src/app/service/common-service.dart';
import 'package:b2s_parent/src/app/widgets/index.dart';
import 'package:flutter/material.dart';

class TicketsChildren extends StatelessWidget {
  static const String routeName = "/ticketsChildren";
  final ProfileTicketArgs arguments;
  TicketsChildren({this.arguments});
  @override
  Widget build(BuildContext context) {
    Widget _itemTickets(BuildContext context, Children children, SaleOrderLine order){
      int __timeUsed = DateTime.now().difference(DateTime.parse(order.sLastUpdate.toString())).inDays;
      int __timeRemaining = order.productId[0]*30 - __timeUsed;
      if(__timeRemaining<0)__timeRemaining = 0;
      final style = TextStyle(fontSize: 13,color: Colors.black54,);
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
                        child:Container(
                          padding: EdgeInsets.fromLTRB(20, 7.5, 0, 7.5),
                          decoration: new BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: new BorderRadius.circular(0.0),
                          ),
                          child: new Row(
                            children: <Widget>[
                              CircleAvatar(
                                radius: 20.0,
                                backgroundImage: MemoryImage(children.photo),
                                backgroundColor: Colors.transparent,
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
                  width: MediaQuery.of(context).size.width-40,
                  child: Center(
                    child: Text(order.companyId[1],style: TextStyle(fontSize: 12,fontWeight: FontWeight.w800,color: Colors.green),),
                  ),
                ),
                Container(
                  height: 20,
                  width: MediaQuery.of(context).size.width - 40,
                  padding: EdgeInsets.only(left: 50,right: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Mã :',style: style,),
                      Text(order.orderId[1],style: style,),
                    ],
                  ),
                ),
                Container(
                  height: 20,
                  width: MediaQuery.of(context).size.width - 40,
                  padding: EdgeInsets.only(left: 50,right: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Loại :',style: style,),
                      Text(order.name,style: style,),
                    ],
                  ),
                ),
                Container(
                  height: 20,
                  width: MediaQuery.of(context).size.width - 40,
                  padding: EdgeInsets.only(left: 50,right: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Đơn giá :',style: style,),
                      Text(Common.formatMoney(order.priceTotal)+" "+order.currencyId[1],style: style,),
                    ],
                  ),
                ),
                Container(
                  height: 20,
                  width: MediaQuery.of(context).size.width - 40,
                  padding: EdgeInsets.only(left: 50,right: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Thời gian kích hoạt :',style: style,),
                      Text(order.sLastUpdate.toString(),style: style,),
                    ],
                  ),
                ),
                Container(
                  height: 20,
                  width: MediaQuery.of(context).size.width - 40,
                  padding: EdgeInsets.only(left: 50,right: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Thời gian còn lại :',style: style,),
                      Text(__timeRemaining.toString()+" Ngày",style: style,),
                    ],
                  ),
                ),
                SizedBox(height: 15,),
                new Container(
                  height: 1,
                  color: Colors.grey.shade200,
                ),
              ],
            ),
          ),
          if(__timeRemaining<=0)Container(
            height: 190,
            width: MediaQuery.of(context).size.width,
            color: Colors.black38,
            child: Center(
              child: Text('HẾT HẠN',style: TextStyle(color: Colors.red,fontWeight: FontWeight.w900,fontSize: 30),),
            ),
          ),
        ],
      );
    };
    Widget _buildTicketsContent() {
      List<Widget> listChildrenItem = new List();
      arguments.listChildrenTickets.forEach((children){
        arguments.listSaleOrderLine.forEach((sale){
          if(children.id==sale.orderPartnerId[0])
            listChildrenItem.add(_itemTickets(context, children,sale));
        });
      });
      return Container(
        color: Colors.grey.shade300,
        child: Column(
          children: listChildrenItem,
        ),
      );
    }
    return Scaffold(
      appBar: TS24AppBar(
        title: Text('Thông tin vé'),
      ),
      body: SingleChildScrollView(
        child: _buildTicketsContent(),
      ),
    );
  }
}
class ProfileTicketArgs {
  List<Children> listChildrenTickets;
  List<SaleOrderLine> listSaleOrderLine;
  ProfileTicketArgs({this.listChildrenTickets, this.listSaleOrderLine});
}
