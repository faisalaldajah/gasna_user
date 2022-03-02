import 'package:flutter/material.dart';

class TaxiButton extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onPressed;

  TaxiButton({required this.title,required this.onPressed,required this.color});

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return RaisedButton(
      onPressed: onPressed,
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(25)),
      color: color,
      textColor: Colors.white,
      child: Container(
        height: 50,
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
