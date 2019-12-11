import 'package:b2s_parent/packages/flutter_credit_card/credit_card_model.dart';
import 'package:b2s_parent/src/app/core/baseViewModel.dart';

class EditPaymentPageViewModel extends ViewModelBase{
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  onCreditCardModelChange(CreditCardModel creditCardModel) {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      this.updateState();
  }
}