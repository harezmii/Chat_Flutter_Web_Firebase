// ignore: camel_case_types
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chattoweb/screen/chat/MessageManager.dart';
import 'package:fluttertoast/fluttertoast.dart';


// ignore: camel_case_types
class chatMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("chatMessage")
                  .orderBy("timestamp")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  Fluttertoast.showToast(
                      msg: "Hata Var",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView(

                  children: snapshot.data!.docs.map ((DocumentSnapshot document) {
                    // return MessageManager(
                    //   document.data()!["userEmail"],
                    //   document.data()!["message"],
                    //   document.data()!["messageType"],
                    //   document.data()!["downloadLink"],
                    //   document.id
                    // );
                    return Container();
                  }).toList(),
                );
              },
            );

  }
}
