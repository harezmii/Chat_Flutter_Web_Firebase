import 'package:chattoweb/utils/Constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;

import 'package:fluttertoast/fluttertoast.dart';

class FileBubble extends StatefulWidget {
  String _userEmail;
  String _downLoadUrl;
  String _id;

  FileBubble(this._userEmail, this._downLoadUrl, this._id);

  @override
  _FileBubbleState createState() => _FileBubbleState();
}

class _FileBubbleState extends State<FileBubble> {
  @override
  void initState() {
    print("File Çalıştı");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        if (FirebaseAuth.instance.currentUser!.email ==
            this.widget._userEmail) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return dialog(
                  context, "Silmek istiyor musunuz?", this.widget._id, 2);
            },
          );
        }
      },
      child: Column(
        crossAxisAlignment:
            FirebaseAuth.instance.currentUser!.email == widget._userEmail
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
        children: [
          Container(
            margin:
                FirebaseAuth.instance.currentUser!.email == widget._userEmail
                    ? EdgeInsets.only(
                        left: 10,
                        top: 10,
                      )
                    : EdgeInsets.only(
                        top: 10,
                        right: 10,
                      ),
            height: 120,
            width: 280,
            decoration:
                FirebaseAuth.instance.currentUser!.email == widget._userEmail
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
                      color: FirebaseAuth.instance.currentUser!.email == widget._userEmail
                          ? Colors.green.shade700 : Colors.deepOrange.shade700,
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red.shade500,
                          ),
                          child: IconButton(
                            tooltip: "Dosyayı indirmek için tıklayın",
                            icon: Icon(
                              Icons.arrow_downward_outlined,
                              size: 40,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              html.AnchorElement element =
                                  new html.AnchorElement(
                                      href: this.widget._downLoadUrl);
                              element.download = this.widget._downLoadUrl;

                              element.click();
                              Fluttertoast.showToast(
                                  msg: "dosya iniyor",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.TOP,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            },
                          )),
                      Expanded(
                        child: Container(
                          height: 80,
                          child: Image.asset(
                            "images/kemik.gif",
                          ),
                        ),
                      ),
                    ],
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
