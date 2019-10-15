import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/helper/constant.dart';
import 'package:b2s_parent/src/app/models/children.dart';
import 'package:b2s_parent/src/app/pages/user/popup_edit_profile_children/popup_edit_profile_children_viewmodel.dart';
import 'package:b2s_parent/src/app/pages/user/user_page_viewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PopupEditProfileChildren extends StatefulWidget {
  static const String routeName = "/popupProfile";
  final ProfileChildrenArgs arguments;
  PopupEditProfileChildren(this.arguments);
  @override
  _PopupEditProfileChildrenState createState() => _PopupEditProfileChildrenState(this.arguments);
}

class ProfileChildrenArgs {
  final String buttonText;
  final Children children;
  final UserPageViewModel userViewModel;
  ProfileChildrenArgs({this.buttonText, this.children, this.userViewModel});
}

class _PopupEditProfileChildrenState extends State<PopupEditProfileChildren> {
  final ProfileChildrenArgs arguments;
  String _gender;
  _PopupEditProfileChildrenState(this.arguments);
  PopupEditProfileChildrenViewModel viewModel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel = PopupEditProfileChildrenViewModel();
    viewModel.userPageViewModel = this.arguments.userViewModel;
    if(this.arguments.children != null) _gender =  this.arguments.children.gender;
    else _gender = GENDER_MALE;
  }

  @override
  Widget build(BuildContext context) {
    viewModel.context = context;
    dialogContent(BuildContext context, Children children, String buttonText) {
      Widget _card(Children children, String buttonText) {
        return Container(
          padding: EdgeInsets.only(
            top: Consts.avatarRadius + Consts.padding,
            bottom: Consts.padding,
            left: Consts.padding,
            right: Consts.padding,
          ),
          margin: EdgeInsets.only(top: Consts.avatarRadius),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Consts.padding),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
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
                          autofocus: true,
                          style: TextStyle(fontSize: 18, color: Colors.black),
                          decoration: InputDecoration(
                            //border: InputBorder,
                            hintText: children != null
                                ? children.name
                                : "Nhập tên...",
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
                      flex: 2,
                      child: Align(
                        alignment: Alignment.center,
                        child: TextFormField(
                          controller: viewModel.ageEditingController,
//                          focusNode: focusAge,
                          style: TextStyle(fontSize: 18, color: Colors.black),
                          decoration: InputDecoration(
                            //border: InputBorder,
                            hintText: children != null
                                ? children.age.toString()
                                : "Nhập tuổi...",
                            errorText: viewModel.errorAge,
                          ),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      flex: 2,
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: DropdownButton(
                            value: _gender,
                            icon: Icon(Icons.arrow_drop_down),
                            //underline: Container(height: 1,color: Colors.grey),
                            onChanged: (String newValue)=> {
                              _gender = newValue,
                              viewModel.gender = newValue,
                              print(newValue),
                            },
                            items: <String>[GENDER_MALE, GENDER_FEMALE]
                                .map<DropdownMenuItem<String>>((String result) {
                              return DropdownMenuItem<String>(
                                value: result,
                                child: Text(
                                    (result == GENDER_MALE) ? 'Nam' : 'Nữ'),
                              );
                            }).toList(),
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
                      child: Align(
                        alignment: Alignment.center,
                        child: TextFormField(
                          controller: viewModel.schoolNameEditingController,
//                          focusNode: focusSchoolName,
                          decoration: InputDecoration(
                              //border: InputBorder,
                              hintText: children != null
                                  ? children.schoolName
                                  : "Nhập tên trường học tại đây...",
                              errorText: viewModel.errorSchoolName),
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.text,
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
              SizedBox(height: 15.0),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: 100,
                  height: 40.0,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[Colors.deepOrange, Colors.yellow],
                      ),
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
                          viewModel.saveChildren(children);
                        },
                        child: Center(
                          child: Text(buttonText),
                        )),
                  ),
                ),
              ),
            ],
          ),
        );
      }

      Widget _avatar() {
        return Center(
            child: Stack(
          children: <Widget>[
            new CachedNetworkImage(
              imageUrl: children != null
                  ? children.photo
                  : "http://getdrawings.com/free-icon/default-user-icon-59.png",
              imageBuilder: (context, imageProvider) => CircleAvatar(
                radius: 70.0,
                backgroundImage: imageProvider,
                backgroundColor: Colors.transparent,
              ),
            ),
            CircleAvatar(
              radius: 70.0,
//                backgroundImage: imageProvider,
              backgroundColor: Colors.white38,
              child: Align(
                  alignment: Alignment.center,
                  child: InkWell(
                      onTap: () {}, //getImage(),
                      child: Container(
                        width: 100,
                        height: 100,
                        child: Icon(Icons.edit),
                      ))),
            )
          ],
        ));
      }

      return new Container(
        child: Stack(
          children: <Widget>[
            _card(children, buttonText),
            _avatar(),
            //...bottom card part,
            //...top circlular image part,
          ],
        ),
      );
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: ViewModelProvider(
        viewmodel: viewModel,
        child: StreamBuilder<Object>(
            stream: viewModel.stream,
            builder: (context, snapshot) {
              return SingleChildScrollView(
                reverse: true,
                child: dialogContent(context, this.arguments.children,
                    this.arguments.buttonText),
              );
            }),
      ),
    );
  }
}

class Consts {
  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}
