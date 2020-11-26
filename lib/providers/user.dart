import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'package:http/http.dart' as http;

class User with ChangeNotifier {
  String _currentUserUuid;

  String get getCurrentUserUuid {
    return _currentUserUuid;
  }

  void setCurrentUserUuid(String newUuid) {
    _currentUserUuid = newUuid;
  }

  Future<String> createNewUser() async {
    String newUuid = Uuid().v4();
    setCurrentUserUuid(newUuid);

    const url = 'http://54.77.35.193/user';
    try {
      await http.post(url, body: {'uuid': newUuid});
    } catch (error) {
      print("error: $error");
    }

    return newUuid;
  }
}
