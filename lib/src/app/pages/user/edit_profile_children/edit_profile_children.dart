import 'dart:io';
import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/models/children.dart';
import 'package:b2s_parent/src/app/models/parent.dart';
import 'package:b2s_parent/src/app/pages/user/edit_profile_children/edit_profile_children_viewmodel.dart';
import 'package:b2s_parent/src/app/theme/theme_primary.dart';
import 'package:b2s_parent/src/app/widgets/drop_down_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    viewModel.childId = this.arguments.childId??-1;
    viewModel.parent = this.arguments.parent;
//    viewModel.listChildren = this.arguments.parent.listChildren;
    viewModel.initData();
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

    final cancelBtn = Positioned(
      top: 25.0,
      left: 0.0,
      child: Container(
        height: 50.0,
        width: 70.0,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.grey.withOpacity(0.5),
        ),
        child: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
          iconSize: 20.0,
        ),
      ),
    );
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
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: ThemePrimary.primaryColor),
                          labelText: 'Họ và tên',
                          hintText:
                              children != null ? children.name : "Nhập tên...",
                          errorText: viewModel.errorName,
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (v) {},
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
                    flex:8,
                    child: Align(
                      alignment: Alignment.center,
                      child: TextFormField(
                        enabled: false,
                        controller: viewModel.birthDayEditingController,
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: ThemePrimary.primaryColor),
                          labelText: 'Ngày sinh',
                          hintText: 'Chọn ngày sinh',
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.center,
                      child: InkWell(
                        onTap: (){
                          viewModel.pickBirthDay();
                        },
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: ThemePrimary.primaryColor,
                            shape: BoxShape.circle
                          ),
                          child: Icon(Icons.date_range,color: Colors.white,),
                        ),
                      )
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
                    child: DropDownField(
                      controller: viewModel.genderEditingController,
                      itemsVisibleInDropdown: 2,
                      value: viewModel.gender,
                      labelStyle: TextStyle(color: ThemePrimary.primaryColor),
                      labelText: 'Giới tính',
                      items: viewModel.listGender,
                      errorText: viewModel.errorGender,
                      onValueChanged: (v) {
                        viewModel.gender = v;
                        viewModel.genderEditingController.text = v.displayName;
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.0),
            Container(
                width: MediaQuery.of(context).size.width,
                child: DropDownField(
                  controller: viewModel.schoolNameEditingController,
                  labelStyle: TextStyle(color: ThemePrimary.primaryColor),
                  value: viewModel.school,
                  labelText: 'Trường học',
                  items: viewModel.listSchool,
                  errorText: viewModel.errorSchoolName,
                  setter: (dynamic value) {},
                  onValueChanged: (v) {
                    viewModel.school = v;
                    viewModel.schoolNameEditingController.text = v.displayName;
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
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: ThemePrimary.primaryColor),
                          labelText: 'Số điện thoại',
                          hintText: children != null
                              ? children.phone.toString()
                              : "Nhập số điện thoại",
                          errorText: viewModel.errorPhone,
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
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
                        controller: viewModel.classesEditingController,
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: ThemePrimary.primaryColor),
                          labelText: 'Lớp',
                          hintText: "Nhập lớp...",
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (v) {},
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
                        controller: viewModel.emailEditingController,
                        decoration: InputDecoration(
                            labelStyle: TextStyle(color: ThemePrimary.primaryColor),
                            labelText: 'Email',
                            hintText: "Nhập email...",
                            errorText: viewModel.errorEmail),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
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
                        controller: viewModel.addressEditingController,
                        decoration: InputDecoration(
                            labelStyle: TextStyle(color: ThemePrimary.primaryColor),
                            labelText: 'Địa chỉ',
                            hintText: children != null
                                ? children.location
                                : "Địa chỉ...",
                            errorText: viewModel.errorAdress),
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.text,
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
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 250,
                          child: Stack(
                            children: <Widget>[
                              _avatar(),
                              cancelBtn,
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
                                  child: Text('LƯU'),
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
