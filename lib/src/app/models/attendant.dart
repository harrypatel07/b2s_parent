import 'package:b2s_parent/src/app/models/res-partner.dart';

class Attendant {
  int id;
  dynamic name;
  dynamic photo;
  dynamic gender;
  dynamic genderId;
  dynamic phone;
  dynamic email;
  Attendant(
      {this.id, this.name, this.photo, this.gender, this.phone, this.email});

  Attendant.fromJsonController(Map<dynamic, dynamic> _attendant) {
    if(!(_attendant["id"] is bool)) this.id = _attendant["id"];
    this.name = _attendant["name"];
    this.phone = _attendant["phone"];
    this.email = _attendant["email"];
    this.photo = _attendant["image"];
    this.genderId = _attendant["title"]["id"];
    this.gender = _attendant["title"]["name"];
  }
  Attendant.fromResPartner(ResPartner resPartner) {
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

  Attendant.fromJson(Map<dynamic, dynamic> json) {
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
}
