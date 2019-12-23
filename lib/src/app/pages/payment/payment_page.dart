import 'package:b2s_parent/packages/flutter_credit_card/credit_card_widget.dart';
import 'package:b2s_parent/src/app/app_localizations.dart';
import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/pages/payment/payment_page_viewmodel.dart';
import 'package:b2s_parent/src/app/widgets/index.dart';
import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  static const String routeName = "/PaymentPage";
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  PaymentPageViewModel viewModel = PaymentPageViewModel();
  @override
  Widget build(BuildContext context) {
    Widget _appBar(){
      return TS24AppBar(
        title: Text(translation.text("PAYMENT_PAGE.TITLE")),
      );
    }
    Widget _card(){
      return CreditCardWidget(
        height: 175,
        cardNumber: "",
        expiryDate: "12/05",
        cardHolderName: "DUONG TUYET MAI",
        showBackView: false,
      );
    }
//    Widget _buttonEditPayment(){
//      return Container(
//        width: MediaQuery.of(context).size.width,
//        height: 50,
//        child: Material(
//          color: ThemePrimary.primaryColor,
//          borderRadius: BorderRadius.all(Radius.circular(12)),
//          child: InkWell(
//            borderRadius: BorderRadius.all(Radius.circular(12)),
//            onTap: (){
//              viewModel.onTapEditPayment();
//            },
//            child: Center(
//              child: Text(translation.text("PAYMENT_PAGE.ADD"),style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w700),),
//            ),
//          ),
//        ),
//      );
//    }
    Widget _body(){
      return SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(15.0),
          alignment: Alignment.topCenter,
          child: _card(),//_buttonEditPayment(),
        ),
      );
    }
    viewModel.context = context;
    return ViewModelProvider(
      viewmodel: viewModel,
      child: StreamBuilder<Object>(
        stream: viewModel.stream,
        builder: (context,snapshot){
          return TS24Scaffold(
            appBar: _appBar(),
            body: _body(),
          );
        },
      ),
    );
  }
}
