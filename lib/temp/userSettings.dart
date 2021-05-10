import 'dart:io';

import 'package:camera_camera/camera_camera.dart';
import 'package:chattoweb/utils/SharedPreferencesProcess.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UserSettings extends StatefulWidget {

  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  ScrollController  _scrollController = new ScrollController();
  GlobalKey _sliverKey = new GlobalKey();
  File _file = new File("");

  bool _isScroll250 = false;
  String _url = "";
  var url;
  bool _update = false;
  bool _updateImage = false;

  @override
  void initState() {
    super.initState();

    getUserData();
  }

  Future<String> getUserData() async {
    this._url = (await SharedPreferencesProcess.getUserImage())!;
    // this._name = await SharedPreferencesProcess.getUserName();
    // this._bio = await SharedPreferencesProcess.getUserDescription();
    // name = _name;
    // bio = _bio;
    url = _url;
    return "Tamam";
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
                print(_file);
              });

              try {
                var link;
                var reference = await firebase_storage.FirebaseStorage.instance
                    .ref()
                    .child("/uploads/userProfile/" +
                        FirebaseAuth.instance.currentUser!.uid +
                        _file.path);
                var storage = await reference.putFile(new File(_file.path));
                var referenceNetwork = await reference
                    .getDownloadURL()
                    .then((value) => link = value);
                print("Link :" + link);
                if (_url != null) {
                  print("Silmede");
                  print(_url);
                  firebase_storage.FirebaseStorage.instance
                      .refFromURL(_url)
                      .delete();
                }
                SharedPreferencesProcess.saveUserImage(link.toString());
                var newUrl = SharedPreferencesProcess.getUserImage();
                setState(() {
                  url = newUrl;
                  _updateImage = true;
                });
                getUserData();
              } catch (e) {
                print("Hata VARRRRRRRRRRRRRRRRRRRRRRRRRrr");
              }

              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      url = _url;
      // name = _name;
      // bio = _bio;
      // _controllerUserName.text = name;
      // _controllerUserDescription.text = bio;
      setState(() {});
    });
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (value) {
          if (value.metrics.pixels > 250) {
            print("Burada");
            setState(() {
              _isScroll250 = true;
              print("Burada");
            });
          }
          if (value.metrics.pixels < 250) {
            setState(() {
              print("şıra00");
              _isScroll250 = false;
            });
          }
          return true;
        },
        child: CustomScrollView(
          clipBehavior: Clip.none,
          physics: BouncingScrollPhysics(),
          controller: _scrollController,
          shrinkWrap: true,
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.cyan.shade700,
              actions: [
                IconButton(
                  padding: EdgeInsets.only(
                    top: 2,
                    left: 10,
                    right: 10,
                    bottom: 10,
                  ),
                  icon: Icon(
                    Icons.more_vert_sharp,
                    size: 28,
                  ),
                  onPressed: () {
                    showMenu(
                      context: context,
                      position: RelativeRect.fromLTRB(180, 10, 0, 10),
                      items: [
                        PopupMenuItem(
                          child: Container(
                            child: ListTile(
                              leading: Icon(
                                Icons.edit_sharp,
                                size: 28,
                              ),
                              title: Text(
                                "Edit Name",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          child: GestureDetector(
                            child: Container(
                              child: ListTile(
                                leading: Icon(
                                  Icons.add_a_photo_outlined,
                                  size: 28,
                                ),
                                title: Text(
                                  "Set new photo",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              openCamera();
                              setState(() {
                                _updateImage = true;
                              });
                            },
                          ),
                        ),
                        PopupMenuItem(
                          child: Container(
                            child: ListTile(
                              leading: Icon(
                                Icons.delete,
                                size: 28,
                              ),
                              title: Text(
                                "Delete",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
              key: _sliverKey,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_sharp,
                  size: 28,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              expandedHeight: 300,
              stretchTriggerOffset: 100,
              pinned: true,
              stretch: true,
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: [
                  StretchMode.zoomBackground,
                ],
                background: url == null
                    ? Image.asset(
                        "images/Person.jpg",
                        fit: BoxFit.cover,
                      )
                    : _updateImage == false
                        ? Image.network(
                            url,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            url,
                            fit: BoxFit.cover,
                          ),
                titlePadding: EdgeInsets.only(left: 16.0),
                title: _isScroll250
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 30,
                          ),
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: url == null ? AssetImage("images/Person.jpg",)
                                    : _updateImage == false
                                    ? NetworkImage(
                                  url,
                                ) as ImageProvider
                                    : NetworkImage(
                                  url,
                                ),

                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              left: 18,
                              top: 6,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Suat Canbay",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    letterSpacing: 1.0,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  "online",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      letterSpacing: 1.0,
                                      fontSize: 12,
                                      color: Colors.grey.shade200),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Stack(
                  overflow: Overflow.visible,
                        children: [
                          Positioned(
                            bottom: 10,
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Suat Canbay",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      letterSpacing: 1.0,
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    "online",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        letterSpacing: 1.0,
                                        fontSize: 10,
                                        color: Colors.grey.shade200),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom : -25,
                            right: 20,
                            child: Container(
                              height: 50,
                              width: 50,
                              child: Icon(Icons.add_a_photo_outlined,),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    child: Column(
                      children: [
                        Container(
                          height: 240,
                          color: Colors.deepOrange,
                          child: Stack(
                            children: [
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Container(
                  //   height: 200,
                  //   color: Colors.greenAccent,
                  // ),
                  // Container(
                  //   height: 200,
                  //   color: Colors.greenAccent,
                  // ),
                  // Container(
                  //   height: 200,
                  //   color: Colors.greenAccent,
                  // ),
                  // Container(
                  //   height: 200,
                  //   color: Colors.greenAccent,
                  // ),
                  // Container(
                  //   height: 200,
                  //   color: Colors.greenAccent,
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
