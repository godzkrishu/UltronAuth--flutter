import 'package:flutter/material.dart';
import 'package:ultron/models/user.dart';
import 'dart:convert';  // Import for jsonDecode

// This class manages the state of the user across the screens
class UserProvider extends ChangeNotifier {
  // Create a private user
  User _user = User(
    id: '',
    email: '',
    name: '',
    password: '',
    stamp: '',
  );

  // Getter function to fetch the private user across various screens
  User get user => _user;

  // Setter function to update the user data across all screens
  void setUser(dynamic user) {
    try {
      if (user is String) {
        // If the user is a JSON string, decode it
        _user = User.fromJson(user);
      } else if (user is Map<String, dynamic>) {
        // If the user is already a Map, directly use fromDBtoApp
        _user = User.fromDBtoApp(user);
      }
      notifyListeners(); // Notify all screens of the change in user value
    } catch (e) {
      print("Error while setting user data: $e");
    }
  }
  // Function to clear the user data (for logout functionality)
  void clearUser() {
    _user = User(
        id: "",
        email: "",
        name: "",
        password: "",
        stamp: ""
    );
    notifyListeners();  // Notify all screens that user data is cleared
  }
}
