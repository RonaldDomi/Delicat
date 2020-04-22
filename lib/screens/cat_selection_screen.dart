import 'package:flutter/material.dart';

class CatSelectionScreen extends StatelessWidget {
  const CatSelectionScreen({Key key}) : super(key: key);

  static const routeName = '/cat-selection';

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(appBar: AppBar(title: Text("Selection Cat Screen"),),);
  }
}
