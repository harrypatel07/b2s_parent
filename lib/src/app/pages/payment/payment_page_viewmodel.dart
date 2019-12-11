import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/pages/payment/editPaymentPage/edit_payment_page.dart';
import 'package:flutter/cupertino.dart';

class PaymentPageViewModel extends ViewModelBase{
  onTapEditPayment(){
    Navigator.pushNamed(context, EditPaymentPage.routeName);
  }
}