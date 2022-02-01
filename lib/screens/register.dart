import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter/services.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  TextEditingController weight = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController height = TextEditingController();

  TextEditingController name = TextEditingController();
  TextEditingController surname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  int initialPage;
  TimeOfDay d1;
  TimeOfDay d2;

  bool _btnEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Personal Information'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Center(
          child: Container(
            decoration: new BoxDecoration(
              color: Colors.transparent,
            ),
            padding: EdgeInsets.all(20),
            child: Center(
              child: new Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: name,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Name',
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
                  TextFormField(
                    controller: surname,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Surname',
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
                  TextFormField(
                    controller: email,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Email',
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
                  TextFormField(
                    controller: password,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Password',
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
                      onPressed: _btnEnabled == true ? saveData : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void isEmpty() {
    print("object");
    if (weight.text == "" || height.text == "" || age.text == "") {
      _btnEnabled = false;
    } else {
      _btnEnabled = true;
    }
  }

  void saveData() async {
    if (weight.text == "" || height.text == "" || age.text == "") {
      Flushbar(
        title: "Error",
        message: "Please fill all area",
        duration: Duration(seconds: 3),
      )..show(context);
    } else {}
  }
}
