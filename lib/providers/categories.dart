import 'dart:io';

import 'dart:convert';

import 'package:delicat/helpers/db_helper.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../models/category.dart';

class Categories with ChangeNotifier {
  //This is the base url for making the api calls
  final baseUrl = 'aws';

  List<Category> _categories = [];
  List<Category> _predefinedCategories = [];

  List<Category> get items {
    return [..._categories];
  }

  List<Category> get predefinedImtes {
    return [..._predefinedCategories];
  }

  Future<Category> findById(catId){
    print("Not implemented yet.");
    Future.delayed(
      Duration(seconds: 2),
      () => Category(name: "Test Cat", colorCode: "#f3f3f3"),
    );
  }

  Future<void> updateCategory(int id, Category editedCategory){
    Future.delayed(
      Duration(seconds: 2),
      () => print("Not implemented yet."),
    );
  }

  Future<void> createCategory(Category category) async {
    //This function will probably be only invoked from the create category widget/view.
    //In that widget/view we expect to have a full form, and on submitting it this function starts

    //We leave the validation logic in another file, and assume that the information we get here is complete and correct

    //The id will be generated from AWS

    //The rest of information needs to be fed to AWS through a POST request

    //We define the call url

    const url = '/product';

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

  void removeCategory(id) {
    _categories.removeWhere((item) => item.id == id);

    notifyListeners();

    DBHelper.delete('user_categories', id);
  }

  void editCategory(id, Category editedCategory) {
    notifyListeners();

    DBHelper.edit('user_categories', id, {
      'id': editedCategory.id,
      'name': editedCategory.name,
      // 'photo': editedCategory.photo.path,
      'colorCode': editedCategory.colorCode,
    });
  }

  Future<void> fetchAndSetCategories() async {
    final dataList = await DBHelper.getData('user_categories');

    // dataList is a List of objects
    _categories = dataList.map(
      (item) {
        Category createdCategory = Category(
          id: item['id'],
          name: item['name'],
          // photo: File(item['photo']),
          colorCode: item['colorCode'],
        );

        return createdCategory;
      },
    ).toList();
    // toList because the return type of .map() is a lazy Iterable
    notifyListeners();
  }

  void editFirstHitStatus() async {
    final dataList = await DBHelper.getData('app_info');
    Map<String, dynamic> mapRead = dataList.first;

    DBHelper.edit("app_info", "1", {
      "firstTime": mapRead['firstTime'] == 1 ? 0 : 1,
    });
  }

  Future<int> getFirstHitStatus() async {
    final dataList = await DBHelper.getData('app_info');

    // get the first record
    Map<String, dynamic> mapRead = dataList.first;
    return mapRead['firstTime'];
  }
}
