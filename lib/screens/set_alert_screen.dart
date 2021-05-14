import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:waterreminder/models/notofication.dart';
import 'package:waterreminder/utils/dbHelper.dart';

class SetAlertScreen extends StatefulWidget {
  @override
  _SetAlertScreenState createState() => _SetAlertScreenState();
}

class _SetAlertScreenState extends State<SetAlertScreen> {
  DatabaseHelper _databaseHelper = DatabaseHelper();
  // ignore: deprecated_member_use
  List<NotificationInfo> notificationInfo = new List<NotificationInfo>();

  TextEditingController wakeUp = TextEditingController();
  TextEditingController sleep = TextEditingController();
  TextEditingController notificationLoop = TextEditingController();
  bool _btnTimeEnabled = false;
  TimeOfDay _time = TimeOfDay(hour: 7, minute: 15);

  _selectWakeUpTime() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
        wakeUp.text = _time.format(context);
        isTimeEmpty();
      });
    }
  }

  _selectSleepTime() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
        sleep.text = _time.format(context);
        isTimeEmpty();
      });
    }
  }

  void saveTimeInfo() {
    if (wakeUp.text == "" || sleep.text == "" || notificationLoop.text == "") {
      Flushbar(
        title: "Error",
        message: "Please fill all area",
        duration: Duration(seconds: 3),
      )..show(context);
    } else {
      _addTimeInfo(
        NotificationInfo(wakeUp.text, sleep.text, notificationLoop.text,
            DateTime.now().toIso8601String()),
      );
    }
  }

  btnSaveClicked() {
    saveTimeInfo();

    Navigator.pop(context);
  }

  isTimeEmpty() {
    if (wakeUp.text == "" ||
        sleep.text == "" ||
        notificationLoop.text == "" ||
        notificationLoop.text == null) {
      _btnTimeEnabled = false;
    } else {
      setState(() {
        _btnTimeEnabled = true;
      });
    }
  }

  void _addTimeInfo(NotificationInfo notificationInfo) async {
    await _databaseHelper.insertNotification(notificationInfo);

    setState(() {});
  }

  void getNotificationData() {
    var notificationInfos = _databaseHelper.getNotificationData();
    notificationInfos.then((data) {
      this.notificationInfo = data;

      for (var daily in notificationInfo) {
        wakeUp.text = daily.wakeUpTime;
        sleep.text = daily.sleepTime;
        notificationLoop.text = daily.sleepTime;
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    getNotificationData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alert Informations'),
      ),
      body: Container(
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
                  _selectWakeUpTime();
                },
                onChanged: (val) {
                  setState(() {
                    isTimeEmpty();
                  });
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                showCursor: false,
                readOnly: true,
                onTap: () {
                  _selectSleepTime();
                },
                controller: sleep,
                decoration: InputDecoration(
                  labelText: 'Sleep time',
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) {
                  setState(() {
                    isTimeEmpty();
                  });
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                showCursor: false,
                readOnly: true,
                onTap: () {
                  _showPicker(context);
                },
                controller: notificationLoop,
                decoration: InputDecoration(
                  labelText: 'Notification Loop',
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
                  onPressed: _btnTimeEnabled == true ? btnSaveClicked : null,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue[800],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showPicker(BuildContext ctx) {
    final List<String> hours = <String>['30min', '1h', '2h', '3h', '4h'];
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Color(0xffffffff),
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xff999999),
                    width: 0.0,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CupertinoButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      setState(() {
                        notificationLoop.text = "";
                      });
                      isTimeEmpty();
                      Navigator.pop(context);
                    },
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 5.0,
                    ),
                  ),
                  CupertinoButton(
                    child: Text('OK'),
                    onPressed: () {
                      isTimeEmpty();

                      Navigator.pop(context);
                    },
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 5.0,
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 200.0,
              color: Color(0xfff7f7f7),
              child: CupertinoPicker(
                backgroundColor: Colors.white,
                itemExtent: 40,
                scrollController: FixedExtentScrollController(initialItem: 0),
                children: <Widget>[for (var i in hours) Text(i.toString())],
                onSelectedItemChanged: (int index) {
                  setState(() {
                    notificationLoop.text = hours[index];
                    isTimeEmpty();
                  });
                },
              ),
            )
          ],
        );
      },
    );
  }
}
