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
      backgroundColor: Colors.white,
      body: Center(child: Column(
        children: [
          Center(child: Text("Splash Screen",style: TextStyle(fontSize: 50,color: Colors.white),)),
          // Image(image: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQPuYzstDI3ddbuulctqZOCew2Xh2JHWAO_Bw&s"),),
        ],
      ),),
    );
  }
}
