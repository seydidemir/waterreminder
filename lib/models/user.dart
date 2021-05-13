class User {
  int id;

  String userWeight;
  String createdDate;
  String dailyAmount;
  String height;
  String age;

  //Constructor
  User(this.userWeight, this.createdDate, this.dailyAmount, this.height,
      this.age);
  // Silme ve güncelleme gibi işlemler için ise id'li  constructor
  User.withId(this.id, this.userWeight, this.createdDate);

  Map<String, dynamic> toMap() {
    //geçici Map nesnesi
    var map = Map<String, dynamic>();

    map["id"] = id;
    map["userWeight"] = userWeight;
    map["dailyAmount"] = dailyAmount;
    map["createdDate"] = createdDate;
    map["height"] = height;
    map["age"] = age;
    return map;
  }

  User.fromMap(Map<String, dynamic> map) {
    this.id = map["id"];
    this.userWeight = map["userWeight"];
    this.createdDate = map["createdDate"];
    this.dailyAmount = map["dailyAmount"];
    this.height = map["height"];
    this.age = map["age"];
  }
}
