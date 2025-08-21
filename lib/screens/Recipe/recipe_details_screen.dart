import 'package:delicat/helpers/colorHelperFunctions.dart';
import 'package:delicat/providers/app_state.dart';
import 'package:delicat/routeNames.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../../providers/recipes.dart';
import '../../providers/categories.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../models/recipe.dart';

class RecipeDetailsScreen extends StatefulWidget {
  final String recipeId;
  const RecipeDetailsScreen({Key? key, required this.recipeId}) : super(key: key);

  @override
  _RecipeDetailsScreenState createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final recipe = Provider.of<Recipes>(context).getRecipeById(widget.recipeId);
    recipe.isFavorite = false;
    final category = Provider.of<Categories>(context).getCategoryById(recipe.categoryId);

    void onEdit() {
      Provider.of<AppState>(context, listen: false).setOngoingRecipe(recipe);
      Provider.of<AppState>(context, listen: false).setIsOngoingRecipeNew(false);

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
        backgroundColor: const Color(0x44000000),
        elevation: 0,
        actions: <Widget>[
          PopupMenuButton(
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
                    fillColor: const Color(0xffF6C2A4),
                    shape: const CircleBorder(),
                    child: const Icon(
                      Icons.edit,
                      size: 35.0,
                      color: Colors.black,
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: 2,
                  child: RawMaterialButton(
                    onPressed: () {},
                    elevation: 2.0,
                    fillColor: const Color(0xffF6C2A4),
                    shape: const CircleBorder(),
                    child: Icon(
                      recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
                      size: 35.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: 3,
                  child: RawMaterialButton(
                    onPressed: () {},
                    elevation: 2.0,
                    fillColor: hexToColor(category.colorCode),
                    shape: const CircleBorder(),
                    child: const Icon(
                      Icons.receipt,
                      size: 35.0,
                      color: Colors.black,
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: 4,
                  child: RawMaterialButton(
                    onPressed: () {},
                    elevation: 2.0,
                    fillColor: hexToColor(category.colorCode),
                    shape: const CircleBorder(),
                    child: const Icon(
                      Icons.home,
                      size: 35.0,
                      color: Colors.black,
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: 4,
                  child: RawMaterialButton(
                    onPressed: () {},
                    elevation: 2.0,
                    fillColor: hexToColor(category.colorCode),
                    shape: const CircleBorder(),
                    child: const Icon(
                      Icons.share,
                      size: 35.0,
                      color: Colors.black,
                    ),
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
          if (recipe.photo != null)
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(recipe.photo!),
                ),
              ),
            ),
          SlidingUpPanel(
            minHeight: 40,
            maxHeight: MediaQuery.of(context).size.height * 0.5,
            borderRadius: const BorderRadius.only(
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
          borderRadius: const BorderRadius.only(
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
                style: const TextStyle(
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