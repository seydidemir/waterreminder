import 'package:fbutton/fbutton.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterreminder/models/notofication.dart';
import 'package:waterreminder/models/user.dart';
import 'package:waterreminder/utils/dbHelper.dart';

class ProfilScreen extends StatefulWidget {
  @override
  _ProfilScreenState createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  DatabaseHelper _databaseHelper = DatabaseHelper();
  // ignore: deprecated_member_use
  List<User> allUserInfo = new List<User>();
  // ignore: deprecated_member_use
  List<NotificationInfo> notificationInfo = new List<NotificationInfo>();

  bool alertValue = false;

  bool _btnEnabled = false;

  String dailyAmount = "";
  TimeOfDay wakeUpTime;
  TimeOfDay sleepTime;
  TextEditingController weight = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController height = TextEditingController();
  TextEditingController wakeUp = TextEditingController();
  TextEditingController sleep = TextEditingController();

  TimeOfDay _time = TimeOfDay(hour: 7, minute: 15);

  void saveWaterAmount(var result) {
    _addUserInfo(
      User(weight.text, DateTime.now().toIso8601String(), result, height.text,
          age.text),
    );
  }

  void _addUserInfo(User user) async {
    await _databaseHelper.insertUser(user);

    setState(() {
      getUserInfo();
    });
  }

  void getUserInfo() {
    var userInfo = _databaseHelper.getUserInfo();
    userInfo.then((data) {
      this.allUserInfo = data;

      for (var daily in allUserInfo) {
        dailyAmount = daily.dailyAmount;
        weight.text = daily.userWeight;
        height.text = daily.height;
        age.text = daily.age;
      }
      setState(() {});
    });
  }

  void getNotificationData() {
    var notificationInfos = _databaseHelper.getNotificationData();
    notificationInfos.then((data) {
      this.notificationInfo = data;

      for (var daily in notificationInfo) {
        print(daily);
      }
      setState(() {});
    });
  }

  void saveTimeInfo() {
    _addTimeInfo(
      NotificationInfo(
          wakeUp.text, DateTime.now().toIso8601String(), sleep.text, "20"),
    );
  }

  void _addTimeInfo(NotificationInfo notificationInfo) async {
    await _databaseHelper.insertNotification(notificationInfo);

    setState(() {
      getUserInfo();
    });
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
    getNotificationData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Settings'),
        shadowColor: Colors.blue,
        backgroundColor: Colors.blue,
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Text(
          ' V1.0 WaterMe',
          style: TextStyle(
            fontSize: 11,
          ),
          textAlign: TextAlign.center,
        ),
        elevation: 0,
      ),
      body: Container(
          child: SettingsList(
        contentPadding: EdgeInsets.all(10),
        backgroundColor: Colors.white,
        sections: [
          SettingsSection(
            title: 'Settings',
            tiles: [
              SettingsTile(
                title: 'Daily Amount',
                subtitle: dailyAmount.isNotEmpty ? dailyAmount + "ml" : "",
                subtitleTextStyle: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
                leading: Icon(
                  FontAwesome.balance_scale,
                  color: Colors.amber,
                ),
                onPressed: (BuildContext context) {
                  getUserInfo();
                  dailyAmountCalculate();
                },
              ),
              SettingsTile(
                title: 'Alert',
                leading: Icon(
                  FontAwesome.bell,
                  color: Colors.blueGrey,
                ),
                onPressed: (BuildContext context) {
                  wakeAndSleeptime();
                },
              ),
              SettingsTile(
                title: 'RATE APP',
                leading: Icon(
                  FontAwesome.star,
                  color: Colors.yellow[700],
                ),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile(
                title: 'CONTACT US',
                leading: Icon(
                  FontAwesome.envelope,
                  color: Colors.green,
                ),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile(
                title: 'SHARE APP',
                leading: Icon(
                  FontAwesome.share_square,
                  color: Colors.blueAccent,
                ),
                onPressed: (BuildContext context) {},
              ),
            ],
          ),
        ],
      )),
    );
  }

  void dailyAmountCalculate() {
    void isEmpty() {
      print("object");
      if (weight.text == "" || height.text == "" || age.text == "") {
        _btnEnabled = false;
      } else {
        _btnEnabled = true;
      }
    }

    void saveData() {
      if (weight.text == "" || height.text == "" || age.text == "") {
        Flushbar(
          title: "Error",
          message: "Please fill all area",
          duration: Duration(seconds: 3),
        )..show(context);
      } else {
        String result = ((int.parse(weight.text) * 0.039) * 1000).toString();

        saveWaterAmount(result);

        FocusScope.of(context).unfocus();
      }
    }

    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, state) {
            return Container(
              decoration: new BoxDecoration(
                color: Colors.transparent,
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(10.0),
                  topRight: const Radius.circular(10.0),
                ),
              ),
              child: Container(
                padding: EdgeInsets.all(20),
                child: new Column(
                  children: <Widget>[
                    Text(
                      "Personal Information",
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: weight,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Weight(kg)',
                        border: OutlineInputBorder(),
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(3),
                      ],
                      onChanged: (val) {
                        setState(() {
                          isEmpty();
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: height,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'height(cm)',
                        border: OutlineInputBorder(),
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(3),
                      ],
                      onChanged: (val) {
                        setState(() {
                          isEmpty();
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: age,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Age',
                        border: OutlineInputBorder(),
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(3),
                      ],
                      onChanged: (val) {
                        setState(() {
                          isEmpty();
                        });
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        child: Text('Save'),
                        onPressed: _btnEnabled == true ? saveData : null,
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  Future<Null> _selectWakeUpTime(StateSetter updateState) async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (newTime != null) {
      updateState(() {
        _time = newTime;
        wakeUp.text = _time.format(context);
      });
    }
  }

  Future<Null> _selectSleepTime(StateSetter updateState) async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (newTime != null) {
      updateState(() {
        _time = newTime;
        sleep.text = _time.format(context);
      });
    }
  }

  void wakeAndSleeptime() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, state) {
            return Container(
              height: MediaQuery.of(context).size.height / 1.5,
              decoration: new BoxDecoration(
                color: Colors.transparent,
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(10.0),
                  topRight: const Radius.circular(10.0),
                ),
              ),
              child: Container(
                padding: EdgeInsets.all(20),
                child: new Column(
                  children: <Widget>[
                    Text(
                      "Alert Information",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: wakeUp,
                      decoration: InputDecoration(
                        labelText: 'Wake up Time',
                        border: OutlineInputBorder(),
                      ),
                      showCursor: false,
                      readOnly: true,
                      onTap: () {
                        _selectWakeUpTime(state);
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      showCursor: false,
                      readOnly: true,
                      onTap: () {
                        _selectSleepTime(state);
                      },
                      controller: sleep,
                      decoration: InputDecoration(
                        labelText: 'Sleep time',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        child: Text('Save'),
                        onPressed: () {
                          saveTimeInfo();

                          Navigator.pop(context);
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          });
        });
  }
}
