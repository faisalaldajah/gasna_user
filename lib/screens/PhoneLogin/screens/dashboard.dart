import 'package:gasna_user/Screens/PhoneLogin/services/authservice.dart';
import 'package:flutter/material.dart';
import 'package:gasna_user/widgets/GradientButton.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GradientButton(
          title: 'Signout',
          onPressed: () {
            AuthService().signOut();
          },
        )
      )
    );
  }
}