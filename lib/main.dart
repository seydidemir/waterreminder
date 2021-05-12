import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:load/load.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterreminder/models/user.dart';
import 'package:waterreminder/utils/bottom_navbar.dart';
import 'dart:io';

import 'package:waterreminder/utils/dbHelper.dart';
import 'package:waterreminder/utils/splash.dart';

int initScreen = 0;
int dailyAmount;

Future<void> main() async {
  runApp(MyApp());

  // initStartApp();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,

      locale: const Locale(
          'tr', ''), // change to locale you want. not all locales are supported
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('tr', ''), // English, no country code
        const Locale.fromSubtags(
            languageCode: 'tr'), // Chinese *See Advanced Locales below*
        // ... other locales the app supports
      ],
      home: WaterReminder(),
    );
  }
}

class WaterReminder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ConnectivityAppWrapper(
      app: LoadingProvider(
        themeData: LoadingThemeData(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Water Reminder',
          theme: ThemeData(
            fontFamily: 'Roboto',
          ),
          home: AdvancedSplashScreen(
            child: BottomNavbar(),
            seconds: 2,
            colorList: [Colors.white],
            appIcon: "assets/img/splash_img.png",
            appTitle: "Powered by SAYTHEIRON",
            appTitleStyle: TextStyle(fontSize: 13, color: Colors.black),
            animate: true,
          ),
        ),
      ),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  DatabaseHelper _databaseHelper = DatabaseHelper();

  TextEditingController weight = TextEditingController();
  TextEditingController age = TextEditingController();
  int initialPage;

  void saveObject(var result) {
    _addUserInfo(User(
      weight.text,
      DateTime.now().toIso8601String(),
      result,
    ));
  }

  void _addUserInfo(User user) async {
    await _databaseHelper.insertUser(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(30),
        child: Container(
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
                    onPressed: () async {
                      String result =
                          ((int.parse(weight.text) * 0.039) * 1000).toString();
                      saveObject(result);

                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setInt('pageState', 1);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => BottomNavbar()),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// class MyColors {
//   static const MaterialColor turkuaz = MaterialColor(
//     0xFFffffff,
//     <int, Color>{
//       50: Colors.white,
//       100: Colors.white,
//       200: Colors.white,
//       300: Colors.white,
//       400: Colors.white,
//       500: Colors.white,
//       600: Colors.white,
//       700: Colors.white,
//       800: Colors.white,
//       900: Colors.white,
//     },
//   );
// }
