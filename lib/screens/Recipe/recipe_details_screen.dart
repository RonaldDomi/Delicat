import 'package:delicat/helpers/colorHelperFunctions.dart';
import 'package:delicat/providers/app_state.dart';
import 'package:delicat/routeNames.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:delicat/helpers/image_helper.dart';

import '../../providers/recipes.dart';
import '../../providers/categories.dart';
import '../../providers/ingredient_checklist.dart';
import '../../providers/cooking_today.dart';
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
    final cookingToday = Provider.of<CookingToday>(context);
    
    // Safe category lookup - return error screen if category doesn't exist
    late final category;
    try {
      category = Provider.of<Categories>(context).getCategoryById(recipe.categoryId);
    } catch (e) {
      // Category was deleted, show error message
      return Scaffold(
        appBar: AppBar(title: const Text('Recipe Not Available')),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'This recipe\'s category has been deleted.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

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
                  value: 6,
                  child: RawMaterialButton(
                    onPressed: () async {
                      await cookingToday.toggleRecipe(widget.recipeId);
                      setState(() {});
                      Navigator.pop(context);
                    },
                    elevation: 2.0,
                    fillColor: const Color(0xffF6C2A4),
                    shape: const CircleBorder(),
                    child: Icon(
                      cookingToday.isRecipeInCookingToday(widget.recipeId)
                          ? Icons.today
                          : Icons.today_outlined,
                      size: 35.0,
                      color: Colors.white,
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
              Consumer<IngredientChecklist>(
                builder: (context, checklist, child) {
                  return Container(
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
                        // Header with title and reset button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Ingredients",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff8B7355),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () async {
                                await checklist.resetRecipeIngredients(recipe.id);
                              },
                              icon: const Icon(
                                Icons.refresh,
                                size: 18,
                                color: Color(0xffF6C2A4),
                              ),
                              label: const Text(
                                "Reset",
                                style: TextStyle(
                                  color: Color(0xffF6C2A4),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Ingredients list with checkboxes
                        ...recipe.ingredients.asMap().entries.map((entry) {
                          String ingredient = entry.value;
                          bool isChecked = checklist.isIngredientChecked(recipe.id, ingredient);
                          
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 2.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Checkbox
                                Transform.scale(
                                  scale: 0.8,
                                  child: Checkbox(
                                    value: isChecked,
                                    onChanged: (value) async {
                                      await checklist.toggleIngredient(recipe.id, ingredient);
                                    },
                                    activeColor: const Color(0xffF6C2A4),
                                    checkColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                ),
                                // Ingredient text
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Text(
                                      ingredient,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: isChecked 
                                          ? const Color(0xff5D4E37).withOpacity(0.6)
                                          : const Color(0xff5D4E37),
                                        height: 1.4,
                                        decoration: isChecked 
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  );
                },
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
