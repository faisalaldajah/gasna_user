import 'package:flutter/material.dart';
import 'package:gasna_user/helpers/helpermethods.dart';
import 'package:gasna_user/brand_colors.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash_screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //final animationController = useAnimationController();
  @override
  void initState() {
    //set time to load the new page
    HelperMethods.getCurrentUserInfo(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrandColors.colorBackground,
      body: Center(
        child: Container(
          height: 500,
          width: 500,
          child: Center(
            child: Lottie.asset(
              'assets/lottiefile.json',
              repeat: true,
              reverse: false,
              animate: true,
            ),
          ),
        ),
      ),
    );
  }
}
