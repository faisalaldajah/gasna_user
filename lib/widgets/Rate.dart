import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gasna_user/screens/mainpage.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';


class Rate extends StatefulWidget {
  @override
  _RateState createState() => _RateState();
}

class _RateState extends State<Rate> {

  double ratingNumber = 1;
  bool ratingIsReadingOnly = false;

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
              Text(
               '${ratingNumber.toInt()}/5',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              SizedBox(height: 35),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SmoothStarRating(
                    color: Colors.yellow,
                    borderColor: Colors.black,
                    size: 45,
                    allowHalfRating: false,
                    starCount: 5,
                    spacing: 10,
                    rating: ratingNumber,
                    isReadOnly: ratingIsReadingOnly,
                    onRated: (value){
                      setState(() {
                        ratingNumber= value;
                        if(value == 0){
                          ratingNumber=1;
                        }
                      });
                    },
                  ),

                  // IconButton(
                  //   icon: Icon(Icons.star_border),
                  //   onPressed: (){
                  //
                  //   },
                  // ),
                  // Icon(
                  //   Icons.star_border,
                  // ),
                  // Icon(
                  //   Icons.star_border,
                  // ),
                  // Icon(
                  //   Icons.star_border,
                  // ),
                  // Icon(
                  //   Icons.star_border,
                  // ),
                ],
              ),
              SizedBox(height: 100),
              GestureDetector(
                onTap: (){
                  setState(() {
                    ratingIsReadingOnly = true;

                  });
                  return showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text("Rating Done"),
                        content: Text("Thank You"),
                        actions: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.of(ctx).pop();
                            },
                            child: GestureDetector(
                                onTap: (){
                                  Navigator.pushNamed(context, MainPage.id);
                                },
                                child: Text("Done")),
                          ),
                        ],
                        // builder: Container(
                        //   child: Text('Rating Done'),
                        //   height: 100,
                        //   width: 100,
                        //   color: Colors.white,
                        // ),
                      )
                  );

                },
                child: Text(
                  'تقييم',
                  style: TextStyle(
                    fontSize: 30
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void ratingDialog(){
  // showDialog(
  //     context: context,
  //     builder: (ctx) => AlertDialog(
  //   title: Text("Alert Dialog Box"),
  //   content: Text("You have raised a Alert Dialog Box"),
  //   actions: <Widget>[
  //     GestureDetector(
  //       onTap: () {
  //         Navigator.of(ctx).pop();
  //       },
  //       child: Text("okay"),
  //     ),
  //   ],
  //   // builder: Container(
  //   //   child: Text('Rating Done'),
  //   //   height: 100,
  //   //   width: 100,
  //   //   color: Colors.white,
  //   // ),
  //     )
  // );
}