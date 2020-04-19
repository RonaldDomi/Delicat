import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/meals.dart';
import './new_meal_screen.dart';

class HomeSceen extends StatelessWidget {
  const HomeSceen({Key key}) : super(key: key);

  void toNewMealScreen(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      NewMealScreen.routeName
    );
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: FutureBuilder(
        future: Provider.of<Meals>(context, listen: false)
            .fetchAndSetMeals(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<Meals>(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text('Got no places yet, start adding some!'),
                      RaisedButton(onPressed: () => toNewMealScreen(context), child: Text("Create new meal"),)
                    ],
                  ),
                ),
                builder: (ctx, meals, ch) => meals.items.length <= 0
                    ? ch
                    : ListView.builder(
                        itemCount: meals.items.length,
                        itemBuilder: (ctx, i) => ListTile(
                              leading: CircleAvatar(
                                backgroundImage: FileImage(
                                  meals.items[i].image,
                                ),
                              ),
                              title: Text(meals.items[i].title),
                              onTap: () {
                                // Go to detail page ...
                              },
                            ),
                      ),
              ),
      ),
    );
  }
}

          