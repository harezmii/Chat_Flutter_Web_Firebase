import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera_camera/camera_camera.dart';
import 'package:chattoweb/screen/chat/MessageManager.dart';
import 'package:chattoweb/screen/chat/type/PhotoBubble.dart';
import 'package:chattoweb/temp/userSettings.dart';
import 'package:chattoweb/utils/SharedPreferencesProcess.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:html' as html;
import 'package:flutter/foundation.dart' show kIsWeb;

//
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   await FirebaseMessaging.instance.subscribeToTopic("/topics/all");
//   print('Handling a background message ${message.messageId}');
// }
//
// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//   'high_importance_channel', // id
//   'High Importance Notifications', // title
//   'This channel is used for important notifications.', // description
//   importance: Importance.high,
// );
//
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// FlutterLocalNotificationsPlugin();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _controller;
  var _scrollController;
  final currentUser = FirebaseAuth.instance.currentUser!.email;
  final isMe = null;
  var resultImageList;
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  var _recorder;
  var _file;

  var url;
  var name;
  bool isOpenedDrawer = false;
  final Stream<QuerySnapshot> _streamChats =
  FirebaseFirestore.instance.collection("chatMessage").orderBy("timestamp").snapshots();

  getImageUrl() async {
    var _url = await SharedPreferencesProcess.getUserImage();
    url = _url.toString();
  }

  getNameUrl() async {
    var _name = await SharedPreferencesProcess.getUserName();
    name = _name.toString();
  }

  var _imageUrl;

  uploadImageStorage() async {
    firebase_storage.Reference reference =
    firebase_storage.FirebaseStorage.instance.ref();

    var user = FirebaseAuth.instance.currentUser!.uid;
    String _fullPath = "";
    var _filed;

    var _input = html.FileUploadInputElement();
    _input.click();

    _input.onChange.listen(
          (event) {
        final file = _input.files!.first;
        final reader = html.FileReader();
        reader.readAsDataUrl(file);
        reader.onLoadEnd.listen(
              (event) async {
            print(file.relativePath);
            var name = file.name.split(".");
            print(name[1]);

            var snap = reference
                .child(
                "/uploads/image/${user.trim()
                    .toString()}/${name[0]}.${name[1]}")
                .putBlob(
                file,
                firebase_storage.SettableMetadata(
                  contentType: "image/" + name[1],
                ));
            _fullPath = snap.snapshot.ref.fullPath;

            Timer(
                Duration(
                  seconds: 2,
                ), () async {
              _imageUrl =
              await reference.storage.ref(_fullPath).getDownloadURL();
              print(_imageUrl);

              try {
                var collection =
                FirebaseFirestore.instance.collection("chatMessage");
                collection.add({
                  "timestamp": Timestamp.now(),
                  "userEmail": FirebaseAuth.instance.currentUser!.email!
                      .trim()
                      .toString(),
                  "messageType": "photo",
                  "imageUrl": file.name.toString(),
                  "downloadLink": _imageUrl.toString(),
                });
              } catch (e) {
                print("Hata VARRRRRRRRRRRRRRRRRRRRRRRRRrr");
              }
            });
          },
        );
      },
    );
  }

  @override
  void dispose() {
    if (_recorder != null) {
      _recorder.closeAudioSession();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if(kIsWeb) {
      print("Web");
    }
    _controller = new TextEditingController();
    _scrollController = new ScrollController();

    // getToken();
    _recorder = new FlutterSoundRecorder();

    // const AndroidInitializationSettings initializationSettingsAndroid =
    // AndroidInitializationSettings('ic_launcher');
    //
    // final InitializationSettings initializationSettings =
    // InitializationSettings(android: initializationSettingsAndroid);
    // flutterLocalNotificationsPlugin.initialize(initializationSettings);
    //
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   RemoteNotification notification = message.notification!;
    //   AndroidNotification? android = message.notification?.android;
    //
    //   if (notification != null && android != null) {
    //     flutterLocalNotificationsPlugin.show(
    //         notification.hashCode,
    //         notification.title,
    //         notification.body,
    //         NotificationDetails(
    //           android: AndroidNotificationDetails(
    //             channel.id,
    //             channel.name,
    //             channel.description,
    //             icon: 'launch_background',
    //           ),
    //         ));
    //   }
    // });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(
        _scrollController.position.maxScrollExtent+100,
      );
    } else {
      Timer(Duration(milliseconds: 500), () => _scrollToBottom());
    }
  }

  openCamera() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return CameraCamera(
            onFile: (file) async {
              setState(() {
                _file = file;
              });

              // var token = await FirebaseMessaging.instance.getToken();

              try {
                var link;
                var reference = await firebase_storage.FirebaseStorage.instance
                    .ref()
                    .child("/uploads/image/" + _file.path);
                var storage = await reference.putFile(new File(_file.path));
                var referenceNetwork = await reference
                    .getDownloadURL()
                    .then((value) => link = value);

                var collection =
                FirebaseFirestore.instance.collection("chatMessage");
                collection.add({
                  "timestamp": Timestamp.now(),
                  "userEmail": FirebaseAuth.instance.currentUser!.email,
                  "messageType": "photo",
                  "imageUrl": reference.fullPath,
                  "downloadLink": link,
                });
              } catch (e) {
                print("Hata VARRRRRRRRRRRRRRRRRRRRRRRRRrr");
              }

              // var data = {
              //   "to": token,
              //   "notification": {
              //     "title": FirebaseAuth.instance.currentUser!.email,
              //     "body": _file.path,
              //   },
              // };
              // var response = await http.post(
              //   Uri.parse("https://fcm.googleapis.com/fcm/send"),
              //   headers: {
              //     'Content-type': 'application/json',
              //     'Authorization':
              //     'key=AAAAdDzidd4:APA91bFgqjMPKJEGzJzrudyZ1P_g5ruNfIzTNWV7x1lj3bHXMw76APkmFwyLGNwsQEITvFJKrsgAgTqGVBwX_nHY0qVx--EwJsNd-WvSrdk1b9ZX_kZsz-JBYj3tZY7Qgq9VF7ePWgN0',
              //   },
              //   body: jsonEncode(
              //     data,
              //   ),
              // );
              // if (response.statusCode == 401) {
              //   print("authorization");
              // }
              // if (response.statusCode == 200) {
              //   print("Success");
              // }
              setState(() {
                // _scrollToBottom();
              });
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }

  String getDownloadUrl(String path) {
    String url = firebase_storage.FirebaseStorage.instance
        .ref(path)
        .getDownloadURL() as String;
    return url;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
     _scrollToBottom();

      if (!isOpenedDrawer) {
        print("Burası Çalıştı");
        isOpenedDrawer = false;
        getImageUrl();
      } else {
        print("Nerede");
      }
    });
    return SafeArea(
      child: Scaffold(
        onDrawerChanged: (e) {
          setState(() {
            getNameUrl();
          });
        },
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.cyan.shade700,
          title: Text(
            "ChatTo",
            style: TextStyle(
                fontSize: 24,
                letterSpacing: 0.8,
                wordSpacing: 1.0,
                fontWeight: FontWeight.bold),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserSettings(),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.only(
                  right: 10.0,
                ),
                child: Icon(
                  Icons.person_rounded,
                  size: 28,
                ),
              ),
            ),
            SizedBox(
              width: 12,
            ),
            GestureDetector(
              child: Icon(
                Icons.water_damage_sharp,
                size: 28,
              ),
              onTap: () async {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Çıkmak İstiyormusun?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("Hayır"),
                          ),
                          TextButton(
                            onPressed: () async {
                              await FirebaseAuth.instance.signOut();
                              final GoogleSignIn googleSignIn = GoogleSignIn();
                              googleSignIn.signOut();
                              Navigator.pushNamed(context, "/");
                            },
                            child: Text("Evet"),
                          ),
                        ],
                      );
                    });
              },
            ),
            SizedBox(
              width: 12,
            ),
          ],
        ),
        drawerEnableOpenDragGesture: true,
        drawer: Drawer(
          child: Column(
            children: [
              Container(
                height: 220.0,
                color: Colors.cyan.shade700,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        top: 20.0,
                      ),
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 26,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            url == null
                                ? Container(
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                    "images/Person.jpg",
                                  ),
                                ),
                              ),
                            )
                                : GestureDetector(
                              child: Container(
                                height: 120,
                                width: 120,
                                child: CircleAvatar(
                                  child: ClipOval(
                                    child: CachedNetworkImage(
                                      width: 120,
                                      height: 120,
                                      imageUrl: url,
                                      placeholder: (context, a) =>
                                          Center(
                                            child:
                                            CircularProgressIndicator(),
                                          ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserSettings(),
                                  ),
                                );
                              },
                            ),
                            Icon(
                              Icons.wb_incandescent_outlined,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 20.0,
                      ),
                      child: ListTile(
                        leading: Container(
                          padding: EdgeInsets.all(
                            8.0,
                          ),
                          child: Column(
                            children: [
                              Text(
                                name == null ? "İsimsiz Kahraman" : name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                "0552 652 7895",
                                style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 0.8,
                                ),
                              )
                            ],
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: FaIcon(
                            FontAwesomeIcons.arrowDown,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.all(
                    10.0,
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.people_alt_sharp,
                          color: Colors.grey,
                          size: 24,
                        ),
                        title: Text("New Group"),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.person_outline_sharp,
                          color: Colors.grey,
                          size: 24,
                        ),
                        title: Text("Contacts"),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.phone,
                          color: Colors.grey,
                          size: 24,
                        ),
                        title: Text("Calls"),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.workspaces_outline,
                          color: Colors.grey,
                          size: 24,
                        ),
                        title: Text("Yakındaki Kişiler"),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.settings,
                          color: Colors.grey,
                          size: 24,
                        ),
                        title: Text("Settings"),
                      ),
                      Divider(
                        height: 2.0,
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.person_add_outlined,
                          color: Colors.grey,
                          size: 24,
                        ),
                        title: Text("Invite Friends"),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.question_answer_sharp,
                          color: Colors.grey,
                          size: 24,
                        ),
                        title: Text("ChatTo FAQ"),
                      ),
                    ],
                  )),
            ],
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Flexible(
                  child: StreamBuilder(
                    stream: _streamChats,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.data == null) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasError) {
                        Fluttertoast.showToast(
                            msg: "Hata Var",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                      if (snapshot.data!.size == 0) {
                        return Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          child: Center(
                            child: Text(
                              "Herhangi içerik yok. Eklemek için mesaj atabilir, + simgesine basıp butonlara uzun basarak foto, ses atabilir,foto çekebilirsiniz.",
                              maxLines: 4,
                              style: TextStyle(
                                letterSpacing: 0.6,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return ListView.builder(
                         physics: AlwaysScrollableScrollPhysics(),
                        itemCount: snapshot.data.docs.length,
                        controller: _scrollController,
                        itemBuilder: (context, index) {
                          return  MessageManager(
                            snapshot.data.docs[index].data()['userEmail'],
                              snapshot.data.docs[index].data()['messageType'] == "message" ?snapshot.data.docs[index].data()['message'] :"test",
                            snapshot.data.docs[index].data()['messageType'],
                            snapshot.data.docs[index].data()['downloadLink'] == null ? "" : snapshot.data.docs[index].data()['downloadLink'],
                            snapshot.data.docs[index].id,
                            );
                            // child: Column(
                            //   crossAxisAlignment: FirebaseAuth.instance
                            //       .currentUser!.email ==
                            //       snapshot.data.docs[index].data()['userEmail']
                            //       ? CrossAxisAlignment.start
                            //       : CrossAxisAlignment.end,
                            //   children: [
                            //     Column(
                            //       children: [
                            //         Container(
                            //           margin: FirebaseAuth.instance.currentUser!
                            //               .email ==
                            //               snapshot.data.docs[index]
                            //                   .data()['userEmail']
                            //               ? EdgeInsets.only(left: 10, top: 10)
                            //               : EdgeInsets.only(
                            //             top: 10,
                            //             right: 10,
                            //           ),
                            //           height: 24,
                            //           width: 230,
                            //           decoration: BoxDecoration(
                            //             color: FirebaseAuth.instance
                            //                 .currentUser!.email ==
                            //                 snapshot.data.docs[index]
                            //                     .data()['userEmail']
                            //                 ? Colors.orange.shade100
                            //                 : Colors.grey,
                            //             borderRadius: BorderRadius.only(
                            //               topLeft: Radius.circular(
                            //                 6,
                            //               ),
                            //               topRight: Radius.circular(
                            //                 6,
                            //               ),
                            //             ),
                            //           ),
                            //           child: Container(
                            //             margin: EdgeInsets.only(
                            //               left: 5,
                            //               top: 3,
                            //             ),
                            //             child: Text(snapshot.data.docs[index]
                            //                 .data()['userEmail'] == null
                            //                 ? ""
                            //                 : snapshot.data.docs[index]
                            //                 .data()['userEmail']),
                            //           ),
                            //         ),
                            //         Container(
                            //           margin: FirebaseAuth.instance.currentUser!
                            //               .email ==
                            //               snapshot.data.docs[index]
                            //                   .data()['userEmail']
                            //               ? EdgeInsets.only(left: 10, top: 0)
                            //               : EdgeInsets.only(
                            //             top: 0,
                            //             right: 10,
                            //           ),
                            //           height: 320,
                            //           width: 230,
                            //           child: snapshot.data.docs[index]
                            //               .data()['downloadLink'] == null
                            //               ? Center(
                            //             child: CircularProgressIndicator(),
                            //           )
                            //               : Image.network(
                            //             snapshot.data.docs[index]
                            //                 .data()['downloadLink'],
                            //             fit: BoxFit.cover,
                            //
                            //           ),
                            //           //Image.network(_indirmeBaglantisi,fit: BoxFit.cover,),
                            //         ),
                            //         Container(
                            //           margin: FirebaseAuth.instance.currentUser!
                            //               .email ==
                            //               snapshot.data.docs[index]
                            //                   .data()['userEmail']
                            //               ? EdgeInsets.only(left: 10, top: 0)
                            //               : EdgeInsets.only(
                            //             top: 0,
                            //             right: 10,
                            //           ),
                            //           height: 24,
                            //           width: 230,
                            //           decoration: BoxDecoration(
                            //             color: FirebaseAuth.instance
                            //                 .currentUser!.email ==
                            //                 snapshot.data.docs[index]
                            //                     .data()['userEmail']
                            //                 ? Colors.orange.shade100
                            //                 : Colors.grey,
                            //             borderRadius: FirebaseAuth.instance
                            //                 .currentUser!.email ==
                            //                 snapshot.data.docs[index]
                            //                     .data()['userEmail']
                            //                 ? BorderRadius.only(
                            //                 bottomLeft: Radius.circular(
                            //                   0,
                            //                 ),
                            //                 bottomRight: Radius.circular(
                            //                   6,
                            //                 ))
                            //                 : BorderRadius.only(
                            //                 bottomLeft: Radius.circular(
                            //                   6,
                            //                 ),
                            //                 bottomRight: Radius.circular(
                            //                   0,
                            //                 )),
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ],
                            // ),

                          // return Container(
                          //   height: 50,
                          //   width: 100,
                          //   decoration: BoxDecoration(
                          //     shape: BoxShape.circle,
                          //   ),
                          //   child: Image.asset(
                          //     "images/suat.jpg",
                          //   ),
                          // );
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery
                          .of(context)
                          .viewInsets
                          .bottom),
                  child: Container(
                    child: Container(
                      height: 50,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              onTap: () {
                                Timer(Duration(seconds: 1), () {
                                });
                              },
                              cursorColor: Colors.red,
                              controller: _controller,
                              decoration: InputDecoration(
                                  icon: FaIcon(
                                    FontAwesomeIcons.smile,
                                    size: 28,
                                    color: Colors.grey.shade500,
                                  ),
                                  contentPadding: EdgeInsets.all(6),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                      )),
                                  labelStyle: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  hintText: "Enter the message",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  )),
                            ),
                          ),
                          Container(
                            width: 50,
                            child: GestureDetector(
                              onTap: () async {
                                // var token = await getToken();
                                var collection = FirebaseFirestore.instance
                                    .collection("chatMessage");

                                if (_controller.value.text.isEmpty) {
                                  Fluttertoast.showToast(
                                      msg: "Alanı boş bırakmayın",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.TOP,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                } else {
                                  collection.add({
                                    "message": _controller.value.text,
                                    "timestamp": Timestamp.now(),
                                    "userEmail": FirebaseAuth
                                        .instance.currentUser!.email,
                                    "messageType": "message"
                                  });
                                  Fluttertoast.showToast(
                                      msg: "Eklendi",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.TOP,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);

                                  // var data = {
                                  //   "to": "/topics/all",
                                  //   "data": {
                                  //     "click_action":
                                  //     "FLUTTER_NOTIFICATION_CLICK",
                                  //     "status": "done",
                                  //   },
                                  //   "priority": "high",
                                  //   "notification": {
                                  //     "title": FirebaseAuth
                                  //         .instance.currentUser!.email,
                                  //     "body": _controller.value.text,
                                  //   },
                                  // };
                                  //
                                  // print("Token" + token + "dercesine");
                                  // var response = await http.post(
                                  //   Uri.parse(
                                  //       "https://fcm.googleapis.com/fcm/send"),
                                  //   headers: {
                                  //     'Content-type': 'application/json',
                                  //     'Authorization':
                                  //     'key=AAAAdDzidd4:APA91bFgqjMPKJEGzJzrudyZ1P_g5ruNfIzTNWV7x1lj3bHXMw76APkmFwyLGNwsQEITvFJKrsgAgTqGVBwX_nHY0qVx--EwJsNd-WvSrdk1b9ZX_kZsz-JBYj3tZY7Qgq9VF7ePWgN0',
                                  //   },
                                  //   body: jsonEncode(
                                  //     data,
                                  //   ),
                                  // );
                                  // if (response.statusCode == 401) {
                                  //   print("authorization");
                                  // }
                                  // if (response.statusCode == 200) {
                                  //   print("Success");
                                  // }
                                  _controller.text = "";

                                  setState(() {
                                    _scrollController.jumpTo(_scrollController
                                        .position.maxScrollExtent);
                                  });

                                  // _scrollController.animateTo(
                                  //     _scrollController.position.maxScrollExtent
                                  //             .ceilToDouble(),
                                  //     duration: Duration(seconds: 1),
                                  //     curve: Curves.bounceOut);

                                  SystemChannels.textInput
                                      .invokeMethod("TextInput.hide");
                                  //  FocusManager.instance.primaryFocus.unfocus();
                                }
                              },
                              child: FaIcon(
                                FontAwesomeIcons.paperPlane,
                                size: 22,
                                color: Colors.cyan.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        floatingActionButton: FabCircularMenu(
          key: fabKey,
          animationDuration: Duration(seconds: 1),
          alignment: Alignment(1.0, 0.84),
          fabOpenIcon: Icon(
            Icons.add,
            color: Colors.white,
          ),
          fabCloseIcon: Icon(
            Icons.cancel,
            color: Colors.white,
          ),
          fabColor: Colors.grey.shade800,
          ringColor: Colors.grey.shade800,
          children: [
            GestureDetector(
              onTap: () async {
                var result;
                await uploadImageStorage();
                // var token = await FirebaseMessaging.instance.getToken();

                if (result == null) {
                  Fluttertoast.showToast(
                      msg: "Seçilemedi",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  Navigator.pushNamed(context, "/home");
                } else {
                  // var data = {
                  //   "to": token,
                  //   "notification": {
                  //     "title": FirebaseAuth.instance.currentUser!.email,
                  //     "body": result.files.first.path,
                  //   },
                  // };
                  // var response = await http.post(
                  //   Uri.parse("https://fcm.googleapis.com/fcm/send"),
                  //   headers: {
                  //     'Content-type': 'application/json',
                  //     'Authorization':
                  //     'key=AAAAdDzidd4:APA91bFgqjMPKJEGzJzrudyZ1P_g5ruNfIzTNWV7x1lj3bHXMw76APkmFwyLGNwsQEITvFJKrsgAgTqGVBwX_nHY0qVx--EwJsNd-WvSrdk1b9ZX_kZsz-JBYj3tZY7Qgq9VF7ePWgN0',
                  //   },
                  //   body: jsonEncode(
                  //     data,
                  //   ),
                  // );
                  // if (response.statusCode == 401) {
                  //   print("authorization");
                  // }
                  // if (response.statusCode == 200) {
                  //   print("Success");
                  // }
                  if (fabKey.currentState!.isOpen) {
                    fabKey.currentState!.close();
                  }
                  // _scrollController.animateTo(
                  //     _scrollController.position.maxScrollExtent,
                  //     duration: Duration(milliseconds: 300),
                  //     curve: Curves.elasticOut);
                }
              },
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.orange.shade500,
                ),
                child: Icon(
                  Icons.photo,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green.shade500,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.insert_drive_file,
                  size: 40,
                  color: Colors.white,
                ),
                onPressed: () async {
                  FilePickerResult result =
                  (await FilePicker.platform.pickFiles(
                    type: FileType.any,
                    allowMultiple: true,
                    allowCompression: true,
                  ))!;
                },
              ),
            ),
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.shade500,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.location_on,
                  size: 40,
                  color: Colors.white,
                ),
                onPressed: () async {
                  FilePickerResult result =
                  (await FilePicker.platform.pickFiles(
                    type: FileType.any,
                    allowMultiple: true,
                    allowCompression: true,
                  ))!;
                },
              ),
            ),
            GestureDetector(
              onTap: () async {
                openCamera();
                if (fabKey.currentState!.isOpen) {
                  fabKey.currentState!.close();
                }
              },
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.brown.shade500,
                ),
                child: Icon(
                  Icons.camera_alt_outlined,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
            GestureDetector(
              onLongPress: () async {
                var hasPermission = await Permission.microphone.isGranted;
                if (!hasPermission) {
                  await Permission.microphone
                      .request()
                      .isGranted;
                }
                Directory appDocDir = await getApplicationDocumentsDirectory();
                String appDocPath = appDocDir.path;
                print("*********************************");

                await _recorder.openAudioSession().then((value) {
                  _recorder.startRecorder(
                    toFile: appDocPath +
                        "/" +
                        DateTime
                            .now()
                            .millisecondsSinceEpoch
                            .toString() +
                        ".aac",
                  );
                  if (_recorder.isRecording) {
                    Fluttertoast.showToast(
                        msg: "Kaydediliyor",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.TOP,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                });
              },
              onLongPressEnd: (value) async {
                String path = (await _recorder.stopRecorder())!;
                await _recorder.closeAudioSession();
                if (_recorder.isStopped) {
                  Fluttertoast.showToast(
                      msg: "Stop Recording : Path > " + path,
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
                try {
                  var link;
                  var reference = await firebase_storage
                      .FirebaseStorage.instance
                      .ref()
                      .child("/uploads/sound/" + path);
                  var storage = await reference.putFile(new File(path));
                  var referenceNetwork = await reference
                      .getDownloadURL()
                      .then((value) => link = value);

                  var collection =
                  FirebaseFirestore.instance.collection("chatMessage");
                  collection.add({
                    "timestamp": Timestamp.now(),
                    "userEmail": FirebaseAuth.instance.currentUser!.email,
                    "messageType": "sound",
                    "imageUrl": reference.fullPath,
                    "downloadLink": link,
                  });

                  // var token = await FirebaseMessaging.instance.getToken();
                  //
                  // var data = {
                  //   "to": token,
                  //   "notification": {
                  //     "title": FirebaseAuth.instance.currentUser!.email,
                  //     "body": "Ses Kaydedildi",
                  //   },
                  // };
                  // var response = await http.post(
                  //   Uri.parse("https://fcm.googleapis.com/fcm/send"),
                  //   headers: {
                  //     'Content-type': 'application/json',
                  //     'Authorization':
                  //     'key=AAAAdDzidd4:APA91bFgqjMPKJEGzJzrudyZ1P_g5ruNfIzTNWV7x1lj3bHXMw76APkmFwyLGNwsQEITvFJKrsgAgTqGVBwX_nHY0qVx--EwJsNd-WvSrdk1b9ZX_kZsz-JBYj3tZY7Qgq9VF7ePWgN0',
                  //   },
                  //   body: jsonEncode(
                  //     data,
                  //   ),
                  // );
                  // if (response.statusCode == 401) {
                  //   print("authorization");
                  // }
                  // if (response.statusCode == 200) {
                  //   print("Success");
                  // }

                  if (fabKey.currentState!.isOpen) {
                    fabKey.currentState!.close();
                  }
                  // _scrollController.animateTo(
                  //     _scrollController.position.maxScrollExtent
                  //         .ceilToDouble() +
                  //         50,
                  //     duration: Duration(milliseconds: 300),
                  //     curve: Curves.elasticOut);
                } catch (e) {
                  print("Hata VARRRRRRRRRRRRRRRRRRRRRRRRRrr");
                }
              },
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.shade500,
                ),
                child: Icon(
                  Icons.mic,
                  size: 32,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// getToken() async {
//   String token = (await FirebaseMessaging.instance.getToken())!;
//   print("Token :" + token);
//   return token;
// }
