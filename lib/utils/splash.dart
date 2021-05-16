import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterreminder/main.dart';
import 'package:waterreminder/screens/home_screen.dart';
import 'package:waterreminder/utils/bottom_navbar.dart';

import 'helper.dart';

class AdvancedSplashScreen extends StatefulWidget {
  // widget
  final Widget child;
  final int seconds;
  final int milliseconds;
  // animate
  final bool animate;

  // appearance
  final List<Color> colorList;
  final String backgroundImage;
  final double bgImageOpacity;
  final String appIcon;
  final String appTitle;
  final TextStyle appTitleStyle;

  AdvancedSplashScreen(
      {this.child,
      this.seconds = 1,
      this.milliseconds = 0,
      this.animate = true,
      this.colorList = const [],
      this.backgroundImage,
      this.bgImageOpacity = 0.1,
      this.appIcon = "",
      this.appTitle = "",
      this.appTitleStyle = const TextStyle(
          fontSize: 43.0,
          color: Colors.white,
          fontFamily: "",
          fontWeight: FontWeight.bold)});

  @override
  _AdvancedSplashScreenState createState() => _AdvancedSplashScreenState();
}

class _AdvancedSplashScreenState extends State<AdvancedSplashScreen>
    with TickerProviderStateMixin {
  Animation<double> _animation;
  Animation<double> _animationText;
  AnimationController _animationController;

  List<double> stopList = [];

  @override
  void initState() {
    super.initState();
    initStartApp();
    buildStopList();

    handleScreenReplacement();

    _animationController = AnimationController(
        vsync: this,
        duration: Duration(
            seconds: (widget.seconds / 2).truncate(),
            milliseconds: (widget.milliseconds / 2.5).truncate()));
    _animation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _animationText = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    if (widget.animate) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  int initScreen = 0;

  void initStartApp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    initScreen = prefs.getInt('pageState');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          // if background image is passed
          (widget.backgroundImage != null)
              ? Opacity(
                  opacity: widget.bgImageOpacity,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          widget.backgroundImage,
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                )
              :
              // if no background image is passed
              Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    stops: stopList,
                    colors: widget.colorList,
                  )),
                ),
          Container(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Center(
                  child: Image.asset(
                    widget.appIcon,
                    width: size.width / 1.3,
                    height: size.height / 1.3,
                  ),
                );
              },
            ),
          ),
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Text(
                    widget.appTitle,
                    style: widget.appTitleStyle,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void handleScreenReplacement() async {
    // var utoken = await Helper.getShared('token');

    // if (utoken != null) {
    //   Service.token = utoken;
    //   var jresponse = await Service.profile();

    //   if (jresponse != null && jresponse['status'] == 1) {
    //     Helper.user = jresponse['data'];
    //   }
    // }
    Timer(Duration(seconds: widget.seconds, milliseconds: widget.milliseconds),
        () {
      if (initScreen == 1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavbar(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OnboardingScreen(),
          ),
        );
      }
    });
  }

  void buildStopList() {
    stopList = [];

    double stopListVal = 0.4;
    widget.colorList.forEach((color) {
      stopList.add(stopListVal);
      stopListVal += 0.2;
    });
  }
}
