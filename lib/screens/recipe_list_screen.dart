import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/categories.dart';
import '../providers/recipes.dart';
import '../routeNames.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class RecipeListScreen extends StatefulWidget {
  final String categoryId;
  RecipeListScreen({this.categoryId});

  @override
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  @override
  Widget build(BuildContext context) {
    final category =
        Provider.of<Categories>(context).getCategoryById(widget.categoryId);
    print("Widget category: $category");
    return Scaffold(
      appBar: AppBar(
        title: Text("Your ${category.name} meals"),
      ),
      body: FutureBuilder(
        future: Provider.of<Recipes>(context, listen: false)
            .getRecipesByCategoryId(category.id),
        builder: (ctx, snapshotRecipes) => snapshotRecipes.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            // : Column(
            //     // mainAxisAlignment: MainAxisAlignment.center,
            //     children: <Widget>[
            //       Container(
            //         margin: EdgeInsets.all(10),
            //         decoration: BoxDecoration(border: Border.all(width: 1)),
            //         constraints: BoxConstraints.expand(height: 300),
            //         child: Consumer<Recipes>(
            //           child: Center(
            //             child:
            //                 const Text("you have no recipes in this category."),
            //           ),
            //           builder: (ctx, recipes, ch) => recipes.items.length <= 0
            //               ? ch
            //               : ListView.builder(
            //                   itemCount: recipes.items.length,
            // itemBuilder: (ctx, i) => Container(
            //   color: Color(int.parse(category.colorCode)),
            //                     child: ListTile(
            //                       title: Text(recipes.items[i].name),
            //                       contentPadding: EdgeInsets.all(15),
            // onTap: () {
            //   Navigator.of(context).pushNamed(
            //     RouterNames.RecipeDetailsScreen,
            //     arguments: recipes.items[i].id.toString(),
            //   );
            // },
            //                     ),
            //                   ),
            //                 ),
            //         ),
            //       ),
            //     ],
            //   ),

            : Consumer<Recipes>(
                child: Center(
                  child: const Text("you have no recipes in this category."),
                ),
                builder: (ctx, recipes, ch) => recipes.items.length <= 0
                    ? ch
                    : Swiper(
                        onTap: (index) {
                          Navigator.of(context).pushNamed(
                            RouterNames.RecipeDetailsScreen,
                            arguments: recipes.items[index].id.toString(),
                          );
                          // print("index pressed: ${recipes.items[index].id}");
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            height: 250,
                            child: Card(
                              elevation: 6,
                              color: Color(int.parse(category.colorCode)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  "${recipes.items[index].name} index: ${recipes.items[index].id}",
                                  style: TextStyle(fontSize: 32),
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: recipes.items.length,
                        viewportFraction: 0.7,
                        scale: 0.8,
                      ),
              ),
      ),
    );
  }
}
