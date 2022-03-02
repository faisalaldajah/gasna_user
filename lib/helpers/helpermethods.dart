import 'dart:convert';
import 'dart:math';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gasna_user/dataprovider/appdata.dart';
import 'package:gasna_user/globalvariable.dart';
import 'package:gasna_user/helpers/requesthelper.dart';
import 'package:gasna_user/models/address.dart';
import 'package:gasna_user/models/directiondetails.dart';
import 'package:gasna_user/models/user.dart';
import 'package:gasna_user/screens/mainpage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

var thePromoCode;

double baseFare = 7;

double comssion = 0.25;

class HelperMethods {
  static void getCurrentUserInfo(context) async {
    // ignore: await_only_futures
    currentFirebaseUser = await FirebaseAuth.instance.currentUser;
    String userid = currentFirebaseUser!.uid;

    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child('users/$userid');

    DatabaseEvent event = await userRef.once();

    if (event.snapshot.value != null) {
      currentUserInfo = UserDetails.fromSnapshot(event.snapshot);
      Navigator.pushNamedAndRemoveUntil(context, MainPage.id, (route) => false);
    }
  }

  static Future<String> findCordinateAddress(Position position, context) async {
    String placeAddress = '';

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      return placeAddress;
    }

    Uri url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey');

    var response = await RequestHelper.getRequest(url);

    if (response != 'failed') {
      placeAddress = response['results'][0]['formatted_address'];

      Address pickupAddress = new Address();

      pickupAddress.longitude = position.longitude;
      pickupAddress.latitude = position.latitude;
      pickupAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false)
          .updatePickupAddress(pickupAddress);
    }

    return placeAddress;
  }

  static Future<DirectionDetails> getDirectionDetails(
      LatLng startPosition, LatLng endPosition) async {
    Uri url = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition.latitude},${startPosition.longitude}&destination=${endPosition.latitude},${endPosition.longitude}&mode=driving&key=$mapKey');

    var response = await RequestHelper.getRequest(url);
    //TODO

    // if (response == 'failed') {
    //   return;
    // }

    DirectionDetails directionDetails = DirectionDetails();

    directionDetails.durationText =
        response['routes'][0]['legs'][0]['duration']['text'];
    directionDetails.durationValue =
        response['routes'][0]['legs'][0]['duration']['value'];

    directionDetails.distanceText =
        response['routes'][0]['legs'][0]['distance']['text'];
    directionDetails.distanceValue =
        response['routes'][0]['legs'][0]['distance']['value'];

    directionDetails.encodedPoints =
        response['routes'][0]['overview_polyline']['points'];

    return directionDetails;
  }

  static double estimateFares() {
    if (thePromoCode == null) {
      thePromoCode = 0;
    }

    double totalFare =
        ((baseFare * numberOfGas) - (thePromoCode * numberOfGas));

    return totalFare;
  }

  static double totalEstimateFares() {
    if (thePromoCode == null) {
      thePromoCode = 0;
    }
    double totalIncome = (baseFare * numberOfGas) - (comssion - numberOfGas);

    return totalIncome;
  }

  static double generateRandomNumber(int max) {
    var randomGenerator = Random();
    int randInt = randomGenerator.nextInt(max);

    return randInt.toDouble();
  }

  // ignore: non_constant_identifier_names
  static sendNotification(String token, context, String ride_id) async {
    var destination =
        Provider.of<AppData>(context, listen: false).pickupAddress;

    Map<String, String> headerMap = {
      'Content-Type': 'application/json',
      'Authorization': serverKey,
    };

    Map notificationMap = {
      'title': 'لديك طلبية جديدة',
      'body': 'Destination, ${destination!.placeName}'
    };

    Map dataMap = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'ride_id': ride_id,
    };

    Map bodyMap = {
      'notification': notificationMap,
      'data': dataMap,
      'priority': 'high',
      'to': token
    };

    var response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: headerMap,
        body: jsonEncode(bodyMap));

    print(response.body);
  }
}
