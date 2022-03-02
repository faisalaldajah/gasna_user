// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gasna_user/models/Regions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'models/user.dart';

String serverKey =
    'key=AAAAWge8Rq8:APA91bG8alZ5vNiQ3sUhgXPEYICezf7yLiU0g08HLDgnsAe9BowH_MOpGMlVxCLxMCh6PjMTSlNrypCZwXmDnwlp9SCcnIBNu-LZLZKvIU6pInY2PeyTzyutfPp2R0TD_WQUyv18Nays';
Regions regions = Regions();
String mapKey = 'AIzaSyAFb2IQsOOu6tce0TqbnAsQ04slmShpP2w';

final CameraPosition googlePlex = CameraPosition(
  target: LatLng(31.954066, 35.931066),
  zoom: 14.4746,
);

User? currentFirebaseUser;
List<Cities> citys = [];
UserDetails? currentUserInfo;
//make it to call list view bulder and the switch will do the rest of work
int numberOfGas = 1;

bool placeSet = false;
String places = 'إختر المدينة';
String governatsPlace = 'إختر المحافظة';

displayToastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}
