import 'package:b2s_parent/src/app/core/app_setting.dart';
import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/helper/validator-helper.dart';
import 'package:b2s_parent/src/app/pages/login/forgotPassword/inputPassword/create_new_pass.dart';
import 'package:b2s_parent/src/app/widgets/ts24_utils_widget.dart';
import 'package:flutter/cupertino.dart';

import '../../../../app_localizations.dart';

class ForgotPasswordEmailViewModel extends ViewModelBase{
  TextEditingController _emailController = TextEditingController();
  get emailController => _emailController;
  String _errorEmail;
  get errorEmail=>_errorEmail;
  ForgotPasswordEmailViewModel(){
    _emailController.addListener(() {
      if (_emailController.text.length > 1) isValidEmail();
    });
  }
  bool isValidEmail() {
    _errorEmail = null;
    var resultEmail = Validator.validateEmail(_emailController.text);
    if (resultEmail != null) {
      _errorEmail = resultEmail;
      this.updateState();
      return false;
    } else
      this.updateState();
    return true;
  }
  onTapButtonNext() async {
    isValidEmail();
    if (!isValidEmail()) return;
    LoadingDialog.showLoadingDialog(
        context, translation.text("COMMON.IN_PROCESS"));
    bool result = await api.resetPassword(email: _emailController.text.toString());
    if (result) {
      LoadingDialog.hideLoadingDialog(context);
      LoadingDialog.showMsgDialog(
          context, translation.text("FORGET_PASSWORD_PAGE.RESET_SUCCESS"));
    } else {
      LoadingDialog.hideLoadingDialog(context);
      LoadingDialog.showMsgDialog(context, translation.text("FORGET_PASSWORD_PAGE.RESET_FAIL"));
    }
    //Navigator.pushNamed(context, CreateNewPass.routeName);
  }
}