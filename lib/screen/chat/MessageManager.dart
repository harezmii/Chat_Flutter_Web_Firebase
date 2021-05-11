import 'package:chattoweb/screen/chat/type/FileBubble.dart';
import 'package:chattoweb/utils/Constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:chattoweb/screen/chat/type/MessageBubble.dart';
import 'package:chattoweb/screen/chat/type/PhotoBubble.dart';
import 'package:chattoweb/screen/chat/type/SoundBubble.dart';

// ignore: must_be_immutable
class MessageManager extends StatefulWidget {
  String _userEmail;
  String _message;
  String _messageType;
  String _imageUrl;
  String _id;

  MessageManager(this._userEmail, this._message, this._messageType, this._imageUrl,this._id);

  String get image => this._imageUrl;

  @override
  _MessageState createState() => _MessageState();
}
class _MessageState extends State<MessageManager> {
  var _indirmeBaglantisi;

  String getDownloadUrl(String path) {

    String url = firebase_storage.FirebaseStorage.instance
        .ref(path)
        .getDownloadURL() as String;
    return url;
  }

  @override
  initState() {
    super.initState();
    print("Message Menager çalıştı");
    print(this.widget._message);
    _indirmeBaglantisi = this.widget._imageUrl;
    setState(() {

    });
  }
  messageType(String type){
    switch(type){
      case "message":
        return MessageBubble(this.widget._userEmail, this.widget._message, this.widget._id);
      case "photo":
        return PhotoBubble(this.widget._userEmail, _indirmeBaglantisi, this.widget._id);
      case "sound":
        return SoundBubble(this.widget._userEmail, _indirmeBaglantisi,this.widget._id);
      case "file":
        return FileBubble(this.widget._userEmail, _indirmeBaglantisi, this.widget._id);
    }
  }
  @override
  Widget  build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
    });
    return Container(
      child: messageType(this.widget._messageType) as Widget,
    );
  }

}
