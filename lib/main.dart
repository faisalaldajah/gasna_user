// ignore_for_file: equal_keys_in_map
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gasna_user/dataprovider/appdata.dart';
import 'package:gasna_user/globalvariable.dart';
import 'package:gasna_user/screens/PhoneLogin/screens/loginpage.dart';
import 'package:gasna_user/screens/SplashScreen.dart';
import 'package:gasna_user/screens/StartPage.dart';
import 'package:gasna_user/screens/loginpage.dart';
import 'package:gasna_user/screens/mainpage.dart';
import 'package:gasna_user/screens/registrationpage.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // ignore: await_only_futures
  currentFirebaseUser = await FirebaseAuth.instance.currentUser;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'JF-Flat-regular',
          primarySwatch: Colors.blue,
        ),
        initialRoute:
            (currentFirebaseUser == null) ? LoginScreens.id : SplashScreen.id,
        routes: {
          SplashScreen.id: (context) => SplashScreen(),
          RegistrationPage.id: (context) => RegistrationPage(),
          LoginPage.id: (context) => LoginPage(),
          MainPage.id: (context) => MainPage(),
          LoginScreens.id: (context) => LoginScreens(),
          StartPage.id: (context) => StartPage(),
        },
      ),
    );
  }
}
