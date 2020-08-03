import 'package:delicat/helperFunctions.dart';
import 'package:delicat/routeNames.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../providers/recipes.dart';
import '../providers/categories.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../models/recipe.dart';

class RecipeDetailsScreen extends StatefulWidget {
  final String recipeId;
  RecipeDetailsScreen({this.recipeId});

  @override
  _RecipeDetailsScreenState createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final recipe = Provider.of<Recipes>(context).getRecipeById(widget.recipeId);
    final category =
        Provider.of<Categories>(context).getCategoryById(recipe.categoryId);

    void onEdit() {
      Provider.of<Recipes>(context, listen: false).setOngoingRecipe(recipe);
      Provider.of<Recipes>(context, listen: false).setIsNew(false);

      Navigator.of(context).pushNamed(
        RouterNames.NewRecipeScreen,
        arguments: [
          category.name,
          category.colorLightCode,
          category.id,
        ],
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Color(0x44000000),
        elevation: 0,
        actions: <Widget>[
          PopupMenuButton(
            // child: Icon(Icons.more_horiz),
            color: Colors.transparent,
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: 3,
                  child: RawMaterialButton(
                    onPressed: () {
                      onEdit();
                    },
                    elevation: 2.0,
                    fillColor: Color(0xffF6C2A4),
                    child: Icon(
                      Icons.edit,
                      size: 35.0,
                      color: Colors.black,
                    ),
                    // padding: EdgeInsets.all(15.0),
                    shape: CircleBorder(),
                  ),
                ),
                PopupMenuItem(
                  value: 2,
                  child: RawMaterialButton(
                    onPressed: () {},
                    elevation: 2.0,
                    fillColor: Color(0xffF6C2A4),
                    child: Icon(
                      recipe.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      size: 35.0,
                      color: Colors.white,
                    ),
                    // padding: EdgeInsets.all(15.0),
                    shape: CircleBorder(),
                  ),
                ),
                PopupMenuItem(
                  value: 3,
                  child: RawMaterialButton(
                    onPressed: () {},
                    elevation: 2.0,
                    fillColor: hexToColor(category.colorCode),
                    child: Icon(
                      Icons.receipt,
                      size: 35.0,
                      color: Colors.black,
                    ),
                    // padding: EdgeInsets.all(15.0),
                    shape: CircleBorder(),
                  ),
                ),
                PopupMenuItem(
                  value: 4,
                  child: RawMaterialButton(
                    onPressed: () {},
                    elevation: 2.0,
                    fillColor: hexToColor(category.colorCode),
                    child: Icon(
                      Icons.home,
                      size: 35.0,
                      color: Colors.black,
                    ),
                    // padding: EdgeInsets.all(15.0),
                    shape: CircleBorder(),
                  ),
                ),
                PopupMenuItem(
                  value: 4,
                  child: RawMaterialButton(
                    onPressed: () {},
                    elevation: 2.0,
                    fillColor: hexToColor(category.colorCode),
                    child: Icon(
                      Icons.share,
                      size: 35.0,
                      color: Colors.black,
                    ),
                    // padding: EdgeInsets.all(15.0),
                    shape: CircleBorder(),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                // image: AssetImage("assets/photos/veggies.jpg"),
                image: FileImage(
                  File(recipe.photo),
                ),
              ),
            ),
          ),
          SlidingUpPanel(
            minHeight: 40,
            maxHeight: MediaQuery.of(context).size.height * 0.5,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18.0),
              topRight: Radius.circular(18.0),
            ),
            panelBuilder: (sc) => _panel(sc, recipe, category.colorCode),
          )
        ],
      ),
    );
  }

  Widget _panel(ScrollController sc, Recipe recipe, String colorCode) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18.0),
            topRight: Radius.circular(18.0),
          ),
          color: hexToColor(colorCode),
        ),
        child: ListView(
          controller: sc,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                recipe.name,
                style: TextStyle(
                  color: hexToColor("#9F8A22"),
                  fontSize: 30,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                recipe.description,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
