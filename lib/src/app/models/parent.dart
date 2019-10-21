import 'dart:convert';
import 'dart:typed_data';

import 'package:b2s_parent/src/app/core/app_setting.dart';
import 'package:b2s_parent/src/app/models/children.dart';
import 'package:b2s_parent/src/app/models/res-partner.dart';

class Parent {
  int id;
  dynamic name;
  dynamic photo;
  dynamic email;
  dynamic phone;
  dynamic gender;
  dynamic contactAddress;
  List<Children> listChildren;
  static dynamic aliasName = "Parent";
  static final Parent _singleton = new Parent._internal();

  factory Parent() {
    return _singleton;
  }

  Parent._internal();

  Parent.newInstance(
      {this.id,
      this.name,
      this.photo,
      this.email,
      this.phone,
      this.gender,
      this.contactAddress}) {
    id = id;
    name = name;
    photo = photo;
    email = email;
    phone = phone;
    gender = gender;
    contactAddress = contactAddress;
  }

  fromResPartner(ResPartner parent, List<ResPartner> child) {
    id = parent.id;
    name = parent.name;
    photo = parent.image;
    email = parent.email;
    phone = parent.phone;
    gender = parent.title;
    contactAddress = parent.contactAddress;
    int index = 0;
    listChildren = child.map((item) {
      bool primary = false;
      if (index == 0) primary = true;
      index++;
      return Children.fromResPartner(item, primary: primary);
    }).toList();
  }

  fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    name = json['name'];
    List photoUint8 = json['photo'];
    photoUint8 = photoUint8.cast<int>();
    photo = Uint8List.fromList(photoUint8);
    email = json['email'];
    phone = json['phone'];
    gender = json['gender'];
    contactAddress = json['contactAddress'];
    List list = json['listChildren'];
    listChildren = list.map((item) => Children.fromJson(item)).toList();
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['photo'] = this.photo;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['gender'] = this.gender;
    data['contactAddress'] = this.contactAddress;
    data['listChildren'] =
        this.listChildren.map((item) => item.toJson()).toList();
    return data;
  }

  Future<dynamic> saveLocal() async {
    return localStorage.setItem(Parent.aliasName, json.encode(this));
  }

  Future<Parent> reloadData() async {
    bool ready = await localStorage.ready;
    if (ready) {
      if (localStorage.getItem(Parent.aliasName) != null) {
        print(jsonDecode(localStorage.getItem(Parent.aliasName)));
        this.fromJson(jsonDecode(localStorage.getItem(Parent.aliasName)));

        return this;
      }
    }
    return this;
  }

  Future<bool> checkParentExist() async {
    await reloadData();
    if (id != null) return true;
    return false;
  }

  static List<Parent> info = [
    Parent.newInstance(
        id: 1,
        name: 'Phu huynh',
        gender: "M",
        phone: "0907488458",
        photo:
            "https://health.uottawa.ca/sites/health.uottawa.ca/files/mparent.jpg")
  ];
}
