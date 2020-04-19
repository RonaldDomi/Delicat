import 'package:delicat/widgets/image_input.dart';
import 'package:flutter/material.dart';

class NewMealScreen extends StatelessWidget {
  static const routeName = '/newmeal';

  const NewMealScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ImageInput(),
          ],
        ),
      ),
    );
  }
}
