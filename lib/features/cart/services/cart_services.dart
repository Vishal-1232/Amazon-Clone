import 'dart:convert';
import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/admin/models/coupon.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/models/user.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class CartServices {
  void removeFromCart({
    required BuildContext context,
    required Product product,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.delete(
        Uri.parse('$baseUrl/api/remove-from-cart/${product.id}'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          User user =
              userProvider.user.copyWith(cart: jsonDecode(res.body)['cart']);
          userProvider.setUserFromModel(user);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<CouponModel?> applyCoupon({
    required BuildContext context,
    required String couponCode,
    required bool onlyCouponCheck,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    // getting cart items
    List<String> cartItems = [];
    for(int i = 0; i < userProvider.user.cart.length; i++){
      var e = userProvider.user.cart[i];
      if(e['isWishlisted']){
        continue;
      }
      cartItems.add(e['product']['_id']);
    }

    try {
      http.Response res = await http.post(
        Uri.parse('$baseUrl/api/v1/coupons/apply?onlyCouponCheck=$onlyCouponCheck'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body:jsonEncode({
          'productId' : cartItems.first,
          'couponCode': couponCode,
        })
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showToast(context, jsonDecode(res.body)['msg']);
        },
      );
      return CouponModel.fromJson(jsonEncode(jsonDecode(res.body)['coupon']));
    } catch (e) {
      print(e);
      return null;
    }
  }
}
