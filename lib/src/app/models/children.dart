import 'dart:typed_data';

import 'package:b2s_parent/src/app/models/res-partner.dart';

class Children {
  int id;
  dynamic name;
  dynamic photo;
  dynamic location = 'HCM, VN.';
  dynamic gender;
  dynamic age;
  bool primary;
  dynamic schoolName;

  Children(
      {this.id,
      this.name,
      this.photo,
      this.gender,
      this.age,
      this.primary,
      this.schoolName});

  Children.fromResPartner(ResPartner children, {bool primary}) {
    id = children.id;
    name = children.name;
    photo = children.image;
    location = children.contactAddress;
    gender = children.title;
    this.primary = primary;
  }

  Children.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    name = json['name'];
    List photoUint8 = json['photo'];
    photoUint8 = photoUint8.cast<int>();
    photo = Uint8List.fromList(photoUint8);
    location = json['location'];
    gender = json['gender'];
    age = json['age'];
    primary = json['primary'];
    schoolName = json['schoolName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["name"] = this.name;
    data["photo"] = this.photo;
    data["location"] = this.location;
    data["gender"] = this.gender;
    data["age"] = this.age;
    data["primary"] = this.primary;
    data["schoolName"] = this.schoolName;
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
        schoolName: "VStar school"),
    Children(
        id: 2,
        name: 'Girl B',
        photo:
            "https://shalimarbphotography.com/wp-content/uploads/2018/06/SBP-0800.jpg",
        gender: 'F',
        age: 10,
        primary: false,
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

  static Children getChildrenPrimary(List<Children> list) {
    return list.singleWhere((child) => child.primary == true);
  }

  static List<Children> getChildrenNotPrimary(List<Children> list) {
    return list.where((child) => child.primary == false).toList();
  }
}
