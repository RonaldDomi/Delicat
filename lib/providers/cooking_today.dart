import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CookingToday with ChangeNotifier {
  Set<String> _cookingTodayRecipes = <String>{};
  SharedPreferences? _prefs;

  Set<String> get cookingTodayRecipes => Set.unmodifiable(_cookingTodayRecipes);

  Future<void> initializePreferences() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadCookingTodayRecipes();
  }

  Future<void> _loadCookingTodayRecipes() async {
    if (_prefs == null) return;
    
    final recipeIds = _prefs!.getStringList('cooking_today_recipes') ?? [];
    _cookingTodayRecipes = recipeIds.toSet();
    
    notifyListeners();
  }

  Future<void> _saveCookingTodayRecipes() async {
    if (_prefs == null) return;
    
    await _prefs!.setStringList('cooking_today_recipes', _cookingTodayRecipes.toList());
  }

  bool isRecipeInCookingToday(String recipeId) {
    return _cookingTodayRecipes.contains(recipeId);
  }

  Future<void> toggleRecipe(String recipeId) async {
    if (_cookingTodayRecipes.contains(recipeId)) {
      _cookingTodayRecipes.remove(recipeId);
    } else {
      _cookingTodayRecipes.add(recipeId);
    }

    await _saveCookingTodayRecipes();
    notifyListeners();
  }

  Future<void> addRecipe(String recipeId) async {
    if (!_cookingTodayRecipes.contains(recipeId)) {
      _cookingTodayRecipes.add(recipeId);
      await _saveCookingTodayRecipes();
      notifyListeners();
    }
  }

  Future<void> removeRecipe(String recipeId) async {
    if (_cookingTodayRecipes.contains(recipeId)) {
      _cookingTodayRecipes.remove(recipeId);
      await _saveCookingTodayRecipes();
      notifyListeners();
    }
  }

  Future<void> clearAll() async {
    _cookingTodayRecipes.clear();
    await _saveCookingTodayRecipes();
    notifyListeners();
  }

  int get count => _cookingTodayRecipes.length;

  bool get isEmpty => _cookingTodayRecipes.isEmpty;
  bool get isNotEmpty => _cookingTodayRecipes.isNotEmpty;

  Future<void> cleanupOrphanedRecipes(Set<String> validRecipeIds) async {
    final recipesToRemove = _cookingTodayRecipes.where((recipeId) => !validRecipeIds.contains(recipeId)).toList();
    
    for (String recipeId in recipesToRemove) {
      _cookingTodayRecipes.remove(recipeId);
    }
    
    if (recipesToRemove.isNotEmpty) {
      await _saveCookingTodayRecipes();
      notifyListeners();
    }
  }
}