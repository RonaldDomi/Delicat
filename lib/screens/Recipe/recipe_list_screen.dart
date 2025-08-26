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
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "${category.name} Catalogue",
                    style: const TextStyle(
                      fontSize: 23,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () async {
                          await Provider.of<Categories>(context, listen: false)
                              .removeCategory(category!.id);
                          // Navigate back to dashboard after deletion
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                        child: const Text(
                          "Remove Category",
                          style: TextStyle(
                            color: Color(0xffF6C2A4),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Provider.of<AppState>(context, listen: false)
                              .setIsOngoingCategoryNew(false);
                          Provider.of<AppState>(context, listen: false)
                              .setOngoingCategory(category!);
                          Navigator.of(context).pushNamed(
                            RouterNames.NewCategoryScreen,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                        child: const Text(
                          "Edit Category",
                          style: TextStyle(
                            color: Color(0xffF6C2A4),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
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
                      backgroundColor: Colors.white,
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    child: const Text(
                      "add a new dish",
                      style: TextStyle(
                        color: Color(0xffF6C2A4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            (recipes.isEmpty)
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
                                category!.name,
                                category!.colorLightCode,
                                category!.id,
                              ],
                            );
                          },
                          elevation: 2.0,
                          shape: const CircleBorder(),
                          child: Icon(
                            Icons.note_add,
                            size: MediaQuery.of(context).size.width * 0.4,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text("No Recipes Created",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 26,
                            )),
                        const SizedBox(height: 10),
                        const Text(
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
                      const SizedBox(height: 50),
                      ElevatedButton(
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
                      )
                    ],
                  ),
          ],
        ),
    );
  }

  Widget _swiperBuilder(BuildContext context, category, recipes) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Swiper(
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