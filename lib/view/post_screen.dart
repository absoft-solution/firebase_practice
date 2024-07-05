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
            title: Text("Update"),
            content: Container(
              child: TextFormField(
                controller: _editController,
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
              TextButton(
                  onPressed: () {
                    databaseRef.child(id).update({
                      'Post': _editController.text.toString(),
                    }).then((value) {
                      Navigator.pop(context);
                    }).catchError((e) {
                      Fluttertoast.showToast(msg: e.toString());
                      Navigator.pop(context);
                    });
                  },
                  child: Text("Update")),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text("Post Screen"),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  auth.signOut().then((value) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  }).catchError((error) {
                    Fluttertoast.showToast(msg: error.toString());
                  });
                },
                icon: Icon(
                  Icons.logout_outlined,
                  size: 30,
                  color: Colors.white,
                ))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddPostScreen()));
          },
          child: Icon(
            Icons.add,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text("Using StreamBuilder"),
              Expanded(
                child: Card(
                    color: Colors.lightGreen.shade100,
                    child: StreamBuilder(
                      stream: databaseRef.onValue,
                      builder:
                          (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        } else {
                          Map<dynamic, dynamic> map =
                              snapshot.data!.snapshot.value as dynamic;
                          List<dynamic> list = [];
                          list.clear();
                          list = map.values.toList();
                          return ListView.builder(
                              itemCount:
                                  snapshot.data!.snapshot.children.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(list[index]['Post'] ?? 'No Data'),
                                  subtitle:
                                      Text(list[index]['id'] ?? 'No ID found'),
                                );
                              });
                        }
                      },
                    )),
              ),
              Text("Using Firebase Animated List"),
              Expanded(
                child: Card(
                  color: Colors.lightBlue.shade100,
                  child: FirebaseAnimatedList(
                      query: databaseRef,
                      itemBuilder: (context, snapshot, animation, index) {
                        return ListTile(
                          title: Text(snapshot.child('Post').value.toString()),
                          subtitle: Text(snapshot.child('id').value.toString()),
                          trailing: PopupMenuButton(
                            child: Icon(Icons.more_vert),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                  child: ListTile(
                                leading: Icon(Icons.edit),
                                title: Text("Edit"),
                                onTap: () {
                                  MyDialog(
                                      snapshot.child('Post').value.toString(),
                                      snapshot.key.toString());
                                },
                              )),
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
                              )),
                            ],
                          ),
                        );
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
