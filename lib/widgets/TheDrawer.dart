import 'package:flutter/material.dart';
import 'package:gasna_user/screens/Support.dart';
import 'package:gasna_user/styles/styles.dart';
import 'package:gasna_user/widgets/Rate.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

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
                      'User Name',
                      style: TextStyle(fontSize: 20, fontFamily: 'Brand-Bold'),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text('View Profile'),
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
                builder: (context) => Rate(),
              ),
            );
          },
          leading: Icon(OMIcons.cardGiftcard),
          title: Text(
            'Free Rides',
            style: kDrawerItemStyle,
          ),
        ),
        ListTile(
          leading: Icon(OMIcons.history),
          title: Text(
            'Ride History',
            style: kDrawerItemStyle,
          ),
        ),
        ListTile(
          onTap: (){
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
            'Support',
            style: kDrawerItemStyle,
          ),
        ),
        ListTile(
          leading: Icon(OMIcons.info),
          title: Text(
            'About',
            style: kDrawerItemStyle,
          ),
        ),
      ],
    );
  }
}
