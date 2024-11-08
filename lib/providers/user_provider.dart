import 'package:amazon_clone/models/user.dart';
import 'package:flutter/material.dart';

import '../features/admin/models/coupon.dart';

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

  // cart management
  double _discount = 0;
  CouponModel? _coupon;
  CouponModel? get coupon => _coupon;
  double get cartTotalAmount {
    double sum = 0;
    for (var e in user.cart) {
      if (!e['isWishlisted']) {
        sum += (e['quantity'] as int) * (e['product']['price'] as int);
      }
    }
    return sum-_discount;
  }
  // Apply discount from coupon
  void applyCoupon(double discountAmount, CouponModel? coupon) {
    _discount = discountAmount;
    _coupon = coupon;
    notifyListeners();
  }
}
