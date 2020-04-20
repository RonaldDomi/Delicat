import 'package:flutter/material.dart';

class CatSelectionScreen extends StatelessWidget {
  const CatSelectionScreen({Key key}) : super(key: key);

  static const routeName = '/cat-selection';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("I'm cat selection screen."),
      ),
    );
  }
}
