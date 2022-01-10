import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gasna_user/globalvariable.dart';
import 'package:gasna_user/screens/PhoneLogin/screens/loginpage.dart';
import 'package:gasna_user/screens/Support.dart';
import 'package:gasna_user/screens/searchpage.dart';
import 'package:gasna_user/styles/styles.dart';
import 'package:gasna_user/widgets/Rate.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:share/share.dart';

import 'BrandDivier.dart';

class TheDrawer extends StatelessWidget {
  const TheDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(0),
      children: <Widget>[
        Container(
          color: Colors.white,
          height: 160,
          child: DrawerHeader(
            decoration: BoxDecoration(color: Colors.white),
            child: Row(
              children: <Widget>[
                Image.asset(
                  'images/user_icon.png',
                  height: 60,
                  width: 60,
                ),
                SizedBox(
                  width: 15,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      currentUserInfo.fullName,
                      style: TextStyle(fontSize: 20, fontFamily: 'Brand-Bold'),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        BrandDivider(),
        SizedBox(
          height: 10,
        ),
        ListTile(
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Support(),
              ),
            );
          },
          leading: Icon(OMIcons.contactSupport),
          title: Text(
            'الدعم',
            style: kDrawerItemStyle,
          ),
        ),
        ListTile(
          leading: Icon(OMIcons.info),
          title: Text(
            'دعوة صدوق',
            style: kDrawerItemStyle,
          ),
          onTap: () {
            Share.share(
                'https://play.google.com/store/apps/details?id=wetech.gasna_user');
          },
        ),
        ListTile(
          leading: Icon(OMIcons.history),
          title: Text(
            'Logout',
            style: kDrawerItemStyle,
          ),
          onTap: () {
            FirebaseAuth.instance.signOut();
            Navigator.pushNamedAndRemoveUntil(
                context, LoginScreens.id, (route) => false);
          },
        ),
      ],
    );
  }
}
