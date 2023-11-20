import 'package:amazon_clone/models/user.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
    id: '',
    name: '',
    email: '',
    password: '',
    address: '',
    type: '',
    token: '',
    cart: [],
  );

  User get user => _user;

  setUser(String user) {
    _user = User.fromJson(user);
    notifyListeners();
  }

  setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }
}
