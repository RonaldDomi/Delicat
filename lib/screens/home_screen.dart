import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/categories.dart';

import '../routeNames.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void navigateTo(routeName, BuildContext ctx) {
    Navigator.of(ctx).pushNamed(routeName);
  }

  checkFirstHitStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstTime = prefs.getBool('first_time');
    if (firstTime != null && !firstTime) {
      // It isn't the first time, so on rebuild just stay here

    } else if (firstTime == null) {
      prefs.setBool('first_time', false);
      Navigator.of(context)
          .pushReplacementNamed(RouterNames.CatSelectionScreen);
    }
  }

  flipFirstHitStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('first_time', null);
    });
  }

  void clearTableData() {
    print("clear table: not implemented");
  }

  Widget _buildSelectedCatsListItem(category) {
    return Dismissible(
      key: ValueKey(category.id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Categories>(context, listen: false)
            .removeCategory(category.id);
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(int.parse(category.colorCode)).withOpacity(0.7),
              Color(int.parse(category.colorCode)),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListTile(
          // title: Text(category.id.toString()),
          title: Text(category.name),
          contentPadding: EdgeInsets.all(15),
          onTap: () {
            Navigator.of(context).pushNamed(RouterNames.RecipeListScreen,
                arguments: category.id.toString());
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    checkFirstHitStatus();

    var selectedCats =
        Provider.of<Categories>(context, listen: false).getAllCategories();

    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
      ),
      body: FutureBuilder(
        future: selectedCats,
        builder: (ctx, snapshotCategories) => snapshotCategories
                    .connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(border: Border.all(width: 1)),
                    constraints: BoxConstraints.expand(height: 300),
                    child: Consumer<Categories>(
                      child: Center(
                        child: const Text("you have no cats on your profile."),
                      ),
                      builder: (ctx, categories, ch) =>
                          categories.items.length <= 0
                              ? ch
                              : ListView.builder(
                                  itemCount: categories.items.length,
                                  itemBuilder: (ctx, i) =>
                                      _buildSelectedCatsListItem(
                                          categories.items[i]),
                                ),
                    ),
                  ),
                  RaisedButton(
                    child: Text("Drop user_categories table"),
                    onPressed: clearTableData,
                  ),
                  RaisedButton(
                    child: Text("Flip first time status (you have to reload)"),
                    onPressed: flipFirstHitStatus,
                  ),
                  Divider(),
                  RaisedButton(
                    child: Text("Create a new category"),
                    onPressed: () =>
                        navigateTo(RouterNames.NewCatScreen, context),
                  ),
                ],
              ),
      ),
    );
  }
}
