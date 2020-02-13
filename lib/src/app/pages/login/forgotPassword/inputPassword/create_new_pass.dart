import 'package:b2s_parent/src/app/app_localizations.dart';
import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/pages/login/forgotPassword/inputPassword/create_new_pass_viewmodel.dart';
import 'package:b2s_parent/src/app/service/common-service.dart';
import 'package:b2s_parent/src/app/theme/theme_primary.dart';
import 'package:b2s_parent/src/app/widgets/ts24_appbar_widget.dart';
import 'package:b2s_parent/src/app/widgets/ts24_scaffold_widget.dart';
import 'package:b2s_parent/src/app/widgets/ts24_utils_widget.dart';
import 'package:flutter/material.dart';

class CreateNewPass extends StatefulWidget {
  static const String routeName = "/createnewpass";
  @override
  _CreateNewPassState createState() => _CreateNewPassState();
}

class _CreateNewPassState extends State<CreateNewPass> {
  CreateNewPassViewModel viewModel = CreateNewPassViewModel();
  @override
  Widget build(BuildContext context) {
    viewModel.context = context;
    Widget _background() {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
//            Container(
//              height: 200,
//              width: MediaQuery.of(context).size.width*0.8,
//              child: Image.asset("assets/images/B2S_logo_Parent.png"),
//            ),
            SizedBox(
              height: 50,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Text(
                translation.text("LOGIN_PAGE.CREATE_PASS").toUpperCase(),
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: Colors.grey[800]),
                textAlign: TextAlign.center,
              ),
            ),

            Expanded(
              child: Container(),
            )
          ],
        ),
      );
    }

    Widget _content(context) {
      Widget _formPassword() {
        return Container(
            decoration: boxShaDow(),
            padding: const EdgeInsets.all(8.0),
            margin:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
            child: Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Stack(
                        alignment: AlignmentDirectional.centerEnd,
                        children: <Widget>[
                          TextFormField(
                            controller: viewModel.passController,
                            focusNode: viewModel.passFocus,
                            style: TextStyle(fontSize: 18, color: Colors.black),
//                            obscureText: !viewModel.showPass ? true : false,
                            decoration: InputDecoration(
                                hintText:
                                    translation.text("LOGIN_PAGE.PASSWORD"),
                                errorText: viewModel.errorPass,
                                labelStyle:
                                    ThemePrimary.loginPageButton(context)),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (v) {
                              viewModel.fieldFocusChange(
                                  context,
                                  viewModel.passFocus,
                                  viewModel.passConfirmFocus);
                            },
                          ),
//                          GestureDetector(
//                            onTap: viewModel.onTapShowPassword,
//                            child: Text(
//                              viewModel.showPass
//                                  ? translation.text("LOGIN_PAGE.HIDE")
//                                  : translation.text("LOGIN_PAGE.SHOW"),
//                              style: TextStyle(
//                                  color: Theme.of(context).primaryColor,
//                                  fontSize: 13,
//                                  fontWeight: FontWeight.bold),
//                            ),
//                          )
                        ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Stack(
                        alignment: AlignmentDirectional.centerEnd,
                        children: <Widget>[
                          TextFormField(
                            controller: viewModel.passControllerConfirm,
                            focusNode: viewModel.passConfirmFocus,
                            style: TextStyle(fontSize: 18, color: Colors.black),
//                            obscureText: !viewModel.showPass ? true : false,
                            decoration: InputDecoration(
                                hintText:
                                    translation.text("LOGIN_PAGE.CONFIRM_PASS"),
                                errorText: viewModel.errorPassConfirm,
                                labelStyle:
                                    ThemePrimary.loginPageButton(context)),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (v) {
//                              viewModel.fieldFocusChange(context,
//                                  viewModel.passFocus, viewModel.passConfirmFocus);
                            },
                          ),
//                          GestureDetector(
//                            onTap: viewModel.onTapShowPassword,
//                            child: Text(
//                              viewModel.showPass
//                                  ? translation.text("LOGIN_PAGE.HIDE")
//                                  : translation.text("LOGIN_PAGE.SHOW"),
//                              style: TextStyle(
//                                  color: Theme.of(context).primaryColor,
//                                  fontSize: 13,
//                                  fontWeight: FontWeight.bold),
//                            ),
//                          )
                        ]),
                  ),
                ],
              ),
            ));
      }

      Widget _submitDone() {
        return Column(
          children: <Widget>[
            SizedBox(height: Common.setFontSize(40)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
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
//                        viewModel.onSignInClicked();
                      },
                      child: Center(
                        child: Text(translation.text("LOGIN_PAGE.DONE"),
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
                height: 130,
              ),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Center(
                  child: Text(
                    translation.text("LOGIN_PAGE.HINT2"),
                    style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              _formPassword(),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 50),
                child: _submitDone(),
              ),
            ],
          ),
        ),
      );
    }

    return ViewModelProvider(
      viewmodel: viewModel,
      child: StreamBuilder<Object>(
        stream: viewModel.stream,
        builder: (context, snapshot) {
          return TS24Scaffold(
            appBar: TS24AppBar(
              title: Text(translation.text("LOGIN_PAGE.FORGOT_PASS")),
            ),
            body: Stack(
              children: <Widget>[
                _background(),
                _content(context),
              ],
            ),
          );
        },
      ),
    );
  }
}
