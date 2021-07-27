import 'package:flutter/material.dart';
import 'package:gasna_user/brand_colors.dart';
import 'package:gasna_user/widgets/GradientButton.dart';

class Support extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrandColors.colorBackground,
      appBar: AppBar(
        title: Center(
          child: Text(
            'أطلب المساعدة',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        backgroundColor: BrandColors.colorBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 50),
        width: double.infinity,
        child: ListView(
          children: [
            SizedBox(height: 30),
            Image(
              alignment: Alignment.center,
              height: 150.0,
              width: 150.0,
              image: AssetImage('images/gasna.png'),
            ),
            SizedBox(height: 15),
            TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  labelText: 'الاسم',
                  labelStyle: TextStyle(
                    fontSize: 14.0,
                  ),
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 10.0)),
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 15),
            TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  labelText: 'الايميل',
                  labelStyle: TextStyle(
                    fontSize: 14.0,
                  ),
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 10.0)),
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 15),
            TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  labelText: 'رقم الهاتف',
                  labelStyle: TextStyle(
                    fontSize: 14.0,
                  ),
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 10.0)),
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 15),
            TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  labelText: 'وصف المشكلة',
                  labelStyle: TextStyle(
                    fontSize: 14.0,
                  ),
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 10.0)),
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 40),
            GradientButton(title: 'تأكيد',onPressed: (){},),
            SizedBox(height: 25),
            Center(
          child: Text(
            'سوف يتم حل مشكلتك في أقرب وقت',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
          ],
        ),
      ),
    );
  }
}
