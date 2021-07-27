import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:gasna_user/brand_colors.dart';
import 'package:gasna_user/screens/mainpage.dart';

class SplashScreen extends StatelessWidget {
  static const String id = 'splash screen';
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [        
        AnimatedSplashScreen(
          splash: 'images/gasna.png',
          splashIconSize: 150,
          nextScreen: MainPage(),
          splashTransition: SplashTransition.rotationTransition,
        ),
      ],
    );
  }
}
