import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:amazon_clone/common/widgets/bottom_bar.dart';
import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/admin/screens/admin_screen.dart';
import 'package:amazon_clone/features/splash_screen/services/splash_services.dart';
import 'package:amazon_clone/models/user.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // redirect user based on his role
  static redirectUser(BuildContext context, String userType){
    if(userType=='user'){
      Navigator.pushReplacementNamed(context, BottomBar.routeName);
    }else if(userType=='admin'){
      Navigator.pushReplacementNamed(context, AdminScreen.routeName);
    }
  }

  // sign-up User
  signUpUser(
      {required BuildContext context,
      required String email,
      required String password,
      required String name}) async {
    try {
      User user = User(
        id: "",
        name: name,
        email: email,
        password: password,
        address: "",
        type: "",
        token: "",
        cart: [],
      );
      http.Response res = await http.post(Uri.parse("$baseUrl/api/signup"),
          body: user.toJson(),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(
                context, "Account created! Login with same credentials!");
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // sign-in User
  signInUser(
      {required BuildContext context,
      required String email,
      required String password}) async {
    try {
      http.Response res = await http.post(Uri.parse("$baseUrl/api/signin"),
          body: jsonEncode({'email': email, 'password': password}),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString(
                "x-auth-token", jsonDecode(res.body)['token']);

            final userProvider = Provider.of<UserProvider>(context,listen: false);
            userProvider.setUser(res.body);
            redirectUser(context, userProvider.user.type);
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // get user data
  Future<void> getUserData(
    BuildContext context,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        await prefs.setString('x-auth-token', '');
      }

      var tokenRes = await http.post(
        Uri.parse('$baseUrl/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!
        },
      );

      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        http.Response userRes = await http.get(
          Uri.parse('$baseUrl/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
        );
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userRes.body);
      }
    } on SocketException catch (_) {
      showSnackBar(context, "Server is unreachable. Please check your connection or try again later.");
    }
    on TimeoutException catch(e) {
      showSnackBar(context, "Request timed out. Please check your internet connection and try again.");
    }
    catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
