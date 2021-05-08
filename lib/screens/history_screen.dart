import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiffy/jiffy.dart';
import 'package:waterreminder/models/water.dart';
import 'package:waterreminder/utils/dbHelper.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  DatabaseHelper _databaseHelper = DatabaseHelper();
  // ignore: deprecated_member_use
  List<WatersAmount> allWaterHistory = new List<WatersAmount>();

  @override
  void initState() {
    super.initState();
    getWatersAmount();
  }

  void getWatersAmount() async {
    var waterAmountFuture = _databaseHelper.getAllData();
    await waterAmountFuture.then(
      (data) {
        setState(() {
          this.allWaterHistory = data;
        });
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('History'),
        shadowColor: Colors.blue,
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  getWatersAmount();
                },
                child: ListView.builder(
                  itemCount: allWaterHistory.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                          leading: SvgPicture.asset(
                            'assets/img/250ml.svg',
                            width: 45,
                          ),
                          title: Text(
                            (allWaterHistory[index].amount.round() * 10)
                                    .toString() +
                                "ml",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  child: Text(
                                    Jiffy(allWaterHistory[index].createdDate)
                                        .format('dd.MM.yyyy HH:mm:ss'),
                                    style: TextStyle(
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )),
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
