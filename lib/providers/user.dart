// Remove these imports:
// import 'dart:convert';
// import 'package:delicat/constants.dart' as constants;
// import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User with ChangeNotifier {
  String _currentUserId = '';

  String get getCurrentUserId {
    return _currentUserId;
  }

  void setCurrentUserId(String newId) {
    _currentUserId = newId;
    notifyListeners();
  }

  Future<void> createAndSetNewUser() async {
    // Generate local UUID instead of creating user on server
    String username = const Uuid().v4();
    username = username.split("-").join("");
    
    _currentUserId = username;
    
    // Save to local storage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', _currentUserId);
    
    notifyListeners();
  }

  Future<void> loadLocalUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    
    if (userId != null) {
      _currentUserId = userId;
    } else {
      // Create new local user if none exists
      await createAndSetNewUser();
    }
    
    notifyListeners();
  }

  // Helper method to check if user is logged in
  bool get isLoggedIn {
    return _currentUserId.isNotEmpty;
  }

  // Helper method to clear user (logout)
  Future<void> clearUser() async {
    _currentUserId = '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    notifyListeners();
  }
}