class Parent {
  int id;
  String name;
  String photo;
  String gender;
  String phone;

  Parent(this.id, this.name, this.photo, this.gender, this.phone);

  Parent.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    name = json['name'];
    photo = json['photo'];
    gender = json['gender'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["name"] = this.name;
    data["photo"] = this.photo;
    data["gender"] = this.gender;
    data["phone"] = this.phone;
    return data;
  }

  static final info = [
    Parent(
        1,
        'Driver 1',
        "https://shalimarbphotography.com/wp-content/uploads/2018/06/SBP-2539.jpg",
        'F',
        "0907488458"),
  ];
}
