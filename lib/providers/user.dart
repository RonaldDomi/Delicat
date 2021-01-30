import 'dart:convert';

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
    const url = 'http://54.195.158.131/user';
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
