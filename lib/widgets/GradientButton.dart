import 'package:flutter/material.dart';
import '../brand_colors.dart';

class GradientButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  GradientButton({required this.title,required this.onPressed});


  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              BrandColors.colorAccent,
              BrandColors.colorAccent1,
              BrandColors.colorAccent,
            ]),
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            spreadRadius: 0.3,
            color: BrandColors.colorPrimaryDark,
          ),
        ],
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          title,
          textDirection: TextDirection.rtl,
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
      ),
    );
  }
}
