import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasse_practice/view/post_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VerifyCodeScreen extends StatefulWidget {
  String phoneNumber;
  String verificationId;

  VerifyCodeScreen(
      {super.key, required this.verificationId, required this.phoneNumber});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  TextEditingController _codeController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Verify Code",
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
              "Enter the 6-digit code sent to ${widget.phoneNumber}",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                labelText: 'Verification Code',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String code = _codeController.text;
                final credential = PhoneAuthProvider.credential(
                    verificationId: widget.verificationId,
                    smsCode: _codeController.text.toString());
                print("Verification Code: $code");
                try {
                  await auth.signInWithCredential(credential);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PostScreen()));
                } catch (e) {
                  Fluttertoast.showToast(msg: e.toString());
                }
              },
              child: Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }
}
