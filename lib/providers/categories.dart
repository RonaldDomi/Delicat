import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../models/category.dart';

class Categories with ChangeNotifier {
  //This is the base url for making the api calls
  final baseUrl = 'aws';

  List<Category> _categories = [
    Category(id: 1, name: 'PredefCat 1', colorCode: '0xfff3f3f3'),
    Category(id: 2, name: 'PredefCat 2', colorCode: '0xffa3a3a3'),
  ];
  List<Category> _predefinedCategories = [];

  List<Category> get items {
    return [..._categories];
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

      //in this stage of the development we'll always have an error since the api endpoint is not implemented yet
      //so we take advantage of this error to return some dummy category data

      // HOW IT SHOULD BE
      // _categories = [];

      // _categories.add(Category(id: 1, name: 'Cat 1', colorCode: '#f3f3f3'));
      // _categories.add(Category(id: 2, name: 'Cat 2', colorCode: '#a3a3a3'));
      // _categories.add(Category(id: 3, name: 'Cat 3', colorCode: '#d3d3d3'));

      // DEBUGGING
      // _categories.add(Category(id: 1, name: 'Cat 1', colorCode: '0xfff3f3f3'));
      // _categories.add(Category(id: 2, name: 'Cat 2', colorCode: '0xffa3a3a3'));
      // _categories.add(Category(id: 3, name: 'Cat 3', colorCode: '0xffd3d3d3'));
      // _categories.add(Category(id: 3, name: 'Cat 4', colorCode: '0xff939393'));
      print("-");
      print("--");
      print("---");
      print("provider categories ${_categories}");
      print("before returning: wait 2 seconds");
      await Future.delayed(const Duration(seconds: 2), () {});
      print("---");
      print("--");
      print("-");
      return _categories;
    }
  }

  Future<List<Category>> getAllPredefinedCategories() async {
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
    const url = '/category/predefined';

    try {
      final response = await http.get(url);

      for (var category in json.decode(response.body)) {
        //purge existing categories
        _predefinedCategories = [];
        //then load again with data coming from server

        //now we create a Category model object from the json data
        var predefinedCategoryToAdd =
            Category(name: category.name, colorCode: category.colorCode);

        //finally we add each parsed category object to our master list
        _predefinedCategories.add(predefinedCategoryToAdd);
      }
      notifyListeners();
    } catch (error) {
      //if we have erorr with our request
      // throw error;
      _predefinedCategories = [];
      _predefinedCategories
          .add(Category(id: 41, name: 'PredfCat 1', colorCode: '0xffb30d04'));
      _predefinedCategories
          .add(Category(id: 42, name: 'PredfCat 2', colorCode: '0xffD1B3C4'));
      _predefinedCategories
          .add(Category(id: 43, name: 'PredfCat 3', colorCode: '0xffc03f20'));
      _predefinedCategories
          .add(Category(id: 44, name: 'PredfCat 4', colorCode: '0xff735D78'));
      _predefinedCategories
          .add(Category(id: 45, name: 'PredfCat 5', colorCode: '0xffEDFF86'));
      _predefinedCategories
          .add(Category(id: 46, name: 'PredfCat 6', colorCode: '0xffF3C969'));

      print("-");
      print("--");
      print("---");
      print("provider predefined ${_predefinedCategories}");
      print("before returning: wait 2 seconds");
      await Future.delayed(const Duration(seconds: 2), () {});
      print("---");
      print("--");
      print("-");

      return _predefinedCategories;
    }
  }

  Category getCategoryById(String catId) {
    //Here we rely solely on the memory data. We take for granted that _categories is already loaded with the up-to-date
    //data from the server. For our app, this should work as intended.

    final cat =
        _categories.singleWhere((element) => element.id.toString() == catId);
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
        id: rng.nextInt(1000),
        name: category.name,
        photo: "-",
        colorCode: category.colorCode,
      );
      _categories.add(newCategory);
      notifyListeners();
      print("created a new catogory: current_caterogy_list: $_categories");

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

  Future<void> removeCategory(id) async {
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
        print(
            "In our _categories list, we have updated our category with the new value: ${_categories.firstWhere((element) => element.id == editedCategory.id)}");
      }
      notifyListeners();
    } catch (error) {
      final existingCategoryIndex =
          _categories.indexWhere((element) => element.id == editedCategory.id);
      _categories[existingCategoryIndex] = editedCategory;
      print(
          "In our _categories list, we have updated our category with the new value: ${_categories.firstWhere((element) => element.id == editedCategory.id)}");
      print("now new updated categories: $_categories");
    }
    notifyListeners();
  }
}
