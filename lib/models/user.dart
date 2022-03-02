// ignore: unused_import
import 'package:firebase_database/firebase_database.dart';

class UserDetails {
  String? fullName;
  String? email;
  String? phone;
  String? id;
  String? homePlaceName;
  String? governorate;

  UserDetails({
    this.email,
    this.fullName,
    this.phone,
    this.id,
    this.homePlaceName,
    this.governorate,
  });

  UserDetails.fromSnapshot(event) {
    id = event.key;
    phone = event.value['phone'];
    email = event.value['email'];
    fullName = event.value['fullname'];
    homePlaceName = event.value['place'];
    governorate = event.value['governorate'];
  }
}
