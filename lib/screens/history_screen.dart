import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiffy/jiffy.dart';
import 'package:load/load.dart';
import 'package:waterreminder/models/user.dart';
import 'package:waterreminder/models/water.dart';
import 'package:waterreminder/utils/dbHelper.dart';
import 'package:wave_progress_widget/wave_progress_widget.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
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
  String _todayPercentage = "";
  double targetValue = 0;
  Color borderColor = Colors.blueAccent;

  @override
  void initState() {
    super.initState();
    getUserInfo();
    getWaweWatersAmount();
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

  void getWaweWatersAmount() {
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
        String percentage =
            (((_todayScore * 100) / _userRequest) * 10).toStringAsFixed(1);
        var goal = double.parse(percentage);
        if (goal >= 100) {
          goal = 100;
          _todayPercentage = goal.toString();
        } else {
          _todayPercentage = percentage.toString();
        }
      });
    });
  }

  // void getWatersAmount() async {
  //   var waterAmountFuture = _databaseHelper.getAllData();
  //   await waterAmountFuture.then(
  //     (data) {
  //       setState(() {
  //         this.allWaterHistory = data;
  //       });
  //     },
  //   );
  // }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('History'),
        shadowColor: Colors.blue,
        backgroundColor: Colors.blue,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  _databaseHelper.deleteAllRecords();

                  getWaweWatersAmount();
                },
                child: Icon(
                  Icons.delete_forever,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 3.6,
              child: Column(
                children: <Widget>[
                  Text(
                    "%  $_todayPercentage",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  WaveProgress(
                    120.0,
                    borderColor,
                    Colors.blue,
                    (1000 / _userRequest) * _progress,
                  ),
                  ListTile(
                    title: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Progress",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              "Daily Goal",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${_todayScore.round() * 10}ml",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${_userRequest.round()}ml",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 15, top: 5, bottom: 5),
              child: Row(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Daily History",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  getWaweWatersAmount();
                },
                child: allWaterHistory.isEmpty
                    ? Center(
                        child: Text(
                          "Don't forget to drink water",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: allWaterHistory.length,
                        itemBuilder: (context, index) {
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: ListTile(
                              leading: SvgPicture.asset(
                                'assets/img/250ml.svg',
                                width: 45,
                              ),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    (allWaterHistory[index].amount.round() * 10)
                                            .toString() +
                                        "ml ",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    Jiffy(allWaterHistory[index].createdDate)
                                        .format('HH:mm'),
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
