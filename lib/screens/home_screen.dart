import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waterreminder/models/water.dart';
import 'package:waterreminder/screens/history_screen.dart';
import 'package:waterreminder/utils/dbHelper.dart';
import 'package:wave_progress_widget/wave_progress.dart';

class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DatabaseHelper _databaseHelper = DatabaseHelper();
  // ignore: deprecated_member_use
  List<WatersAmount> allWaterHistory = new List<WatersAmount>();

  double groupValue = 20.0;
  double _progress = 0.0;
  double _todayScore = 0.0;
  double _userRequest = 2600;
  double targetValue = 0;
  Color borderColor = Colors.blueAccent;
  bool backBtn = false;

  @override
  void initState() {
    super.initState();
    getWatersAmount();
  }

  void _handleRadioValueChange(double value) {
    setState(() {
      groupValue = value;
      print(groupValue);
    });
  }

  void getWatersAmount() {
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
      getWatersAmount();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Water Reminder'),
        shadowColor: Colors.blue,
        backgroundColor: Colors.blue,
      ),
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
                  margin: EdgeInsets.only(top: 5.0, bottom: 10.0),
                  child: Text(
                    '${_todayScore.round() * 10}ml / ${_userRequest.round()}ml',
                    style: TextStyle(color: Colors.blueAccent, fontSize: 20.0),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    20,
                  ),
                  color: Colors.white70.withOpacity(0.6)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width / 3,
                        height: 100,
                        child: GestureDetector(
                          onTap: () {
                            setState(
                              () {
                                groupValue = 10.0;
                              },
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Spacer(),
                              SvgPicture.asset(
                                'assets/img/coffee-cup.svg',
                                width: 35,
                                color: Colors.blue,
                              ),
                              Spacer(),
                              Text(
                                "100ml",
                                style: TextStyle(fontSize: 13.0),
                              ),
                              Radio(
                                activeColor: Colors.blue,
                                value: 10.0,
                                groupValue: groupValue,
                                onChanged: _handleRadioValueChange,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 115,
                        child: VerticalDivider(color: Colors.grey),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: 100,
                        child: GestureDetector(
                          onTap: () {
                            setState(
                              () {
                                groupValue = 20.0;
                              },
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Spacer(),
                              SvgPicture.asset('assets/img/glass-of-water.svg',
                                  width: 35, color: Colors.blue),
                              Spacer(),
                              Text(
                                "200ml",
                                style: TextStyle(fontSize: 13.0),
                              ),
                              Radio(
                                activeColor: Colors.blue,
                                value: 20.0,
                                groupValue: groupValue,
                                onChanged: _handleRadioValueChange,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: 100,
                        child: GestureDetector(
                          onTap: () {
                            setState(
                              () {
                                groupValue = 33.0;
                              },
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Spacer(),
                              SvgPicture.asset(
                                'assets/img/can.svg',
                                width: 35,
                                color: Colors.blue,
                              ),
                              Spacer(),
                              Text(
                                "330ml",
                                style: TextStyle(fontSize: 13.0),
                              ),
                              Radio(
                                activeColor: Colors.blue,
                                value: 33.0,
                                groupValue: groupValue,
                                onChanged: _handleRadioValueChange,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 115,
                        child: VerticalDivider(color: Colors.grey),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: 100,
                        child: GestureDetector(
                          onTap: () {
                            setState(
                              () {
                                groupValue = 50.0;
                              },
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Spacer(),
                              SvgPicture.asset(
                                'assets/img/water-bottle.svg',
                                width: 35,
                                color: Colors.blue,
                              ),
                              Spacer(),
                              Text(
                                "500ml",
                                style: TextStyle(fontSize: 13.0),
                              ),
                              Radio(
                                activeColor: Colors.blue,
                                value: 50.0,
                                groupValue: groupValue,
                                onChanged: _handleRadioValueChange,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 0,
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
                      fillColor: Colors.blue,
                      child: Icon(
                        Icons.add,
                        size: 35.0,
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.all(10.0),
                      shape: CircleBorder(),
                      onPressed: () {
                        saveObject();
                        setState(
                          () => {
                            backBtn = true,
                            if (_todayScore.round() * 10 >= _userRequest)
                              {
                                borderColor = Colors.green[800],
                              },
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
                              }
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

                                    getWatersAmount();
                                    backBtn = false;
                                  }
                                : null),
                      ),
                    ),
                  ],
                )),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            TextButton(
              child: Text(
                "History",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22.0,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistoryScreen()),
                );
              },
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
