import 'package:flutter/material.dart';
import 'dart:core';

import './categories_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => CategoriesScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xffF1EBE8),
        ),
        child: Container(
          child: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Container(
                  child: Image(
                    image: AssetImage("assets/logo/logo.png"),
                  ),
                ),
                radius: 100.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "delicacy",
                    style: TextStyle(
                      fontSize: 28,
                    ),
                  ),
                  Text(
                    "catalogue",
                    style: TextStyle(
                      fontSize: 28,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
