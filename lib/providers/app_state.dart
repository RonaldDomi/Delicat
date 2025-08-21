import 'package:delicat/models/category.dart';
import 'package:delicat/models/recipe.dart';
import 'package:flutter/material.dart';

class AppState with ChangeNotifier {
  Category _ongoingCategory = Category.empty();
  Recipe _ongoingRecipe = Recipe.empty();

  String _currentUnsplashPhoto = "";
  String _currentNewRecipePhoto = "";

  bool _isOngoingRecipeNew = true;
  bool _isOngoingCategoryNew = true;

  bool _firstTime = true;

  // ################################ SETTERS ################################ //
  // ################################ SETTERS ################################ //
  // ################################ SETTERS ################################ //

  void setCurrentUnsplashPhoto(String newCategoryPhoto) {
    _currentUnsplashPhoto = newCategoryPhoto;
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
    _currentUnsplashPhoto = "";
  }

  void zeroCurrentRecipePhoto() {
    _currentNewRecipePhoto = "";
  }

  void zeroOngoingCategory() {
    _ongoingCategory = Category.empty();
  }

  void zeroOngoingRecipe() {
    _ongoingRecipe = Recipe.empty();
  }

  void setFirstTime(bool firstTime) {
    _firstTime = firstTime;
  }

  // ################################ GETTERS ################################ //
  // ################################ GETTERS ################################ //
  // ################################ GETTERS ################################ //

  String get currentNewCategoryPhoto {
    return _currentUnsplashPhoto;
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
