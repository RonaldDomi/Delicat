import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'dart:async';
import 'package:delicat/screens/Category/categories_screen.dart';

class GeneratingCategoriesScreen extends StatefulWidget {
  const GeneratingCategoriesScreen({Key key}) : super(key: key);

  @override
  _GeneratingCategoriesScreenState createState() =>
      _GeneratingCategoriesScreenState();
}

class _GeneratingCategoriesScreenState
    extends State<GeneratingCategoriesScreen> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 3), () {
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
      body: InkWell(
        onTap: () {},
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Color(0xffF1EBE8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 0,
                    ),
                  ),
                  Expanded(
                    flex: 2,
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
                                "deli",
                                style: TextStyle(
                                  fontSize: 37,
                                ),
                              ),
                              Text(
                                "cat",
                                style: TextStyle(
                                  fontSize: 37,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        JumpingDotsProgressIndicator(
                          fontSize: 37.0,
                        ),
                        Text(
                          "generating your menu",
                          style: TextStyle(
                            color: Color(0xffE5D8A2),
                            fontSize: 25,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Tip",
                          style: TextStyle(
                            fontSize: 30,
                            color: Color(0xffF6C2A4),
                          ),
                        ),
                        Text(
                          "click on the delicat icon",
                          style: TextStyle(
                            fontSize: 19,
                            color: Color(0xffBB9982),
                          ),
                        ),
                        Text(
                          "to get a random recipe",
                          style: TextStyle(
                            fontSize: 19,
                            color: Color(0xffBB9982),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
