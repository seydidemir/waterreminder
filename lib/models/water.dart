class WatersAmount {
  int id;
  double amount;
  String createdDate;

  //Constructor
  WatersAmount(this.amount, this.createdDate);
  // Silme ve güncelleme gibi işlemler için ise id'li  constructor
  WatersAmount.withId(this.id, this.amount, this.createdDate);

  Map<String, dynamic> toMap() {
    //geçici Map nesnesi
    var map = Map<String, dynamic>();

    map["id"] = id;
    map["amount"] = amount;
    map["createdDate"] = createdDate;
    return map;
  }

  WatersAmount.fromMap(Map<String, dynamic> map) {
    this.id = map["id"];
    this.amount = double.parse(map["amount"]);
    this.createdDate = map["createdDate"];
  }
}
