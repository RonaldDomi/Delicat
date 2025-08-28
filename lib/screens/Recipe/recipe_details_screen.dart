import 'package:delicat/helpers/colorHelperFunctions.dart';
import 'package:delicat/providers/app_state.dart';
import 'package:delicat/routeNames.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:delicat/helpers/image_helper.dart';

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
  PanelController _panelController = PanelController();
  bool _isPanelOpen = false;

  @override
  Widget build(BuildContext context) {
    final recipe = Provider.of<Recipes>(context).getRecipeById(widget.recipeId);
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
                    onPressed: () {
                      Provider.of<Recipes>(context, listen: false).toggleFavorite(widget.recipeId);
                      setState(() {});
                      Navigator.pop(context);
                    },
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
                    onPressed: () {
                      Navigator.pop(context);
                    },
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
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
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
                  value: 5,
                  child: RawMaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
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
                  image: ImageHelper.getImageProvider(recipe.photo),
                ),
              ),
            ),
          SlidingUpPanel(
            controller: _panelController,
            minHeight: 100,
            maxHeight: MediaQuery.of(context).size.height * 0.65,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18.0),
              topRight: Radius.circular(18.0),
            ),
            onPanelOpened: () {
              setState(() {
                _isPanelOpen = true;
              });
            },
            onPanelClosed: () {
              setState(() {
                _isPanelOpen = false;
              });
            },
            panelBuilder: (sc) => _panel(sc, recipe, category.colorCode),
          ),
          Positioned(
            right: 20,
            bottom: 120,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: hexToColor(category.colorCode),
              onPressed: () {
                if (_isPanelOpen) {
                  _panelController.close();
                } else {
                  _panelController.open();
                }
              },
              child: Icon(
                _isPanelOpen ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
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
                  color: hexToColor("#FFFFFF"),
                  fontSize: 40,
                ),
              ),
            ),
            
            // Ingredients Section
            if (recipe.ingredients.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30.0),
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Ingredients",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff8B7355),
                      ),
                    ),
                    const SizedBox(height: 15),
                    ...recipe.ingredients.asMap().entries.map((entry) {
                      String ingredient = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 6, right: 12),
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Color(0xffF6C2A4),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                ingredient,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff5D4E37),
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            
            const SizedBox(height: 20),
            
            Container(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                recipe.description,
                style: TextStyle(
                  color: hexToColor("#FFFFFF"),
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
