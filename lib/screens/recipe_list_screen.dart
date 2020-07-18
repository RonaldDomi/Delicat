import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';

// import '../models/category.dart';
import '../providers/categories.dart';
import '../providers/recipes.dart';
import '../routeNames.dart';
import '../screen_scaffold.dart';
import '../widgets/recipe_list_item.dart';

import '../helperFunctions.dart';

class RecipeListScreen extends StatefulWidget {
  final String categoryId;
  RecipeListScreen({this.categoryId});

  @override
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  final TextEditingController _nameController = new TextEditingController();

  void selfRestartState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final category =
        Provider.of<Categories>(context).getCategoryById(widget.categoryId);
    _nameController.text = category.name;

    return ScreenScaffold(
      child: FutureBuilder(
        future: Provider.of<Recipes>(context, listen: false)
            .getRecipesByCategoryId(category.id),
        builder: (ctx, snapshotRecipes) => snapshotRecipes.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                color: hexToColor(category.colorLightCode),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "${category.name} Catalogue",
                            style: TextStyle(
                              fontSize: 23,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              RaisedButton(
                                onPressed: () {
                                  Provider.of<Recipes>(context, listen: false)
                                      .setIsEdited(false);
                                  Provider.of<Recipes>(context, listen: false)
                                      .setIsNew(true);
                                  Navigator.of(context).pushNamed(
                                    RouterNames.NewRecipeScreen,
                                    arguments: [
                                      category.name,
                                      category.colorLightCode,
                                      category.id,
                                    ],
                                  );
                                },
                                color: Colors.white,
                                elevation: 6,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                                child: Text(
                                  "add a new dish",
                                  style: TextStyle(
                                    color: Color(0xffF6C2A4),
                                  ),
                                ),
                              ),
                              RaisedButton(
                                onPressed: () {
                                  print("push route with $category");
                                  Navigator.of(context).pushNamed(
                                    RouterNames.NewCategoriesScreen,
                                    arguments: category,
                                  );
                                },
                                color: Colors.white,
                                elevation: 6,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                                child: Text(
                                  "Edit Category",
                                  style: TextStyle(
                                    color: Color(0xffF6C2A4),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    (snapshotRecipes.data.length <= 0)
                        ? Center(
                            child: Text(
                                "you have no recipes in this category. ${snapshotRecipes.data}"),
                          )
                        : _swiperBuilder(
                            context, category, snapshotRecipes.data),
                    SizedBox(
                      height: 50,
                    ),
                    RaisedButton(
                      onPressed: () {
                        var pass;
                      },
                      padding: EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      color: hexToColor(category.colorCode),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(
                          "Read More",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  Widget _swiperBuilder(BuildContext context, category, recipes) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Swiper(
        onTap: (index) {
          Navigator.of(context).pushNamed(
            RouterNames.RecipeDetailsScreen,
            arguments: recipes[index].id,
          );
        },
        itemBuilder: (BuildContext context, int index) {
          return RecipeListItem(
            recipes[index],
            category.colorCode,
            selfRestartState,
            category.photo,
          );
        },
        itemCount: recipes.length,
        viewportFraction: 0.6,
        scale: 0.8,
      ),
    );
  }
}
// Padding(
//   padding: const EdgeInsets.all(16.0),
//   child: TextField(
//     controller: _nameController,
//     decoration: InputDecoration(labelText: "Rename"),
//     onSubmitted: (String value) {
//       Provider.of<Categories>(context, listen: false)
//           .editCategory(
//         Category(
//           id: category.id,
//           name: value,
//           photo: category.photo,
//           colorCode: category.colorCode,
//           colorLightCode: category.colorLightCode,
//         ),
//       );
//     },
//   ),
// ),
