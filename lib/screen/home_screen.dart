import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wave_progress_widget/wave_progress.dart';

class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double groupValue = 20.0;
  double _progress = 0.0;
  double _todayScore = 0.0;
  double _userRequest = 2600;
  double targetValue = 0;
  int _selectedIndex = 0;
  Color borderColor = Colors.blueAccent;
  double _lastAdded = 0;
  bool backBtn = false;

  @override
  void initState() {
    super.initState();
  }

  void _handleRadioValueChange(double value) {
    setState(() {
      groupValue = value;
      print(groupValue);
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
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              height: 150.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(
                        () {
                          groupValue = 10.0;
                        },
                      );
                    },
                    child: Container(
                      width: 160.0,
                      color: Color(0xFF505160),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Spacer(),
                          Text(
                            "100ml",
                            style: TextStyle(fontSize: 18.0),
                          ),
                          Spacer(),
                          SvgPicture.asset(
                            'assets/img/cup.svg',
                            width: 45,
                            color: Colors.white,
                          ),
                          Spacer(),
                          Radio(
                            activeColor: Colors.white,
                            value: 10.0,
                            groupValue: groupValue,
                            onChanged: _handleRadioValueChange,
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(
                        () {
                          groupValue = 20.0;
                        },
                      );
                    },
                    child: Container(
                      width: 160.0,
                      color: Color(0xFF68829E),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Spacer(),
                          Text(
                            "200ml",
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                            ),
                          ),
                          Spacer(),
                          SvgPicture.asset(
                            'assets/img/250ml.svg',
                            width: 45,
                          ),
                          Spacer(),
                          Radio(
                            activeColor: Colors.white,
                            value: 20.0,
                            groupValue: groupValue,
                            onChanged: _handleRadioValueChange,
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
                      width: 160.0,
                      color: Color(0xFFAEBD38),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Spacer(),
                          Text(
                            "330ml",
                            style: TextStyle(fontSize: 18.0),
                          ),
                          Spacer(),
                          SvgPicture.asset(
                            'assets/img/drink-water.svg',
                            width: 45,
                          ),
                          Spacer(),
                          Radio(
                            activeColor: Colors.white,
                            value: 33.0,
                            groupValue: groupValue,
                            onChanged: _handleRadioValueChange,
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
                      width: 160.0,
                      color: Color(0xFF598234),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Spacer(),
                          Text(
                            "500ml",
                            style: TextStyle(fontSize: 18.0),
                          ),
                          Spacer(),
                          SvgPicture.asset(
                            'assets/img/bottle.svg',
                            width: 45,
                          ),
                          Spacer(),
                          Radio(
                            activeColor: Colors.white,
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
                ),
                Text(
                  '${_todayScore.round() * 10}ml / ${_userRequest.round()}ml',
                  style: TextStyle(color: Colors.blueAccent, fontSize: 20.0),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Visibility(
                visible: true,
                child: Container(
                  child: RawMaterialButton(
                    elevation: 2.0,
                    fillColor: Colors.blue,
                    child: Icon(
                      Icons.add,
                      size: 45.0,
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.all(15.0),
                    shape: CircleBorder(),
                    onPressed: () {
                      setState(
                        () => {
                          _todayScore += groupValue,
                          _lastAdded = groupValue,
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
                ),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Center(
              child: Visibility(
                visible: backBtn,
                child: Container(
                  child: TextButton(
                    child: Text(
                      "Geri Al",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 22.0,
                      ),
                    ),
                    onPressed: () {
                      setState(
                        () => {
                          _todayScore -= groupValue,
                          _lastAdded = 0,
                          backBtn = false,
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
