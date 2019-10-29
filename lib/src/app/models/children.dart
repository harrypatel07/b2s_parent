import 'dart:typed_data';

import 'package:b2s_parent/src/app/models/res-partner.dart';

class Children {
  int id;
  dynamic name;
  dynamic photo;
  dynamic location = 'HCM, VN.';
  dynamic gender;
  dynamic genderId;
  dynamic age;
  bool primary;
  dynamic schoolName;
  dynamic phone;
  dynamic email;
  dynamic parentId;
  dynamic paidTicket;
  dynamic lat;
  dynamic lng;
  Children(
      {this.id,
      this.name,
      this.photo,
      this.gender,
      this.age,
      this.primary,
      this.schoolName,
      this.phone,
      this.email,
      this.parentId,
      this.genderId,
      this.paidTicket,
      this.location,
      this.lat,
      this.lng});

  Children.fromResPartner(ResPartner resPartner, {bool primary}) {
    id = resPartner.id;
    name = resPartner.name;
    photo = resPartner.image;
    location = resPartner.contactAddress;
    if (resPartner.title is List) {
      gender = resPartner.title[1];
      genderId = resPartner.title[0];
    }
    email = resPartner.email;
    phone = resPartner.phone;
    schoolName = "";
    paidTicket = false;
    if (resPartner.parentId is List) parentId = resPartner.parentId[0];
    this.primary = primary;
  }

  Children.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['photo'] is List) {
      List photoUint8 = json['photo'];
      photoUint8 = photoUint8.cast<int>();
      photo = Uint8List.fromList(photoUint8);
    } else if (!(json['photo'] is bool)) photo = json['photo'];
    location = json['location'];
    gender = json['gender'];
    genderId = json['genderId'];
    age = json['age'];
    primary = json['primary'];
    schoolName = json['schoolName'];
    phone = json['phone'];
    email = json['email'];
    parentId = json['parentId'];
    paidTicket = json['paidTicket'];
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["name"] = this.name;
    data["photo"] = this.photo;
    data["location"] = this.location;
    data["gender"] = this.gender;
    data["genderId"] = this.genderId;
    data["age"] = this.age;
    data["primary"] = this.primary;
    data["schoolName"] = this.schoolName;
    data["phone"] = this.phone;
    data["email"] = this.email;
    data["parentId"] = this.parentId;
    data["paidTicket"] = this.paidTicket;
    data["lat"] = this.lat;
    data["lng"] = this.lng;
    return data;
  }

  static final List<Children> list = [
    Children(
        id: 1,
        name: 'Boy A',
        photo:
            "https://shalimarbphotography.com/wp-content/uploads/2018/06/SBP-2539.jpg",
        gender: 'F',
        age: 12,
        primary: true,
        paidTicket: true,
        schoolName: "VStar school"),
    Children(
        id: 2,
        name: 'Girl B',
        photo:
            "https://shalimarbphotography.com/wp-content/uploads/2018/06/SBP-0800.jpg",
        gender: 'F',
        age: 10,
        primary: false,
        paidTicket: true,
        schoolName: "VStar school"),
  ];

  static List<Children> setChildrenPrimary(
      List<Children> list, int childrenID) {
    for (var item in list) {
      if (item.id == childrenID)
        item.primary = true;
      else
        item.primary = false;
    }
    return list;
  }

  static List<Children> getListChildrenPaidTicket(List<Children> list) {
    return list.where((child) => child.paidTicket == true).toList();
  }

  static Children getChildrenPrimary(List<Children> list) {
    return list.firstWhere((child) => child.primary == true,
        orElse: () => null);
  }

  static List<Children> getChildrenNotPrimary(List<Children> list) {
    return list.where((child) => child.primary == false).toList();
  }
}
