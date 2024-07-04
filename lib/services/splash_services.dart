import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasse_practice/view/home_screen.dart';
import 'package:firebasse_practice/view/login_screen.dart';
import 'package:flutter/material.dart';

class SplashServices {

  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if (user != null) {
    Timer(Duration(seconds: 5),()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen())));
    }
    else
      {
        Timer(Duration(seconds: 5),()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen())));

      }
  }
}