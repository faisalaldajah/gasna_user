import 'package:flutter/material.dart';
import 'package:gasna_user/screens/StartPage.dart';
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
    Future.delayed(Duration(seconds: 4), () {
      Navigator.pushNamedAndRemoveUntil(
          context, StartPage.id, (route) => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrandColors.colorAccent,
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

              //controller: useAnimationController(),
              // onLoaded: (composition){
              //   animationController.addStatusListener((status) {
              //     if (status == AnimationStatus.completed) {
              //       var model;
              //       model.indicateAnimationComplete();
              //     }
              //   });
              // },
            ),
          ),
        ),
      ),
    );
  }
}
