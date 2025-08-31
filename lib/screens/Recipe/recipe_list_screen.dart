import 'package:delicat/helpers/colorHelperFunctions.dart';
import 'package:delicat/routeNames.dart';
import 'package:delicat/providers/app_state.dart';
import 'package:delicat/providers/categories.dart';
import 'package:delicat/providers/recipes.dart';
import 'package:delicat/models/category.dart';
import 'package:delicat/screens/Recipe/components/recipe_list_item.dart';

import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:provider/provider.dart';

class RecipeListScreen extends StatefulWidget {
  final String categoryId;
  const RecipeListScreen({Key? key, required this.categoryId}) : super(key: key);

  @override
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  int _currentRecipeIndex = 0;
  
  void selfRestartState() {
    setState(() {});
  }

  void _showRemoveDialog(BuildContext context, Category category) {
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Category'),
        content: Text('Are you sure you want to remove "${category.name}"? This will delete all recipes in this category.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(true);
              
              // First, get all recipes in this category and remove them (including from favorites)
              final recipes = Provider.of<Recipes>(context, listen: false);
              final categoryRecipes = recipes.getRecipesByCategoryId(category.id);
              
              // Remove each recipe (this will also remove them from favorites)
              for (final recipe in categoryRecipes) {
                await recipes.removeRecipe(recipe.id);
              }
              
              // Then remove the category itself
              await Provider.of<Categories>(context, listen: false)
                  .removeCategory(category.id);
              
              // Navigate back to dashboard after deletion
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text("Remove"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Category? category;
    try {
      category = Provider.of<Categories>(context).getCategoryById(widget.categoryId);
    } catch (e) {
      // Category was deleted, navigate back to dashboard
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      });
      // Return a simple loading widget while navigating
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    final recipes =
        Provider.of<Recipes>(context).getRecipesByCategoryId(widget.categoryId);
    return Container(
        color: hexToColor(category!.colorLightCode),
        child: SafeArea(
          child: Column(
            children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Title with More Menu
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          category.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.black54,
                          size: 28,
                        ),
                        onSelected: (String result) {
                          if (result == 'edit') {
                            Provider.of<AppState>(context, listen: false)
                                .setIsOngoingCategoryNew(false);
                            Provider.of<AppState>(context, listen: false)
                                .setOngoingCategory(category!);
                            Navigator.of(context).pushNamed(
                              RouterNames.NewCategoryScreen,
                            );
                          } else if (result == 'remove') {
                            _showRemoveDialog(context, category!);
                          }
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.edit,
                                  color: hexToColor(category!.colorCode),
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                const Text('Edit Category'),
                              ],
                            ),
                          ),
                          const PopupMenuDivider(),
                          const PopupMenuItem<String>(
                            value: 'remove',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'Remove Category',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      // Random Recipe Button
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [hexToColor(category.colorCode), hexToColor(category.colorLightCode)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final randomRecipe = Provider.of<Recipes>(context, listen: false)
                                .getRandomRecipeByCategory(widget.categoryId);
                            if (randomRecipe != null) {
                              Navigator.of(context).pushNamed(
                                RouterNames.RecipeDetailsScreen,
                                arguments: randomRecipe.id,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          icon: const Icon(
                            Icons.shuffle,
                            color: Colors.white,
                            size: 18,
                          ),
                          label: const Text(
                            "Random Recipe",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      // Add New Recipe Button
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: hexToColor(category.colorCode).withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Provider.of<AppState>(context, listen: false)
                                .setIsOngoingRecipeNew(true);
                            Navigator.of(context).pushNamed(
                              RouterNames.NewRecipeScreen,
                              arguments: [
                                category!.name,
                                category!.colorLightCode,
                                category!.id,
                              ],
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          icon: Icon(
                            Icons.add_circle_outline,
                            color: hexToColor(category.colorCode),
                            size: 20,
                          ),
                          label: Text(
                            "Add New Dish",
                            style: TextStyle(
                              color: hexToColor(category.colorCode),
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            (recipes.isEmpty)
                ? Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
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
                                category!.name,
                                category!.colorLightCode,
                                category!.id,
                              ],
                            );
                          },
                          elevation: 2.0,
                          shape: const CircleBorder(),
                          child: Icon(
                            Icons.restaurant_menu,
                            size: MediaQuery.of(context).size.width * 0.3,
                            color: Colors.orange.shade300,
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text("Your Recipe Collection Awaits!",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            )),
                        const SizedBox(height: 15),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40.0),
                          child: Text(
                              "Start building your culinary library! Tap above to add your first delicious recipe with photos and step-by-step instructions.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                                height: 1.4,
                              )),
                        )
                        ],
                      ),
                    ),
                  )
                : Expanded(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: _swiperBuilder(context, category, recipes),
                        ),
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: ElevatedButton(
                          onPressed: () {
                            if (recipes.isNotEmpty) {
                              Navigator.of(context).pushNamed(
                                RouterNames.RecipeDetailsScreen,
                                arguments: recipes[_currentRecipeIndex].id,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            backgroundColor: hexToColor(category.colorCode),
                          ),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: const Text(
                              "Read More",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        )
                      ],
                    ),
                  ),
          ],
        ),
        ),
    );
  }

  Widget _swiperBuilder(BuildContext context, category, recipes) {
    return SizedBox(
      height: double.infinity,
      child: Swiper(
        loop: false,
        onIndexChanged: (index) {
          setState(() {
            _currentRecipeIndex = index;
          });
        },
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
