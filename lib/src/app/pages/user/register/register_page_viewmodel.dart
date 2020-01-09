import 'dart:io';
import 'dart:typed_data';

import 'package:b2s_parent/src/app/app_localizations.dart';
import 'package:b2s_parent/src/app/core/app_setting.dart';
import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/helper/utils.dart';
import 'package:b2s_parent/src/app/helper/validator-helper.dart';
import 'package:b2s_parent/src/app/models/parent.dart';
import 'package:b2s_parent/src/app/models/res-partner.dart';
import 'package:b2s_parent/src/app/service/inAppBrowser-service.dart';
import 'package:b2s_parent/src/app/widgets/drop_down_field.dart';
import 'package:b2s_parent/src/app/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';

class RegisterPageViewModel extends ViewModelBase {
  TextEditingController nameEditingController = new TextEditingController();
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passEditingController = new TextEditingController();
  TextEditingController passConfirmEditingController =
      new TextEditingController();
  TextEditingController phoneEditingController = new TextEditingController();
  TextEditingController addressEditingController = new TextEditingController();
  TextEditingController genderEditingController = new TextEditingController();
  List<ItemDropDownField> listGender = List();
  Uint8List imagePicker;
  String errorName;
  String errorEmail;
  String errorPass;
  String errorPassConfirm;
  ItemDropDownField gender;
  String errorPhone;
  String errorAddress;
  File imageFile;
  dynamic pickImageError;
  String retrieveDataError;
  bool loadingGender = true;
  bool checkPolicy = false;
  bool isSend = false;
  ScrollController scrollController = ScrollController();
  final FocusNode nameFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();
  final FocusNode passFocus = FocusNode();
  final FocusNode passConfirmFocus = FocusNode();
  final FocusNode mailFocus = FocusNode();
  final FocusNode addressFocus = FocusNode();

  InAppBrowserService browser = InAppBrowserService();
  fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  RegisterPageViewModel() {
    createEvent();
    getListGender();
  }
  createEvent() {
    nameEditingController.addListener(() => {isValidName()});
    emailEditingController.addListener(() => {isValidEmail()});
    passEditingController.addListener(() => {isValidPass()});
    passConfirmEditingController.addListener(() => {isValidPassConfirm()});
    phoneEditingController.addListener(() => {isValidPhone()});
//    addressEditingController.addListener(() => {isValidAddress()});
  }

  bool isValidEmail() {
    errorEmail = null;
    var resultEmail = Validator.validateEmail(emailEditingController.text);
    if (resultEmail != null) {
      errorEmail = resultEmail;
      this.updateState();
      return false;
    } else
      this.updateState();
    return true;
  }

  bool isValidPass() {
    errorPass = null;
    var resultPass = Validator.validatePassword(passEditingController.text);
    if (resultPass != null) {
      errorPass = resultPass;
      this.updateState();
      return false;
    } else
      this.updateState();
    return true;
  }

  bool isValidPassConfirm() {
    errorPassConfirm = null;
    if (passEditingController.text != passConfirmEditingController.text) {
      errorPassConfirm = translation.text("COMMON.PASS_NOT_TRUE");
      this.updateState();
      return false;
    } else
      this.updateState();
    return true;
  }

  bool isValidPhone() {
    errorPhone = null;
    var resultPhone = Validator.validatePhone(phoneEditingController.text);
    if (resultPhone != null) {
      errorPhone = resultPhone;
      this.updateState();
      return false;
    } else
      this.updateState();
    return true;
  }

  bool isValidName() {
    errorName = null;
    var resultName = Validator.validateName(nameEditingController.text);
    if (resultName != null) {
      errorName = resultName.toString();
      this.updateState();
      return false;
    } else
      this.updateState();
    return true;
  }

  bool isValidAddress() {
    errorAddress = null;
    var result = Validator.validAddress(addressEditingController.text);
    if (result != null) {
      errorAddress = result;
      this.updateState();
      return false;
    } else
      this.updateState();
    return true;
  }

  @override
  void dispose() {
    super.dispose();
    nameEditingController.dispose();
    phoneEditingController.dispose();
    passEditingController.dispose();
    passConfirmEditingController.dispose();
    emailEditingController.dispose();
    addressEditingController.dispose();
  }

  bool isValidInfo() {
    if (isValidEmail() &&
        isValidPass() &&
        isValidPassConfirm() &&
        isValidName() &&
        isValidPhone() &&
        checkPolicy /* && isValidAddress()*/) {
      this.updateState();
      return true;
    }
    return false;
  }

  updateParent(Parent parent) {
    if (parent.name != nameEditingController.text)
      parent.name = nameEditingController.text;
    if (parent.contactAddress != addressEditingController.text)
      parent.contactAddress = addressEditingController.text;
    if (parent.phone != phoneEditingController.text)
      parent.phone = phoneEditingController.text;
    if (parent.email != emailEditingController.text)
      parent.email = emailEditingController.text;
    if (gender != null) {
      parent.genderId = gender.id;
      parent.gender = gender.displayName;
    }
    if (imagePicker != null) parent.photo = imagePicker;
  }

//  Future<bool> saveParent() async {
//    print("save profile Parent");
  //this.updateState();
//    if (isValidInfo()) {
//      if (parent != null) {
//        if (_nameEditingController.text != "") {
//          Parent _parent = Parent();
//          updateParent(_parent);
//          bool result = await updateParentSever(_parent);
//          if (result) {
//            parent = _parent;
//            return true;
//          }
//        }
//      }
//    }
//    return false;
//  }

  Future<bool> updateParentSever(Parent parent) async {
    ResPartner resPartner = ResPartner.fromParent(parent);
    bool result = await api.updateCustomer(resPartner);
    if (result) {
      parent.photo =
          '$domainApi/web/image?model=res.partner&field=image&id=${parent.id}&${api.sessionId}';
      api.getParentInfo(parent.id);
      return true;
    }
    return false;
  }

  onTapPickMaps() async {
    LocationResult result = await LocationPicker.pickLocation(
      context,
      ggKey,
    );
    print("result = $result");
    addressEditingController.text = result.address;
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

  void onImageButtonPressed(ImageSource source) async {
    try {
      imageFile = await ImagePicker.pickImage(source: source);
      readFileByte(imageFile.path).then((bytesData) {
        imagePicker = bytesData;
        this.updateState();
      });
    } catch (e) {
      pickImageError = e;
    }
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
//      if (children.genderId != null)
//        gender = getGenderFromID(children.genderId);
//      else
      gender = listGender[0];
      loadingGender = false;
      this.updateState();
    });
  }

  ItemDropDownField getGenderFromID(int id) {
    for (int i = 0; i < listGender.length; i++)
      if (listGender[i].id == id) return listGender[i];
    return listGender[0];
  }

  onTapRegister() async {
    isSend = true;
    if (!isValidInfo()) return;
    LoadingDialog.showLoadingDialog(context, 'Đang xử lý...');
    bool result = await api.insertUserPortal(
        email: emailEditingController.text,
        password: passEditingController.text,
        name: nameEditingController.text,
        phone: phoneEditingController.text);
    if (result) {
      LoadingDialog.hideLoadingDialog(context);
      LoadingDialog.showLoadingDialog(context, "Đăng ký thành công.");
      Future.delayed(Duration(seconds: 2)).then((_) {
        LoadingDialog.hideLoadingDialog(context);
        Navigator.pop(context, emailEditingController.text);
      });
    } else
      Navigator.pop(context);
  }

  onChangeCheckPolicy(bool value) {
    checkPolicy = value;
    if (checkPolicy) isSend = false;
    this.updateState();
  }

  onTapPolicy() {
    browser.open(
      url: "http://www.bus2school.vn/contactus",
      options: InAppBrowserClassOptions(
        inAppWebViewWidgetOptions: InAppWebViewWidgetOptions(
          inAppWebViewOptions: InAppWebViewOptions(
            useShouldOverrideUrlLoading: true,
            useOnLoadResource: true,
          ),
        ),
      ),
    );
  }
}
