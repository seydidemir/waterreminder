import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:load/load.dart';
import 'dart:io';
import 'package:waterreminder/utils/splash.dart';

void main() async {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new WaterReminder(),
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
            primaryTextTheme: TextTheme(
              headline6: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          home: AdvancedSplashScreen(
            // child: Helper.user != null ? HomeScreen() : LoginScreen(),
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
