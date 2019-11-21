import 'package:b2s_parent/src/app/core/app_setting.dart';
import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/models/children.dart';
import 'package:b2s_parent/src/app/models/parent.dart';
import 'package:b2s_parent/src/app/models/sale-order-line.dart';
import 'package:b2s_parent/src/app/models/sale-order.dart';
import 'package:b2s_parent/src/app/pages/user/tickets_detail/ticket_detail_page.dart';
import 'package:flutter/cupertino.dart';
class TicketChildrenViewModel extends ViewModelBase{
  List<Children> listChildrenTickets;
  List<SaleOrderLine> listSaleOrderLine;
  List<SaleOrder> listSaleOrder;
  TicketChildrenViewModel(){
    listChildrenTickets = Children.getListChildrenPaidTicket(Parent().listChildren);
    onLoad();
  }
  onLoad(){
    loading = true;
    api.getTicketOfListChildren().then((tickets){
      listSaleOrderLine = tickets;
      loading = false;
      this.updateState();
    });
  }
  onTapTicket(Children children, SaleOrderLine saleOrderLine){
    Navigator.pushNamed(context, TicketsDetailPage.routeName,arguments: TicketsDetailPageArgs(children: children, orderLine: saleOrderLine));
  }
}