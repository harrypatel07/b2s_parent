import 'package:b2s_parent/src/app/app_localizations.dart';
import 'package:b2s_parent/src/app/core/app_setting.dart';
import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/helper/validator-helper.dart';
import 'package:b2s_parent/src/app/models/parent.dart';
import 'package:b2s_parent/src/app/pages/home/home_page.dart';
import 'package:b2s_parent/src/app/pages/login/forgotPassword/inputEmail/input_email.dart';
import 'package:b2s_parent/src/app/pages/tabs/tabs_page.dart';
import 'package:b2s_parent/src/app/pages/user/register/register_page.dart';
import 'package:b2s_parent/src/app/provider/api_master.dart';
import 'package:b2s_parent/src/app/service/apple-service.dart';
import 'package:b2s_parent/src/app/service/facebook-service.dart';
import 'package:b2s_parent/src/app/service/googleplus-service.dart';
import 'package:b2s_parent/src/app/service/onesingal-service.dart';
import 'package:b2s_parent/src/app/widgets/ts24_utils_widget.dart';
import 'package:flutter/material.dart';

enum TypeLogin { facebook, google, apple }

class LoginPageViewModel extends ViewModelBase {
  final focus = FocusNode();
  TextEditingController _emailController = new TextEditingController();
  get emailController => _emailController;
  TextEditingController _passController = new TextEditingController();
  get passController => _passController;

  String _errorEmail;
  get errorEmail => _errorEmail;

  String _errorPass;
  get errorPass => _errorPass;

  bool _showPass = false;
  get showPass => _showPass;
  LoginPageViewModel() {
    //account demo
    // _emailController.text = "dhoangchau@gmail.com";
    // _passController.text = "123456";
    _emailController.addListener(() {
      if (_emailController.text.length > 1) isValidEmail();
    });
    _passController.addListener(() {
      if (_passController.text.length > 1) isValidInfo();
    });
  }

  void onTapShowPassword() {
    _showPass = !_showPass;
    this.updateState();
  }

  bool isValidEmail() {
    _errorEmail = null;
    var resultemail = Validator.validateEmail(_emailController.text);
    if (resultemail != null) {
      _errorEmail = resultemail;
      this.updateState();
      return false;
    } else
      this.updateState();
    return true;
  }

  bool isValidPass() {
    _errorPass = null;
    var resultpass = Validator.validatePassword(_passController.text);
    if (resultpass != null) {
      _errorPass = resultpass;
      this.updateState();
      return false;
    } else
      this.updateState();
    return true;
  }

  bool isValidInfo() {
    if (isValidEmail() && isValidPass()) {
      this.updateState();
      return true;
    }
    return false;
  }

  onSignInClicked() async {
    if (isValidInfo()) {
      //Kiểm tra login
      LoadingDialog.showLoadingDialog(
          context, translation.text("WAITING_MESSAGE.AUTH_ACCOUNT"));
      var _checkLogin = await api.checkLogin(
        username: _emailController.text.trim(),
        password: _passController.text.trim(),
      );

      if (_checkLogin == StatusCodeGetToken.TRUE) {
        // Lấy id của user
        var userInfo = await api.getUser();
        if (userInfo != null) {
          //Đổ data vào parent model
          await api.getParentInfo(userInfo['partnerID']);
          //Lấy danh sách children đã mua vé
          await api.getTicketOfListChildren();
          //Gửi tags đến onesignal
          Parent _parent = Parent();
          print("_parent.email");
          print(_parent.email);
          print("_parent.toJsonOneSignal()");
          print(_parent.toJsonOneSignal());
          OneSignalService.sendTags(_parent.toJsonOneSignal());
        }
        LoadingDialog.hideLoadingDialog(context);
        ToastController.show(
            context: context,
            duration: Duration(milliseconds: 300),
            message: translation.text("WAITING_MESSAGE.PERMISSION_CONNECT"));

        Future.delayed(const Duration(milliseconds: 300), () {
          Navigator.pushReplacementNamed(context, TabsPage.routeName,
              arguments: TabsArgument(routeChildName: HomePage.routeName));
        });
        // Navigator.popAndPushNamed(context, TabsPage.routeName,
        //     arguments: TabsArgument(routeChildName: HomePage.routeName));
      } else {
        LoadingDialog.hideLoadingDialog(context);
        return LoadingDialog.showMsgDialog(
            context, translation.text("ERROR_MESSAGE.WRONG_LOGIN"));
      }
    }
  }

  onTapSignIn() {
    Navigator.pushNamed(context, RegisterPage.routeName).then((result) {
      try {
        if (result != null) {
          _emailController.text = result;
          this.updateState();
        }
      } catch (e) {}
    });
  }

  onTapForgotPassword() {
    Navigator.pushNamed(context, ForgotPasswordEmail.routeName);
  }

  googleLogin() async {
    LoadingDialog.showLoadingDialog(
        context, translation.text("WAITING_MESSAGE.SOCIAL_NETWORK"));
    if (GooglePlusService.currentUser != null)
      await GooglePlusService.handleSignOut();
    var _result = await GooglePlusService.handleSignIn();
//    print('${GooglePlusService.currentUser.email}, ${GooglePlusService.currentUser.displayName}');
//    print('result $_result');
    LoadingDialog.hideLoadingDialog(context);
    if (_result) {
      //print('${GooglePlusService.currentUser.email}');
      _socialLogin(GooglePlusService.currentUser.email, TypeLogin.google);
      //print('${GooglePlusService.currentUser.email}, ${GooglePlusService.currentUser.displayName}');
    }
  }

  facebookLogin() async {
    LoadingDialog.showLoadingDialog(
        context, translation.text("WAITING_MESSAGE.SOCIAL_NETWORK"));
    FacebookService facebookService = FacebookService();
    if (facebookService.email != null) await facebookService.handleSignOut();
    var _result = await facebookService.handleSignIn();
    LoadingDialog.hideLoadingDialog(context);
    print('fb ${facebookService.email} ${facebookService.name}');
    if (_result) _socialLogin(facebookService.email, TypeLogin.facebook);
  }

  appleLogin() async {
    LoadingDialog.showLoadingDialog(
        context, translation.text("WAITING_MESSAGE.SOCIAL_NETWORK"));
    var _result = await AppleService.handleLogin();
    LoadingDialog.hideLoadingDialog(context);
    if (_result) _socialLogin(AppleService.currentUser.email, TypeLogin.apple);
  }

  _socialLogin(String email, TypeLogin typeLogin) async {
    print('email $email');
    LoadingDialog.showLoadingDialog(
        context, translation.text("WAITING_MESSAGE.AUTH_ACCOUNT"));
    var _checkExist = await api.checkUserExist(email);
    if (_checkExist != null) {
      //Đổ data vào parent model
      await api.getParentInfo(_checkExist.id);
      //Lấy danh sách children đã mua vé
      await api.getTicketOfListChildren();
      //Gửi tags đến onesignal
      Parent _parent = Parent();
      print("_parent.email");
      print(_parent.email);
      print("_parent.toJsonOneSignal()");
      print(_parent.toJsonOneSignal());
      OneSignalService.sendTags(_parent.toJsonOneSignal());
      LoadingDialog.hideLoadingDialog(context);
      ToastController.show(
          context: context,
          duration: Duration(milliseconds: 300),
          message: translation.text("WAITING_MESSAGE.PERMISSION_CONNECT"));

      Future.delayed(const Duration(milliseconds: 300), () {
        Navigator.pushReplacementNamed(context, TabsPage.routeName,
            arguments: TabsArgument(routeChildName: HomePage.routeName));
      });
    } else {
      LoadingDialog.hideLoadingDialog(context);
      Navigator.pushNamed(context, RegisterPage.routeName,
          arguments: typeLogin);
//      Navigator.pushNamed(context, RegisterPage.routeName, ).then((result) {
//        try {
//          if (result != null) {
//            _emailController.text = result;
//            this.updateState();
//          }
//        } catch (e) {}
//      });
//      return LoadingDialog.showMsgDialog(
//          context, translation.text("ERROR_MESSAGE.USET_NOT_EXIST"));
    }
  }
}
