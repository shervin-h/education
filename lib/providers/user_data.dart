import 'package:flutter/material.dart';
import 'package:education/models/user.dart';
import 'package:education/helpers/preferences.dart';

class UserData extends ChangeNotifier{

  User? user;

  void setUser(User user) {
    this.user = user;
    notifyListeners();
  }

  void removeUser() {
    user = null;
    notifyListeners();
  }
}