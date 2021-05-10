import 'package:chattoweb/screen/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  var _tabController;
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _email1Controller = new TextEditingController();
  TextEditingController _passController = new TextEditingController();
  TextEditingController _pass1Controller = new TextEditingController();
  TextEditingController _passAgainController = new TextEditingController();

  //
  // isUserLogin() async {
  //   var user = FirebaseAuth.instance.currentUser;
  //   if (user == null) {
  //     print("Mezarcıcccc");
  //   } else {
  //     setState(() {
  //
  //     });
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => Home(),
  //       ),
  //     );
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  signInEmail(String email, String pass) async {
    print("Email:" + email);
    var credintial = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: pass);

    return credintial;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          margin: EdgeInsets.only(top: 20),
          child: Column(
            children: [
              ListTile(
                leading: Container(
                  width: 200,
                  child: TabBar(
                    indicatorColor: Colors.black54,
                    indicatorSize: TabBarIndicatorSize.label,
                    controller: _tabController,
                    onTap: (i) {},
                    automaticIndicatorColorAdjustment: false,
                    tabs: [
                      Tab(
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "Register",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                trailing: Container(
                  child: Icon(
                    Icons.emoji_people_sharp,
                    color: Colors.white,
                  ),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Tab(
                      child: Container(
                        margin: EdgeInsets.only(top: 100, left: 0),
                        child: Column(
                          children: [
                            Container(
                              child: Text(
                                "Welcome Back !",
                                style:
                                    TextStyle(fontSize: 24, letterSpacing: 1.0),
                              ),
                              margin: EdgeInsets.only(right: 120),
                            ),
                            SizedBox(
                              height: 14,
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                right: 220,
                                left: 0,
                              ),
                              child: Text(
                                "ChatTo",
                                style: TextStyle(
                                    fontSize: 24,
                                    letterSpacing: 1.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 20, top: 40),
                              child: Column(
                                children: [
                                  Container(
                                    child: TextFormField(
                                      cursorColor: Colors.red,
                                      keyboardType: TextInputType.emailAddress,
                                      controller: _emailController,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(6),
                                          icon: Icon(
                                            Icons.email_outlined,
                                            color: Colors.black54,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                            color: Colors.black,
                                          )),
                                          focusColor: Colors.black54,
                                          labelText: "Email",
                                          labelStyle: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          hintText: "Enter the email",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          )),
                                    ),
                                    margin:
                                        EdgeInsets.only(right: 20, left: 10),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Container(
                                    child: TextFormField(
                                      cursorColor: Colors.red,
                                      obscureText: true,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      controller: _passController,
                                      decoration: InputDecoration(
                                          icon: Icon(
                                            Icons.lock_open_outlined,
                                            color: Colors.black54,
                                          ),
                                          contentPadding: EdgeInsets.all(6),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                            color: Colors.black,
                                          )),
                                          labelText: "Password",
                                          labelStyle: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          hintText: "Enter the password",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          )),
                                    ),
                                    margin:
                                        EdgeInsets.only(right: 20, left: 10),
                                  ),
                                ],
                              ),
                            ),

                            // icons
                            Container(
                              margin: EdgeInsets.only(
                                top: 20,
                                left: 30,
                              ),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    child: FaIcon(
                                      FontAwesomeIcons.facebookF,
                                      color: Colors.black,
                                    ),
                                    onTap: () {},
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  GestureDetector(
                                    child: FaIcon(
                                      FontAwesomeIcons.googlePlusG,
                                      color: Colors.black,
                                      size: 32,
                                    ),
                                    onTap: () {
                                      var userCredential = signInWithGoogle();

                                      userCredential.whenComplete(() {
                                        Fluttertoast.showToast(
                                            msg: "Hesap Seçilmedi",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.TOP,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      });
                                      userCredential.then((value) {
                                        print("Başarılı");
                                        if (value.credential != null) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return Home();
                                              },
                                            ),
                                          );
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            // end icons

                            Expanded(
                              child: Stack(
                                children: [
                                  Positioned(
                                    child: Text(
                                      "Forgot Password?",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    bottom: 70,
                                    left: 40,
                                  ),
                                  Positioned(
                                    child: Container(
                                      height: 60,
                                      width: 400,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                      ),
                                    ),
                                    bottom: 0,
                                  ),
                                  Positioned(
                                    child: GestureDetector(
                                      onTap: () async {
                                        if (_emailController
                                                .value.text.isNotEmpty &&
                                            _passController
                                                .value.text.isNotEmpty) {
                                          try {
                                            print(_emailController.value.text);
                                            var userCredential = signInEmail(
                                                _emailController.value.text
                                                    .trim()
                                                    .toString(),
                                                _passController.value.text
                                                    .trim()
                                                    .toString());

                                            if (userCredential != null) {
                                              if (!FirebaseAuth.instance
                                                  .currentUser!.emailVerified) {
                                                Fluttertoast.showToast(
                                                    msg: "Email Onaylayın",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.TOP,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor: Colors.red,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg: "Giriş Başarılı",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.TOP,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor: Colors.red,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);
                                                Navigator.pushNamed(context, "/home");
                                              }
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg: "Hata",
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.TOP,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0
                                              );
                                            }
                                          } on FirebaseAuthException catch (e) {

                                            if (e.code == 'user-not-found') {
                                              Fluttertoast.showToast(
                                                  msg: "Email Adresi bulunamadı",
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.TOP,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0
                                              );
                                            } else if (e.code ==
                                                'wrong-password') {
                                              Fluttertoast.showToast(
                                                  msg: "Yanlış Şifre",
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.TOP,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0
                                              );
                                            }
                                          }
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: "Alanları Boş Bırakmayın",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.TOP,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0
                                          );
                                        }
                                      },
                                      child: Container(
                                        child: Icon(
                                          Icons.arrow_right_alt_sharp,
                                          size: 32,
                                          color: Colors.white,
                                        ),
                                        height: 50,
                                        width: 80,
                                        decoration: BoxDecoration(
                                            color: Colors.orange.shade400,
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                      ),
                                    ),
                                    bottom: 32,
                                    right: 30,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        margin: EdgeInsets.only(top: 100, left: 0),
                        child: Column(
                          children: [
                            Container(
                              child: Text(
                                "Hello ChatTos !",
                                style:
                                    TextStyle(fontSize: 24, letterSpacing: 1.0),
                              ),
                              margin: EdgeInsets.only(right: 120),
                            ),
                            SizedBox(
                              height: 14,
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                right: 220,
                                left: 0,
                              ),
                              child: Text(
                                "ChatTo",
                                style: TextStyle(
                                    fontSize: 24,
                                    letterSpacing: 1.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 20, top: 40),
                              child: Column(
                                children: [
                                  Container(
                                    child: TextFormField(
                                      cursorColor: Colors.red,
                                      keyboardType: TextInputType.emailAddress,
                                      controller: _email1Controller,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(6),
                                          icon: Icon(
                                            Icons.email_outlined,
                                            color: Colors.black54,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                            color: Colors.black,
                                          )),
                                          focusColor: Colors.black54,
                                          labelText: "Email",
                                          labelStyle: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          hintText: "Enter the email",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          )),
                                    ),
                                    margin:
                                        EdgeInsets.only(right: 20, left: 10),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Container(
                                    child: TextFormField(
                                      cursorColor: Colors.red,
                                      obscureText: true,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      controller: _pass1Controller,
                                      decoration: InputDecoration(
                                          icon: Icon(
                                            Icons.lock_open_outlined,
                                            color: Colors.black54,
                                          ),
                                          contentPadding: EdgeInsets.all(6),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                            color: Colors.black,
                                          )),
                                          labelText: "Password",
                                          labelStyle: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          hintText: "Enter the password",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          )),
                                    ),
                                    margin:
                                        EdgeInsets.only(right: 20, left: 10),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Container(
                                    child: TextFormField(
                                      cursorColor: Colors.red,
                                      obscureText: true,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      controller: _passAgainController,
                                      decoration: InputDecoration(
                                          icon: Icon(
                                            Icons.lock_open_outlined,
                                            color: Colors.black54,
                                          ),
                                          contentPadding: EdgeInsets.all(6),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                            color: Colors.black,
                                          )),
                                          labelText: "Password Again",
                                          labelStyle: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          hintText: "Enter the password",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          )),
                                    ),
                                    margin:
                                        EdgeInsets.only(right: 20, left: 10),
                                  ),
                                ],
                              ),
                            ),

                            // icons
                            Container(
                              margin: EdgeInsets.only(
                                top: 20,
                                left: 30,
                              ),
                              child: Row(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.facebookF,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  FaIcon(
                                    FontAwesomeIcons.googlePlusG,
                                    color: Colors.black,
                                    size: 32,
                                  ),
                                ],
                              ),
                            ),
                            // end icons

                            Expanded(
                              child: Stack(
                                children: [
                                  Positioned(
                                    child: Container(
                                      height: 60,
                                      width: 400,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                      ),
                                    ),
                                    bottom: 0,
                                  ),
                                  Positioned(
                                    child: GestureDetector(
                                      onTap: () async {
                                        if (_email1Controller
                                                .value.text.isNotEmpty &&
                                            _pass1Controller
                                                .value.text.isNotEmpty &&
                                            _passAgainController
                                                .value.text.isNotEmpty) {
                                          if (_pass1Controller.value.text
                                                  .toString() ==
                                              _passAgainController.value.text
                                                  .toString()) {
                                            try {
                                              await FirebaseAuth.instance
                                                  .createUserWithEmailAndPassword(
                                                      email: _email1Controller
                                                          .value.text,
                                                      password: _pass1Controller
                                                          .value.text);
                                            } on FirebaseAuthException catch (e) {
                                              if (e.code == 'weak-password') {
                                                // Toast.show(
                                                //     "Parolanız Zayıf", context,
                                                //     duration:
                                                //         Toast.LENGTH_SHORT,
                                                //     gravity: Toast.BOTTOM);
                                              } else if (e.code ==
                                                  'email-already-in-use') {
                                                // Toast.show(
                                                //     "Bu email kullanılıyor !",
                                                //     context,
                                                //     duration:
                                                //         Toast.LENGTH_SHORT,
                                                //     gravity: Toast.BOTTOM);
                                              }
                                            } catch (e) {
                                              // Toast.show("Hata Var!", context,
                                              //     duration: Toast.LENGTH_SHORT,
                                              //     gravity: Toast.BOTTOM);
                                            }

                                            // Toast.show(
                                            //     "Kayıt Oldunuz.Giriş Ekranına Yönlendiriliyorsunuz",
                                            //     context,
                                            //     duration: Toast.LENGTH_LONG,
                                            //     gravity: Toast.BOTTOM);
                                            _pass1Controller.text = "";
                                            _passAgainController.text = "";
                                            _email1Controller.text = "";
                                            Navigator.pushNamed(context, "/");
                                          } else {
                                            print(
                                                "Girdiğiniz Şifreler Uyuşmuyor.Kontrol Ediniz!");
                                          }
                                        } else {
                                          print("Alanları boş bırakmayınız");
                                        }
                                      },
                                      child: Container(
                                        child: Icon(
                                          Icons.arrow_right_alt_sharp,
                                          size: 32,
                                          color: Colors.white,
                                        ),
                                        height: 50,
                                        width: 80,
                                        decoration: BoxDecoration(
                                            color: Colors.red.shade400,
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                      ),
                                    ),
                                    bottom: 32,
                                    right: 30,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<TabController>('_tabController', _tabController));
  }
}

Future<UserCredential> signInWithGoogle() async {
  await Firebase.initializeApp();
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  final GoogleSignInAuthentication googleAuth =
      await googleUser!.authentication;
  final OAuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  return await FirebaseAuth.instance.signInWithCredential(credential);
}
