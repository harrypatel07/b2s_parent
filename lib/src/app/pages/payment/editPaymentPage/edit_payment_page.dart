import 'package:b2s_parent/packages/flutter_credit_card/credit_card_form.dart';
import 'package:b2s_parent/packages/flutter_credit_card/credit_card_widget.dart';
import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/pages/payment/editPaymentPage/edit_payment_page_viewmodel.dart';
import 'package:b2s_parent/src/app/theme/theme_primary.dart';
import 'package:b2s_parent/src/app/widgets/index.dart';
import 'package:flutter/material.dart';

class EditPaymentPage extends StatefulWidget {
  static const String routeName = '/editPayment';
  @override
  _EditPaymentPageState createState() => _EditPaymentPageState();
}

class _EditPaymentPageState extends State<EditPaymentPage> {
  EditPaymentPageViewModel viewModel = EditPaymentPageViewModel();
  @override
  Widget build(BuildContext context) {
    Widget _body (){
      return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            CreditCardWidget(
              height: 175,
              cardNumber: viewModel.cardNumber,
              expiryDate: viewModel.expiryDate,
              cardHolderName: viewModel.cardHolderName,
              showBackView: false,
            ),
            Container(
              child: CreditCardForm(
                themeColor: ThemePrimary.primaryColor,
                onCreditCardModelChange: viewModel.onCreditCardModelChange,
              ),
            )
          ],
        ),
      );
    }
    viewModel.context = context;
    return ViewModelProvider(
      viewmodel: viewModel,
      child: StreamBuilder<Object>(
        stream: viewModel.stream,
        builder: (context,snapshot){
          return  TS24Scaffold(
            appBar: TS24AppBar(
              title: Text('Thanh Toán'),
            ),
            body: _body(),
          );
        },
      ),
    );
  }
}
