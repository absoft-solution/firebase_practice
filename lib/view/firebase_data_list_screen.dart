import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'add_firestore_data_screen.dart';
import 'login_screen.dart';

class FirebaseDataListScreen extends StatefulWidget {
  const FirebaseDataListScreen({super.key});

  @override
  State<FirebaseDataListScreen> createState() => _FirebaseDataListScreenState();
}

final auth = FirebaseAuth.instance;
final firestore = FirebaseFirestore.instance.collection('post').snapshots();

class _FirebaseDataListScreenState extends State<FirebaseDataListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        title: Text("Firestore Data List"),
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
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddFirestoreDataScreen()));
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            Fluttertoast.showToast(
                msg: "Unknown error occurred, please re-open the app");
            return Center(child: Text('An error occurred'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available'));
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: Text(
                      snapshot.data!.docs[index]['post'].toString(),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
