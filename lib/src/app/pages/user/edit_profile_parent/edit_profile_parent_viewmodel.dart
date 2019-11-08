import 'dart:io';
import 'dart:typed_data';

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
  TextEditingController _nameEditingController = new TextEditingController();
  TextEditingController get nameEditingController => _nameEditingController;
  TextEditingController _emailEditingController = new TextEditingController();
  TextEditingController get emailEditingController => _emailEditingController;
  TextEditingController _phoneEditingController = new TextEditingController();
  TextEditingController get phoneEditingController => _phoneEditingController;
  TextEditingController _addressEditingController = new TextEditingController();
  TextEditingController get addressEditingController =>
      _addressEditingController;
  TextEditingController _genderEditingController = new TextEditingController();
  TextEditingController get genderEditingController => _genderEditingController;
  List<ItemDropDownField> listGender = List();
  Uint8List imagePicker;
  String errorName;
  String _errorEmail;
  ItemDropDownField gender;
  get errorEmail => _errorEmail;
  String _errorPhone;
  get errorPhone => _errorPhone;
  String _errorAddress;
  get errorAdress => _errorAddress;
  File imageFile;
  dynamic pickImageError;
  String retrieveDataError;
  EditProfileParentViewModel() {
    createEvent();
    getListGender();
  }
  createEvent() {
    _nameEditingController.addListener(() => {isValidName()});
    _emailEditingController.addListener(() => {isValidEmail()});
    _phoneEditingController.addListener(() => {isValidPhone()});
    _addressEditingController.addListener(() => {isValidAddress()});
  }

  bool isValidEmail() {
    _errorEmail = null;
    var resultemail = Validator.validateEmail(_emailEditingController.text);
    if (resultemail != null) {
      _errorEmail = resultemail;
      this.updateState();
      return false;
    } else
      this.updateState();
    return true;
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

  bool isValidName() {
    errorName = null;
    var resultName = Validator.validateName(_nameEditingController.text);
    if (resultName != null) {
      errorName = resultName.toString();
      this.updateState();
      return false;
    } else
      this.updateState();
    return true;
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
    _phoneEditingController.dispose();
    _emailEditingController.dispose();
    _addressEditingController.dispose();
  }

  bool isValidInfo() {
    if (isValidName() && isValidPhone() && isValidEmail() && isValidAddress()) {
      this.updateState();
      return true;
    }
    return false;
  }

  updateParent(Parent parent) {
    if (parent.name != _nameEditingController.text)
      parent.name = _nameEditingController.text;
    if (parent.contactAddress != _addressEditingController.text)
      parent.contactAddress = _addressEditingController.text;
    if (parent.phone != _phoneEditingController.text)
      parent.phone = _phoneEditingController.text;
    if (parent.email != _emailEditingController.text)
      parent.email = _emailEditingController.text;
    if (gender != null) {
      parent.genderId = gender.id;
      parent.photo = imagePicker;
      parent.gender = gender.displayName;
    }
  }

  Future<bool> saveParent(Parent parent) async {
    print("save profile Parent");
    //this.updateState();
    if (isValidInfo()) {
      if (parent != null) {
        if (_nameEditingController.text != "") {
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
    _addressEditingController.text = result.address;
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
    api.getTitleCustomer().then((lst) {
      lst.forEach((item) {
        listGender
            .add(ItemDropDownField(id: item.id, displayName: item.displayName));
      });
      gender = getGenderFromID(parent.genderId);
      this.updateState();
    });
  }

  ItemDropDownField getGenderFromID(int id) {
    for (int i = 0; i < listGender.length; i++)
      if (listGender[i].id == id) return listGender[i];
    return listGender[0];
  }
}
