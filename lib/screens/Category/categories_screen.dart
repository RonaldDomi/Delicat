import 'package:delicat/models/category.dart';
import 'package:delicat/providers/app_state.dart';
import 'package:delicat/providers/categories.dart';
import 'package:delicat/providers/recipes.dart';
import 'package:delicat/routeNames.dart';
import 'package:delicat/screens/Category/components/categories_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  Future<bool> _onBackPressed() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to exit an App'),
        actions: <Widget>[
          GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: const Text("NO"),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(true),
            child: const Text("YES"),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    List<Category> allCategories =
        Provider.of<Categories>(context).categories;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          final shouldPop = await _onBackPressed();
          if (shouldPop && context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Container(
        color: const Color(0xffF1EBE8),
        child: SafeArea(   // ✅ SafeArea added here
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      "Your Menu",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff8B7355),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xffF6C2A4), Color(0xffEED0BE)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              final recipes =
                                  Provider.of<Recipes>(context, listen: false);
                              final randomRecipe =
                                  recipes.getRandomRecipe();
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            icon: const Icon(
                              Icons.shuffle,
                              color: Colors.white,
                              size: 20,
                            ),
                            label: const Text(
                              "Random Recipe",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        // Add Category Button
                        ElevatedButton.icon(
                          onPressed: () {
                            Provider.of<AppState>(context, listen: false)
                                .setIsOngoingCategoryNew(true);
                            Navigator.of(context)
                                .pushNamed(RouterNames.NewCategoryScreen);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 6,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          icon: const Icon(
                            Icons.add,
                            color: Color(0xffF6C2A4),
                            size: 20,
                          ),
                          label: const Text(
                            "New Category",
                            style: TextStyle(
                              color: Color(0xffF6C2A4),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              (allCategories.isEmpty)
                  ? Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.restaurant_menu,
                                size: 60,
                                color: Color(0xffF6C2A4),
                              ),
                            ),
                            const SizedBox(height: 30),
                            const Text(
                              "No Categories Yet",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff927C6C),
                              ),
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              "Start building your recipe collection\nby creating your first category",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff927C6C),
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 40),
                            ElevatedButton(
                              onPressed: () {
                                Provider.of<AppState>(context, listen: false)
                                    .setIsOngoingCategoryNew(true);
                                Navigator.of(context)
                                    .pushNamed(RouterNames.NewCategoryScreen);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffF6C2A4),
                                elevation: 8,
                                shadowColor: Colors.black.withOpacity(0.3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 15,
                                ),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                  SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      "Create Your First Catalog",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 180,
                          childAspectRatio: 2 / 2.6,
                          crossAxisSpacing: 30,
                          mainAxisSpacing: 30,
                        ),
                        padding: const EdgeInsets.all(30),
                        itemCount: allCategories.length,
                        itemBuilder: (ctx, i) => InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              RouterNames.RecipeListScreen,
                              arguments: allCategories[i].id,
                            );
                          },
                          child: CategoryItem(allCategories[i]),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

