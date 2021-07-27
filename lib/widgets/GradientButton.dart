import 'package:flutter/material.dart';
import '../brand_colors.dart';

class GradientButton extends StatefulWidget {
  final String title;
  final Function onPressed;

  GradientButton({this.title, this.onPressed});

  @override
  _GradientButtonState createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              BrandColors.colorAccent,
              BrandColors.colorAccent1,
            ]),
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            spreadRadius: 0.3,
            color: BrandColors.colorMoreBlue,
          ),
        ],
      ),
      child: TextButton(
        onPressed: widget.onPressed,
        child: Text(
          widget.title,
          textDirection: TextDirection.rtl,
          style: TextStyle(fontSize: 25,color: Colors.white),
        ),
      ),
    );
  }
}
