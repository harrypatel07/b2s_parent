import 'dart:io';
import 'dart:typed_data';
import 'package:b2s_parent/src/app/app_localizations.dart';
import 'package:b2s_parent/src/app/core/app_setting.dart';
import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/helper/index.dart';
import 'package:b2s_parent/src/app/helper/utils.dart';
import 'package:b2s_parent/src/app/models/children.dart';
import 'package:b2s_parent/src/app/models/parent.dart';
import 'package:b2s_parent/src/app/models/res-partner.dart';
import 'package:b2s_parent/src/app/service/common-service.dart';
import 'package:b2s_parent/src/app/widgets/drop_down_field.dart';
import 'package:b2s_parent/src/app/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EditProfileChildrenViewModel extends ViewModelBase {
  List<ItemDropDownField> listGender = List();
  List<ItemDropDownField> listSchool = List();
  Parent parent;
  int childId;
  Children children;
  Uint8List imageDefault;
  bool loadingGender = true;
  bool loadingSchool = true;
  TextEditingController _emailEditingController = new TextEditingController();

  TextEditingController get emailEditingController => _emailEditingController;
  TextEditingController _nameEditingController = new TextEditingController();
  TextEditingController get nameEditingController => _nameEditingController;
  TextEditingController _ageEditingController = new TextEditingController();
  TextEditingController get ageEditingController => _ageEditingController;
  TextEditingController _schoolNameEditingController =
      new TextEditingController();
  TextEditingController get schoolNameEditingController =>
      _schoolNameEditingController;
  TextEditingController _classesEditingController = new TextEditingController();
  TextEditingController get classesEditingController =>
      _classesEditingController;
  TextEditingController _birthDayEditingController =
      new TextEditingController();
  TextEditingController get birthDayEditingController =>
      _birthDayEditingController;
  TextEditingController _addressEditingController = new TextEditingController();
  TextEditingController get addressEditingController =>
      _addressEditingController;
  TextEditingController _genderEditingController = new TextEditingController();
  TextEditingController get genderEditingController => _genderEditingController;
  TextEditingController _phoneEditingController = new TextEditingController();
  TextEditingController get phoneEditingController => _phoneEditingController;

  ItemDropDownField gender;
  ItemDropDownField school;
  String classes;

  String _errorGender;
  get errorGender => _errorGender;
  String _errorPhone;
  get errorPhone => _errorPhone;
  String _errorEmail;
  get errorEmail => _errorEmail;
  String errorName;
  String _errorAge;
  get errorAge => _errorAge;
  String _errorSchoolName;
  get errorSchoolName => _errorSchoolName;
  String _errorAddress;
  get errorAddress => _errorAddress;
  File imageFile;
  Uint8List imagePicker;
  dynamic pickImageError;
  String retrieveDataError;
  LocationResult locationResult;
  String errorBirthDay;
  DateTime birthDay;
  ScrollController scrollController = new ScrollController();
  final FocusNode nameFocus = FocusNode();
  final FocusNode schoolFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();
  final FocusNode classFocus = FocusNode();
  final FocusNode mailFocus = FocusNode();
  final FocusNode addressFocus = FocusNode();
  fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  EditProfileChildrenViewModel() {
    createEvent();
//    rootBundle.load('assets/images/user.png').then((bytes) {
//      imageDefault = bytes.buffer.asUint8List();
//    });
  }
  createEvent() {
    _nameEditingController.addListener(() => {isValidName()});
    _emailEditingController.addListener(() => {isValidEmail()});
    _ageEditingController.addListener(() => {isValidAge()});
//    _schoolNameEditingController
//        .addListener(() => {checkValidSchoolNameInit()});
    _addressEditingController.addListener(() => {isValidAddress()});
    _birthDayEditingController.addListener(() => {isValidBirthDay()});
//    _phoneEditingController.addListener(() => {isValidPhone()});
//    _genderEditingController.addListener(() => {isValidGender()});
  }

  initData() {
    getListGender();
//    getListSchool();
    // if (viewModel.children != null)
    //   viewModel.imagePicker = viewModel.children.photo;
    if (this.childId != -1)
      children =
          parent.listChildren.singleWhere((child) => child.id == this.childId);
    if (children != null) {
      _nameEditingController.text = children.name;
      _ageEditingController.text =
          (children.age is bool || children.age == null)
              ? ''
              : children.age.toString();
      _schoolNameEditingController.text =
          (children.schoolName is bool || children.schoolName == null)
              ? ''
              : children.schoolName.toString();
      _addressEditingController.text =
          (children.location is bool || children.location == null)
              ? ''
              : children.location.toString();
      _genderEditingController.text =
          (children.gender is bool || children.gender == null)
              ? ''
              : children.gender.toString();
//      _emailEditingController.text = children.email ?? parent.email;
      _classesEditingController.text =
          (children.classes is bool || children.classes == null)
              ? ''
              : children.classes.toString();
      _phoneEditingController.text =
          (children.phone is bool || children.phone == null)
              ? ''
              : children.phone.toString();
      _birthDayEditingController.text =
          (children.birthday is bool || children.birthday == null)
              ? ''
              : DateFormat('dd/MM/yyyy')
                  .format(DateTime.parse(children.birthday.toString()));
    }
  }

  bool isValidPhone() {
    _errorPhone = null;
    var resultPhone = Validator.validatePhone(_phoneEditingController.text);
    if (resultPhone != null) {
      _errorPhone = resultPhone;
      this.updateState();
      return false;
    } else
      this.updateState();
    return true;
  }

  bool isValidEmail() {
    _errorEmail = null;
    var resultEmail = Validator.validateEmail(_emailEditingController.text);
    if (resultEmail != null) {
      _errorEmail = resultEmail;
      this.updateState();
      return false;
    } else
      this.updateState();
    return true;
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

  bool isValidBirthDay() {
    errorBirthDay = null;
    var result = Validator.validateBirthDay(_birthDayEditingController.text);
    if (result != null) {
      errorBirthDay = result;
      this.updateState();
      return false;
    } else
      this.updateState();
    return true;
  }

//  bool isValidGender() {
//    _errorGender = null;
//    var result = Validator.validateGender(_genderEditingController.text);
//    if (result != null) {
//      _errorGender = result;
//      this.updateState();
//      return false;
//    } else
//      this.updateState();
//    return true;
//  }
  bool isValidGender() {
    _errorGender = null;
    if (gender != null && gender.id != -1) {
      this.updateState();
      return true;
    } else {
      _errorGender = translation.text("COMMON.GENDER_INVALID");
      this.updateState();
      return false;
    }
  }

//  bool checkValidSchoolNameInit() {
//    _errorSchoolName = null;
//    if (_schoolNameEditingController.text.length < 1)
//      return true;
//    else
//      return isValidSchoolName();
//  }

  bool isValidSchoolName() {
    _errorSchoolName = null;
//    if(_schoolNameEditingController.text == '')
//      return true;
    List<ItemDropDownField> listSearch = listSchool
        .where((item) =>
            Common.sanitizing(
                _schoolNameEditingController.text.toLowerCase()) ==
            Common.sanitizing(item.displayName.toLowerCase()))
        .toList();
    if (listSearch.length <= 0) {
      _errorSchoolName = translation.text("COMMON.SCHOOL_INVALID");
      this.updateState();
      return false;
    } else {
      _errorSchoolName = null;
//    var result =
//        Validator.validateSchoolName(_schoolNameEditingController.text);
//    if (result != null) {
//      _errorSchoolName = result;
      this.updateState();
      return true;
    }
  }

  bool isValidAddress() {
    _errorAddress = null;
    var result = Validator.validAddress(_addressEditingController.text);
    if (result != null) {
      _errorAddress = result;
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
    _addressEditingController.dispose();
  }

  bool isValidInfo() {
    if (isValidName() &&
        isValidBirthDay() &&
        isValidGender()
        /*&& isValidSchoolName() && isValidGender() && isValidPhone()  && isValidEmail() */ &&
        isValidAddress()) {
      this.updateState();
      return true;
    }
    return false;
  }

  // Children updateListChildren(
  //     {int id,
  //     String name,
  //     int age,
  //     String email,
  //     String phone,
  //     String classes,
  //     int genderId,
  //     int schoolId,
  //     String address}) {
  //   var children = listChildren.singleWhere((item) => item.id == id);
  //   if (name != "") children.name = name;
  //   if (age != null) children.age = age;
  //   if (genderId != null) children.genderId = genderId;
  //   if (schoolId != null) children.schoolId = schoolId;
  //   if (address != "") children.location = address;
  //   if (email != "") children.email = email;
  //   if (phone != "") children.phone = phone;
  //   if (classes != "") children.classes = classes;
  //   children.parentId = parent.id;
  //   // if (imagePicker != null) children.photo = imagePicker;
  //   if (locationResult != null) {
  //     children.lat = locationResult.latLng.latitude;
  //     children.lng = locationResult.latLng.longitude;
  //   }
  //   return children;
  // }

  addChildren(Children children) {
    parent.listChildren.add(children);
  }

  Future<int> insertChildrenSever(Children children) async {
    ResPartner resPartner = ResPartner.fromChildren(children);
    var result = await api.insertCustomer(resPartner);
    if (result != null) {
      api.getParentInfo(parent.id);
      // children.gender = gender.displayName;
      // children.schoolName = school.displayName;
    }
    return result;
  }

  Future<bool> updateChildrenSever(Children children) async {
    ResPartner resPartner = ResPartner.fromChildren(children);
    bool result = await api.updateCustomer(resPartner);
    if (result) {
      api.getParentInfo(parent.id);
      // children.gender = gender.displayName;
      // children.schoolName = school.displayName;
      return true;
    }
    return false;
  }

  /// return 1 success
  /// return -1 fail
  /// return 0 input invalid
  Future<int> saveChildren() async {
    if (isValidInfo()) {
      if (children != null) {
        if (_nameEditingController.text != "") {
          // var child = updateListChildren(
          //     id: children.id,
          //     name: _nameEditingController.text,
          //     age: 12,
          //     classes: _classesEditingController.text,
          //     email: _emailEditingController.text,
          //     phone: _phoneEditingController.text,
          //     genderId: gender.id,
          //     schoolId: school.id,
          //     address: _addressEditingController.text);
          children.parentId = parent.id;
          children.name = _nameEditingController.text;
          children.classes = _classesEditingController.text;
          children.email = parent.email;
          children.phone = _phoneEditingController.text;
          //DateTime dateTime = DateTime.parse('9/9/1999');
          if (birthDay != null)
            children.birthday = DateFormat('yyyy-MM-dd').format(birthDay);
          if (gender != null) {
            children.genderId = gender.id;
            children.gender = gender.displayName;
          }
          if (school != null) {
            children.schoolId = school.id;
            children.schoolName = school.displayName;
          }
          children.location = _addressEditingController.text;
          if (locationResult != null) {
            children.lat = locationResult.latLng.latitude;
            children.lng = locationResult.latLng.longitude;
            // update list children
//            var _childrenUpdate =
//                parent.listChildren.singleWhere((item) => item.id == this.children.id);
//            if (_childrenUpdate != null) _childrenUpdate = this.children;

//            print(_childrenUpdate.photo);
          }
          if (imagePicker != null) children.photo = imagePicker;
          bool result = await updateChildrenSever(children);
          if (result) {
            children.photo =
                "$domainApi/web/image?model=res.partner&field=image&id=${children.id}&${api.sessionId}";
            return 1;
          } else
            return -1;
        }
      } else {
        children = Children(
            parentId: parent.id,
            name: _nameEditingController.text,
            schoolId: school.id,
            email: parent.email,
            phone: _phoneEditingController.text,
            classes: _classesEditingController.text,
            photo: imagePicker,
            location: _addressEditingController.text,
            birthday: DateFormat('yyyy-MM-dd').format(birthDay));
        if (gender.id != null) children.genderId = gender.id;
        if (school.id != null) children.schoolId = school.id;
        if (locationResult != null) {
          children.lat = locationResult.latLng.latitude;
          children.lng = locationResult.latLng.longitude;
        }
        int result = await insertChildrenSever(children);
        if (result != null) {
          children.id = result;
          // if (children.photo == null) children.photo = imageDefault;
          children.photo =
              "$domainApi/web/image?model=res.partner&field=image&id=${children.id}&${api.sessionId}";
          parent.listChildren.add(children);
          return 1;
        }
        return -1;
      }
    }
    return 0;
  }

  Future onTapSave() async {
    LoadingDialog.showLoadingDialog(
        context, translation.text("COMMON.IN_PROCESS"));
    this.saveChildren().then((v) {
      if (v == 1) {
        LoadingDialog.hideLoadingDialog(context);
        Navigator.pop(context, parent.listChildren);
      } else if (v == -1) {
        LoadingDialog.hideLoadingDialog(context);
        Navigator.pop(context, parent.listChildren);
      } else {
        LoadingDialog.hideLoadingDialog(context);
      }
    });
  }

  onTapPickMaps() async {
    locationResult = await LocationPicker.pickLocation(
      context,
      ggKey,
      initialCenter: LatLng(10.777127, 106.6753133),
      requiredGPS: false,
    );
    print("result = $locationResult");
    if (locationResult != null)
      _addressEditingController.text = locationResult.address;
    this.updateState();
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await ImagePicker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file == null) {
      imageFile = response.file;
      this.updateState();
    }
  }

  void onImageButtonPressed(ImageSource source) {
    try {
      ImagePicker.pickImage(source: source).then((value) {
        imageFile = value;
        readFileByte(value.path).then((bytesData) {
          imagePicker = bytesData;
          this.updateState();
        });
      });
    } catch (e) {
      pickImageError = e;
    }
  }

  onSelectedSchoolItem(String strSchool) {
    school = listSchool.firstWhere((s) => s.displayName == strSchool);
//    schoolNameEditingController.text = strSchool;
    this.updateState();
  }

  List<String> sortListSchoolShow(List<String> list) {
    if ((school != null || school.displayName != "") &&
        _schoolNameEditingController.text == '') {
      list.remove(school.displayName);
      list.insert(0, school.displayName);
    }
    return list;
  }

  getListGender() {
    loadingGender = true;
    this.updateState();
    api.getTitleCustomer().then((lst) {
      lst.forEach((item) {
        listGender
            .add(ItemDropDownField(id: item.id, displayName: item.displayName));
      });
      listGender.insert(
          0,
          ItemDropDownField(
              id: -1,
              displayName: translation.text("USER_PAGE.SELECT_GENDER")));
      if (children.genderId != null)
        gender = getGenderFromID(children.genderId);
      else
        gender = listGender[0];
      loadingGender = false;
      this.updateState();
    });
  }

  getListSchool() async {
    loadingSchool = true;
    this.updateState();
    api.getListSchool().then((lst) {
      lst.forEach((item) {
        listSchool
            .add(ItemDropDownField(id: item.id, displayName: item.displayName));
      });
      if (children != null)
        school = getSchoolFromID(children.schoolId);
      else {
        school = ItemDropDownField(id: 1, displayName: '');
        _schoolNameEditingController.text = '';
//          school = listSchool[0];
//          _schoolNameEditingController.text = school.displayName;
      }
      loadingSchool = false;
//      checkValidSchoolNameInit();
      this.updateState();
    });
  }

  ItemDropDownField getGenderFromID(int id) {
    try {
      for (int i = 0; i < listGender.length; i++)
        if (listGender[i].id == id) return listGender[i];
      return listGender[0];
    } catch (e) {
      return null;
    }
  }

  ItemDropDownField getSchoolFromID(int id) {
    try {
      for (int i = 0; i < listSchool.length; i++)
        if (listSchool[i].id == id) return listSchool[i];
      return listSchool[0];
    } catch (e) {
      return null;
    }
  }

  Future pickBirthDay() async {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(1950, 1, 1),
        maxTime: DateTime.now(),
        theme: DatePickerTheme(
            backgroundColor: Colors.grey[200],
            itemStyle: TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
              // shadows: [
              //   Shadow(
              //     blurRadius: 1.0,
              //     color: Colors.black12,
              //     offset: Offset(1.0, 1.0),
              //   ),
              // ],
            ),
            doneStyle: TextStyle(
                color: Colors.orange,
                fontSize: 16,
                fontWeight: FontWeight.bold)), onChanged: (date) {
      print('change $date in time zone ' +
          date.timeZoneOffset.inHours.toString());
    }, onConfirm: (date) {
      birthDay = date;
      _birthDayEditingController.text =
          DateFormat('dd/MM/yyyy').format(birthDay);
//      this.updateState();
    }, currentTime: DateTime.now(), locale: LocaleType.vi);
  }
}
