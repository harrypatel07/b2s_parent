import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/helper/constant.dart';
import 'package:b2s_parent/src/app/helper/index.dart';
import 'package:b2s_parent/src/app/models/children.dart';
import 'package:b2s_parent/src/app/pages/user/user_page_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PopupEditProfileChildrenViewModel extends ViewModelBase
{
  List<Children> listChildren;
  TextEditingController _nameEditingController = new TextEditingController();
  get nameEditingController => _nameEditingController;
  TextEditingController _ageEditingController = new TextEditingController();
  get ageEditingController => _ageEditingController;
  TextEditingController _schoolNameEditingController =
  new TextEditingController();
  get schoolNameEditingController => _schoolNameEditingController;

  String gender;
  String errorName;
  String _errorAge;
  get errorAge => _errorAge;
  String _errorSchoolName;
  get errorSchoolName => _errorSchoolName;

  UserPageViewModel userPageViewModel;
  PopupEditProfileChildrenViewModel() {
    createEvent();
    listChildren = Children.list;
    gender = GENDER_MALE;
  }
  createEvent(){
    _nameEditingController.addListener(
            () => { isValidName()});
    _ageEditingController.addListener(
            () => { isValidAge()});
    _schoolNameEditingController.addListener(() => {
      isValidSchoolName()
    });
  }
  bool isValidName() {
    errorName = null;
    var resultName = Validator.validateName(_nameEditingController.text);
    if (resultName != null) {
      errorName = resultName;
      this.updateState();
      return false;
    } else
      this.updateState();
    return true;
  }

  bool isValidAge() {
    _errorAge = null;
    var result = Validator.validateAge(_ageEditingController.text);
    if (result != null) {
      _errorAge = result;
      this.updateState();
      return false;
    } else
      this.updateState();
    return true;
  }

  bool isValidSchoolName() {
    _errorSchoolName = null;
    var result = Validator.validateSchoolName(_schoolNameEditingController.text);
    if (result != null) {
      _errorSchoolName = result;
      this.updateState();
      return false;
    } else
      this.updateState();
    return true;
  }

  @override
  void dispose() {
    super.dispose();
    _nameEditingController.dispose();
    _ageEditingController.dispose();
    _schoolNameEditingController.dispose();
  }
  bool isValidInfo() {
    if (isValidName() && isValidAge() && isValidSchoolName()) {
      this.updateState();
      return true;
    }
    return false;
  }


  updateListChildren(
      int id, String name, int age, String gender, String school) {
    var children = listChildren.singleWhere((item) => item.id == id);
    if (name != "") children.name = name;
    if (age != null) children.age = age;
    if (gender != "") children.gender = gender;
    if (school != "") children.schoolName = school;
    this.updateState();
  }

  addChildren(
      String name, int age, String gender, String school, String photo) {
    listChildren.add(new Children(
        id: listChildren.length + 1,
        name: name,
        photo: photo,
        gender: gender,
        age: age,
        primary: false,
        schoolName: school));
    this.updateState();
  }
  saveChildren(Children children) {
    print("aaaaaaaaaaa");
    //this.updateState();
    if(isValidInfo()) {
      int age = 0;
      if (children != null)
        age = children.age;

      if (children != null) {
        if (_nameEditingController.text != "")
          age = int.parse(_ageEditingController.text);
        updateListChildren(children.id, _nameEditingController.text, age, gender,
            _schoolNameEditingController.text);
        Navigator.of(context).pop();

        print("Tab popup OK" + listChildren[0].name);
      } else {
        addChildren(
            _nameEditingController.text,
            12,
            gender,
            _schoolNameEditingController.text,
            "http://getdrawings.com/free-icon/default-user-icon-59.png");

        Navigator.of(context).pop();

      }
        if (userPageViewModel != null)
          userPageViewModel.updateState();
    }
  }
  pickImage() {
    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      this.updateState();
    }
  }
}