import 'package:delicat/helpers/colorHelperFunctions.dart';
import 'package:delicat/routeNames.dart';
import 'package:delicat/providers/app_state.dart';
import 'package:delicat/providers/categories.dart';
import 'package:delicat/providers/recipes.dart';
import 'package:delicat/screens/Recipe/components/recipe_list_item.dart';
import 'package:delicat/screens/widgets/screen_scaffold.dart';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';

class RecipeListScreen extends StatefulWidget {
  final String categoryId;
  RecipeListScreen({this.categoryId});

  @override
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  void selfRestartState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final category =
        Provider.of<Categories>(context).getCategoryById(widget.categoryId);
    final recipes =
        Provider.of<Recipes>(context).getRecipesByCategoryId(widget.categoryId);
    return ScreenScaffold(
      child: Container(
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
                          Provider.of<Categories>(context)
                              .removeCategory(category.id);
                          Navigator.of(context).pop();
                        },
                        color: Colors.white,
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        child: Text(
                          "Remove Category",
                          style: TextStyle(
                            color: Color(0xffF6C2A4),
                          ),
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {
                          Provider.of<AppState>(context)
                              .setIsOngoingCategoryNew(false);
                          Provider.of<AppState>(context)
                              .setOngoingCategory(category);
                          Navigator.of(context).pushNamed(
                            RouterNames.NewCategoryScreen,
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
                  ),
                  RaisedButton(
                    onPressed: () {
                      Provider.of<AppState>(context, listen: false)
                          .setIsOngoingRecipeNew(true);
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
                ],
              ),
            ),
            (recipes.length <= 0)
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RawMaterialButton(
                          onPressed: () {
                            Provider.of<AppState>(context, listen: false)
                                .setIsOngoingRecipeNew(true);
                            Navigator.of(context).pushNamed(
                              RouterNames.NewRecipeScreen,
                              arguments: [
                                category.name,
                                category.colorLightCode,
                                category.id,
                              ],
                            );
                          },
                          elevation: 2.0,
                          // fillColor: Color(0xffF6C2A4),
                          child: Icon(
                            Icons.note_add,
                            size: MediaQuery.of(context).size.width * 0.4,
                            color: Colors.black54,
                          ),
                          // padding: EdgeInsets.all(15.0),
                          shape: CircleBorder(),
                        ),
                        SizedBox(height: 20),
                        Text("No Recipes Created",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 26,
                            )),
                        SizedBox(height: 10),
                        Text(
                            "Jot down a recipe or a dish, add images, describe the instruction and more.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 20,
                            ))
                      ],
                    ),
                  )
                : Column(
                    children: <Widget>[
                      _swiperBuilder(context, category, recipes),
                      SizedBox(
                        height: 50,
                      ),
                      RaisedButton(
                        onPressed: () {
                          // Navigator.of(context).pushNamed(
                          //   RouterNames.RecipeDetailsScreen,
                          //   arguments: recipes[index].id,
                          // );
                          // ;
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
          ],
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
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: RecipeListItem(
              recipes[index],
              category.colorCode,
              selfRestartState,
            ),
          );
        },
        itemCount: recipes.length,
        viewportFraction: 0.6,
        scale: 0.8,
      ),
    );
  }
}
