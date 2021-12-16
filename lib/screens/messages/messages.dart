import 'package:cloud_firestore/cloud_firestore.dart';
import '../../screens/messages/message_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatefulWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Government Messages"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: StreamBuilder<QuerySnapshot>(
            stream: db
                .collection('users')
                .doc(_auth.currentUser?.uid)
                .collection("govMessages")
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return MessageItem(
                      message: data["message"],
                    );
                  }).toList(),
                );
              }
            }),
      ),
    );
  }
}
