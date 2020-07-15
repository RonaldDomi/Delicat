import 'package:delicat/helperFunctions.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  final String colorCode;
  final String name;
  CameraScreen(this.colorCode, this.name);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            width: double.infinity,
            color: hexToColor(widget.colorCode),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "${widget.name} Catalogue",
                  style: TextStyle(
                    fontSize: 23,
                  ),
                ),
                RaisedButton(
                  disabledTextColor: Color(0xffD6D6D6),
                  disabledColor: Colors.white,
                  disabledElevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: Text(
                    "add a new recipe",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Center(
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: hexToColor("#E4E4E4"),
                    border: Border.all(
                      color: hexToColor("#EEDA76"),
                      width: 5,
                    ),
                  ),
                ),
              )),
          Container(
            height: MediaQuery.of(context).size.height * 0.15,
            width: double.infinity,
            color: hexToColor(widget.colorCode),
            child: Center(
              child: InkWell(
                onTap: () {
                  print("whoms summoned the almight one?");
                },
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                    border: Border.all(
                      color: hexToColor("#655C3D"),
                      width: 5,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            padding: EdgeInsets.symmetric(horizontal: 75),
            child: Center(
              child: Text(
                "Make sure you fill the circle",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  color: hexToColor("#F6C2A4"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
