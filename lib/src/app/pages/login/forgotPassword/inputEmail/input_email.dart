import 'package:b2s_parent/src/app/app_localizations.dart';
import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/pages/login/forgotPassword/inputEmail/input_email_viewmodel.dart';
import 'package:b2s_parent/src/app/service/common-service.dart';
import 'package:b2s_parent/src/app/theme/theme_primary.dart';
import 'package:b2s_parent/src/app/widgets/index.dart';
import 'package:flutter/material.dart';

class ForgotPasswordEmail extends StatefulWidget {
  static const String routeName = "/forgotPasswordEmail";
  @override
  _ForgotPasswordEmailState createState() => _ForgotPasswordEmailState();
}

class _ForgotPasswordEmailState extends State<ForgotPasswordEmail> {
  ForgotPasswordEmailViewModel viewModel = ForgotPasswordEmailViewModel();
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
                "${translation.text("LOGIN_PAGE.INPUT_EMAIL")}"
                    .toUpperCase(),
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
      Widget _formEmail() {
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
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                    child: TextFormField(
                      controller: viewModel.emailController,
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      decoration: InputDecoration(
                          hintText: translation.text("FORGET_PASSWORD_PAGE.EMAIL"),
                          errorText: viewModel.errorEmail,
                          labelStyle: ThemePrimary.loginPageButton(context)),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        viewModel.onTapButtonNext();
                      },
                    ),
                  ),
                ],
              ),
            ));
      }

      Widget _submitNext() {
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
                        viewModel.onTapButtonNext();
                      },
                      child: Center(
                        child: Text(translation.text("FORGET_PASSWORD_PAGE.SUBMIT_BUTTON"),
                            style: TextStyle(
                                color: Colors.white,
                                //fontFamily: "Poppins-Bold",
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                letterSpacing: 1.0),
                        ),
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
        padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 0),
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
                    translation.text("FORGET_PASSWORD_PAGE.SUB_TITLE"),
                    style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              _formEmail(),

              Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 100),
                child: _submitNext(),
              ),
//              _socialLogin(),
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
              title: Text(translation.text("FORGET_PASSWORD_PAGE.TITLE")),
            ),
//            body: Stack(
//              children: <Widget>[
//                _background(),
//                _content(context),
//              ],
//            ),
            body: _content(context),
          );
        },
      ),
    );
  }
}
