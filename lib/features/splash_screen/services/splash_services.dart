// Provider.of<UserProvider>(context).user.token.isNotEmpty
//           ? Provider.of<UserProvider>(context).user.type == 'user'
//               ? const BottomBar()
//               : const AdminScreen()
//           : const AuthScreen()

import 'dart:async';

import 'package:amazon_clone/common/widgets/bottom_bar.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/admin/screens/admin_screen.dart';
import 'package:amazon_clone/features/auth/screens/auth_screen.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../auth/services/auth_service.dart';

class SplashServices {
  final _authService = AuthService();
  Future<void> isLogin(BuildContext context) async {
    try{
      await _authService.getUserData(context);
      final user = Provider.of<UserProvider>(context,listen: false).user;

      if(user.token.isNotEmpty){
        if(user.type=='user'){
          Navigator.pushReplacementNamed(context, BottomBar.routeName);
        }else if(user.type=='admin'){
          Navigator.pushReplacementNamed(context, AdminScreen.routeName);
        }
      }else{
        Navigator.pushReplacementNamed(context, AuthScreen.routeName);
      }
    }
    catch (e){
      showSnackBar(context, e.toString());
    }
  }
}
