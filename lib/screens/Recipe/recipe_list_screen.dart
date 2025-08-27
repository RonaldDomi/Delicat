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
        child: SafeArea(
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
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
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
                      // padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    child: const Text(
                      "add a new dish",
                      style: TextStyle(
                        color: Color(0xffF6C2A4),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
