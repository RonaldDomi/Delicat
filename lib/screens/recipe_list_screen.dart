import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/recipes.dart';

class RecipeListScreen extends StatelessWidget {
  const RecipeListScreen({Key key}) : super(key: key);

  static const routeName = '/recipe-list';
  void navigateTo(routeName, BuildContext ctx) {
    Navigator.of(ctx).pushNamed(routeName);
  }
  //we need to get categoryId by route argument and pass it to fetchAndSetRecipesByCategory(categoryId)
  @override
  Widget build(BuildContext context) {

  final arguments =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;
    final categoryId = arguments['categoryId'] as int;
    print("categoryId is $categoryId");


    return Scaffold(
      appBar: AppBar(
        title: Text("Your {name} meals"),
      ),
      body: FutureBuilder(
        future:
            Provider.of<Recipes>(context, listen: false).fetchAndSetRecipesByCategory(categoryId),
        builder: (ctx, snapshotRecipes) => snapshotRecipes.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    color: Colors.red,
                    constraints: BoxConstraints.expand(height: 300),
                    child: Consumer<Recipes>(
                      child: Center(
                        child:
                            const Text("you have no recipes in this category."),
                      ),
                      builder: (ctx, recipes, ch) => recipes.items.length <= 0
                          ? ch
                          : ListView.builder(
                              itemCount: recipes.items.length,
                              itemBuilder: (ctx, i) => Container(
                                color: Color(
                                    int.parse(recipes.items[i].category.colorCode)),
                                child: ListTile(
                                  title: Text(recipes.items[i].name),
                                  contentPadding: EdgeInsets.all(15),
                                  onTap: () {
                                    navigateTo(RecipeListScreen.routeName, context);
                                  },
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
