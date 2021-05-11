import 'package:fbutton/fbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:settings_ui/settings_ui.dart';
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

  bool alertValue = false;
  String dailyAmount = "";
  TextEditingController weight = TextEditingController();
  TextEditingController age = TextEditingController();

  void saveObject(var result) {
    _addUserInfo(User(
      weight.text,
      DateTime.now().toIso8601String(),
      result,
    ));
  }

  void _addUserInfo(User user) async {
    await _databaseHelper.insertUser(user);

    setState(() {
      getUserInfo();
    });
  }

  void getUserInfo() {
    var weightText;
    var userInfo = _databaseHelper.getUserInfo();
    userInfo.then((data) {
      this.allUserInfo = data;
      for (var daily in allUserInfo) {
        dailyAmount = daily.dailyAmount;
        weightText = daily.userWeight;
      }
      setState(() {
        weight.text = weightText;
      });
    });
  }

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
        shadowColor: Colors.blue,
        backgroundColor: Colors.blue,
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
                  subtitle: dailyAmount.isNotEmpty
                      ? dailyAmount + "ml"
                      : "click to calculate",
                  subtitleTextStyle: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                  leading: Icon(FontAwesome.balance_scale),
                  onPressed: (BuildContext context) {
                    getUserInfo();
                    _settingModalBottomSheet(context);
                  }),
              SettingsTile(
                title: 'Alert',
                leading: Icon(FontAwesome.bell),
                onPressed: (BuildContext context) {},
              ),
            ],
          ),
        ],
      )),
    );
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
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
                    "Personal Information",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: weight,
                    decoration: InputDecoration(
                      labelText: 'Weight(kg)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: age,
                    decoration: InputDecoration(
                      labelText: 'Age',
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
                        String result =
                            ((int.parse(weight.text) * 0.039) * 1000)
                                .toString();
                        saveObject(result);

                        Navigator.pop(context, result);
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
