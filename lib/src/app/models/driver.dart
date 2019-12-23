import 'package:b2s_parent/src/app/models/res-partner.dart';

class Driver {
  int id;
  dynamic name;
  dynamic photo;
  dynamic gender;
  dynamic genderId;
  dynamic phone;
  dynamic email;
  Driver({this.id, this.name, this.photo, this.gender, this.phone, this.email});

  Driver.fromJsonController(Map<dynamic, dynamic> _driver) {
    this.id = _driver["id"];
    this.name = (_driver["name"] is bool) ? "" : _driver["name"];
    this.phone = (_driver["phone"] is bool) ? "" : _driver["phone"];
    this.email = (_driver["email"] is bool) ? "" : _driver["email"];
    this.photo = (_driver["photo"] is bool) ? "" : _driver["photo"];
  }
  Driver.fromResPartner(ResPartner resPartner) {
    id = resPartner.id;
    name = resPartner.name;
    photo = resPartner.image;
    if (resPartner.title is List) {
      gender = resPartner.title[1];
      genderId = resPartner.title[0];
    }
    phone = resPartner.phone;
    email = resPartner.email;
  }

  Driver.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    name = json['name'];
    photo = json['photo'];
    gender = json['gender'];
    genderId = json['genderId'];
    phone = json['phone'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["name"] = this.name;
    data["photo"] = this.photo;
    data["gender"] = this.gender;
    data["genderId"] = this.genderId;
    data["phone"] = this.phone;
    data["email"] = this.email;
    return data;
  }

  static final List<Driver> list = [
    Driver(
        id: 1,
        name: 'Driver 1',
        photo:
            "https://shalimarbphotography.com/wp-content/uploads/2018/06/SBP-2539.jpg",
        gender: 'F',
        phone: "0907488458"),
    Driver(
        id: 2,
        name: 'Driver 2',
        photo:
            "https://shalimarbphotography.com/wp-content/uploads/2018/06/SBP-0800.jpg",
        gender: 'F',
        phone: "0905123456"),
  ];
}
