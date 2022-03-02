// ignore: unused_import
import 'package:firebase_database/firebase_database.dart';

class DriversAvailable {
  var lat;
  var long;
  var id;
  var place;
  var governorate;

  DriversAvailable({
    this.governorate,
    this.id,
    this.lat,
    this.long,
    this.place,
  });

  DriversAvailable.fromSnapshot(snapshot){
    governorate = snapshot.value['governorate'];
    place = snapshot.value['governorate']['homePlaceName'];
  }
}
