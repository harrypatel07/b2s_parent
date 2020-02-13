import 'package:b2s_parent/src/app/app_localizations.dart';
import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/helper/validator-helper.dart';
import 'package:flutter/material.dart';

class CreateNewPassViewModel extends ViewModelBase {
  TextEditingController _passController = TextEditingController();
  get passController => _passController;
  bool showPass = true;
  String errorPass;
  TextEditingController _passControllerConfirm = TextEditingController();
  get passControllerConfirm => _passControllerConfirm;
  bool showPassConfirm = true;
  String errorPassConfirm;
  final FocusNode passFocus = FocusNode();
  final FocusNode passConfirmFocus = FocusNode();
  CreateNewPassViewModel() {
    passController.addListener(() => {isValidPass()});
    passControllerConfirm.addListener(() => {isValidPassConfirm()});
  }
  fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  bool isValidPass() {
    errorPass = null;
    var resultPass = Validator.validatePassword(passController.text);
    if (resultPass != null) {
      errorPass = resultPass;
      this.updateState();
      return false;
    } else
      this.updateState();
    return true;
  }

  bool isValidPassConfirm() {
    errorPassConfirm = null;
    if (passControllerConfirm.text != passController.text) {
      errorPassConfirm = translation.text("COMMON.PASS_NOT_TRUE");
      this.updateState();
      return false;
    } else
      this.updateState();
    return true;
  }
}
