import 'dart:io';
import 'dart:typed_data';

import 'package:b2s_parent/src/app/app_localizations.dart';
import 'package:b2s_parent/src/app/core/app_setting.dart';
import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/helper/index.dart';
import 'package:b2s_parent/src/app/helper/utils.dart';
import 'package:b2s_parent/src/app/models/parent.dart';
import 'package:b2s_parent/src/app/models/res-partner.dart';
import 'package:b2s_parent/src/app/widgets/drop_down_field.dart';
import 'package:flutter/material.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileParentViewModel extends ViewModelBase {
  Parent parent;
  TextEditingController nameEditingController = new TextEditingController();
  TextEditingController phoneEditingController = new TextEditingController();
  TextEditingController addressEditingController = new TextEditingController();
  TextEditingController genderEditingController = new TextEditingController();
  List<ItemDropDownField> listGender = List();
  Uint8List imagePicker;
  String errorName;
  ItemDropDownField gender;
  String errorGender;
  String errorPhone;
  String errorAddress;
  File imageFile;
  dynamic pickImageError;
  String retrieveDataError;
  bool loadingGender = true;
  ScrollController scrollController = ScrollController();
  final FocusNode nameFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();
  final FocusNode mailFocus = FocusNode();
  final FocusNode addressFocus = FocusNode();
  fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  EditProfileParentViewModel() {
    createEvent();
    getListGender();
  }
  createEvent() {
    nameEditingController.addListener(() => {isValidName()});
    phoneEditingController.addListener(() => {isValidPhone()});
    addressEditingController.addListener(() => {isValidAddress()});
  }

  initData() {
    if (parent != null) {
      nameEditingController.text = parent.name;
      phoneEditingController.text =
          (parent.phone is bool || parent.phone == null)
              ? ''
              : parent.phone.toString();
      addressEditingController.text =
          (parent.contactAddress is bool || parent.contactAddress == null)
              ? ''
              : parent.contactAddress.toString();
      genderEditingController.text =
          (parent.gender is bool || parent.gender == null)
              ? ''
              : parent.gender.toString();
    }
  }
  bool isValidGender() {
    errorGender = null;
    if (gender != null && gender.id != -1) {
      this.updateState();
      return true;
    } else {
      errorGender = translation.text("COMMON.GENDER_REQUITE");
      this.updateState();
      return false;
    }
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
    addressEditingController.dispose();
  }

  bool isValidInfo() {
    if (isValidName() &&
        isValidGender() &&
        isValidPhone() /* && isValidEmail()*/ &&
        isValidAddress()) {
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
    if (gender != null) {
      parent.genderId = gender.id;
      parent.gender = gender.displayName;
    }
    if (imagePicker != null) parent.photo = imagePicker;
  }

  Future<bool> saveParent(Parent parent) async {
    print("save profile Parent");
    //this.updateState();
    if (isValidInfo()) {
      if (parent != null) {
        if (nameEditingController.text != "") {
          Parent _parent = Parent();
          updateParent(_parent);
          bool result = await updateParentSever(_parent);
          if (result) {
            parent = _parent;
            return true;
          }
        }
      }
    }
    return false;
  }

  Future<bool> updateParentSever(Parent parent) async {
    ResPartner resPartner = ResPartner.fromParent(parent);
    bool result = await api.updateCustomer(resPartner);
    if (result) {
      parent.photo =
          '$domainApi/web/image?model=res.partner&field=image&id=${parent.id}&${api.sessionId}';
      await api.getParentInfo(parent.id);
      api.getTicketOfListChildren();
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
      if (parent.genderId != null)
        gender = getGenderFromID(parent.genderId);
      else
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
}
