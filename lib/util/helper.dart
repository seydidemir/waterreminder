import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_animations/simple_animations.dart';

class Helper {
  static dynamic user;

  static void setShared(String name, dynamic value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(name, value);
    prefs.commit();
  }

  static dynamic getShared(String name) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(name);
  }
}

class GBColors {
  static const MaterialColor primary = MaterialColor(
    0xFF00A0A0,
    <int, Color>{
      50: Color(0xFF00A0A0),
      100: Color(0xFF00A0A0),
      200: Color(0xFF00A0A0),
      300: Color(0xFF00A0A0),
      400: Color(0xFF00A0A0),
      500: Color(0xFF00A0A0),
      600: Color(0xFF00A0A0),
      700: Color(0xFF00A0A0),
      800: Color(0xFF00A0A0),
      900: Color(0xFF00A0A0),
    },
  );
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (_timer != null) {
      _timer.cancel();
    }

    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  FadeAnimation(this.delay, this.child);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTrackTween([
      Track("opacity")
          .add(Duration(milliseconds: 500), Tween(begin: 0.0, end: 1.0)),
      Track("translateY").add(
          Duration(milliseconds: 500), Tween(begin: -30.0, end: 0.0),
          curve: Curves.easeOut)
    ]);

    return ControlledAnimation(
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builderWithChild: (context, child, animation) => Opacity(
        opacity: animation["opacity"],
        child: Transform.translate(
            offset: Offset(0, animation["translateY"]), child: child),
      ),
    );
  }
}
