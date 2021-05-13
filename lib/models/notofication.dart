class NotificationInfo {
  int id;
  String wakeUpTime;
  String sleepTime;
  String notificationLoop;
  String createdDate;

  //Constructor
  NotificationInfo(
    this.wakeUpTime,
    this.sleepTime,
    this.notificationLoop,
    this.createdDate,
  );

  Map<String, dynamic> toMap() {
    //geçici Map nesnesi
    var map = Map<String, dynamic>();

    map["id"] = id;
    map["wakeUpTime"] = wakeUpTime;
    map["sleepTime"] = sleepTime;
    map["createdDate"] = createdDate;
    map["notificationLoop"] = notificationLoop;
    return map;
  }

  NotificationInfo.fromMap(Map<String, dynamic> map) {
    this.id = map["id"];
    this.wakeUpTime = map["wakeUpTime"];
    this.sleepTime = map["sleepTime"];
    this.createdDate = map["createdDate"];
    this.notificationLoop = map["notificationLoop"];
  }
}
