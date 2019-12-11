import 'dart:io';
import 'package:b2s_parent/packages/flutter_form_builder/lib/src/fields/form_builder_dropdown.dart';
import 'package:b2s_parent/packages/flutter_form_builder/lib/src/fields/form_builder_typeahead.dart';
import 'package:b2s_parent/packages/flutter_form_builder/lib/src/form_builder_validators.dart';
import 'package:b2s_parent/src/app/app_localizations.dart';
import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/models/children.dart';
import 'package:b2s_parent/src/app/models/parent.dart';
import 'package:b2s_parent/src/app/pages/user/edit_profile_children/edit_profile_children_viewmodel.dart';
import 'package:b2s_parent/src/app/service/common-service.dart';
import 'package:b2s_parent/src/app/theme/theme_primary.dart';
import 'package:b2s_parent/src/app/widgets/drop_down_field.dart';
import 'package:b2s_parent/src/app/widgets/ts24_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileChildren extends StatefulWidget {
  static const String routeName = "/editProfile";
  final ProfileChildrenArgs arguments;
  EditProfileChildren(this.arguments);
  @override
  _EditProfileChildrenState createState() =>
      _EditProfileChildrenState(this.arguments);
}

class ProfileChildrenArgs {
  final int childId;
  final Parent parent;
  ProfileChildrenArgs({this.childId, this.parent});
}

class _EditProfileChildrenState extends State<EditProfileChildren> {
  ProfileChildrenArgs arguments;
  _EditProfileChildrenState(this.arguments);
  EditProfileChildrenViewModel viewModel;

  @override
  void initState() {
    // TODO: implement initState
    viewModel = EditProfileChildrenViewModel();
    viewModel.childId = this.arguments.childId ?? -1;
    viewModel.parent = this.arguments.parent;
//    viewModel.listChildren = this.arguments.parent.listChildren;
    viewModel.initData();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
      viewModel.scrollController.animateTo(viewModel.scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 200), curve: Curves.easeOut);
    }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    viewModel.context = context;
    Widget _avatar() {
      Widget _initImage() {
        return Image(
          image: (viewModel.children == null && viewModel.imagePicker == null)
              ? AssetImage('assets/images/user.png')
              : (viewModel.children != null && viewModel.imagePicker == null
                  ? (viewModel.children.photo == null
                      ? AssetImage('assets/images/user.png')
                      : NetworkImage(viewModel.children.photo))
                  : MemoryImage(viewModel.imagePicker)),
          fit: BoxFit.cover,
        );
      }

      Widget _resultImage() {
        final Text retrieveError = _getRetrieveErrorWidget();
        if (retrieveError != null) {
          return retrieveError;
        }
        if (viewModel.imageFile != null) {
          return Image(
            image: MemoryImage(viewModel.imagePicker),
            fit: BoxFit.cover,
          );
        } else if (viewModel.pickImageError != null) {
          return Text(
            'Pick image error: $viewModel.pickImageError',
            textAlign: TextAlign.center,
          );
        } else {
          return _initImage();
        }
      }

      final __editBtn = Positioned(
        bottom: 5.0,
        right: 5,
        child: Container(
          height: 70.0,
          width: 70.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withOpacity(0.2),
          ),
          child: IconButton(
            icon: Icon(Icons.edit, size: 30, color: Colors.white),
            onPressed: () =>
                viewModel.onImageButtonPressed(ImageSource.gallery),
            iconSize: 20.0,
          ),
        ),
      );
      return Stack(
        children: <Widget>[
          Container(
            height: 350,
            width: MediaQuery.of(context).size.width,
            child: Platform.isAndroid
                ? FutureBuilder<void>(
                    future: viewModel.retrieveLostData(),
                    builder:
                        (BuildContext context, AsyncSnapshot<void> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return _initImage();
                        case ConnectionState.done:
                          return _resultImage();
                        default:
                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'Pick image/video error: ${snapshot.error}}',
                                textAlign: TextAlign.center,
                              ),
                            );
                          } else {
                            return _initImage();
                          }
                      }
                    },
                  )
                : (_resultImage()),
          ),
          __editBtn,
        ],
      );
    }

    Widget _backButton() {
      return Positioned(
        top: 0,
        left: 0,
        child: SafeArea(
          top: true,
          bottom: false,
          child: TS24Button(
            onTap: () {
              Navigator.of(context).pop();
            },
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(25),
                  topRight: Radius.circular(25)),
              color: Colors.black38,
            ),
            width: 70,
            height: 50,
            child: Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }

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

    Widget _card(Children children) {
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
                        controller: viewModel.nameEditingController,
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        focusNode: viewModel.nameFocus,
                        decoration: InputDecoration(
                          labelStyle: __styleTextLabel,
                          labelText: translation.text("USER_PROFILE.FULL_NAME"),
                          hintText: children != null
                              ? children.name
                              : translation.text("USER_PROFILE.INPUT_NAME"),
                          errorText: viewModel.errorName,
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (v) {
                          viewModel.fieldFocusChange(context,
                              viewModel.nameFocus, viewModel.schoolFocus);
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
                    flex: 8,
                    child: Align(
                      alignment: Alignment.center,
                      child: TextFormField(
                        enabled: false,
                        controller: viewModel.birthDayEditingController,
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        decoration: InputDecoration(
                          labelStyle: __styleTextLabel,
                          errorText: viewModel.errorBirthDay,
                          errorStyle:
                              TextStyle(color: Colors.red[800], fontSize: 13),
                          labelText: translation.text("USER_PROFILE.BIRTH_DAY"),
                          hintText: translation.text("USER_PROFILE.SELECT_DAY"),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Align(
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () {
                            viewModel.pickBirthDay();
                          },
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                                color: ThemePrimary.primaryColor,
                                shape: BoxShape.circle),
                            child: Icon(
                              Icons.date_range,
                              color: Colors.white,
                            ),
                          ),
                        )),
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
                child: viewModel.loadingSchool ||
                        viewModel.listSchool.length == 0
                    ? _textFormFieldLoading(
                        translation.text("USER_PROFILE.SCHOOL"))
                    : FormBuilderTypeAhead(
                        readOnly: false,
                        textFieldConfiguration: TextFieldConfiguration(
                            focusNode: viewModel.schoolFocus,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            onSubmitted: (v) {
                              viewModel.fieldFocusChange(context,
                                  viewModel.schoolFocus, viewModel.phoneFocus);
                            }),
                        decoration: InputDecoration(
                            hintText: "Nhập tên trường...",
                            labelText: translation.text("USER_PROFILE.SCHOOL"),
                            labelStyle: __styleTextLabel,
                            errorText: viewModel.errorSchoolName),
                        attribute: translation.text("USER_PROFILE.SCHOOL"),
                        initialValue: viewModel.school.displayName,
                        onChanged: (text) =>
                            viewModel.schoolNameEditingController.text = text,
                        itemBuilder: (context, school) {
                          return ListTile(
                            title: Text(school),
                          );
                        },
                        onSuggestionSelected: (strSchool) => {
                          viewModel.onSelectedSchoolItem(strSchool),
                          viewModel.fieldFocusChange(context,
                              viewModel.schoolFocus, viewModel.phoneFocus),
                        },
                        suggestionsCallback: (query) {
                          if (query.length != 0 && query != '') {
                            var lowercaseQuery =
                                Common.sanitizing(query.toLowerCase());
                            var listResult = viewModel.listSchool
                                .where((school) {
                                  return (Common.sanitizing(
                                          school.displayName.toLowerCase())
                                      .contains(lowercaseQuery));
                                })
                                .toList(growable: false)
                                .map((item) => item.displayName)
                                .toList()
                                  ..sort((a, b) =>
                                      Common.sanitizing(a.toLowerCase())
                                          .indexOf(lowercaseQuery)
                                          .compareTo(
                                              Common.sanitizing(b.toLowerCase())
                                                  .indexOf(lowercaseQuery)));
                            return viewModel.sortListSchoolShow(listResult);
                          } else {
                            var listResult = viewModel.listSchool
                                .map((item) => item.displayName)
                                .toList();
                            return viewModel.sortListSchoolShow(listResult);
                          }
                        },
                      )),
            SizedBox(height: 15.0),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Flexible(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: viewModel.phoneEditingController,
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        focusNode: viewModel.phoneFocus,
                        decoration: InputDecoration(
                          labelStyle: __styleTextLabel,
                          labelText:
                              translation.text("USER_PROFILE.PHONE_NUMBER"),
                          hintText: children != null
                              ? children.phone.toString()
                              : translation.text("USER_PROFILE.INPUT_PHONE"),
//                          errorText: viewModel.errorPhone,
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        onFieldSubmitted: (v) {
                          viewModel.fieldFocusChange(context,
                              viewModel.phoneFocus, viewModel.classFocus);
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
                        focusNode: viewModel.classFocus,
                        controller: viewModel.classesEditingController,
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        decoration: InputDecoration(
                          labelStyle: __styleTextLabel,
                          labelText: translation.text("USER_PROFILE.CLASS"),
                          hintText:
                              translation.text("USER_PROFILE.INPUT_CLASS"),
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (v) {
                          viewModel.fieldFocusChange(context,
                              viewModel.classFocus, viewModel.addressFocus);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
//            SizedBox(height: 15.0),
//            Container(
//              width: MediaQuery.of(context).size.width,
//              child: Row(
//                children: <Widget>[
//                  Flexible(
//                    child: Align(
//                      alignment: Alignment.center,
//                      child: TextFormField(
//                        focusNode: viewModel.mailFocus,
//                        controller: viewModel.emailEditingController,
//                        decoration: InputDecoration(
//                            labelStyle: __styleTextLabel,
//                            labelText: translation.text("USER_PROFILE.EMAIL"),
//                            hintText:
//                                translation.text("USER_PROFILE.INPUT_EMAIL"),
//                            errorText: viewModel.errorEmail),
//                        textInputAction: TextInputAction.next,
//                        keyboardType: TextInputType.text,
//                        onFieldSubmitted: (v){
//                          viewModel.fieldFocusChange(context, viewModel.mailFocus, viewModel.addressFocus);
//                        },
//                      ),
//                    ),
//                  ),
//                ],
//              ),
//            ),
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
                            labelStyle: __styleTextLabel,
                            labelText: translation.text("USER_PROFILE.ADDRESS"),
                            hintText: children != null
                                ? children.location
                                : translation
                                    .text("USER_PROFILE.INPUT_ADDRESS"),
                            errorText: viewModel.errorAdress),
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.text,
                        onFieldSubmitted: (v) {
                          viewModel.addressFocus.unfocus();
                          viewModel.onTapSave();
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
//          Text(
//            description,
//            textAlign: TextAlign.center,
//            style: TextStyle(
//              fontSize: 16.0,
//            ),
//          ),
          ],
        ),
      );
    }

    return Scaffold(
      body: ViewModelProvider(
        viewmodel: viewModel,
        child: StreamBuilder<Object>(
            stream: viewModel.stream,
            builder: (context, snapshot) {
              return Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    controller: viewModel.scrollController,
                    reverse: true,
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 250,
                          child: Stack(
                            children: <Widget>[
                              _avatar(),
                              _backButton(),
                            ],
                          ),
                        ),
                        _card(viewModel.children),
                        SizedBox(
                          height: 80,
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
                                onTap: () {
                                  viewModel.onTapSave();
                                },
                                child: Center(
                                  child: Text(
                                    translation
                                        .text("COMMON.SAVE")
                                        .toUpperCase(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 16),
                                  ),
                                )),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }

  Text _getRetrieveErrorWidget() {
    if (viewModel.retrieveDataError != null) {
      final Text result = Text(viewModel.retrieveDataError);
      viewModel.retrieveDataError = null;
      return result;
    }
    return null;
  }
}

class Consts {
  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}
