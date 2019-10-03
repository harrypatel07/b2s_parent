class Driver {
  final int id;
  final String name;
  final String photo;
  final String gender;
  final String phone;

  Driver(this.id, this.name, this.photo, this.gender, this.phone);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["name"] = this.name;
    data["photo"] = this.photo;
    data["gender"] = this.gender;
    data["phone"] = this.phone;
    return data;
  }

  static final List<Driver> list = [
    Driver(
        1,
        'Driver 1',
        "https://shalimarbphotography.com/wp-content/uploads/2018/06/SBP-2539.jpg",
        'F',
        "0907488458"),
    Driver(
        2,
        'Driver 2',
        "https://shalimarbphotography.com/wp-content/uploads/2018/06/SBP-0800.jpg",
        'F',
        "0905123456"),
  ];
}
