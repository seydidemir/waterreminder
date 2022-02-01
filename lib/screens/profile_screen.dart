import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:load/load.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:waterreminder/models/notofication.dart';
import 'package:waterreminder/models/user.dart';
import 'package:waterreminder/screens/set_alert_screen.dart';
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

  bool _btnDailyEnabled = false;
  bool _btnTimeEnabled = false;

  String dailyAmount = "";
  TimeOfDay wakeUpTime;
  TimeOfDay sleepTime;
  TextEditingController weight = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController height = TextEditingController();

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

  final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'info@seydidemir.com',
      queryParameters: {'subject': ''});

  String _websiteLaunchUri = 'https://www.seydidemir.com';
  void _launchURL() async => await canLaunch(_websiteLaunchUri)
      ? await launch(_websiteLaunchUri)
      : throw 'Could not launch $_websiteLaunchUri';

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Settings'),
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
                  trailing: Icon(
                    FontAwesome.chevron_right,
                    color: Colors.grey,
                    size: 20,
                  ),
                  onPressed: (BuildContext context) {
                    getUserInfo();
                    dailyAmountCalculate();
                  },
                ),
                SettingsTile(
                  title: 'Alert',
                  leading: Icon(
                    Icons.notification_add,
                  ),
                  onPressed: (BuildContext context) {
                    showLoadingDialog();
                    Navigator.of(context).push(_createRoute());

                    // Fluttertoast.showToast(
                    //     msg: "Coming Soon",
                    //     toastLength: Toast.LENGTH_SHORT,
                    //     gravity: ToastGravity.CENTER,
                    //     timeInSecForIosWeb: 1,
                    //     backgroundColor: Colors.red,
                    //     textColor: Colors.white,
                    //     fontSize: 16.0);
                  },
                ),
                SettingsTile(
                  title: 'Wake-up / Sleep time',
                  leading: Icon(
                    FontAwesome.bed,
                    color: Colors.red,
                  ),
                  onPressed: (BuildContext context) {
                    showLoadingDialog();
                    Navigator.of(context).push(_createRoute());
                    // Fluttertoast.showToast(
                    //     msg: "Coming Soon",
                    //     toastLength: Toast.LENGTH_SHORT,
                    //     gravity: ToastGravity.CENTER,
                    //     timeInSecForIosWeb: 1,
                    //     backgroundColor: Colors.red,
                    //     textColor: Colors.white,
                    //     fontSize: 16.0);
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
                  onPressed: (BuildContext context) {
                    launch(_emailLaunchUri.toString());
                  },
                ),
                SettingsTile(
                  title: 'SHARE APP',
                  leading: Icon(
                    FontAwesome.share_square,
                    color: Colors.blueAccent,
                  ),
                  onPressed: (BuildContext context) {
                    Fluttertoast.showToast(
                        msg: "Coming Soon",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  },
                ),
                SettingsTile(
                  title: 'Website',
                  leading: Icon(
                    FontAwesome.globe,
                    color: Colors.green,
                  ),
                  onPressed: (BuildContext context) {
                    _launchURL();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SetAlertScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  void dailyAmountCalculate() {
    void isEmpty() {
      print("object");
      if (weight.text == "" || height.text == "" || age.text == "") {
        _btnDailyEnabled = false;
      } else {
        _btnDailyEnabled = true;
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
                        onPressed: _btnDailyEnabled == true ? saveData : null,
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }
}
