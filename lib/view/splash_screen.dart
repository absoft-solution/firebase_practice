import 'dart:async';

import 'package:firebasse_practice/services/splash_services.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices splashServices=SplashServices();
  @override
  void initState() {
    splashServices.isLogin(context);
    // splashServices.isLogin(context);
    super.initState();
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(child: Text("Splash Screen",style: TextStyle(fontSize: 50,color: Colors.white),)),
    );
  }
}
