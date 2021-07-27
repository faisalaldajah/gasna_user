import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Rate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            children: [
              SizedBox(height: 35),
              AutoSizeText(
                'تقييم',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              SizedBox(height: 15),
              SvgPicture.asset('images/review.svg',width: 150,height: 150,),
              SizedBox(height: 35),
              AutoSizeText(
                '4/5',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.star_border,
                  ),
                  Icon(
                    Icons.star_border,
                  ),
                  Icon(
                    Icons.star_border,
                  ),
                  Icon(
                    Icons.star_border,
                  ),
                  Icon(
                    Icons.star_border,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
