import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasse_practice/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth= FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text("Post Screen"),
          centerTitle: true,
          actions: [
            IconButton(onPressed: (){
              auth.signOut().then((value){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
              }).catchError((error){
                Fluttertoast.showToast(msg: error.toString());
              });
            }, icon: Icon(Icons.logout_outlined,size: 30,color: Colors.white,))
          ],
        ),
      ),
    );
  }
}
