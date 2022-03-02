// ignore: unused_import
import 'package:firebase_database/firebase_database.dart';

class Driver {
  String? fullName;
  String? email;
  String? phone;
  String? id;
  String? governorate;
  String? place;
  String? agentName;
  var driversIsAvailable;
  String? amount;
  String? status;
  String? currentAmount;
  String? driverType;


  Driver({
    this.fullName,
    this.email,
    this.phone,
    this.id,
    this.governorate,
    this.place,
    this.agentName,
    this.driversIsAvailable,
    this.amount,
    this.currentAmount,
    this.status,
    this.driverType,
  });

  Driver.fromSnapshot(snapshot) {
    id = snapshot.key;
    phone = snapshot.value['phone'];
    email = snapshot.value['email'];
    fullName = snapshot.value['fullname'];
    place = snapshot.value['place'];
    agentName = snapshot.value['agentName'];
    driversIsAvailable = snapshot.value['driversIsAvailable'];
    governorate = snapshot.value['governorate'];
    currentAmount = snapshot.value['currentAmount'];
    driverType = snapshot.value['driverType'];
  }
}
