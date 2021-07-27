import 'package:flutter/material.dart';
import 'package:gasna_user/brand_colors.dart';
import 'package:gasna_user/widgets/BrandDivier.dart';

import 'TaxiButton.dart';

class CollectPayment extends StatelessWidget {
  final String paymentMethod;
  final double fares;
  final finishCode;

  CollectPayment({this.paymentMethod, this.fares,this.finishCode});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(4.0),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(4)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Text(
              'المجموع',
              textDirection: TextDirection.rtl,
            ),
            SizedBox(
              height: 20,
            ),
            BrandDivider(),
            SizedBox(
              height: 16.0,
            ),
            Text(
              'JD$fares',
              style: TextStyle(fontFamily: 'Brand-Bold', fontSize: 50),
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'المبلغ أعلاه هو إجمالي الأجر الذي يجب أن عليك دفعه',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'كود الانهاء: $finishCode',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: 230,
              child: TaxiButton(
                title: (paymentMethod == 'cash') ? 'تأكيد' : 'تأكيد',
                color: BrandColors.colorMoreBlue,
                onPressed: () {
                  Navigator.pop(context, 'close');
                },
              ),
            ),
            SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}
