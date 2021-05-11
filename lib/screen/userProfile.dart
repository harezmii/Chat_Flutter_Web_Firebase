import 'dart:io';
import 'package:camera_camera/camera_camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:chattoweb/utils/Constant.dart';
import 'package:chattoweb/utils/SharedPreferencesProcess.dart';
import 'package:fluttertoast/fluttertoast.dart';


class UserProfile extends StatefulWidget {

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  TextEditingController _controllerUserName = new TextEditingController();
  TextEditingController _controllerUserNameEdit = new TextEditingController();
  TextEditingController _controllerUserDescription =
      new TextEditingController();
  TextEditingController _controllerUserDescriptionEdit =
      new TextEditingController();
  File _file = new File("");
  bool _update = false;
  bool _updateImage = false;

  var _url;
  var url;

  var _name;
  var name;

  var _bio;
  var bio;

  Future<String> getUserData() async {
    this._url = await SharedPreferencesProcess.getUserImage();
    this._name = await SharedPreferencesProcess.getUserName();
    this._bio = await SharedPreferencesProcess.getUserDescription();
    print("Data");
    print(_url);
    print(_name);
    print(_bio);
    name = _name;
    bio = _bio;
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
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      url = _url;
      name = _name;
      bio = _bio;
      _controllerUserName.text = name;
      _controllerUserDescription.text = bio;
      setState(() {});
    });
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          color: Colors.cyan.shade700,
          child: ListView(
            children: [
              Container(
                height: 180,
                width: 180,
                margin: EdgeInsets.only(top: 40, left: 90, right: 90),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: url == null
                        ? AssetImage("images/Person.jpg")
                        : _updateImage == false
                            ? NetworkImage(url) as ImageProvider
                            : NetworkImage(url),
                  ),
                  border: Border.all(width: 2, color: Colors.amber),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      child: GestureDetector(
                        onTap: () {
                          openCamera();
                          setState(() {
                            _updateImage = true;
                          });
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.lightGreen.shade700,
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      bottom: 0,
                      right: 0,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 60,
              ),
              _update == true
                  ? userNameEdit(_controllerUserNameEdit)
                  : GestureDetector(
                      onLongPress: () {
                        setState(() {
                          getUserData();
                          _controllerUserNameEdit.text = name;
                          _controllerUserDescriptionEdit.text = bio;
                          _update = true;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.amber,
                            width: 2.0,
                          ),
                        ),
                        margin: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: TextFormField(
                          enabled: false,
                          cursorColor: Colors.red,
                          controller: _controllerUserName,
                          decoration: InputDecoration(
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
                              hintText: "Write Name",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )),
                        ),
                      ),
                    ),
              SizedBox(
                height: 30,
              ),
              _update == true
                  ? userDescriptionEdit(context, _controllerUserDescriptionEdit)
                  : GestureDetector(
                      onLongPress: () {
                        setState(() {
                          getUserData();
                          _controllerUserNameEdit.text = name;
                          _controllerUserDescriptionEdit.text = bio;

                          _update = true;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.amber,
                            width: 2.0,
                          ),
                        ),
                        margin: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: TextFormField(
                          enabled: false,
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                          cursorColor: Colors.red,
                          controller: _controllerUserDescription,
                          decoration: InputDecoration(
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
                              hintText: "Write User Bio",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )),
                        ),
                      ),
                    ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () async {
                  if (!_update) {
                    Fluttertoast.showToast(
                        msg: "Güncellemek İçin istediğiniz alanı sağa sola kaydırın",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.TOP,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  } else {
                    getUserData();
                    var collection = FirebaseFirestore.instance.collection(
                        "/user/" +
                            FirebaseAuth.instance.currentUser!.uid +
                            "/userProfile/");
                    collection.add(
                      {
                        "timestamp": Timestamp.now(),
                        "userEmail": FirebaseAuth.instance.currentUser!.email,
                        "userName": name,
                        "userBio": bio,
                        "downloadLink": url,
                      },
                    );

                    await SharedPreferencesProcess.saveUserName(
                        _controllerUserNameEdit.value.text);
                    await SharedPreferencesProcess.saveUserDescription(
                        _controllerUserDescriptionEdit.value.text);
                    print("Trigger");

                    setState(() {
                      getUserData();
                      _controllerUserName.text =
                          _controllerUserNameEdit.value.text;
                      _controllerUserDescription.text =
                          _controllerUserDescriptionEdit.text;
                      _update = false;
                    });
                  }
                },
                child: Container(
                  height: 50,
                  margin: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Center(
                    child: Text(
                      "Güncelle",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          letterSpacing: 1.0),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.lightGreen.shade700,
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                    border: Border.all(
                      color: Colors.amber,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
