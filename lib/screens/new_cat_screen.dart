import 'package:flutter/material.dart';

class NewCatScreen extends StatelessWidget {
  const NewCatScreen({Key key}) : super(key: key);

  static const routeName = '/new-cat';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("New cat screen"),
      ),
    );
  }
}
