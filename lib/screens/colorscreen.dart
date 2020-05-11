import 'package:flutter/material.dart';
import './colorpicker.dart';

class ColorScreen extends StatefulWidget {
  static const routeName = '/colorpicker';
  @override
  _ColorScreenState createState() => _ColorScreenState();
}

class _ColorScreenState extends State<ColorScreen> {
  Color pickerColor = Color(0xff443a49);

  Color currentColor = Color(0xff443a49);
  void changeColor(Color color) {
    setState(() => {
          print("pickerColor: ${color}"),
          pickerColor = color,
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ColorPicker Screen"),
      ),
      body: Column(
        children: <Widget>[
          AlertDialog(
            title: const Text('Pick a color!'),
            content: SingleChildScrollView(
              child: BlockPicker(
                pickerColor: currentColor,
                onColorChanged: changeColor,
              ),
            ),
          ),
          Text("color: ${pickerColor.toString()}"),
        ],
      ),
    );
  }
}
