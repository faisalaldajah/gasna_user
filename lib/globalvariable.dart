import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'models/user.dart';

String serverKey =
    'key=AAAAWge8Rq8:APA91bG8alZ5vNiQ3sUhgXPEYICezf7yLiU0g08HLDgnsAe9BowH_MOpGMlVxCLxMCh6PjMTSlNrypCZwXmDnwlp9SCcnIBNu-LZLZKvIU6pInY2PeyTzyutfPp2R0TD_WQUyv18Nays';

String mapKey = 'AIzaSyAFb2IQsOOu6tce0TqbnAsQ04slmShpP2w';

final CameraPosition googlePlex = CameraPosition(
  target: LatLng(31.954066, 35.931066),
  zoom: 14.4746,
);

User currentFirebaseUser;

UserDetails currentUserInfo;

int numberOfGas = 1;
