import 'package:chattoweb/utils/Constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chattoweb/utils/Constant.dart';
import 'package:flutter_sound/flutter_sound.dart';

// ignore: must_be_immutable
class SoundBubble extends StatefulWidget {
  String _userEmail;
  String _downloadUrl;
  String _id;

  SoundBubble(this._userEmail, this._downloadUrl,this._id);

  @override
  _SoundBubbleState createState() => _SoundBubbleState();
}

class _SoundBubbleState extends State<SoundBubble> {
  late FlutterSoundPlayer _player;

  @override
  void initState() {
    print("Sound çalıştı");
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: (){
        if(FirebaseAuth.instance.currentUser!.email == this.widget._userEmail){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return  dialog(context, "Silmek istiyor musunuz?", this.widget._id,1,url: this.widget._downloadUrl);
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
            margin: FirebaseAuth.instance.currentUser!.email == widget._userEmail
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
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          _player = new FlutterSoundPlayer();
                          await _player.openAudioSession().then(
                                (value) async {
                              await _player.startPlayer(
                                  fromURI: this.widget._downloadUrl,
                                  codec: Codec.aacADTS,
                                  whenFinished: () async {
                                    await _player.stopPlayer();
                                  });
                            },
                          );
                        },
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red.shade500,
                          ),
                         child: Icon(
                              Icons.play_arrow_sharp,
                              size: 40,
                              color: Colors.white,
                            ),

                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 80,

                          child: Image.asset("images/kemik.gif",),
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
