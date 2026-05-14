import 'package:flutter/material.dart';
import 'package:linkaty/features/auth/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  void setUser(UserModel? newUser) {
    _user = newUser;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }


  bool get isLoggedIn => _user != null;
}
