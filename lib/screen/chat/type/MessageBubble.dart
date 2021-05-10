import 'package:chattoweb/utils/Constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MessageBubble extends StatefulWidget {
  String _userEmail;
  String _message;
  String _id;

  MessageBubble(this._userEmail, this._message, this._id);

  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {

  @override
  void initState() {
    print("Message çalıştı");
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
           return  dialog(context, "Silmek istiyor musunuz?", this.widget._id,0);
          },
        );
      },
      child: Column(
        crossAxisAlignment:
        FirebaseAuth.instance.currentUser!.email == widget._userEmail
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          Container(
            margin: FirebaseAuth.instance.currentUser!.email ==  widget._userEmail
                ? EdgeInsets.only(
              left: 10,
              top: 10,
            )
                : EdgeInsets.only(
              top: 10,
              right: 10,
            ),
            height: 70,
            width: 280,
            decoration: FirebaseAuth.instance.currentUser!.email == widget._userEmail
                ? meDecoration
                : otherDecoration,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget._userEmail,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    // ignore: unnecessary_null_comparison
                    widget._message == null ? "test" : widget._message,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              margin: EdgeInsets.only(left: 8, top: 8),
            ),
          ),
        ],
      ),
    );
  }
}
