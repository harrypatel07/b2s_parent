import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/pages/login/login_page_viewmodel.dart';
import 'package:b2s_parent/src/app/service/index.dart';
import 'package:b2s_parent/src/app/theme/theme_primary.dart';
import 'package:b2s_parent/src/app/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../app_localizations.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = "/loginPage";
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginPageViewModel viewModel = LoginPageViewModel();
  @override
  Widget build(BuildContext context) {
    viewModel.context = context;
    return TS24Scaffold(
      resizeToAvoidBottomPadding: true,
      body: ViewModelProvider(
          viewmodel: viewModel,
          child: StreamBuilder<Object>(
              stream: viewModel.stream,
              builder: (context, snapshot) {
                return LoginBodyWidget();
              })),
    );
  }
}

class LoginBodyWidget extends StatefulWidget {
  @override
  _LoginBodyWidgetState createState() => _LoginBodyWidgetState();
}

class _LoginBodyWidgetState extends State<LoginBodyWidget> {
  LoginPageViewModel viewModel;
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) => () {
    //       if (Platform.isIOS) OneSignalService.requestPermission();
    //     });
  }

  Widget _background() => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 40, right: 40, top: 20.0),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // Expanded(
                  //   flex: 5,
                  //   child: Text(translation.text("LOGIN_PAGE.WELCOME"),
                  //       textAlign: TextAlign.center,
                  //       style: TextStyle(
                  //           //fontFamily: "Poppins-Bold",
                  //           fontSize: Common.setFontSize(30),
                  //           letterSpacing: .6,
                  //           fontWeight: FontWeight.bold)),
                  // ),
                  Expanded(
                      flex: 5,
                      child: Container(
                        height: 280,
                        child: Image.asset("assets/images/B2S_logo_Parent.png"),
                      )),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(),
          ),
          Flexible(
            child: Container(
              //height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/city.gif"),
                      fit: BoxFit.fitWidth)),
            ),
          )
        ],
      );

  Widget _content(context) {
    final focus = FocusNode();

    Widget _formLogin() {
      return Container(
          //width: MediaQuery.of(context).size.width - 80,
          decoration: boxShaDow(),
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
          child: Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                  child: TextFormField(
                    controller: viewModel.emailController,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    decoration: InputDecoration(
                        hintText: translation.text("LOGIN_PAGE.EMAIL"),
                        errorText: viewModel.errorEmail,
                        labelStyle: ThemePrimary.loginPageButton(context)),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).requestFocus(focus);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: Stack(
                      alignment: AlignmentDirectional.centerEnd,
                      children: <Widget>[
                        TextFormField(
                          controller: viewModel.passController,
                          focusNode: focus,
                          style: TextStyle(fontSize: 18, color: Colors.black),
                          obscureText: !viewModel.showPass ? true : false,
                          decoration: InputDecoration(
                              hintText: translation.text("LOGIN_PAGE.PASSWORD"),
                              errorText: viewModel.errorPass,
                              labelStyle:
                                  ThemePrimary.loginPageButton(context)),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (v) {
                            viewModel.onSignInClicked();
                          },
                        ),
                        GestureDetector(
                          onTap: viewModel.onTapShowPassword,
                          child: Text(
                            viewModel.showPass
                                ? translation.text("LOGIN_PAGE.HIDE")
                                : translation.text("LOGIN_PAGE.SHOW"),
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ]),
                ),
              ],
            ),
          ));
    }

    Widget _socialLogin() {
      return Container(
//        color: Colors.red,
        width: MediaQuery.of(context).size.width,
//        height: 100,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 2,
                    color: Colors.grey[400],
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'Social Login',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.grey[400]),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 2,
                    color: Colors.grey[400],
                  ),
                ),
                SizedBox(
                  width: 15,
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 50,
                  height: 50,
                  decoration:
                      BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                  child: Center(
                    child: Icon(
                      FontAwesomeIcons.facebookF,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: 50,
                  height: 50,
                  decoration:
                      BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  child: Center(
                    child: Icon(
                      FontAwesomeIcons.googlePlusG,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: 50,
                  height: 50,
                  decoration:
                      BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
                  child: Center(
                    child: Icon(
                      FontAwesomeIcons.apple,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Người dùng mới?',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  width: 5,
                ),
                InkWell(
                    onTap: () {
                      viewModel.onTapSignIn();
                    },
                    child: Text(
                      'Đăng ký',
                      style: TextStyle(
                          color: ThemePrimary.primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ))
              ],
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      );
    }

    Widget _submitLogin() {
      Widget radioButton(bool isSelected) => Container(
            width: 16.0,
            height: 16.0,
            padding: EdgeInsets.all(2.0),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 2.0, color: Colors.black)),
            child: isSelected
                ? Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.black),
                  )
                : Container(),
          );
      return Column(
        children: <Widget>[
          SizedBox(height: Common.setFontSize(40)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
//               Row(
//                 children: <Widget>[
// //                  SizedBox(
// //                    width: 12.0,
// //                  ),
//                   GestureDetector(
//                     onTap: () {},
//                     child: radioButton(false),
//                   ),
//                   SizedBox(
//                     width: 8.0,
//                   ),
//                   Text("Remember me",
//                       style: TextStyle(
//                         fontSize: 12,
//                         //fontFamily: "Poppins-Medium"
//                       ))
//                 ],
//               ),
              Container(),
              Container(
                width: MediaQuery.of(context).size.width - 250,
                height: 40,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0xFFFFD752), Color(0xFFD4AF0B)]),
                    borderRadius: BorderRadius.circular(6.0),
                    boxShadow: [
                      BoxShadow(
                          color: Color(0xFFFFD752).withOpacity(.3),
                          offset: Offset(0.0, 8.0),
                          blurRadius: 8.0)
                    ]),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      viewModel.onSignInClicked();
                    },
                    child: Center(
                      child: Text(translation.text("LOGIN_PAGE.SIGN_IN"),
                          style: TextStyle(
                              color: Colors.white,
                              //fontFamily: "Poppins-Bold",
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              letterSpacing: 1.0)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Padding(
      padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 35.0),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 200,
            ),
            _formLogin(),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: _submitLogin(),
            ),
            _socialLogin(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Common.initFontSize(context);
    viewModel = ViewModelProvider.of(context);
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        _background(),
        _content(context),
      ],
    );
  }
}
