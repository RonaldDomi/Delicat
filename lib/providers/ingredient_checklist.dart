import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IngredientChecklist with ChangeNotifier {
  Map<String, Set<String>> _checkedIngredients = {};
  SharedPreferences? _prefs;

  Map<String, Set<String>> get checkedIngredients => _checkedIngredients;

  Future<void> initializePreferences() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadCheckedIngredients();
  }

  Future<void> _loadCheckedIngredients() async {
    if (_prefs == null) return;
    
    final keys = _prefs!.getKeys().where((key) => key.startsWith('ingredient_checked_'));
    
    for (String key in keys) {
      final recipeId = key.replaceFirst('ingredient_checked_', '');
      final checkedList = _prefs!.getStringList(key) ?? [];
      _checkedIngredients[recipeId] = checkedList.toSet();
    }
    
    notifyListeners();
  }

  Future<void> _saveCheckedIngredients(String recipeId) async {
    if (_prefs == null) return;
    
    final checkedList = _checkedIngredients[recipeId]?.toList() ?? [];
    await _prefs!.setStringList('ingredient_checked_$recipeId', checkedList);
  }

  bool isIngredientChecked(String recipeId, String ingredient) {
    return _checkedIngredients[recipeId]?.contains(ingredient) ?? false;
  }

  Future<void> toggleIngredient(String recipeId, String ingredient) async {
    if (!_checkedIngredients.containsKey(recipeId)) {
      _checkedIngredients[recipeId] = <String>{};
    }

    if (_checkedIngredients[recipeId]!.contains(ingredient)) {
      _checkedIngredients[recipeId]!.remove(ingredient);
    } else {
      _checkedIngredients[recipeId]!.add(ingredient);
    }

    await _saveCheckedIngredients(recipeId);
    notifyListeners();
  }

  Future<void> resetRecipeIngredients(String recipeId) async {
    _checkedIngredients[recipeId] = <String>{};
    await _saveCheckedIngredients(recipeId);
    notifyListeners();
  }

  Future<void> clearAllData() async {
    if (_prefs == null) return;
    
    final keys = _prefs!.getKeys().where((key) => key.startsWith('ingredient_checked_'));
    for (String key in keys) {
      await _prefs!.remove(key);
    }
    
    _checkedIngredients.clear();
    notifyListeners();
  }
}