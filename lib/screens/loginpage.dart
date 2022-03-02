// ignore_for_file: unnecessary_import, unused_import

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gasna_user/screens/StartPage.dart';
import 'package:gasna_user/screens/registrationpage.dart';
import 'package:gasna_user/widgets/GradientButton.dart';
import 'package:gasna_user/widgets/ProgressDialog.dart';

class LoginPage extends StatefulWidget {
  static const String id = 'login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  void showSnackBar(String title) {
    final snackbar = SnackBar(
      content: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15),
      ),
    );
    // ignore: deprecated_member_use
    scaffoldKey.currentState!.showSnackBar(snackbar);
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var placeController = TextEditingController();

  void login() async {
    //show please wait dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        status: 'Logging you in',
      ),
    );
    UserCredential user =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );

    if (user.user!.email != null) {
      // verify login
      DatabaseReference userRef =
          FirebaseDatabase.instance.ref().child('users/${user.user!.uid}');
      // userRef.once().then((DataSnapshot snapshot) {
      //   if (snapshot.value != null) {
      //     Navigator.pushNamedAndRemoveUntil(
      //         context, StartPage.id, (route) => false);
      //   }
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 70,
                ),
                Image(
                  alignment: Alignment.center,
                  height: 200.0,
                  width: 200.0,
                  image: AssetImage('images/gasna.png'),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: 'Email address',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 10.0)),
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 10.0)),
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: placeController,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 10.0)),
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      GradientButton(
                        title: 'دخول',
                        onPressed: () async {
                          //check network availability

                          var connectivityResult =
                              await Connectivity().checkConnectivity();
                          if (connectivityResult != ConnectivityResult.mobile &&
                              connectivityResult != ConnectivityResult.wifi) {
                            showSnackBar('No internet connectivity');
                            return;
                          }

                          if (!emailController.text.contains('@')) {
                            showSnackBar('Please enter a valid email address');
                            return;
                          }

                          if (passwordController.text.length < 8) {
                            showSnackBar('Please enter a valid password');
                            return;
                          }

                          login();
                          //todo check this code
                          // if(login !=null){
                          //   Navigator.pushNamed(context, SplashScreen.id);
                          // }
                        },
                      ),
                    ],
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RegistrationPage.id);
                    },
                    child: Text(
                      ' لا تملك حساب - أنشيء حساب جديد',
                      style: TextStyle(color: Colors.black),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
