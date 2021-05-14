import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waterreminder/models/user.dart';
import 'package:waterreminder/models/water.dart';
import 'package:waterreminder/utils/dbHelper.dart';
import 'package:wave_progress_widget/wave_progress.dart';

class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DatabaseHelper _databaseHelper = DatabaseHelper();
  // ignore: deprecated_member_use
  List<WatersAmount> allWaterHistory = new List<WatersAmount>();
  // ignore: deprecated_member_use
  List<User> allUserInfo = new List<User>();

  String dailyAmount = "";

  double groupValue = 20.0;
  double _progress = 0.0;
  double _todayScore = 0.0;
  double _userRequest = 0.0;
  double targetValue = 0;
  Color borderColor = Colors.blue;
  bool backBtn = false;
  Color iconColor = Colors.white;

  @override
  void initState() {
    super.initState();
    getUserInfo();
    getDailyWatersAmount();
  }

  void getUserInfo() {
    var userInfo = _databaseHelper.getUserInfo();
    userInfo.then((data) {
      this.allUserInfo = data;
      for (var daily in allUserInfo) {
        dailyAmount = daily.dailyAmount;
        _userRequest = double.parse(dailyAmount);
      }
    });
  }

  void _handleRadioValueChange(double value) {
    setState(() {
      groupValue = value;
      print(groupValue);
    });
  }

  void getDailyWatersAmount() {
    double flag = 0.0;
    var waterAmountFuture = _databaseHelper.getTodayDayData();
    waterAmountFuture.then((data) {
      this.allWaterHistory = data;
      for (var maxAmount in allWaterHistory) {
        flag += maxAmount.amount;
      }

      setState(() {
        _todayScore = flag;
        _progress = _todayScore;
      });
    });
  }

  void saveObject() {
    _addWater(WatersAmount(
      groupValue,
      DateTime.now().toIso8601String(),
    ));
  }

  void _addWater(WatersAmount watersAmount) async {
    await _databaseHelper.insert(watersAmount);

    setState(() {
      getDailyWatersAmount();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Water Reminder')),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Color(0xffF1F1F1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                WaveProgress(
                  120.0,
                  borderColor,
                  Colors.blue,
                  (1000 / _userRequest) * _progress,
                ),
                Container(
                  margin: EdgeInsets.only(top: 15.0, bottom: 10.0),
                  child: Text(
                    '${_todayScore.round() * 10}ml / ${_userRequest.round()}ml',
                    style: TextStyle(color: Colors.blueAccent, fontSize: 20.0),
                  ),
                ),
              ],
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(
                              () {
                                groupValue = 10.0;
                              },
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.redAccent.withOpacity(0.5),
                            ),
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.all(10),
                            width: 120,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SvgPicture.asset(
                                  'assets/img/coffee-cup.svg',
                                  width: 45,
                                  color: iconColor,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "100 ml",
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w600),
                                ),
                                Container(
                                  height: 25,
                                  width: 20,
                                  child: Radio(
                                    activeColor: Colors.white,
                                    value: 10.0,
                                    groupValue: groupValue,
                                    onChanged: _handleRadioValueChange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(
                              () {
                                groupValue = 33.0;
                              },
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.greenAccent.withOpacity(0.5),
                            ),
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.all(10),
                            width: 120,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SvgPicture.asset(
                                  'assets/img/can.svg',
                                  width: 45,
                                  color: iconColor,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "330 ml",
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w600),
                                ),
                                Container(
                                  height: 25,
                                  width: 20,
                                  child: Radio(
                                    activeColor: Colors.white,
                                    value: 33.0,
                                    groupValue: groupValue,
                                    onChanged: _handleRadioValueChange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(
                              () {
                                groupValue = 20.0;
                              },
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.blueAccent.withOpacity(0.5),
                            ),
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.all(10),
                            width: 120,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SvgPicture.asset(
                                  'assets/img/glass-of-water.svg',
                                  width: 45,
                                  color: iconColor,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "200 ml",
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w600),
                                ),
                                Container(
                                  height: 25,
                                  width: 20,
                                  child: Radio(
                                    activeColor: Colors.white,
                                    value: 20.0,
                                    groupValue: groupValue,
                                    onChanged: _handleRadioValueChange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(
                              () {
                                groupValue = 50.0;
                              },
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.orangeAccent.withOpacity(0.5),
                            ),
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.all(10),
                            width: 120,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SvgPicture.asset(
                                  'assets/img/water-bottle.svg',
                                  width: 45,
                                  color: iconColor,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "500 ml",
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w600),
                                ),
                                Container(
                                  height: 25,
                                  width: 20,
                                  child: Radio(
                                    activeColor: Colors.white,
                                    value: 50.0,
                                    groupValue: groupValue,
                                    onChanged: _handleRadioValueChange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Visibility(
                visible: true,
                child: Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RawMaterialButton(
                      elevation: 2.0,
                      fillColor: Colors.white,
                      child: Icon(
                        Icons.notifications,
                        size: 30.0,
                        color: Colors.black54,
                      ),
                      padding: EdgeInsets.all(7.0),
                      shape: CircleBorder(),
                      onPressed: () {},
                    ),
                    RawMaterialButton(
                      elevation: 2.0,
                      fillColor: Theme.of(context).primaryColor,
                      child: Icon(
                        Icons.add,
                        size: 45.0,
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.all(10.0),
                      shape: CircleBorder(),
                      onPressed: () {
                        saveObject();
                        setState(
                          () => {
                            backBtn = true,
                            if ((_progress.round() * 10) + groupValue >=
                                _userRequest)
                              {
                                _progress = _userRequest / 10,
                                print("hedef tamamlandı"),
                              }
                            else if ((_progress.round() * 10) + groupValue <=
                                _userRequest)
                              {
                                _progress += groupValue,
                              },
                          },
                        );
                      },
                    ),
                    Visibility(
                      visible: true,
                      child: Container(
                        child: RawMaterialButton(
                            elevation: 2.0,
                            fillColor: Colors.white,
                            child: Icon(
                              FontAwesome.angle_double_left,
                              size: 30.0,
                              color: setColor(),
                            ),
                            padding: EdgeInsets.all(7.0),
                            shape: CircleBorder(),
                            onPressed: backBtn
                                ? () {
                                    _databaseHelper.delete();

                                    getDailyWatersAmount();
                                    backBtn = false;
                                  }
                                : null),
                      ),
                    ),
                  ],
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  setColor() {
    if (backBtn) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }
}
