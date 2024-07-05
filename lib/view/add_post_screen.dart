import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final databaseRef = FirebaseDatabase.instance.ref('Post');
  TextEditingController _postController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text("Add Post"),
          centerTitle: true,
          foregroundColor: Colors.white,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: _postController,
                maxLines: 4,
                decoration: InputDecoration(
                    hintText: "Whats in your mind?",
                    border: OutlineInputBorder()),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                databaseRef
                    .child(DateTime.now().microsecondsSinceEpoch.toString())
                    .set({
                  'id': DateTime.now().microsecondsSinceEpoch.toString(),
                  'Post': _postController.text.toString(),
                }).then((value) {
                  Fluttertoast.showToast(msg: "Post Added");
                  _postController.clear();
                }).catchError((error) {
                  Fluttertoast.showToast(msg: error.toString());
                });
              },
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: Text(
                "Add Post",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
