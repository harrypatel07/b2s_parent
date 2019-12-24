import 'package:b2s_parent/packages/flutter_form_builder/lib/src/fields/form_builder_dropdown.dart';
import 'package:b2s_parent/packages/flutter_form_builder/lib/src/form_builder_validators.dart';
import 'package:b2s_parent/src/app/app_localizations.dart';
import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/pages/user/register/register_page_viewmodel.dart';
import 'package:b2s_parent/src/app/theme/theme_primary.dart';
import 'package:b2s_parent/src/app/widgets/drop_down_field.dart';
import 'package:b2s_parent/src/app/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterPage extends StatefulWidget {
  static const String routeName = '/register';
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  RegisterPageViewModel viewModel = RegisterPageViewModel();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    viewModel.context = context;
    final __styleTextLabel = TextStyle(
        color: Colors.orange[800], fontWeight: FontWeight.bold, fontSize: 16);
    Widget _textFormFieldLoading(String text) {
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  height: 45,
                ),
                Text(
                  text,
                  style: __styleTextLabel,
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 15,
                  height: 15,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        ThemePrimary.colorDriverApp),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 1,
              color: Colors.grey[350],
            ),
          ],
        ),
      );
    }

    Widget _card() {
      return Container(
        margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // To make the card compact
          children: <Widget>[
            SizedBox(height: 15.0),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: Align(
                      alignment: Alignment.center,
                      child: TextFormField(
                        focusNode: viewModel.mailFocus,
                        controller: viewModel.emailEditingController,
                        decoration: InputDecoration(
                            labelText: translation.text("USER_PROFILE.EMAIL"),
                            labelStyle: __styleTextLabel,
                            hintText:
                                translation.text("USER_PROFILE.INPUT_EMAIL"),
                            errorText: viewModel.errorEmail),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        onFieldSubmitted: (v) {
                          viewModel.fieldFocusChange(context,
                              viewModel.mailFocus, viewModel.passFocus);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.0),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: Align(
                      alignment: Alignment.center,
                      child: TextFormField(
                        focusNode: viewModel.passFocus,
                        controller: viewModel.passEditingController,
                        decoration: InputDecoration(
                            labelText: translation.text("LOGIN_PAGE.PASSWORD"),
                            labelStyle: __styleTextLabel,
//                            hintText: translation.text("USER_PROFILE.INPUT_EMAIL"),
                            errorText: viewModel.errorPass),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        onFieldSubmitted: (v) {
                          viewModel.fieldFocusChange(context,
                              viewModel.passFocus, viewModel.passConfirmFocus);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.0),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: Align(
                      alignment: Alignment.center,
                      child: TextFormField(
                        focusNode: viewModel.passConfirmFocus,
                        controller: viewModel.passConfirmEditingController,
                        decoration: InputDecoration(
                            labelText:
                                translation.text("LOGIN_PAGE.PASSWORD_AGAIN"),
                            labelStyle: __styleTextLabel,
//                            hintText: translation.text("USER_PROFILE.INPUT_EMAIL"),
                            errorText: viewModel.errorPassConfirm),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        onFieldSubmitted: (v) {
                          viewModel.fieldFocusChange(context,
                              viewModel.passConfirmFocus, viewModel.nameFocus);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.0),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: Align(
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: viewModel.nameEditingController,
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        focusNode: viewModel.nameFocus,
                        decoration: InputDecoration(
                          labelText: translation.text("USER_PROFILE.FULL_NAME"),
                          labelStyle: __styleTextLabel,
                          hintText: translation.text("USER_PROFILE.INPUT_NAME"),
                          errorText: viewModel.errorName,
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (v) {
                          viewModel.fieldFocusChange(context,
                              viewModel.nameFocus, viewModel.phoneFocus);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.0),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: viewModel.loadingGender ||
                            viewModel.listGender.length == 0
                        ? _textFormFieldLoading(
                            translation.text("USER_PROFILE.GENDER"))
                        : FormBuilderDropdown(
                            attribute: translation.text("USER_PROFILE.GENDER"),
                            decoration: InputDecoration(
                              labelText:
                                  translation.text("USER_PROFILE.GENDER"),
                              labelStyle: __styleTextLabel,
                            ),
                            initialValue: viewModel.gender,
                            validators: [FormBuilderValidators.required()],
                            items: viewModel.listGender
                                .map((gender) =>
                                    DropdownMenuItem<ItemDropDownField>(
                                      value: gender,
                                      child: Text(gender.displayName),
                                    ))
                                .toList(),
                            onChanged: (gender) => viewModel.gender = gender,
                          ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.0),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Flexible(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: viewModel.phoneEditingController,
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        focusNode: viewModel.phoneFocus,
                        decoration: InputDecoration(
                          labelText:
                              translation.text("USER_PROFILE.PHONE_NUMBER"),
                          hintText:
                              translation.text("USER_PROFILE.INPUT_PHONE"),
                          labelStyle: __styleTextLabel,
                          errorText: viewModel.errorPhone,
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        onFieldSubmitted: (v) {
                          viewModel.fieldFocusChange(context,
                              viewModel.phoneFocus, viewModel.addressFocus);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.0),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Flexible(
                    flex: 4,
                    child: Align(
                      alignment: Alignment.center,
                      child: TextFormField(
                        focusNode: viewModel.addressFocus,
                        controller: viewModel.addressEditingController,
                        decoration: InputDecoration(
                            labelText: translation.text("USER_PROFILE.ADDRESS"),
                            labelStyle: __styleTextLabel,
                            hintText:
                                translation.text("USER_PROFILE.INPUT_ADDRESS"),
                            errorText: viewModel.errorAddress),
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.text,
                        onFieldSubmitted: (v) {
                          viewModel.addressFocus.unfocus();
//                          viewModel.saveParent();
                        },
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.center,
                      child: InkWell(
                        onTap: () {
                          viewModel.onTapPickMaps();
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          child: Icon(
                            FontAwesomeIcons.searchLocation,
                            color: ThemePrimary.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget _appBar() {
      return TS24AppBar(
        title: Text(translation.text("REGISTER_PAGE.TITLE")),
      );
    }

    Widget _body() {
      return Stack(
        children: <Widget>[
          SingleChildScrollView(
            controller: viewModel.scrollController,
            reverse: true,
            child: Column(
              children: <Widget>[
                _card(),
                SizedBox(
                  height: 70,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 50,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: ThemePrimary.primaryColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[500],
                          offset: Offset(0.0, 1.5),
                          blurRadius: 1.5,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                        onTap: () async {
//                                  LoadingDialog.showLoadingDialog(context,
//                                      translation.text("COMMON.IN_PROCESS"));
//                                  viewModel
//                                      .saveParent(viewModel.parent)
//                                      .then((v) {
//                                    if (v) {
//                                      LoadingDialog.hideLoadingDialog(context);
//                                      Navigator.pop(context);
//                                    } else {
//                                      LoadingDialog.hideLoadingDialog(context);
//                                      Navigator.pop(context);
//                                    }
//                                  });
                        },
                        child: Center(
                          child: Text(
                            translation
                                .text("REGISTER_PAGE.REGISTER")
                                .toUpperCase(),
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Colors.white),
                          ),
                        )),
                  ),
                ),
              ),
            ),
          )
        ],
      );
    }

    return ViewModelProvider(
      viewmodel: viewModel,
      child: StreamBuilder<Object>(
          stream: viewModel.stream,
          builder: (context, snapshot) {
            return TS24Scaffold(
              appBar: _appBar(),
              body: _body(),
            );
          }),
    );
  }
}

class Const {
  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}
