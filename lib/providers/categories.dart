import 'dart:convert';
import 'dart:math';

import 'package:tinycolor/tinycolor.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../helpers/db_helper.dart';
import '../helperFunctions.dart';
import '../models/category.dart';

class Categories with ChangeNotifier {
  //This is the base url for making the api calls
  final baseUrl = 'aws';

  Category ongoingCategory = Category();
  String _currentNewCategoryPhoto = "";

  List<Category> _categories = [];

  List<Category> _predefinedCategories = [
    Category(
      id: "42",
      name: 'Dessert',
      colorCode: '#E5C1CB',
      photo: "assets/photos/dessert-circle.png",
      colorLightCode: colorToHex(TinyColor(
        hexToColor("#E5C1CB"),
      ).brighten(14).color),
    ),
    Category(
      id: "43",
      name: 'Vegetable',
      colorCode: '#DDE5B0',
      colorLightCode: colorToHex(TinyColor(
        hexToColor("#DDE5B0"),
      ).brighten(14).color),
      photo: "assets/photos/vegetable-circle.png",
    ),
    Category(
      id: "44",
      name: 'Breakfast',
      colorCode: '#ABBFB5',
      colorLightCode: colorToHex(TinyColor(
        hexToColor("#ABBFB5"),
      ).brighten(14).color),
      photo: "assets/photos/breakfast-circle.png",
    ),
    Category(
      id: "45",
      name: 'Burger',
      colorCode: '#1B2E46',
      colorLightCode: colorToHex(TinyColor(
        hexToColor("#1B2E46"),
      ).brighten(14).color),
      photo: "assets/photos/burgers-circle.png",
    ),
  ];

  List<Category> get items {
    return [..._categories];
  }

  String get currentNewCategoryPhoto {
    return _currentNewCategoryPhoto;
  }

  String setCurrentNewCategoryPhoto(String newPhoto) {
    _currentNewCategoryPhoto = newPhoto;
  }

  String getCurrentNewCategoryPhoto() {
    return _currentNewCategoryPhoto;
  }

  void zeroCurrentPhoto() {
    _currentNewCategoryPhoto = "";
  }

  void setOngoingCategory(Category category) {
    ongoingCategory = category;
  }

  Category getOngoingCategory() {
    return ongoingCategory;
  }

  void zeroOngoingCategory() {
    ongoingCategory = Category();
  }

  List<Category> get predefinedItems {
    return [..._predefinedCategories];
  }

  Future<List<Category>> getAllCategories() async {
    // AWS should try and give us something of the shape:
    // [
    //   { 'uid' : 'x',
    //   'name' : 'x',
    //   'photo' : 'x',
    //   'colorCode' : 'x',
    //   'recipes' : [{}{}]
    //   },
    //  { another cateogry object ... }
    // ]
    const url = '/category/all';

    try {
      final response = await http.get(url);

      for (var category in json.decode(response.body)) {
        //purge existing categories
        _categories = [];
        //then load again with data coming from server

        //now we create a Category model object from the json data
        var categoryToAdd =
            Category(name: category.name, colorCode: category.colorCode);

        //finally we add each parsed category object to our master list
        _categories.add(categoryToAdd);
      }
      notifyListeners();
    } catch (error) {
      //if we have erorr with our request
      // throw error;
      await Future.delayed(const Duration(milliseconds: 250), () {});

      final dataList = await DBHelper.getData('category');
      _categories = dataList
          .map(
            (item) => Category(
              id: item['id'],
              colorCode: item['color_code'],
              colorLightCode: item['color_code_light'],
              name: item['name'],
              photo: item['photo'],
            ),
          )
          .toList();
      print("categories: $_categories");
      return _categories;
    }
  }

  Category getCategoryById(String catId) {
    //Here we rely solely on the memory data. We take for granted that _categories is already loaded with the up-to-date
    //data from the server. For our app, this should work as intended.

    final cat = _categories.singleWhere((element) => element.id == catId);
    //When we will have the option to share recipes online, we will have to implement this with api, but only for recipes. This version is MVP 1 consistent
    return cat;
  }

  Future<void> createCategory(Category category) async {
    //This function will probably be only invoked from the create category widget/view.
    //In that widget/view we expect to have a full form, and on submitting it this function starts

    //We leave the validation logic in another file, and assume that the information we get here is complete and correct

    //The id will be generated from AWS

    //The rest of information needs to be fed to AWS through a POST request

    //We define the call url

    const url = '/category';

    //a future is automatically returned since we're using 'async' as function signature
    try {
      final response = await http.post(url,
          body: json.encode({
            'name': category.name,
            'colorCode': category.colorCode,
            'photo': category.photo
          }));

      final newCategory = Category(
          //it is important that we get the id from the server with this response on the cateogyr creation endpoint
          id: json.decode(response.body)['id'],
          name: category.name,
          colorCode: category.colorCode,
          photo: category.photo);
      _categories.add(newCategory);
      notifyListeners();
    } catch (error) {
      print("error: no api call implemented. manually creating...");
      var rng = new Random();
      final newCategory = Category(
        id: rng.nextInt(1000).toString(),
        name: category.name,
        photo: category.photo,
        colorCode: category.colorCode,
        colorLightCode: category.colorLightCode,
      );
      _categories.add(newCategory);
      DBHelper.insert('category', {
        "id": newCategory.id,
        "name": newCategory.name,
        // "photo": newCategory.photo.path,
        "photo": newCategory.photo,
        "color_code": newCategory.colorCode,
        "color_code_light": newCategory.colorLightCode,
      });
      final dataList = await DBHelper.getData('category');

      notifyListeners();

      // throw error; //throws the error to the frontend so it can be handled there
      //Provider....createCategory()...catchError((error){
      // showDialog(context: context, builder: (ctx) => AlertDialog(title: Text("An error occured"), content: Text("An error occured"), actions: <Widget>[FlatButton(child: Text("ok"), onPressed: (){Navigator.of(context).pop();})])
      // })
      // see episode 11 for more details
    }

    //the return of Future is to allow the frontend to show a loading indicator while the api call is in progress
    //Where Navigator.pop() exists, it should be changed to:
    //Provider.of<Products>(context).createCategory(_newCategory).then((_){
    //    Navigator.of(context).pop()
    // })
    //see chapter 10 episode 10 for how to fully implement in frontend
  }

  Future<void> removeCategory(String id) async {
    final url = '/category/$id';
    try {
      final response = await http.delete(url);

      _categories.removeWhere((item) =>
          item.id ==
          id); //here we assume response finished correctly, maybe additional checks needed
    } catch (error) {
      _categories.removeWhere((item) =>
          item.id ==
          id); //here we assume response finished correctly, maybe additional checks needed
    }

    notifyListeners();
  }

  Future<void> editCategory(Category editedCategory) async {
    final url = '/category/${editedCategory.id}';
    try {
      final response = await http.put(url, body: {
        'name': editedCategory.name,
        'colorCode': editedCategory.colorCode,
      });

      Category existingCategory = _categories.firstWhere(
          (element) =>
              element.id ==
              json.decode(response.body)[
                  'id'], //here we'd actually like to use the response from the server,
          //just to make sure what we're updating the list with is a category coming from the server, not from what it's supposed to be from the frontend
          orElse: () => null);
      if (existingCategory == null) {
        // means orElse executed, and this element is not found
        print("This category doesn't exist in _categories. Issue. ");
      } else {
        print("error: no api call implemented");
        existingCategory = new Category(
            id: json.decode(response.body)['id'],
            name: json.decode(response.body)['name'],
            colorCode: json.decode(response.body)[
                'colorCode']); // here we make the pointer of the exsisting category inside _categories to point to a new Category object
        //hopefully updated correctly
      }
      notifyListeners();
    } catch (error) {
      final existingCategoryIndex =
          _categories.indexWhere((element) => element.id == editedCategory.id);
      _categories[existingCategoryIndex] = editedCategory;
      DBHelper.edit('category', editedCategory.id, {
        "id": editedCategory.id,
        "name": editedCategory.name,
        // "photo": editedCategory.photo.path,
        "photo": editedCategory.photo,
        "color_code": editedCategory.colorCode,
        "color_code_light": editedCategory.colorLightCode,
      });
    }

    notifyListeners();
  }
}
