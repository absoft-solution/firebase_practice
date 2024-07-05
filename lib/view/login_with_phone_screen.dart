import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasse_practice/view/verify_code_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginWithPhoneScreen extends StatefulWidget {
  const LoginWithPhoneScreen({Key? key}) : super(key: key);

  @override
  State<LoginWithPhoneScreen> createState() => _LoginWithPhoneScreenState();
}

class _LoginWithPhoneScreenState extends State<LoginWithPhoneScreen> {
  TextEditingController _phoneNumberController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            "Login with Phone",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              Text(
                "Enter your phone number",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  hintText: '+92 300 0000000',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  String phoneNumber = _phoneNumberController.text;
                  auth.verifyPhoneNumber(
                      phoneNumber: phoneNumber,
                      verificationCompleted: (_) {},
                      verificationFailed: (e) {
                        Fluttertoast.showToast(msg: e.toString());
                      },
                      codeSent: (String verificationId, int? token) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VerifyCodeScreen(
                                      verificationId: verificationId,
                                      phoneNumber: phoneNumber,
                                    )));
                      },
                      codeAutoRetrievalTimeout: (e) {
                        Fluttertoast.showToast(msg: e.toString());
                      });
                  print("Phone Number: $phoneNumber");
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
