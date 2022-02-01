import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:load/load.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterreminder/models/user.dart';
import 'package:waterreminder/screens/login.dart';
import 'package:waterreminder/utils/bottom_navbar.dart';
import 'dart:io';

import 'package:waterreminder/utils/dbHelper.dart';
import 'package:waterreminder/utils/splash.dart';

import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

int initScreen = 0;
int dailyAmount;

//this is the name given to the background fetch
const simplePeriodicTask = "simplePeriodicTask";
// flutter local notification setup
void showNotification(v, flp) async {
  var android = AndroidNotificationDetails(
      'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
      priority: Priority.high, importance: Importance.max);
  var iOS = IOSNotificationDetails();
  var platform = NotificationDetails(android: android, iOS: iOS);
  await flp.show(0, 'Virtual intelligent solution', '$v', platform,
      payload: 'VIS \n $v');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // AdMobService.initialize();

  runApp(MyApp());

  // initStartApp();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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
          theme: ThemeData(primaryColor: Colors.blue[800]),
          home: AdvancedSplashScreen(
            child: BottomNavbar(),
            seconds: 2,
            colorList: [Colors.blue[800]],
            appIcon: "assets/img/MLogo.png",
            appTitle: "Powered by SeydiDemir",
            appTitleStyle: TextStyle(fontSize: 13, color: Colors.white),
            animate: true,
          ),
        ),
      ),
    );
  }
}

// class OnboardingScreen extends StatefulWidget {
//   @override
//   _OnboardingScreenState createState() => _OnboardingScreenState();
// }

// class _OnboardingScreenState extends State<OnboardingScreen> {
//   DatabaseHelper _databaseHelper = DatabaseHelper();

//   TextEditingController weight = TextEditingController();
//   TextEditingController age = TextEditingController();
//   TextEditingController height = TextEditingController();
//   int initialPage;
//   TimeOfDay d1;
//   TimeOfDay d2;

//   bool _btnEnabled = false;

//   void saveObject(var result) {
//     _addUserInfo(User(weight.text, DateTime.now().toIso8601String(), result,
//         height.text, age.text));
//   }

//   void _addUserInfo(User user) async {
//     await _databaseHelper.insertUser(user);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text('Personal Information'),
//       ),
//       body: GestureDetector(
//         onTap: () {
//           FocusScope.of(context).unfocus();
//         },
//         child: Center(
//           child: Container(
//             decoration: new BoxDecoration(
//               color: Colors.transparent,
//             ),
//             padding: EdgeInsets.all(20),
//             child: Center(
//               child: new Column(
//                 children: <Widget>[
//                   SizedBox(
//                     height: 10,
//                   ),
//                   TextFormField(
//                     controller: weight,
//                     keyboardType: TextInputType.number,
//                     decoration: InputDecoration(
//                       labelText: 'Weight(kg)',
//                       border: OutlineInputBorder(),
//                     ),
//                     inputFormatters: [
//                       LengthLimitingTextInputFormatter(3),
//                     ],
//                     onChanged: (val) {
//                       setState(() {
//                         isEmpty();
//                       });
//                     },
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   TextFormField(
//                     controller: height,
//                     keyboardType: TextInputType.number,
//                     decoration: InputDecoration(
//                       labelText: 'height(cm)',
//                       border: OutlineInputBorder(),
//                     ),
//                     inputFormatters: [
//                       LengthLimitingTextInputFormatter(3),
//                     ],
//                     onChanged: (val) {
//                       setState(() {
//                         isEmpty();
//                       });
//                     },
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   TextFormField(
//                     controller: age,
//                     keyboardType: TextInputType.number,
//                     decoration: InputDecoration(
//                       labelText: 'Age',
//                       border: OutlineInputBorder(),
//                     ),
//                     inputFormatters: [
//                       LengthLimitingTextInputFormatter(3),
//                     ],
//                     onChanged: (val) {
//                       setState(() {
//                         isEmpty();
//                       });
//                     },
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   SizedBox(
//                     width: double.infinity,
//                     height: 50,
//                     child: ElevatedButton(
//                       child: Text('Save'),
//                       onPressed: _btnEnabled == true ? saveData : null,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void isEmpty() {
//     print("object");
//     if (weight.text == "" || height.text == "" || age.text == "") {
//       _btnEnabled = false;
//     } else {
//       _btnEnabled = true;
//     }
//   }

//   void saveData() async {
//     if (weight.text == "" || height.text == "" || age.text == "") {
//       Flushbar(
//         title: "Error",
//         message: "Please fill all area",
//         duration: Duration(seconds: 3),
//       )..show(context);
//     } else {
//       String result = ((int.parse(weight.text) * 0.039) * 1000).toString();

//       saveObject(result);

//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       prefs.setInt('pageState', 1);
//       FocusScope.of(context).unfocus();
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => LoginScreen()),
//       );
//     }
//   }
// }

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyColors {
  static const MaterialColor turkuaz = MaterialColor(
    0xFFf8f8f8,
    <int, Color>{
      50: Colors.white,
      100: Colors.black,
      200: Colors.white,
      300: Colors.red,
      400: Colors.white,
      500: Colors.white,
      600: Colors.white,
      700: Colors.white,
      800: Colors.white,
      900: Colors.white,
    },
  );
}
