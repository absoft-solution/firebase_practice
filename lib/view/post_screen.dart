import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebasse_practice/view/add_post_screen.dart';
import 'package:firebasse_practice/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

final _editController = TextEditingController();

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  final databaseRef = FirebaseDatabase.instance.ref("Post");

  Future<void> MyDialog(String title, String id) async {
    _editController.text = title;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Update Post"),
          content: TextFormField(
            controller: _editController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Edit Post",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                databaseRef.child(id).update({
                  'Post': _editController.text.toString(),
                }).then((value) {
                  Navigator.pop(context);
                  Fluttertoast.showToast(msg: "Post updated successfully");
                }).catchError((e) {
                  Fluttertoast.showToast(msg: e.toString());
                  Navigator.pop(context);
                });
              },
              child: Text("Update"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text("Post Screen"),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                auth.signOut().then((value) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                }).catchError((error) {
                  Fluttertoast.showToast(msg: error.toString());
                });
              },
              icon: Icon(
                Icons.logout,
                size: 30,
                color: Colors.white,
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddPostScreen()));
          },
          child: Icon(Icons.add),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Using StreamBuilder",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  color: Colors.lightGreen.shade100,
                  child: StreamBuilder(
                    stream: databaseRef.onValue,
                    builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        Map<dynamic, dynamic> map =
                            snapshot.data!.snapshot.value as dynamic;
                        List<dynamic> list = [];
                        list.clear();
                        list = map.values.toList();
                        return ListView.builder(
                          itemCount: snapshot.data!.snapshot.children.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 6, left: 6),
                              child: Card(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: ListTile(
                                  title: Text(
                                    list[index]['Post'] ?? 'No Data',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    list[index]['id'] ?? 'No ID found',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
              Text(
                "Using Firebase Animated List",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  color: Colors.lightBlue.shade100,
                  child: FirebaseAnimatedList(
                    query: databaseRef,
                    itemBuilder: (context, snapshot, animation, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 6, left: 6),
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            title: Text(
                              snapshot.child('Post').value.toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              snapshot.child('id').value.toString(),
                              style: TextStyle(color: Colors.grey),
                            ),
                            trailing: PopupMenuButton(
                              icon: Icon(Icons.more_vert),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  child: ListTile(
                                    leading: Icon(Icons.edit),
                                    title: Text("Edit"),
                                    onTap: () {
                                      MyDialog(
                                        snapshot.child('Post').value.toString(),
                                        snapshot.key.toString(),
                                      );
                                    },
                                  ),
                                ),
                                PopupMenuItem(
                                  child: ListTile(
                                    leading: Icon(Icons.delete),
                                    title: Text("Delete"),
                                    onTap: () {
                                      databaseRef
                                          .child(snapshot.key.toString())
                                          .remove();
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
