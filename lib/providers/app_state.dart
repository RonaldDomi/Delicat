import 'package:delicat/models/category.dart';
import 'package:delicat/models/recipe.dart';
import 'package:flutter/material.dart';

class AppState with ChangeNotifier {
  Category _ongoingCategory = Category();
  Recipe _ongoingRecipe = Recipe();

  String _currentNewCategoryPhoto = "";
  String _currentNewRecipePhoto = "";

  bool _isOngoingRecipeNew;
  bool _isOngoingCategoryNew;

  bool _firstTime;

  // ################################ SETTERS ################################ //
  void setCurrentNewCategoryPhoto(String newCategoryPhoto) {
    _currentNewCategoryPhoto = newCategoryPhoto;
  }

  void setCurrentNewRecipePhoto(String newRecipePhoto) {
    _currentNewRecipePhoto = newRecipePhoto;
  }

  void setIsOngoingCategoryNew(bool isNew) {
    _isOngoingCategoryNew = isNew;
  }

  void setIsOngoingRecipeNew(bool isNew) {
    _isOngoingRecipeNew = isNew;
  }

  void setOngoingCategory(Category category) {
    _ongoingCategory = category;
  }

  void setOngoingRecipe(Recipe recipe) {
    _ongoingRecipe = recipe;
  }

  void zeroCurrentCategoryPhoto() {
    _currentNewCategoryPhoto = "";
  }

  void zeroCurrentRecipePhoto() {
    _currentNewRecipePhoto = "";
  }

  void zeroOngoingCategory() {
    _ongoingCategory = Category();
  }

  void zeroOngoingRecipe() {
    _ongoingRecipe = Recipe();
  }

  void setFirstTime(bool firstTime) {
    _firstTime = firstTime;
  }

  // ################################ GETTERS ################################ //
  String get currentNewCategoryPhoto {
    return _currentNewCategoryPhoto;
  }

  String get currentNewRecipePhoto {
    return _currentNewRecipePhoto;
  }

  bool get isOngoingCategoryNew {
    return _isOngoingCategoryNew;
  }

  bool get isOngoingRecipeNew {
    return _isOngoingRecipeNew;
    // return true;
  }

  Category get ongoingCategory {
    return _ongoingCategory;
  }

  Recipe get ongoingRecipe {
    return _ongoingRecipe;
  }

  bool get firstTime {
    return _firstTime;
  }
}
