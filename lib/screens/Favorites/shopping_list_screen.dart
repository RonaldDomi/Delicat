import 'package:delicat/providers/recipes.dart';
import 'package:delicat/providers/cooking_today.dart';
import 'package:delicat/providers/ingredient_checklist.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShoppingListScreen extends StatelessWidget {
  
  Map<String, int> _aggregateIngredients(List<String> recipeIds, Recipes recipesProvider) {
    final Map<String, int> aggregatedIngredients = {};
    
    for (String recipeId in recipeIds) {
      try {
        final recipe = recipesProvider.getRecipeById(recipeId);
        for (String ingredient in recipe.ingredients) {
          final cleanIngredient = ingredient.trim().toLowerCase();
          if (cleanIngredient.isNotEmpty) {
            aggregatedIngredients[cleanIngredient] = (aggregatedIngredients[cleanIngredient] ?? 0) + 1;
          }
        }
      } catch (e) {
        // Recipe not found, skip
        continue;
      }
    }
    
    return aggregatedIngredients;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xffF6C2A4),
              Color(0xffEED0BE),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Shopping List',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Consumer2<CookingToday, Recipes>(
                      builder: (context, cookingToday, recipes, child) {
                        final recipeCount = cookingToday.count;
                        return Text(
                          'Ingredients from $recipeCount planned recipe${recipeCount == 1 ? '' : 's'}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Consumer3<CookingToday, Recipes, IngredientChecklist>(
                  builder: (context, cookingToday, recipes, ingredientChecklist, child) {
                    if (cookingToday.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.shopping_cart_outlined,
                                size: 60,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'No ingredients to shop',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Add recipes to your cooking today\nlist to generate a shopping list',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    final aggregatedIngredients = _aggregateIngredients(
                      cookingToday.cookingTodayRecipes.toList(), 
                      recipes
                    );
                    
                    if (aggregatedIngredients.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.info_outline,
                                size: 60,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'No ingredients found',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'The planned recipes don\'t have\ningredients listed yet',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    final sortedIngredients = aggregatedIngredients.entries.toList()
                      ..sort((a, b) => a.key.compareTo(b.key));

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.shopping_cart,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  '${sortedIngredients.length} unique ingredients',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: () async {
                                    // Reset all ingredient checkboxes for cooking today recipes
                                    for (String recipeId in cookingToday.cookingTodayRecipes) {
                                      await ingredientChecklist.resetRecipeIngredients(recipeId);
                                    }
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('All items unchecked'),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Reset',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: sortedIngredients.length,
                                itemBuilder: (context, index) {
                                  final ingredient = sortedIngredients[index];
                                  final ingredientName = ingredient.key;
                                  final count = ingredient.value;
                                  
                                  // Check if any recipe has this ingredient checked
                                  bool isAnyChecked = false;
                                  for (String recipeId in cookingToday.cookingTodayRecipes) {
                                    if (ingredientChecklist.isIngredientChecked(recipeId, ingredientName)) {
                                      isAnyChecked = true;
                                      break;
                                    }
                                  }
                                  
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    decoration: BoxDecoration(
                                      color: isAnyChecked 
                                        ? Colors.green.withOpacity(0.1)
                                        : Colors.grey.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: isAnyChecked 
                                          ? Colors.green.withOpacity(0.3)
                                          : Colors.grey.withOpacity(0.2),
                                      ),
                                    ),
                                    child: CheckboxListTile(
                                      value: isAnyChecked,
                                      onChanged: (bool? value) async {
                                        // Toggle for all recipes that have this ingredient
                                        for (String recipeId in cookingToday.cookingTodayRecipes) {
                                          try {
                                            final recipe = recipes.getRecipeById(recipeId);
                                            final hasIngredient = recipe.ingredients.any((ing) => 
                                              ing.trim().toLowerCase() == ingredientName);
                                            
                                            if (hasIngredient) {
                                              await ingredientChecklist.toggleIngredient(recipeId, ingredientName);
                                            }
                                          } catch (e) {
                                            // Recipe not found, skip
                                          }
                                        }
                                      },
                                      title: Text(
                                        ingredientName,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xff8B7355),
                                          decoration: isAnyChecked 
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                        ),
                                      ),
                                      subtitle: count > 1 
                                        ? Text(
                                            'Needed for $count recipes',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600],
                                              decoration: isAnyChecked 
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none,
                                            ),
                                          )
                                        : null,
                                      activeColor: Colors.green,
                                      controlAffinity: ListTileControlAffinity.leading,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
