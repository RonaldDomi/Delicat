import 'dart:convert';

import 'package:delicat/constants.dart' as constants;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class User with ChangeNotifier {
  String _currentUserId;

  String get getCurrentUserId {
    return _currentUserId;
  }

  void setCurrentUserId(String newId) {
    _currentUserId = newId;
  }

  void createAndSetNewUser() async {
    String url = constants.url + '/user';
    String username = Uuid().v4();
    username = username.split("-").join("");
    Map<String, String> headers = {"Content-type": "application/json"};
    String body = json.encode({
      "username": username,
      "password": "password",
    });
    try {
      var response = await http.post(url, headers: headers, body: body);
      _currentUserId = json.decode(response.body)["_id"];
    } catch (error) {
      print("error: $error");
    }
  }
}
