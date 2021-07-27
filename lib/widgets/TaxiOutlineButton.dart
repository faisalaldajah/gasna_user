import 'package:flutter/material.dart';

import '../brand_colors.dart';

class TaxiOutlineButton extends StatelessWidget {

  final String title;
  final Function onPressed;
  final Color color;

  TaxiOutlineButton({this.title, this.onPressed, this.color});

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return OutlineButton(
        borderSide: BorderSide(color: color),
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(25.0),
        ),
        onPressed: onPressed,
        color: color,
        textColor: color,
        child: Container(
          height: 50.0,
          child: Center(
            child: Text(title,
                style: TextStyle(fontSize: 15.0, fontFamily: 'Brand-Bold', color: BrandColors.colorText)),
          ),
        )
    );
  }
}

